#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

mod crypto;
mod protection;
mod screenshot_guard;

use crypto::{decrypt_password, encrypt_password};
use serde::{Deserialize, Serialize};
use std::sync::atomic::{AtomicBool, Ordering};
use tokio::sync::Mutex;
use tauri::{ClipboardManager, Manager, State};
#[cfg(target_os = "windows")]
use winreg::enums::HKEY_CURRENT_USER;
#[cfg(target_os = "windows")]
use winreg::RegKey;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PasswordEntry {
    pub id: String,
    pub title: String,
    pub encrypted_password: String,
    pub salt: String,
    pub created_at: String,
}

struct AppState {
    authenticated: AtomicBool,
    passwords: Mutex<Vec<PasswordEntry>>,
    next_id: Mutex<u64>,
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
    if username.trim().is_empty() || password.trim().is_empty() {
        return Err("Введите логин и пароль".into());
    }
    if username.trim() == "test" && password == "test" {
        state.authenticated.store(true, Ordering::SeqCst);
        return Ok("OK".into());
    }

    Err("Неверный логин или пароль".into())
}

#[tauri::command]
async fn register(
    _state: State<'_, AppState>,
    username: String,
    password: String,
    seed_phrase: String,
) -> Result<String, String> {
    if username.trim().is_empty() || username.len() < 3 {
        return Err("Логин минимум 3 символа".into());
    }
    if password.len() < 8 {
        return Err("Пароль минимум 8 символов".into());
    }
    if seed_phrase.split_whitespace().count() < 3 {
        return Err("Сид-фраза минимум 3 слова".into());
    }

    Ok("Аккаунт создан! Войдите.".into())
}

#[tauri::command]
async fn logout(state: State<'_, AppState>) -> Result<(), String> {
    state.authenticated.store(false, Ordering::SeqCst);
    state.passwords.lock().await.clear();
    Ok(())
}

#[tauri::command]
async fn get_passwords(state: State<'_, AppState>) -> Result<Vec<PasswordEntry>, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }
    let list = state.passwords.lock().await;
    Ok(list.clone())
}

#[tauri::command]
async fn add_password(
    state: State<'_, AppState>,
    title: String,
    password: String,
    seed_phrase: String,
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
    if seed_phrase.trim().is_empty() {
        return Err("Введите сид-фразу".into());
    }

    let (encrypted, salt) = encrypt_password(&password, &seed_phrase)?;

    let mut id_counter = state.next_id.lock().await;
    *id_counter += 1;
    let id = format!("{}", *id_counter);

    let entry = PasswordEntry {
        id: id.clone(),
        title: title.trim().to_string(),
        encrypted_password: encrypted,
        salt,
        created_at: chrono_now(),
    };

    state.passwords.lock().await.push(entry.clone());

    Ok(entry)
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
        let list = state.passwords.lock().await;
        list.iter()
            .find(|e| e.id == entry_id)
            .cloned()
            .ok_or("Запись не найдена")?
    };

    let decrypted = decrypt_password(&entry.encrypted_password, &entry.salt, &seed_phrase)?;

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
    let mut list = state.passwords.lock().await;
    list.retain(|e| e.id != entry_id);
    Ok(())
}

#[tauri::command]
async fn is_authenticated(state: State<'_, AppState>) -> Result<bool, String> {
    Ok(state.authenticated.load(Ordering::SeqCst))
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

fn chrono_now() -> String {
    let now = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs();
    format!("2024-01-01T00:00:{}Z", now % 60)
}

fn main() {
    protection::init_protection();

    tauri::Builder::default()
        .manage(AppState {
            authenticated: AtomicBool::new(false),
            passwords: Mutex::new(Vec::new()),
            next_id: Mutex::new(0),
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
