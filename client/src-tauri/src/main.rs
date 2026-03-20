#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

mod api;
mod crypto;
mod protection;
mod screenshot_guard;

use api::{AdminStats, ApiClient, AuthProfile, PasswordEntry};
use crypto::{
    decrypt_password, decrypt_password_with_master_key, default_encryption_algorithm,
    encrypt_password_with_master_key, generate_master_key, prepare_master_key_envelope,
    resolve_encryption_algorithm, unwrap_master_key, wrap_master_key, MasterKeyEnvelope,
};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Mutex as StdMutex;
use tauri::{ClipboardManager, Manager, State};
use tokio::sync::Mutex;
#[cfg(target_os = "windows")]
use winreg::enums::HKEY_CURRENT_USER;
#[cfg(target_os = "windows")]
use winreg::RegKey;
use zeroize::{Zeroize, Zeroizing};

struct AppState {
    authenticated: AtomicBool,
    api: Mutex<ApiClient>,
    current_user: StdMutex<Option<AuthProfile>>,
}

#[cfg(target_os = "windows")]
const STARTUP_RUN_KEY_PATH: &str = "Software\\Microsoft\\Windows\\CurrentVersion\\Run";
#[cfg(target_os = "windows")]
const STARTUP_VALUE_NAME: &str = "SecureGuard";
const DEFAULT_CLIPBOARD_TIMEOUT_SECS: u64 = 30;
const MIN_CLIPBOARD_TIMEOUT_SECS: u64 = 5;
const MAX_CLIPBOARD_TIMEOUT_SECS: u64 = 300;

fn is_not_authenticated_error(message: &str) -> bool {
    let normalized = message.to_ascii_lowercase();
    normalized.contains("not authenticated") || normalized.contains("unauthenticated")
}

fn clear_auth_state(state: &State<'_, AppState>, api: &mut ApiClient) {
    api.clear_session();
    state.authenticated.store(false, Ordering::SeqCst);
    if let Ok(mut current_user) = state.current_user.lock() {
        *current_user = None;
    }
}

fn sanitize_clipboard_timeout_seconds(value: Option<u64>) -> u64 {
    value
        .unwrap_or(DEFAULT_CLIPBOARD_TIMEOUT_SECS)
        .clamp(MIN_CLIPBOARD_TIMEOUT_SECS, MAX_CLIPBOARD_TIMEOUT_SECS)
}

#[tauri::command]
async fn login(
    state: State<'_, AppState>,
    username: String,
    password: String,
) -> Result<AuthProfile, String> {
    let password = Zeroizing::new(password);
    let username = username.trim();
    if username.is_empty() || password.trim().is_empty() {
        return Err("Введите логин и пароль".into());
    }

    {
        let mut api = state.api.lock().await;
        let profile = api.authorize(username, password.as_str()).await?;
        if let Ok(mut current_user) = state.current_user.lock() {
            *current_user = Some(profile.clone());
        }
        state.authenticated.store(true, Ordering::SeqCst);
        return Ok(profile);
    }
}

#[tauri::command]
async fn register(
    state: State<'_, AppState>,
    username: String,
    password: String,
    seed_phrase: String,
) -> Result<String, String> {
    let password = Zeroizing::new(password);
    let seed_phrase = Zeroizing::new(seed_phrase);
    let username = username.trim();
    let seed_phrase = seed_phrase.trim();

    if username.is_empty() || username.len() < 3 {
        return Err("Логин минимум 3 символа".into());
    }
    if password.len() < 8 {
        return Err("Пароль минимум 8 символов".into());
    }
    if seed_phrase.split_whitespace().count() < 1 {
        return Err("Seed phrase must contain at least 1 word".into());
    }

    {
        let mut api = state.api.lock().await;
        api.register(username, password.as_str(), seed_phrase)
            .await?;
        api.clear_session();
    }

    if let Ok(mut current_user) = state.current_user.lock() {
        *current_user = None;
    }

    state.authenticated.store(false, Ordering::SeqCst);
    Ok("Аккаунт создан! Войдите.".into())
}

#[tauri::command]
async fn prepare_local_master_key_envelope(
    seed_phrase: String,
    encryption_algorithm: String,
) -> Result<MasterKeyEnvelope, String> {
    let seed_phrase = Zeroizing::new(seed_phrase);
    let seed_phrase = seed_phrase.trim();
    if seed_phrase.is_empty() {
        return Err("Р’РІРµРґРёС‚Рµ СЃРёРґ-С„СЂР°Р·Сѓ".into());
    }

    let selected_algorithm = resolve_encryption_algorithm(&encryption_algorithm)
        .ok_or("РќРµРїРѕРґРґРµСЂР¶РёРІР°РµРјС‹Р№ Р°Р»РіРѕСЂРёС‚Рј С€РёС„СЂРѕРІР°РЅРёСЏ")?;
    prepare_master_key_envelope(seed_phrase, selected_algorithm)
}

#[tauri::command]
async fn logout(state: State<'_, AppState>) -> Result<(), String> {
    let mut api = state.api.lock().await;
    if api.is_authenticated() {
        match api.logout().await {
            Ok(_) => {}
            Err(err) => {
                clear_auth_state(&state, &mut api);
                return Err(err);
            }
        }
    }
    state.authenticated.store(false, Ordering::SeqCst);
    api.clear_session();
    if let Ok(mut current_user) = state.current_user.lock() {
        *current_user = None;
    }
    Ok(())
}

#[tauri::command]
fn get_session_user(state: State<'_, AppState>) -> Result<Option<AuthProfile>, String> {
    state
        .current_user
        .lock()
        .map(|user| user.clone())
        .map_err(|_| "Failed to read session user".to_string())
}

#[tauri::command]
async fn get_admin_stats(state: State<'_, AppState>) -> Result<AdminStats, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("РќРµ Р°РІС‚РѕСЂРёР·РѕРІР°РЅ".into());
    }

    let mut api = state.api.lock().await;
    match api.get_admin_stats().await {
        Ok(stats) => Ok(stats),
        Err(err) => {
            if is_not_authenticated_error(&err) {
                clear_auth_state(&state, &mut api);
            }
            Err(err)
        }
    }
}

#[tauri::command]
async fn set_theme_preference(
    state: State<'_, AppState>,
    light_theme_enabled: bool,
) -> Result<bool, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("РќРµ Р°РІС‚РѕСЂРёР·РѕРІР°РЅ".into());
    }

    let mut api = state.api.lock().await;
    match api.change_theme(light_theme_enabled).await {
        Ok(_) => Ok(light_theme_enabled),
        Err(err) => {
            if is_not_authenticated_error(&err) {
                clear_auth_state(&state, &mut api);
            }
            Err(err)
        }
    }
}

#[tauri::command]
async fn set_language_preference(
    state: State<'_, AppState>,
    language: String,
) -> Result<String, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("РќРµ Р°РІС‚РѕСЂРёР·РѕРІР°РЅ".into());
    }

    let mut api = state.api.lock().await;
    match api.change_language(&language).await {
        Ok(value) => Ok(value),
        Err(err) => {
            if is_not_authenticated_error(&err) {
                clear_auth_state(&state, &mut api);
            }
            Err(err)
        }
    }
}

#[tauri::command]
async fn set_encryption_preference(
    state: State<'_, AppState>,
    encryption_algorithm: String,
) -> Result<String, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("РќРµ Р°РІС‚РѕСЂРёР·РѕРІР°РЅ".into());
    }

    let mut api = state.api.lock().await;
    match api.change_encryption(&encryption_algorithm).await {
        Ok(value) => Ok(value),
        Err(err) => {
            if is_not_authenticated_error(&err) {
                clear_auth_state(&state, &mut api);
            }
            Err(err)
        }
    }
}

#[tauri::command]
async fn get_passwords(state: State<'_, AppState>) -> Result<Vec<PasswordEntry>, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }
    let mut api = state.api.lock().await;
    match api.list_passwords().await {
        Ok(entries) => Ok(entries),
        Err(err) => {
            if is_not_authenticated_error(&err) {
                clear_auth_state(&state, &mut api);
            }
            Err(err)
        }
    }
}

#[tauri::command]
async fn add_password(
    state: State<'_, AppState>,
    title: String,
    password: String,
    seed_phrase: String,
    encryption_algorithm: String,
    local_wrapped_master_key: Option<String>,
    local_wrapping_salt: Option<String>,
    local_wrapping_algorithm: Option<String>,
) -> Result<PasswordEntry, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }
    if title.trim().is_empty() {
        return Err("Введите название".into());
    }
    let password = Zeroizing::new(password);
    if password.trim().is_empty() {
        return Err("Введите пароль".into());
    }
    let seed_phrase = Zeroizing::new(seed_phrase);
    let seed_phrase = seed_phrase.trim();
    if seed_phrase.is_empty() {
        return Err("Введите сид-фразу".into());
    }

    let selected_algorithm = resolve_encryption_algorithm(&encryption_algorithm)
        .ok_or("Неподдерживаемый алгоритм шифрования")?;
    let existing_entries = {
        let mut api = state.api.lock().await;
        match api.list_passwords().await {
            Ok(entries) => entries,
            Err(err) => {
                if is_not_authenticated_error(&err) {
                    clear_auth_state(&state, &mut api);
                }
                return Err(err);
            }
        }
    };

    let envelope_from_entries = existing_entries.iter().find_map(|entry| {
        if entry.wrapped_master_key.trim().is_empty() || entry.salt.trim().is_empty() {
            return None;
        }

        Some(MasterKeyEnvelope {
            wrapped_master_key: entry.wrapped_master_key.clone(),
            wrapping_salt: entry.salt.clone(),
            encryption_algorithm: if entry.encryption_algorithm.trim().is_empty() {
                default_encryption_algorithm().to_string()
            } else {
                entry.encryption_algorithm.clone()
            },
        })
    });

    let envelope_from_local = match (local_wrapped_master_key, local_wrapping_salt) {
        (Some(wrapped_master_key), Some(wrapping_salt))
            if !wrapped_master_key.trim().is_empty() && !wrapping_salt.trim().is_empty() =>
        {
            Some(MasterKeyEnvelope {
                wrapped_master_key,
                wrapping_salt,
                encryption_algorithm: local_wrapping_algorithm
                    .and_then(|value| {
                        resolve_encryption_algorithm(&value).map(|item| item.to_string())
                    })
                    .unwrap_or_else(|| selected_algorithm.to_string()),
            })
        }
        _ => None,
    };

    let mut master_key = if let Some(envelope) = envelope_from_entries
        .as_ref()
        .or(envelope_from_local.as_ref())
    {
        unwrap_master_key(
            &envelope.wrapped_master_key,
            &envelope.wrapping_salt,
            seed_phrase,
            &envelope.encryption_algorithm,
        )?
    } else {
        generate_master_key()
    };

    let encrypted_password = encrypt_password_with_master_key(password.as_str(), &master_key)?;
    let entry_envelope = wrap_master_key(&master_key, seed_phrase, selected_algorithm)?;
    master_key.zeroize();

    let entry = PasswordEntry {
        id: uuid::Uuid::new_v4().to_string(),
        title: title.trim().to_string(),
        encrypted_password,
        salt: entry_envelope.wrapping_salt,
        wrapped_master_key: entry_envelope.wrapped_master_key,
        encryption_algorithm: entry_envelope.encryption_algorithm,
        created_at: chrono_now(),
    };

    let mut api = state.api.lock().await;
    match api.add_password(entry).await {
        Ok(saved) => Ok(saved),
        Err(err) => {
            if is_not_authenticated_error(&err) {
                clear_auth_state(&state, &mut api);
            }
            Err(err)
        }
    }
}

#[tauri::command]
async fn copy_password(
    app_handle: tauri::AppHandle,
    state: State<'_, AppState>,
    entry_id: String,
    seed_phrase: String,
    clipboard_timeout_seconds: Option<u64>,
) -> Result<String, String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }

    let entry = {
        let mut api = state.api.lock().await;
        let list = match api.list_passwords().await {
            Ok(list) => list,
            Err(err) => {
                if is_not_authenticated_error(&err) {
                    clear_auth_state(&state, &mut api);
                }
                return Err(err);
            }
        };
        list.iter()
            .find(|e| e.id == entry_id)
            .cloned()
            .ok_or("Запись не найдена")?
    };

    let seed_phrase = Zeroizing::new(seed_phrase);
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

    let decrypted = if !entry.wrapped_master_key.trim().is_empty() {
        let mut master_key = unwrap_master_key(
            &entry.wrapped_master_key,
            &entry.salt,
            seed_phrase,
            algorithm,
        )?;
        let decrypted = Zeroizing::new(decrypt_password_with_master_key(
            &entry.encrypted_password,
            &master_key,
        )?);
        master_key.zeroize();
        decrypted
    } else {
        Zeroizing::new(decrypt_password(
            &entry.encrypted_password,
            &entry.salt,
            seed_phrase,
            algorithm,
        )?)
    };

    app_handle
        .clipboard_manager()
        .write_text(decrypted.as_str())
        .map_err(|e| format!("Буфер обмена: {}", e))?;

    let handle = app_handle.clone();
    let clipboard_timeout_seconds = sanitize_clipboard_timeout_seconds(clipboard_timeout_seconds);
    tokio::spawn(async move {
        tokio::time::sleep(tokio::time::Duration::from_secs(clipboard_timeout_seconds)).await;
        let _ = handle.clipboard_manager().write_text("");
    });

    Ok("Скопировано".into())
}

#[tauri::command]
async fn delete_password(state: State<'_, AppState>, entry_id: String) -> Result<(), String> {
    if !state.authenticated.load(Ordering::SeqCst) {
        return Err("Не авторизован".into());
    }
    let mut api = state.api.lock().await;
    match api.delete_password(&entry_id).await {
        Ok(_) => Ok(()),
        Err(err) => {
            if is_not_authenticated_error(&err) {
                clear_auth_state(&state, &mut api);
            }
            Err(err)
        }
    }
}

#[tauri::command]
async fn is_authenticated(state: State<'_, AppState>) -> Result<bool, String> {
    let api = state.api.lock().await;
    let authenticated = state.authenticated.load(Ordering::SeqCst) && api.is_authenticated();
    if !authenticated {
        state.authenticated.store(false, Ordering::SeqCst);
    }
    Ok(authenticated)
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
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs()
        .to_string()
}

fn main() {
    #[cfg(all(target_os = "windows", not(debug_assertions)))]
    protection::init_protection();

    tauri::Builder::default()
        .manage(AppState {
            authenticated: AtomicBool::new(false),
            api: Mutex::new(ApiClient::new()),
            current_user: StdMutex::new(None),
        })
        .setup(|app| {
            let window = app.get_window("main").unwrap();
            screenshot_guard::init_screenshot_protection(window);
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            register,
            prepare_local_master_key_envelope,
            login,
            logout,
            get_session_user,
            get_admin_stats,
            set_theme_preference,
            set_language_preference,
            set_encryption_preference,
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
