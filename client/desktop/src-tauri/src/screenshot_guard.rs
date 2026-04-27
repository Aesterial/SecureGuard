#[cfg(target_os = "windows")]
use winapi::shared::minwindef::*;
#[cfg(target_os = "windows")]
use winapi::shared::windef::*;
#[cfg(target_os = "windows")]
use winapi::um::errhandlingapi::*;
#[cfg(target_os = "windows")]
use winapi::um::winuser::*;

use once_cell::sync::OnceCell;
use std::ptr;
use std::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use std::thread;
use std::time::Duration;
use tauri::Window;

static WINDOW_HWND: OnceCell<isize> = OnceCell::new();
static PROTECTION_ON: AtomicBool = AtomicBool::new(false);
static LAST_AFFINITY_ERROR: AtomicU32 = AtomicU32::new(0);

#[cfg(target_os = "windows")]
const WDA_NONE: DWORD = 0x00000000;
#[cfg(target_os = "windows")]
const WDA_MONITOR: DWORD = 0x00000001;
#[cfg(target_os = "windows")]
const WDA_EXCLUDEFROMCAPTURE: DWORD = 0x00000011;

#[cfg(target_os = "windows")]
fn spawn_guard_thread<F>(name: &str, f: F)
where
    F: FnOnce() + Send + 'static,
{
    if let Err(err) = thread::Builder::new().name(name.to_string()).spawn(f) {
        eprintln!("SecureGuard screenshot thread '{}' failed: {}", name, err);
    }
}

pub fn is_protection_enabled() -> bool {
    PROTECTION_ON.load(Ordering::SeqCst)
}

pub fn set_screenshot_protection(enabled: bool) {
    PROTECTION_ON.store(enabled, Ordering::SeqCst);

    #[cfg(target_os = "windows")]
    {
        if let Some(&hwnd) = WINDOW_HWND.get() {
            if enabled {
                apply_display_affinity(hwnd as HWND);
            } else {
                disable_display_affinity(hwnd as HWND);
            }
        }
    }
}

pub fn init_screenshot_protection(window: Window) {
    #[cfg(target_os = "windows")]
    {
        let hwnd = match window.hwnd() {
            Ok(hwnd) => hwnd.0,
            Err(err) => {
                eprintln!("SecureGuard screenshot guard init failed: {}", err);
                return;
            }
        };
        let _ = WINDOW_HWND.set(hwnd);
        spawn_guard_thread("sg-affinity-keepalive", move || {
            monitor_affinity(hwnd as HWND);
        });
        spawn_guard_thread("sg-clipboard-monitor", move || {
            monitor_clipboard(hwnd as HWND);
        });
    }
}
#[cfg(target_os = "windows")]
fn apply_display_affinity(hwnd: HWND) -> bool {
    unsafe {
        if set_display_affinity(hwnd, WDA_EXCLUDEFROMCAPTURE) {
            LAST_AFFINITY_ERROR.store(0, Ordering::SeqCst);
            return true;
        }

        if set_display_affinity(hwnd, WDA_MONITOR) {
            LAST_AFFINITY_ERROR.store(0, Ordering::SeqCst);
            return true;
        }

        let code = GetLastError();
        if code == 0 || code == 8 || code == 1400 {
            return false;
        }

        let prev = LAST_AFFINITY_ERROR.swap(code, Ordering::SeqCst);
        if prev != code {
            eprintln!(
                "SecureGuard screenshot affinity failed (hwnd={:?}, err={})",
                hwnd, code
            );
        }
        false
    }
}

#[cfg(target_os = "windows")]
fn disable_display_affinity(hwnd: HWND) {
    unsafe {
        let _ = set_display_affinity(hwnd, WDA_NONE);
    }
}

#[cfg(target_os = "windows")]
fn monitor_affinity(hwnd: HWND) {
    thread::sleep(Duration::from_millis(1200));
    loop {
        if PROTECTION_ON.load(Ordering::SeqCst) {
            apply_display_affinity(hwnd);
            thread::sleep(Duration::from_millis(1500));
        } else {
            thread::sleep(Duration::from_secs(3));
        }
    }
}

#[cfg(target_os = "windows")]
unsafe fn set_display_affinity(hwnd: HWND, affinity: DWORD) -> bool {
    if hwnd.is_null() || IsWindow(hwnd) == 0 {
        return false;
    }

    let root = GetAncestor(hwnd, GA_ROOT);
    if !root.is_null()
        && SetWindowDisplayAffinity(root, affinity) != 0
        && window_affinity_matches(root, affinity)
    {
        return true;
    }

    SetWindowDisplayAffinity(hwnd, affinity) != 0 && window_affinity_matches(hwnd, affinity)
}

#[cfg(target_os = "windows")]
unsafe fn window_affinity_matches(hwnd: HWND, expected: DWORD) -> bool {
    let mut current: DWORD = 0;
    if GetWindowDisplayAffinity(hwnd, &mut current) == 0 {
        return false;
    }

    if expected == WDA_EXCLUDEFROMCAPTURE {
        current == WDA_EXCLUDEFROMCAPTURE || current == WDA_MONITOR
    } else {
        current == expected
    }
}

#[cfg(target_os = "windows")]
unsafe fn clear_clipboard() {
    if OpenClipboard(ptr::null_mut()) != 0 {
        EmptyClipboard();
        CloseClipboard();
    }
}
#[cfg(target_os = "windows")]
fn monitor_clipboard(_hwnd: HWND) {
    loop {
        if !PROTECTION_ON.load(Ordering::SeqCst) {
            thread::sleep(Duration::from_secs(2));
            continue;
        }

        unsafe {
            if IsClipboardFormatAvailable(2) != 0
                || IsClipboardFormatAvailable(8) != 0
                || IsClipboardFormatAvailable(17) != 0
            {
                clear_clipboard();
            }
        }

        thread::sleep(Duration::from_millis(500));
    }
}
