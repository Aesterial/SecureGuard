#[cfg(target_os = "windows")]
use winapi::shared::minwindef::*;
#[cfg(target_os = "windows")]
use winapi::shared::windef::*;
#[cfg(target_os = "windows")]
use winapi::um::handleapi::*;
#[cfg(target_os = "windows")]
use winapi::um::libloaderapi::*;
#[cfg(target_os = "windows")]
use winapi::um::tlhelp32::*;
#[cfg(target_os = "windows")]
use winapi::um::winuser::*;

use once_cell::sync::OnceCell;
use std::ptr;
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;
use std::time::Duration;
use tauri::Window;

static WINDOW_HWND: OnceCell<isize> = OnceCell::new();
static PROTECTION_ON: AtomicBool = AtomicBool::new(false);

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
        let hwnd = window.hwnd().unwrap().0 as isize;
        let _ = WINDOW_HWND.set(hwnd);
        PROTECTION_ON.store(true, Ordering::SeqCst);
        apply_display_affinity(hwnd as HWND);
        thread::spawn(|| {
            install_keyboard_hook();
        });
        thread::spawn(|| {
            monitor_capture_tools();
        });
        thread::spawn(move || {
            monitor_clipboard(hwnd as HWND);
        });
    }
}
#[cfg(target_os = "windows")]
fn apply_display_affinity(hwnd: HWND) {
    unsafe {
        let result = SetWindowDisplayAffinity(hwnd, 0x00000011);

        if result == 0 {
            SetWindowDisplayAffinity(hwnd, 0x00000001);
        }
    }
}

#[cfg(target_os = "windows")]
fn disable_display_affinity(hwnd: HWND) {
    unsafe {
        let _ = SetWindowDisplayAffinity(hwnd, 0x00000000);
    }
}
#[cfg(target_os = "windows")]
fn install_keyboard_hook() {
    unsafe {
        let hook = SetWindowsHookExW(
            WH_KEYBOARD_LL,
            Some(keyboard_proc),
            GetModuleHandleW(ptr::null()),
            0,
        );

        if hook.is_null() {
            return;
        }
        let mut msg: MSG = std::mem::zeroed();
        while GetMessageW(&mut msg, ptr::null_mut(), 0, 0) > 0 {
            TranslateMessage(&msg);
            DispatchMessageW(&msg);
        }

        UnhookWindowsHookEx(hook);
    }
}
#[cfg(target_os = "windows")]
unsafe extern "system" fn keyboard_proc(
    code: i32,
    w_param: WPARAM,
    l_param: LPARAM,
) -> LRESULT {
    if code == HC_ACTION as i32 {
        let kb = *(l_param as *const KBDLLHOOKSTRUCT);

        if !PROTECTION_ON.load(Ordering::SeqCst) {
            return CallNextHookEx(ptr::null_mut(), code, w_param, l_param);
        }

        if kb.vkCode == 0x2C {
            clear_clipboard();
            return 1;
        }
        if kb.vkCode == 0x53 {
            let win = GetAsyncKeyState(VK_LWIN) as u16 & 0x8000 != 0
                || GetAsyncKeyState(VK_RWIN) as u16 & 0x8000 != 0;
            let shift = GetAsyncKeyState(VK_SHIFT) as u16 & 0x8000 != 0;

            if win && shift {
                clear_clipboard();
                return 1;
            }
        }
        if kb.vkCode == 0x2C {
            let alt = GetAsyncKeyState(VK_MENU) as u16 & 0x8000 != 0;
            if alt {
                clear_clipboard();
                return 1;
            }
        }
    }

    CallNextHookEx(ptr::null_mut(), code, w_param, l_param)
}
#[cfg(target_os = "windows")]
unsafe fn clear_clipboard() {
    if OpenClipboard(ptr::null_mut()) != 0 {
        EmptyClipboard();
        CloseClipboard();
    }
}
#[cfg(target_os = "windows")]
fn monitor_capture_tools() {
    let tools = [
        "sharex.exe",
        "lightshot.exe",
        "greenshot.exe",
        "snippingtool.exe",
        "screenclippinghost.exe",
        "screensketch.exe",
        "snagit.exe",
        "snagit32.exe",
        "picpick.exe",
        "gyazo.exe",
        "gyazowin.exe",
        "flameshot.exe",
        "screenpresso.exe",
        "monosnap.exe",
        "nimbus screenshot.exe",
        "joxi.exe",
        "clip2net.exe",
        "obs64.exe",
        "obs32.exe",
        "obs.exe",
        "streamlabs obs.exe",
        "bandicam.exe",
        "bdcam.exe",
        "camtasia.exe",
        "camrecorder.exe",
        "fraps.exe",
        "action.exe",
        "xsplit.exe",
        "gamebar.exe",
        "gamebarpresencewriter.exe",
        "clipboardfusion.exe",
        "ditto.exe",
        "peek.exe",
    ];

    loop {
        if !PROTECTION_ON.load(Ordering::SeqCst) {
            thread::sleep(Duration::from_secs(5));
            continue;
        }

        unsafe {
            let snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
            if snapshot == INVALID_HANDLE_VALUE {
                thread::sleep(Duration::from_secs(3));
                continue;
            }

            let mut entry: PROCESSENTRY32 = std::mem::zeroed();
            entry.dwSize = std::mem::size_of::<PROCESSENTRY32>() as u32;

            if Process32First(snapshot, &mut entry) != 0 {
                loop {
                    let name_bytes: Vec<u8> = entry
                        .szExeFile
                        .iter()
                        .take_while(|&&c| c != 0)
                        .map(|&c| c as u8)
                        .collect();

                    if let Ok(name) = String::from_utf8(name_bytes) {
                        let lower = name.to_lowercase();
                        for tool in &tools {
                            if lower.contains(tool) {
                                if let Some(&hwnd) = WINDOW_HWND.get() {
                                    apply_display_affinity(hwnd as HWND);
                                }
                                break;
                            }
                        }
                    }

                    if Process32Next(snapshot, &mut entry) == 0 {
                        break;
                    }
                }
            }

            CloseHandle(snapshot);
        }

        thread::sleep(Duration::from_secs(3));
    }
}

#[cfg(target_os = "windows")]
fn monitor_clipboard(hwnd: HWND) {
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
                let fg = GetForegroundWindow();
                if fg == hwnd as HWND {
                    clear_clipboard();
                }
            }
        }

        thread::sleep(Duration::from_millis(500));
    }
}
