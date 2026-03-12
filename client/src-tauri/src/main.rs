#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

mod api;
mod crypto;
mod protection;
mod screenshot_guard;

use api::{ApiClient, PasswordEntry};
use crypto::{
    decrypt_password, default_encryption_algorithm, encrypt_password, resolve_encryption_algorithm,
};
#[cfg(target_os = "windows")]
use std::ffi::OsStr;
#[cfg(target_os = "windows")]
use std::os::windows::ffi::OsStrExt;
#[cfg(target_os = "windows")]
use std::ptr;
use std::sync::atomic::{AtomicBool, Ordering};
use tauri::{ClipboardManager, Manager, State};
use tokio::sync::Mutex;
#[cfg(target_os = "windows")]
use winapi::um::securitybaseapi::{AllocateAndInitializeSid, CheckTokenMembership, FreeSid};
#[cfg(target_os = "windows")]
use winapi::um::shellapi::ShellExecuteW;
#[cfg(target_os = "windows")]
use winapi::um::winnt::{
    DOMAIN_ALIAS_RID_ADMINS, PSID, SECURITY_BUILTIN_DOMAIN_RID, SID_IDENTIFIER_AUTHORITY,
};
#[cfg(target_os = "windows")]
use winapi::um::winuser::SW_SHOWNORMAL;
#[cfg(target_os = "windows")]
use winreg::enums::HKEY_CURRENT_USER;
#[cfg(target_os = "windows")]
use winreg::RegKey;

struct AppState {
    authenticated: AtomicBool,
    api: Mutex<ApiClient>,
}

#[cfg(target_os = "windows")]
const STARTUP_RUN_KEY_PATH: &str = "Software\\Microsoft\\Windows\\CurrentVersion\\Run";
#[cfg(target_os = "windows")]
const STARTUP_VALUE_NAME: &str = "SecureGuard";

#[tauri::command]
async fn login(
    state: State<'_, AppState>,
    username: String,
    password: String,
) -> Result<String, String> {
    let username = username.trim();
    if username.is_empty() || password.trim().is_empty() {
        return Err("Введите логин и пароль".into());
    }

    {
        let mut api = state.api.lock().await;
        api.authorize(username, &password).await?;
    }

    state.authenticated.store(true, Ordering::SeqCst);
    Ok("OK".into())
}

#[tauri::command]
async fn register(
    state: State<'_, AppState>,
    username: String,
    password: String,
    seed_phrase: String,
) -> Result<String, String> {
    let username = username.trim();
    let seed_phrase = seed_phrase.trim();

    if username.is_empty() || username.len() < 3 {
        return Err("Логин минимум 3 символа".into());
    }
    if password.len() < 8 {
        return Err("Пароль минимум 8 символов".into());
    }
    if seed_phrase.split_whitespace().count() < 3 {
        return Err("Сид-фраза минимум 3 слова".into());
    }

    {
        let mut api = state.api.lock().await;
        api.register(username, &password, seed_phrase).await?;
        api.clear_session();
    }

    state.authenticated.store(false, Ordering::SeqCst);
    Ok("Аккаунт создан! Войдите.".into())
}

#[tauri::command]
async fn logout(state: State<'_, AppState>) -> Result<(), String> {
    state.authenticated.store(false, Ordering::SeqCst);
    let mut api = state.api.lock().await;
    api.clear_session();
    Ok(())
}

#[tauri::command]
async fn get_passwords(state: State<'_, AppState>) -> Result<Vec<PasswordEntry>, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }
    let api = state.api.lock().await;
    api.list_passwords().await
}

#[tauri::command]
async fn add_password(
    state: State<'_, AppState>,
    title: String,
    password: String,
    seed_phrase: String,
    encryption_algorithm: String,
) -> Result<PasswordEntry, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }
    if title.trim().is_empty() {
        return Err("Введите название".into());
    }
    if password.trim().is_empty() {
        return Err("Введите пароль".into());
    }
    let seed_phrase = seed_phrase.trim();
    if seed_phrase.is_empty() {
        return Err("Введите сид-фразу".into());
    }

    let algorithm = resolve_encryption_algorithm(&encryption_algorithm)
        .ok_or("Неподдерживаемый алгоритм шифрования")?;
    let (encrypted, salt) = encrypt_password(&password, seed_phrase, algorithm)?;

    let entry = PasswordEntry {
        id: String::new(),
        title: title.trim().to_string(),
        encrypted_password: encrypted,
        salt,
        encryption_algorithm: algorithm.to_string(),
        created_at: chrono_now(),
    };

    let api = state.api.lock().await;
    api.add_password(entry).await
}

#[tauri::command]
async fn copy_password(
    app_handle: tauri::AppHandle,
    state: State<'_, AppState>,
    entry_id: String,
    seed_phrase: String,
) -> Result<String, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }

    let entry = {
        let api = state.api.lock().await;
        let list = api.list_passwords().await?;
        list.iter()
            .find(|e| e.id == entry_id)
            .cloned()
            .ok_or("Запись не найдена")?
    };

    let seed_phrase = seed_phrase.trim();
    if seed_phrase.is_empty() {
        return Err("Введите сид-фразу".into());
    }

    let algorithm = if entry.encryption_algorithm.trim().is_empty() {
        default_encryption_algorithm()
    } else {
        resolve_encryption_algorithm(&entry.encryption_algorithm)
            .ok_or("Неподдерживаемый алгоритм шифрования записи")?
    };

    let decrypted = decrypt_password(
        &entry.encrypted_password,
        &entry.salt,
        seed_phrase,
        algorithm,
    )?;

    app_handle
        .clipboard_manager()
        .write_text(&decrypted)
        .map_err(|e| format!("Буфер обмена: {}", e))?;

    let handle = app_handle.clone();
    tokio::spawn(async move {
        tokio::time::sleep(tokio::time::Duration::from_secs(30)).await;
        let _ = handle.clipboard_manager().write_text("");
    });

    Ok("Скопировано".into())
}

#[tauri::command]
async fn delete_password(state: State<'_, AppState>, entry_id: String) -> Result<(), String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }
    let api = state.api.lock().await;
    api.delete_password(&entry_id).await
}

#[tauri::command]
async fn is_authenticated(state: State<'_, AppState>) -> Result<bool, String> {
    if state.authenticated.load(Ordering::SeqCst) {
        return Ok(true);
    }
    let api = state.api.lock().await;
    Ok(api.is_authenticated())
}

#[tauri::command]
async fn get_screenshot_guard_status() -> Result<bool, String> {
    Ok(screenshot_guard::is_protection_enabled())
}

#[tauri::command]
async fn set_screenshot_guard_enabled(
    state: State<'_, AppState>,
    enabled: bool,
) -> Result<bool, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }

    screenshot_guard::set_screenshot_protection(enabled);
    Ok(enabled)
}

#[tauri::command]
async fn get_startup_status(state: State<'_, AppState>) -> Result<bool, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }

    get_windows_startup_status()
}

#[tauri::command]
async fn set_startup_enabled(state: State<'_, AppState>, enabled: bool) -> Result<bool, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }

    set_windows_startup_enabled(enabled)
}

#[cfg(target_os = "windows")]
fn get_windows_startup_status() -> Result<bool, String> {
    let hkcu = RegKey::predef(HKEY_CURRENT_USER);
    let run_key = match hkcu.open_subkey(STARTUP_RUN_KEY_PATH) {
        Ok(key) => key,
        Err(err) if err.kind() == std::io::ErrorKind::NotFound => return Ok(false),
        Err(err) => return Err(format!("Не удалось открыть ключ автозапуска: {}", err)),
    };

    match run_key.get_value::<String, _>(STARTUP_VALUE_NAME) {
        Ok(value) => Ok(!value.trim().is_empty()),
        Err(err) if err.kind() == std::io::ErrorKind::NotFound => Ok(false),
        Err(err) => Err(format!("Не удалось прочитать автозапуск: {}", err)),
    }
}

#[cfg(not(target_os = "windows"))]
fn get_windows_startup_status() -> Result<bool, String> {
    Err("Автозапуск поддерживается только на Windows".into())
}

#[cfg(target_os = "windows")]
fn set_windows_startup_enabled(enabled: bool) -> Result<bool, String> {
    let hkcu = RegKey::predef(HKEY_CURRENT_USER);
    let (run_key, _) = hkcu
        .create_subkey(STARTUP_RUN_KEY_PATH)
        .map_err(|err| format!("Не удалось открыть ключ автозапуска: {}", err))?;

    if enabled {
        let exe_path = std::env::current_exe()
            .map_err(|err| format!("Не удалось получить путь приложения: {}", err))?;
        let startup_value = format!("\"{}\"", exe_path.display());

        run_key
            .set_value(STARTUP_VALUE_NAME, &startup_value)
            .map_err(|err| format!("Не удалось включить автозапуск: {}", err))?;
    } else {
        match run_key.delete_value(STARTUP_VALUE_NAME) {
            Ok(_) => {}
            Err(err) if err.kind() == std::io::ErrorKind::NotFound => {}
            Err(err) => return Err(format!("Не удалось отключить автозапуск: {}", err)),
        }
    }

    Ok(enabled)
}

#[cfg(not(target_os = "windows"))]
fn set_windows_startup_enabled(_enabled: bool) -> Result<bool, String> {
    Err("Автозапуск поддерживается только на Windows".into())
}

#[cfg(target_os = "windows")]
fn ensure_elevated_or_relaunch() {
    if is_running_as_admin() {
        return;
    }

    let exe = match std::env::current_exe() {
        Ok(path) => path,
        Err(err) => {
            eprintln!("SecureGuard UAC: current_exe failed: {}", err);
            std::process::exit(1);
        }
    };

    let args: Vec<String> = std::env::args().skip(1).collect();
    let params = quote_windows_args(&args);

    let verb = to_wide("runas");
    let file = to_wide_os(exe.as_os_str());
    let params_wide = to_wide(&params);

    let result = unsafe {
        ShellExecuteW(
            ptr::null_mut(),
            verb.as_ptr(),
            file.as_ptr(),
            if params.is_empty() {
                ptr::null()
            } else {
                params_wide.as_ptr()
            },
            ptr::null(),
            SW_SHOWNORMAL,
        ) as isize
    };

    if result <= 32 {
        eprintln!(
            "SecureGuard UAC: elevation failed (ShellExecuteW={})",
            result
        );
        std::process::exit(1);
    }

    std::process::exit(0);
}

#[cfg(target_os = "windows")]
fn is_running_as_admin() -> bool {
    unsafe {
        let mut admin_group: PSID = ptr::null_mut();
        let nt_authority = SID_IDENTIFIER_AUTHORITY {
            Value: [0, 0, 0, 0, 0, 5],
        };

        let sid_ok = AllocateAndInitializeSid(
            &nt_authority as *const _ as *mut _,
            2,
            SECURITY_BUILTIN_DOMAIN_RID,
            DOMAIN_ALIAS_RID_ADMINS,
            0,
            0,
            0,
            0,
            0,
            0,
            &mut admin_group,
        );

        if sid_ok == 0 || admin_group.is_null() {
            return false;
        }

        let mut is_member = 0;
        let token_ok = CheckTokenMembership(ptr::null_mut(), admin_group, &mut is_member);
        FreeSid(admin_group);

        token_ok != 0 && is_member != 0
    }
}

#[cfg(target_os = "windows")]
fn quote_windows_args(args: &[String]) -> String {
    args.iter()
        .map(|arg| quote_windows_arg(arg))
        .collect::<Vec<_>>()
        .join(" ")
}

#[cfg(target_os = "windows")]
fn quote_windows_arg(value: &str) -> String {
    if value.is_empty() {
        return "\"\"".to_string();
    }

    if !value
        .chars()
        .any(|ch| ch.is_whitespace() || ch == '"' || ch == '\\')
    {
        return value.to_string();
    }

    let mut quoted = String::from("\"");
    let mut backslashes = 0usize;

    for ch in value.chars() {
        match ch {
            '\\' => backslashes += 1,
            '"' => {
                quoted.push_str(&"\\".repeat(backslashes * 2 + 1));
                quoted.push('"');
                backslashes = 0;
            }
            _ => {
                quoted.push_str(&"\\".repeat(backslashes));
                backslashes = 0;
                quoted.push(ch);
            }
        }
    }

    quoted.push_str(&"\\".repeat(backslashes * 2));
    quoted.push('"');
    quoted
}

#[cfg(target_os = "windows")]
fn to_wide(value: &str) -> Vec<u16> {
    OsStr::new(value)
        .encode_wide()
        .chain(std::iter::once(0))
        .collect()
}

#[cfg(target_os = "windows")]
fn to_wide_os(value: &OsStr) -> Vec<u16> {
    value.encode_wide().chain(std::iter::once(0)).collect()
}

fn chrono_now() -> String {
    let now = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs();
    format!("2024-01-01T00:00:{}Z", now % 60)
}

fn main() {
    #[cfg(target_os = "windows")]
    ensure_elevated_or_relaunch();

    #[cfg(all(target_os = "windows", not(debug_assertions)))]
    protection::init_protection();

    tauri::Builder::default()
        .manage(AppState {
            authenticated: AtomicBool::new(false),
            api: Mutex::new(ApiClient::new()),
        })
        .setup(|app| {
            let window = app.get_window("main").unwrap();
            screenshot_guard::init_screenshot_protection(window);
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            register,
            login,
            logout,
            get_passwords,
            add_password,
            copy_password,
            delete_password,
            is_authenticated,
            get_screenshot_guard_status,
            set_screenshot_guard_enabled,
            get_startup_status,
            set_startup_enabled,
        ])
        .run(tauri::generate_context!())
        .expect("Ошибка запуска приложения");
}
