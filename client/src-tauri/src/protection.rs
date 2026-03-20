#[cfg(target_os = "windows")]
use winapi::shared::minwindef::*;
// #[cfg(target_os = "windows")]
// use winapi::shared::ntdef::NULL;
#[cfg(target_os = "windows")]
use winapi::um::debugapi::*;
// #[cfg(target_os = "windows")]
// use winapi::um::errhandlingapi::*;
#[cfg(target_os = "windows")]
use winapi::um::handleapi::*;
#[cfg(target_os = "windows")]
use winapi::um::libloaderapi::*;
#[cfg(target_os = "windows")]
use winapi::um::memoryapi::*;
#[cfg(target_os = "windows")]
use winapi::um::processthreadsapi::*;
#[cfg(target_os = "windows")]
use winapi::um::tlhelp32::*;
#[cfg(target_os = "windows")]
use winapi::um::winnt::*;
#[cfg(target_os = "windows")]
use winapi::um::winuser::FindWindowA;

use std::process;
use std::ptr;
use std::thread;
use std::time::{Duration, Instant};

#[cfg(target_os = "windows")]
fn spawn_guard_thread<F>(name: &str, f: F)
where
    F: FnOnce() + Send + 'static,
{
    if let Err(err) = thread::Builder::new().name(name.to_string()).spawn(f) {
        eprintln!("SecureGuard protection thread '{}' failed: {}", name, err);
    }
}

fn djb2_hash(s: &[u8]) -> u32 {
    let mut hash: u32 = 5381;
    for &b in s {
        hash = hash.wrapping_mul(33).wrapping_add(b as u32);
    }
    hash
}

fn hash_lower(s: &str) -> u32 {
    let lower: Vec<u8> = s
        .bytes()
        .map(|b| if b >= b'A' && b <= b'Z' { b + 32 } else { b })
        .collect();
    djb2_hash(&lower)
}

#[cfg(all(target_os = "windows", target_arch = "x86_64"))]
mod raw_syscall {
    use super::*;

    ///   4C 8B D1          mov r10, rcx
    ///   B8 XX XX 00 00    mov eax, <syscall_number>

    unsafe fn get_ssn(func_name: &[u8]) -> Option<u32> {
        let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
        if ntdll.is_null() {
            return None;
        }

        let func = GetProcAddress(ntdll, func_name.as_ptr() as *const i8);
        if func.is_null() {
            return None;
        }

        let ptr = func as *const u8;

        if *ptr == 0x4C && *ptr.add(1) == 0x8B && *ptr.add(2) == 0xD1 && *ptr.add(3) == 0xB8 {
            let ssn = std::ptr::read_unaligned(ptr.add(4) as *const u32);
            return Some(ssn);
        }

        resolve_ssn_from_neighbors(ntdll, ptr, func_name)
    }

    unsafe fn resolve_ssn_from_neighbors(
        _ntdll: winapi::shared::minwindef::HMODULE,
        hooked_func: *const u8,
        func_name: &[u8],
    ) -> Option<u32> {
        let base = hooked_func as isize;
        let stub_size: isize = 0x20;

        for direction in &[-1isize, 1isize] {
            for distance in 1..=32isize {
                let neighbor = (base + direction * distance * stub_size) as *const u8;
                if neighbor.is_null() {
                    continue;
                }

                if *neighbor == 0x4C
                    && *neighbor.add(1) == 0x8B
                    && *neighbor.add(2) == 0xD1
                    && *neighbor.add(3) == 0xB8
                {
                    let neighbor_ssn = std::ptr::read_unaligned(neighbor.add(4) as *const u32);
                    let our_ssn = (neighbor_ssn as isize - direction * distance) as u32;
                    return Some(our_ssn);
                }
            }
        }

        resolve_ssn_from_disk(func_name)
    }

    unsafe fn resolve_ssn_from_disk(func_name: &[u8]) -> Option<u32> {
        use std::fs;
        use std::path::PathBuf;

        let sys_root = std::env::var("SystemRoot").unwrap_or_else(|_| "C:\\Windows".to_string());
        let path = PathBuf::from(&sys_root).join("System32").join("ntdll.dll");

        let data = fs::read(&path).ok()?;

        if data.len() < 0x1000 {
            return None;
        }

        let dos_header = &data[0..64];
        if dos_header[0] != 0x4D || dos_header[1] != 0x5A {
            return None;
        }
        let e_lfanew =
            u32::from_le_bytes([data[0x3C], data[0x3D], data[0x3E], data[0x3F]]) as usize;
        if e_lfanew + 4 > data.len() {
            return None;
        }

        if &data[e_lfanew..e_lfanew + 4] != b"PE\0\0" {
            return None;
        }

        let opt_hdr = e_lfanew + 24;
        let magic = u16::from_le_bytes([data[opt_hdr], data[opt_hdr + 1]]);
        if magic != 0x020B {
            return None;
        }

        let export_dir_offset = opt_hdr + 112;
        let export_rva = u32::from_le_bytes([
            data[export_dir_offset],
            data[export_dir_offset + 1],
            data[export_dir_offset + 2],
            data[export_dir_offset + 3],
        ]) as usize;

        if export_rva == 0 {
            return None;
        }

        let file_header = e_lfanew + 4;
        let num_sections =
            u16::from_le_bytes([data[file_header + 2], data[file_header + 3]]) as usize;
        let size_of_opt =
            u16::from_le_bytes([data[file_header + 16], data[file_header + 17]]) as usize;
        let first_section = file_header + 20 + size_of_opt;

        let rva_to_offset = |rva: usize| -> Option<usize> {
            for i in 0..num_sections {
                let sh = first_section + i * 40;
                let vaddr = u32::from_le_bytes([
                    data[sh + 12],
                    data[sh + 13],
                    data[sh + 14],
                    data[sh + 15],
                ]) as usize;
                let vsize =
                    u32::from_le_bytes([data[sh + 8], data[sh + 9], data[sh + 10], data[sh + 11]])
                        as usize;
                let raw_offset = u32::from_le_bytes([
                    data[sh + 20],
                    data[sh + 21],
                    data[sh + 22],
                    data[sh + 23],
                ]) as usize;

                if rva >= vaddr && rva < vaddr + vsize {
                    return Some(rva - vaddr + raw_offset);
                }
            }
            None
        };

        let export_offset = rva_to_offset(export_rva)?;

        let num_names = u32::from_le_bytes([
            data[export_offset + 24],
            data[export_offset + 25],
            data[export_offset + 26],
            data[export_offset + 27],
        ]) as usize;

        let names_rva = u32::from_le_bytes([
            data[export_offset + 32],
            data[export_offset + 33],
            data[export_offset + 34],
            data[export_offset + 35],
        ]) as usize;

        let ordinals_rva = u32::from_le_bytes([
            data[export_offset + 36],
            data[export_offset + 37],
            data[export_offset + 38],
            data[export_offset + 39],
        ]) as usize;

        let funcs_rva = u32::from_le_bytes([
            data[export_offset + 28],
            data[export_offset + 29],
            data[export_offset + 30],
            data[export_offset + 31],
        ]) as usize;

        let names_offset = rva_to_offset(names_rva)?;
        let ordinals_offset = rva_to_offset(ordinals_rva)?;
        let funcs_offset = rva_to_offset(funcs_rva)?;

        let search_name = if func_name.last() == Some(&0) {
            &func_name[..func_name.len() - 1]
        } else {
            func_name
        };

        for i in 0..num_names {
            let name_rva = u32::from_le_bytes([
                data[names_offset + i * 4],
                data[names_offset + i * 4 + 1],
                data[names_offset + i * 4 + 2],
                data[names_offset + i * 4 + 3],
            ]) as usize;

            let name_off = match rva_to_offset(name_rva) {
                Some(o) => o,
                None => continue,
            };

            let mut matches = true;
            for (j, &b) in search_name.iter().enumerate() {
                if name_off + j >= data.len() || data[name_off + j] != b {
                    matches = false;
                    break;
                }
            }
            if !matches {
                continue;
            }

            if name_off + search_name.len() < data.len() && data[name_off + search_name.len()] != 0
            {
                continue;
            }

            let ordinal = u16::from_le_bytes([
                data[ordinals_offset + i * 2],
                data[ordinals_offset + i * 2 + 1],
            ]) as usize;

            let func_rva = u32::from_le_bytes([
                data[funcs_offset + ordinal * 4],
                data[funcs_offset + ordinal * 4 + 1],
                data[funcs_offset + ordinal * 4 + 2],
                data[funcs_offset + ordinal * 4 + 3],
            ]) as usize;

            let func_file_offset = rva_to_offset(func_rva)?;

            // 4C 8B D1 B8 XX XX 00 00
            if func_file_offset + 8 <= data.len()
                && data[func_file_offset] == 0x4C
                && data[func_file_offset + 1] == 0x8B
                && data[func_file_offset + 2] == 0xD1
                && data[func_file_offset + 3] == 0xB8
            {
                let ssn = u32::from_le_bytes([
                    data[func_file_offset + 4],
                    data[func_file_offset + 5],
                    data[func_file_offset + 6],
                    data[func_file_offset + 7],
                ]);
                return Some(ssn);
            }

            return None;
        }

        None
    }

    #[inline(never)]
    unsafe fn do_syscall4(ssn: u32, arg1: u64, arg2: u64, arg3: u64, arg4: u64) -> i32 {
        let result: i32;
        core::arch::asm!(
            "mov r10, rcx",  // r10 == first arg
            "syscall",
            in("eax") ssn,
            in("rcx") arg1,
            in("rdx") arg2,
            in("r8") arg3,
            in("r9") arg4,
            out("r10") _,
            out("r11") _,
            lateout("eax") result,
            options(nostack),
        );
        result
    }

    // DIRECT SYSCALLS $$$
    pub unsafe fn syscall_nt_query_info_process(
        process: HANDLE,
        info_class: u32,
        buffer: *mut std::ffi::c_void,
        buffer_size: u32,
        return_length: *mut u32,
    ) -> i32 {
        let ssn = match get_ssn(b"NtQueryInformationProcess\0") {
            Some(n) => n,
            None => return -1,
        };

        let result: i32;
        core::arch::asm!(
            "mov r10, rcx",
            "sub rsp, 0x28",       // shadow space + 5th arg
            "mov [rsp+0x20], {arg5}",
            "syscall",
            "add rsp, 0x28",
            arg5 = in(reg) return_length as u64,
            in("eax") ssn,
            in("rcx") process as u64,
            in("rdx") info_class as u64,
            in("r8") buffer as u64,
            in("r9") buffer_size as u64,
            out("r10") _,
            out("r11") _,
            lateout("eax") result,
        );
        result
    }

    pub unsafe fn syscall_nt_set_info_thread(
        thread: HANDLE,
        info_class: u32,
        buffer: *mut std::ffi::c_void,
        buffer_size: u32,
    ) -> i32 {
        let ssn = match get_ssn(b"NtSetInformationThread\0") {
            Some(n) => n,
            None => return -1,
        };

        do_syscall4(
            ssn,
            thread as u64,
            info_class as u64,
            buffer as u64,
            buffer_size as u64,
        )
    }

    pub unsafe fn syscall_nt_query_sys_info(
        info_class: u32,
        buffer: *mut std::ffi::c_void,
        buffer_size: u32,
        return_length: *mut u32,
    ) -> i32 {
        let ssn = match get_ssn(b"NtQuerySystemInformation\0") {
            Some(n) => n,
            None => return -1,
        };

        do_syscall4(
            ssn,
            info_class as u64,
            buffer as u64,
            buffer_size as u64,
            return_length as u64,
        )
    }

    pub unsafe fn syscall_nt_close(handle: HANDLE) -> i32 {
        let ssn = match get_ssn(b"NtClose\0") {
            Some(n) => n,
            None => return -1,
        };

        let result: i32;
        core::arch::asm!(
            "mov r10, rcx",
            "syscall",
            in("eax") ssn,
            in("rcx") handle as u64,
            out("r10") _,
            out("r11") _,
            lateout("eax") result,
            options(nostack),
        );
        result
    }

    pub fn check_debug_port_direct() {
        unsafe {
            let mut debug_port: usize = 0;
            let status = syscall_nt_query_info_process(
                GetCurrentProcess(),
                0x07, // ProcessDebugPort
                &mut debug_port as *mut _ as *mut std::ffi::c_void,
                std::mem::size_of::<usize>() as u32,
                ptr::null_mut(),
            );

            if status == 0 && debug_port != 0 {
                super::corrupt_and_exit();
            }
        }
    }

    pub fn check_debug_object_direct() {
        unsafe {
            let mut debug_obj: usize = 0;
            let status = syscall_nt_query_info_process(
                GetCurrentProcess(),
                0x1E, // ProcessDebugObjectHandle
                &mut debug_obj as *mut _ as *mut std::ffi::c_void,
                std::mem::size_of::<usize>() as u32,
                ptr::null_mut(),
            );

            if status == 0 {
                super::corrupt_and_exit();
            }
        }
    }

    pub fn check_debug_flags_direct() {
        unsafe {
            let mut debug_flags: u32 = 1;
            let status = syscall_nt_query_info_process(
                GetCurrentProcess(),
                0x1F, // ProcessDebugFlags
                &mut debug_flags as *mut _ as *mut std::ffi::c_void,
                std::mem::size_of::<u32>() as u32,
                ptr::null_mut(),
            );

            if status == 0 && debug_flags == 0 {
                super::corrupt_and_exit();
            }
        }
    }

    pub fn hide_thread_direct() {
        unsafe {
            syscall_nt_set_info_thread(
                GetCurrentThread(),
                0x11, // ThreadHideFromDebugger
                ptr::null_mut(),
                0,
            );
        }
    }

    pub fn check_kernel_debugger_direct() {
        unsafe {
            #[repr(C)]
            struct KernelDebuggerInfo {
                debugger_enabled: u8,
                debugger_not_present: u8,
            }

            let mut info: KernelDebuggerInfo = std::mem::zeroed();
            let status = syscall_nt_query_sys_info(
                0x23, // SystemKernelDebuggerInformation
                &mut info as *mut _ as *mut std::ffi::c_void,
                std::mem::size_of::<KernelDebuggerInfo>() as u32,
                ptr::null_mut(),
            );

            if status == 0 && info.debugger_enabled != 0 && info.debugger_not_present == 0 {
                super::corrupt_and_exit();
            }
        }
    }

    pub fn close_handle_trap_direct() {
        unsafe {
            let invalid: HANDLE = 0xDEADBEEFusize as HANDLE;
            let status = syscall_nt_close(invalid);
            // STATUS_INVALID_HANDLE = 0xC0000008
            if status != -1073741816i32 {
                // 0xC0000008 as i32
                super::corrupt_and_exit();
            }
        }
    }

    pub fn check_ntdll_hooks() {
        unsafe {
            let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
            if ntdll.is_null() {
                return;
            }

            let funcs_to_check: &[&[u8]] = &[
                b"NtQueryInformationProcess\0",
                b"NtSetInformationThread\0",
                b"NtQuerySystemInformation\0",
                b"NtClose\0",
                b"NtGetContextThread\0",
                b"NtSetContextThread\0",
                b"NtContinue\0",
                b"NtCreateThreadEx\0",
            ];

            for func_name in funcs_to_check {
                let func = GetProcAddress(ntdll, func_name.as_ptr() as *const i8);
                if func.is_null() {
                    continue;
                }

                let ptr = func as *const u8;

                // 4C 8B D1 (mov r10, rcx)
                // B8 XX XX 00 00 (mov eax, ssn)
                let b0 = *ptr;

                // E9 = JMP rel32 (detour)
                // FF 25 = JMP [rip+disp32]
                // 68 = PUSH imm32 (push-ret)
                // CC = INT3 (breakpoint)
                if b0 == 0xE9 || b0 == 0xCC || b0 == 0x68 {
                    super::corrupt_and_exit();
                }

                // FF 25 check
                if b0 == 0xFF && *ptr.add(1) == 0x25 {
                    super::corrupt_and_exit();
                }

                // 4C 8B D1 on x64
                if b0 != 0x4C || *ptr.add(1) != 0x8B || *ptr.add(2) != 0xD1 {
                    super::corrupt_and_exit(); // hooked !!!
                }
            }
        }
    }
}

#[cfg(target_os = "windows")]
fn blacklisted_hashes() -> Vec<u32> {
    vec![
        // debuggers
        hash_lower("ollydbg.exe"),
        hash_lower("x64dbg.exe"),
        hash_lower("x32dbg.exe"),
        hash_lower("ida.exe"),
        hash_lower("ida64.exe"),
        hash_lower("idag.exe"),
        hash_lower("idag64.exe"),
        hash_lower("idaw.exe"),
        hash_lower("idaw64.exe"),
        hash_lower("idaq.exe"),
        hash_lower("idaq64.exe"),
        hash_lower("windbg.exe"),
        hash_lower("windbgx.exe"),
        hash_lower("dbgsrv.exe"),
        hash_lower("kd.exe"),
        hash_lower("ntkd.exe"),
        hash_lower("ntsd.exe"),
        hash_lower("cdb.exe"),
        // RE tools
        hash_lower("ghidra.exe"),
        hash_lower("ghidrarun.exe"),
        hash_lower("javaw.exe"),
        hash_lower("binaryninja.exe"),
        hash_lower("radare2.exe"),
        hash_lower("r2agent.exe"),
        hash_lower("cutter.exe"),
        hash_lower("rizin.exe"),
        hash_lower("hopper.exe"),
        // memory tools
        hash_lower("cheatengine-x86_64.exe"),
        hash_lower("cheatengine-i386.exe"),
        hash_lower("cheatengine.exe"),
        hash_lower("reclass.exe"),
        hash_lower("reclass.net.exe"),
        hash_lower("processhacker.exe"),
        hash_lower("systeminformer.exe"),
        hash_lower("procmon.exe"),
        hash_lower("procmon64.exe"),
        hash_lower("procexp.exe"),
        hash_lower("procexp64.exe"),
        // dumpers / unpackers
        hash_lower("scylla.exe"),
        hash_lower("scylla_x64.exe"),
        hash_lower("scylla_x86.exe"),
        hash_lower("megadumper.exe"),
        hash_lower("dumpcap.exe"),
        hash_lower("pestudio.exe"),
        hash_lower("pe-bear.exe"),
        hash_lower("die.exe"),
        // network
        hash_lower("fiddler.exe"),
        hash_lower("wireshark.exe"),
        hash_lower("httpdebugger.exe"),
        hash_lower("httpdebuggerpro.exe"),
        hash_lower("charlesdebug.exe"),
        // .NET
        hash_lower("dnspy.exe"),
        hash_lower("dnspy-x86.exe"),
        hash_lower("dotpeek.exe"),
        hash_lower("ilspy.exe"),
        // misc
        hash_lower("hiew.exe"),
        hash_lower("immunitydebugger.exe"),
        hash_lower("importrec.exe"),
        hash_lower("protection_id.exe"),
        hash_lower("apimonitor-x64.exe"),
        hash_lower("apimonitor-x86.exe"),
    ]
}

pub fn init_protection() {
    #[cfg(target_os = "windows")]
    {
        check_debugger();
        check_hardware_breakpoints();

        // safe checks ?
        spawn_guard_thread("sg-startup-checks", || {
            thread::sleep(Duration::from_millis(500));

            check_ntquery_debug_port();
            check_ntquery_debug_object();
            check_ntquery_debug_flags();
            check_heap_flags();
            check_kernel_debugger();
        });
        
        thread::spawn(|| {
            thread::sleep(Duration::from_secs(2));
            erase_pe_header();
        });

        spawn_watchdog();
        spawn_integrity_watchdog();
        spawn_syscall_watchdog();
    }
}

/*
pub fn init_protection() {
    #[cfg(target_os = "windows")]
    {
        check_debugger();
        check_hardware_breakpoints();

        #[cfg(target_arch = "x86_64")]
        {
            raw_syscall::check_debug_port_direct();
            raw_syscall::check_debug_object_direct();
            raw_syscall::check_debug_flags_direct();
            raw_syscall::check_ntdll_hooks();
            raw_syscall::hide_thread_direct();
        }

        hide_thread();
        patch_dbg_attach();

        thread::spawn(|| {
            thread::sleep(Duration::from_millis(500));

            #[cfg(target_arch = "x86_64")]
            {
                raw_syscall::check_debug_port_direct();
                raw_syscall::check_debug_object_direct();
                raw_syscall::check_debug_flags_direct();
                raw_syscall::check_kernel_debugger_direct();
                raw_syscall::close_handle_trap_direct();
            }

            check_ntquery_debug_port();
            check_ntquery_debug_object();
            check_ntquery_debug_flags();
            check_heap_flags();
            check_kernel_debugger();
        });

        thread::spawn(|| {
            thread::sleep(Duration::from_secs(2));
            erase_pe_header();
        });

        spawn_watchdog();
        spawn_integrity_watchdog();
        spawn_syscall_watchdog();
    }
}
*/

#[cfg(target_os = "windows")]
fn check_debugger() {
    unsafe {
        if IsDebuggerPresent() != 0 {
            corrupt_and_exit();
        }

        let mut present: BOOL = 0;
        if CheckRemoteDebuggerPresent(GetCurrentProcess(), &mut present) != 0 && present != 0 {
            corrupt_and_exit();
        }

        // Keep lightweight checks to reduce false positives on real user machines.
        check_peb_debug_flag();
    }
}

#[cfg(target_os = "windows")]
fn check_peb_flag() {
    #[cfg(target_arch = "x86_64")]
    unsafe {
        let peb: u64;
        core::arch::asm!("mov {}, gs:[0x60]", out(reg) peb);
        if peb != 0 {
            let flags = ptr::read_unaligned((peb + 0xBC) as *const u32);
            if flags & 0x70 != 0 {
                corrupt_and_exit();
            }
        }
    }

    #[cfg(target_arch = "x86")]
    unsafe {
        let peb: u32;
        core::arch::asm!("mov {}, fs:[0x30]", out(reg) peb);
        if peb != 0 {
            let flags = ptr::read_unaligned((peb + 0x68) as *const u32);
            if flags & 0x70 != 0 {
                corrupt_and_exit();
            }
        }
    }
}

#[cfg(target_os = "windows")]
fn check_peb_debug_flag() {
    #[cfg(target_arch = "x86_64")]
    unsafe {
        let peb: u64;
        core::arch::asm!("mov {}, gs:[0x60]", out(reg) peb);
        if peb != 0 {
            let being_debugged = ptr::read_unaligned((peb + 0x02) as *const u8);
            if being_debugged != 0 {
                corrupt_and_exit();
            }
        }
    }
}

#[cfg(target_os = "windows")]
fn check_hardware_breakpoints() {
    unsafe {
        let mut ctx: CONTEXT = std::mem::zeroed();
        ctx.ContextFlags = CONTEXT_DEBUG_REGISTERS;

        if GetThreadContext(GetCurrentThread(), &mut ctx) != 0 {
            if ctx.Dr0 != 0 || ctx.Dr1 != 0 || ctx.Dr2 != 0 || ctx.Dr3 != 0 {
                corrupt_and_exit();
            }
            if ctx.Dr7 & 0xFF != 0 {
                corrupt_and_exit();
            }
        }
    }
}

#[cfg(target_os = "windows")]
fn check_ntquery_debug_port() {
    unsafe {
        let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
        if ntdll.is_null() {
            return;
        }

        let func = GetProcAddress(ntdll, b"NtQueryInformationProcess\0".as_ptr() as *const i8);
        if func.is_null() {
            return;
        }

        type NtQueryInfoProc =
            unsafe extern "system" fn(HANDLE, u32, *mut std::ffi::c_void, u32, *mut u32) -> i32;

        let nt_query: NtQueryInfoProc = std::mem::transmute(func);

        let mut debug_port: usize = 0;
        let status = nt_query(
            GetCurrentProcess(),
            0x07,
            &mut debug_port as *mut _ as *mut std::ffi::c_void,
            std::mem::size_of::<usize>() as u32,
            ptr::null_mut(),
        );

        if status == 0 && debug_port != 0 {
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
fn check_ntquery_debug_object() {
    unsafe {
        let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
        if ntdll.is_null() {
            return;
        }

        let func = GetProcAddress(ntdll, b"NtQueryInformationProcess\0".as_ptr() as *const i8);
        if func.is_null() {
            return;
        }

        type NtQueryInfoProc =
            unsafe extern "system" fn(HANDLE, u32, *mut std::ffi::c_void, u32, *mut u32) -> i32;

        let nt_query: NtQueryInfoProc = std::mem::transmute(func);

        let mut debug_obj: usize = 0;
        let status = nt_query(
            GetCurrentProcess(),
            0x1E,
            &mut debug_obj as *mut _ as *mut std::ffi::c_void,
            std::mem::size_of::<usize>() as u32,
            ptr::null_mut(),
        );

        if status == 0 {
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
fn check_ntquery_debug_flags() {
    unsafe {
        let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
        if ntdll.is_null() {
            return;
        }

        let func = GetProcAddress(ntdll, b"NtQueryInformationProcess\0".as_ptr() as *const i8);
        if func.is_null() {
            return;
        }

        type NtQueryInfoProc =
            unsafe extern "system" fn(HANDLE, u32, *mut std::ffi::c_void, u32, *mut u32) -> i32;

        let nt_query: NtQueryInfoProc = std::mem::transmute(func);

        let mut debug_flags: u32 = 1;
        let status = nt_query(
            GetCurrentProcess(),
            0x1F,
            &mut debug_flags as *mut _ as *mut std::ffi::c_void,
            std::mem::size_of::<u32>() as u32,
            ptr::null_mut(),
        );

        if status == 0 && debug_flags == 0 {
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
fn check_heap_flags() {
    #[cfg(target_arch = "x86_64")]
    unsafe {
        let peb: u64;
        core::arch::asm!("mov {}, gs:[0x60]", out(reg) peb);
        if peb == 0 {
            return;
        }

        let process_heap = ptr::read_unaligned((peb + 0x30) as *const u64);
        if process_heap == 0 {
            return;
        }

        let flags = ptr::read_unaligned((process_heap + 0x70) as *const u32);
        let force_flags = ptr::read_unaligned((process_heap + 0x74) as *const u32);

        if flags != 2 || force_flags != 0 {
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
fn check_kernel_debugger() {
    unsafe {
        let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
        if ntdll.is_null() {
            return;
        }

        let func = GetProcAddress(ntdll, b"NtQuerySystemInformation\0".as_ptr() as *const i8);
        if func.is_null() {
            return;
        }

        type NtQuerySysInfo =
            unsafe extern "system" fn(u32, *mut std::ffi::c_void, u32, *mut u32) -> i32;

        let nt_query: NtQuerySysInfo = std::mem::transmute(func);

        #[repr(C)]
        struct KernelDebuggerInfo {
            debugger_enabled: u8,
            debugger_not_present: u8,
        }

        let mut info: KernelDebuggerInfo = std::mem::zeroed();
        let status = nt_query(
            0x23,
            &mut info as *mut _ as *mut std::ffi::c_void,
            std::mem::size_of::<KernelDebuggerInfo>() as u32,
            ptr::null_mut(),
        );

        if status == 0 && info.debugger_enabled != 0 && info.debugger_not_present == 0 {
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
fn check_closehandle_trap() {
    unsafe {
        let result = std::panic::catch_unwind(|| {
            let invalid: HANDLE = 0xDEADBEEF as HANDLE;
            CloseHandle(invalid);
        });
        if result.is_err() {
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
fn check_timing() {
    let t1: u64;
    let t2: u64;
    unsafe {
        core::arch::asm!("rdtsc", "shl rdx, 32", "or rax, rdx", out("rax") t1, out("rdx") _);
    }

    let mut dummy: u64 = 0;
    for i in 0..500_000u64 {
        dummy = dummy.wrapping_add(i);
    }
    let _ = dummy;

    unsafe {
        core::arch::asm!("rdtsc", "shl rdx, 32", "or rax, rdx", out("rax") t2, out("rdx") _);
    }

    if t2.wrapping_sub(t1) > 100_000_000 {
        corrupt_and_exit();
    }

    let start = Instant::now();
    let mut v: u64 = 0;
    for i in 0..200_000u64 {
        v = v.wrapping_mul(i.wrapping_add(1));
    }
    let _ = v;
    if start.elapsed().as_millis() > 300 {
        corrupt_and_exit();
    }
}

#[cfg(target_os = "windows")]
fn patch_dbg_attach() {
    unsafe {
        let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
        if ntdll.is_null() {
            return;
        }

        let func = GetProcAddress(ntdll, b"DbgUiRemoteBreakin\0".as_ptr() as *const i8);
        if func.is_null() {
            return;
        }

        let mut old_protect: DWORD = 0;
        let patch_size = 8usize;

        if VirtualProtect(
            func as *mut _,
            patch_size,
            PAGE_EXECUTE_READWRITE,
            &mut old_protect,
        ) != 0
        {
            let kernel32 = GetModuleHandleA(b"kernel32.dll\0".as_ptr() as *const i8);
            if !kernel32.is_null() {
                let exit_proc = GetProcAddress(kernel32, b"ExitProcess\0".as_ptr() as *const i8);
                if !exit_proc.is_null() {
                    let target = func as *mut u8;
                    // mov, ecx 0
                    *target = 0x31; // xor ecx, ecx
                    *target.add(1) = 0xC9;
                    *target.add(2) = 0xE9;
                    let rel_addr = (exit_proc as isize) - (target.add(7) as isize);
                    ptr::write_unaligned(target.add(3) as *mut i32, rel_addr as i32);
                }
            }

            VirtualProtect(func as *mut _, patch_size, old_protect, &mut old_protect);
        }

        let dbg_break = GetProcAddress(ntdll, b"DbgBreakPoint\0".as_ptr() as *const i8);
        if !dbg_break.is_null() {
            let mut old: DWORD = 0;
            if VirtualProtect(dbg_break as *mut _, 1, PAGE_EXECUTE_READWRITE, &mut old) != 0 {
                *(dbg_break as *mut u8) = 0xC3; // ret
                VirtualProtect(dbg_break as *mut _, 1, old, &mut old);
            }
        }
    }
}

#[cfg(target_os = "windows")]
fn hide_thread() {
    unsafe {
        let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
        if ntdll.is_null() {
            return;
        }

        let func = GetProcAddress(ntdll, b"NtSetInformationThread\0".as_ptr() as *const i8);
        if func.is_null() {
            return;
        }

        type NtSetInfoThread =
            unsafe extern "system" fn(HANDLE, u32, *mut std::ffi::c_void, u32) -> i32;

        let nt_set: NtSetInfoThread = std::mem::transmute(func);
        nt_set(GetCurrentThread(), 0x11, ptr::null_mut(), 0);
    }
}

#[cfg(target_os = "windows")]
fn erase_pe_header() {
    unsafe {
        let module = GetModuleHandleA(ptr::null());
        if module.is_null() {
            return;
        }

        let base = module as *mut u8;
        if *(base as *const u16) != 0x5A4D {
            return;
        }

        let size: usize = 0x1000;
        let mut old_protect: DWORD = 0;

        if VirtualProtect(base as *mut _, size, PAGE_READWRITE, &mut old_protect) != 0 {
            for i in 0..size {
                let garbage = ((i * 0x5DEECE66D + 0xB) & 0xFF) as u8;
                *base.add(i) = garbage;
            }
            VirtualProtect(base as *mut _, size, old_protect, &mut old_protect);
        }
    }
}

#[cfg(target_os = "windows")]
unsafe fn check_debugger_windows() {
    let window_classes: &[&[u8]] = &[
        b"OLLYDBG\0",
        b"x64dbg\0",
        b"x32dbg\0",
        b"WinDbgFrameClass\0",
        b"ID\0",
        b"idawindow\0",
        b"taboraliofficeclass\0",
        b"IDATopLevelWindow\0",
        b"SunAwtFrame\0",
        b"ApApiTraceMainWnd\0",
        b"TfrmCheatEngine\0",
        b"dark_trainer\0",
    ];

    for class in window_classes {
        let hwnd = FindWindowA(class.as_ptr() as *const i8, ptr::null());
        if !hwnd.is_null() {
            corrupt_and_exit();
        }
    }

    let window_titles: &[&[u8]] = &[
        b"Ghidra\0",
        b"IDA -\0",
        b"IDA Pro\0",
        b"x64dbg\0",
        b"x32dbg\0",
        b"OllyDbg\0",
        b"Cheat Engine\0",
        b"Binary Ninja\0",
        b"Cutter\0",
        b"Scylla\0",
        b"Process Hacker\0",
        b"System Informer\0",
        b"ReClass\0",
    ];

    for title in window_titles {
        let hwnd = FindWindowA(ptr::null(), title.as_ptr() as *const i8);
        if !hwnd.is_null() {
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
unsafe fn check_blacklisted_processes() {
    let snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if snapshot == INVALID_HANDLE_VALUE {
        return;
    }

    let hashes = blacklisted_hashes();

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
                let h = hash_lower(&name);
                if hashes.contains(&h) {
                    CloseHandle(snapshot);
                    corrupt_and_exit();
                }
            }

            if Process32Next(snapshot, &mut entry) == 0 {
                break;
            }
        }
    }

    CloseHandle(snapshot);
}

#[cfg(target_os = "windows")]
unsafe fn check_suspicious_drivers() {
    let devices: &[&[u8]] = &[
        b"\\\\.\\NTICE\0",
        b"\\\\.\\SICE\0",
        b"\\\\.\\SIWVID\0",
        b"\\\\.\\REGVXG\0",
        b"\\\\.\\FILEVXG\0",
        b"\\\\.\\TRW\0",
        b"\\\\.\\ICEEXT\0",
    ];

    for dev in devices {
        let handle = winapi::um::fileapi::CreateFileA(
            dev.as_ptr() as *const i8,
            GENERIC_READ,
            0,
            ptr::null_mut(),
            winapi::um::fileapi::OPEN_EXISTING,
            0,
            ptr::null_mut(),
        );

        if handle != INVALID_HANDLE_VALUE {
            CloseHandle(handle);
            corrupt_and_exit();
        }
    }
}

#[cfg(target_os = "windows")]
unsafe fn check_parent_process() {
    let ntdll = GetModuleHandleA(b"ntdll.dll\0".as_ptr() as *const i8);
    if ntdll.is_null() {
        return;
    }

    let func = GetProcAddress(ntdll, b"NtQueryInformationProcess\0".as_ptr() as *const i8);
    if func.is_null() {
        return;
    }

    type NtQueryInfoProc =
        unsafe extern "system" fn(HANDLE, u32, *mut std::ffi::c_void, u32, *mut u32) -> i32;

    let nt_query: NtQueryInfoProc = std::mem::transmute(func);

    // PROCESS_BASIC_INFORMATION
    #[repr(C)]
    struct ProcessBasicInfo {
        exit_status: usize,
        peb_base: usize,
        affinity_mask: usize,
        base_priority: i32,
        _pad: u32,
        unique_pid: usize,
        parent_pid: usize,
    }

    let mut info: ProcessBasicInfo = std::mem::zeroed();
    let status = nt_query(
        GetCurrentProcess(),
        0, // ProcessBasicInformation
        &mut info as *mut _ as *mut std::ffi::c_void,
        std::mem::size_of::<ProcessBasicInfo>() as u32,
        ptr::null_mut(),
    );

    if status != 0 {
        return;
    }

    let snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if snapshot == INVALID_HANDLE_VALUE {
        return;
    }

    let mut entry: PROCESSENTRY32 = std::mem::zeroed();
    entry.dwSize = std::mem::size_of::<PROCESSENTRY32>() as u32;

    if Process32First(snapshot, &mut entry) != 0 {
        loop {
            if entry.th32ProcessID as usize == info.parent_pid {
                let name_bytes: Vec<u8> = entry
                    .szExeFile
                    .iter()
                    .take_while(|&&c| c != 0)
                    .map(|&c| c as u8)
                    .collect();

                if let Ok(name) = String::from_utf8(name_bytes) {
                    let lower = name.to_lowercase();
                    let h = hash_lower(&lower);
                    let hashes = blacklisted_hashes();
                    if hashes.contains(&h) {
                        CloseHandle(snapshot);
                        corrupt_and_exit();
                    }
                }
                break;
            }

            if Process32Next(snapshot, &mut entry) == 0 {
                break;
            }
        }
    }

    CloseHandle(snapshot);
}

#[cfg(target_os = "windows")]
fn spawn_watchdog() {
    spawn_guard_thread("sg-watchdog", || {
        hide_thread();

        thread::sleep(Duration::from_secs(3));

        loop {
            let sleep_ms = 2000
                + (std::time::SystemTime::now()
                    .duration_since(std::time::UNIX_EPOCH)
                    .unwrap_or_default()
                    .as_millis()
                    % 3000) as u64;

            thread::sleep(Duration::from_millis(sleep_ms));

            unsafe {
                if IsDebuggerPresent() != 0 {
                    corrupt_and_exit();
                }

                let mut present: BOOL = 0;
                if CheckRemoteDebuggerPresent(GetCurrentProcess(), &mut present) != 0
                    && present != 0
                {
                    corrupt_and_exit();
                }

                check_debugger_windows(); // tested, work
                check_blacklisted_processes(); // tested, work
                check_suspicious_drivers(); // not tested
                check_parent_process() // tested, work
            }

            check_hardware_breakpoints(); // tested (ida, cannot to handling types), work
            check_ntquery_debug_port(); // not tested
            check_ntquery_debug_flags(); // not tested
        }
    });
}

#[cfg(target_os = "windows")]
fn spawn_integrity_watchdog() {
    let check_debugger_addr = check_debugger as *const () as usize;
    let initial_hash = unsafe { hash_code_region(check_debugger_addr, 64) };

    spawn_guard_thread("sg-integrity-watchdog", move || {
        hide_thread();
        thread::sleep(Duration::from_secs(7));

        loop {
            thread::sleep(Duration::from_secs(5));

            let current_hash = unsafe { hash_code_region(check_debugger_addr, 64) };
            if current_hash != initial_hash {
                corrupt_and_exit();
            }

            check_timing();

            unsafe {
                let funcs: &[usize] = &[
                    check_debugger as *const () as usize,
                    check_hardware_breakpoints as *const () as usize,
                    check_ntquery_debug_port as *const () as usize,
                    silent_exit as *const () as usize,
                ];

                for &addr in funcs {
                    let byte = *(addr as *const u8);
                    if byte == 0xCC {
                        corrupt_and_exit();
                    }
                }
            }
        }
    });
}

#[cfg(all(target_os = "windows", target_arch = "x86_64"))]
fn spawn_syscall_watchdog() {
    spawn_guard_thread("sg-syscall-watchdog", || {
        raw_syscall::hide_thread_direct();
        thread::sleep(Duration::from_secs(4));

        loop {
            let jitter = (std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .unwrap_or_default()
                .as_nanos()
                % 4000) as u64
                + 1500;
            thread::sleep(Duration::from_millis(jitter));

            raw_syscall::check_debug_port_direct();
            raw_syscall::check_debug_object_direct();
            raw_syscall::check_debug_flags_direct();
            raw_syscall::check_kernel_debugger_direct();
            raw_syscall::check_ntdll_hooks();
            check_hardware_breakpoints();
            check_timing();
        }
    });
}

#[cfg(target_os = "windows")]
unsafe fn hash_code_region(addr: usize, len: usize) -> u32 {
    let mut hash: u32 = 0;
    for i in 0..len {
        let byte = *((addr + i) as *const u8);
        hash = hash.wrapping_mul(31).wrapping_add(byte as u32);
    }
    hash
}

fn silent_exit() -> ! {
    process::exit(0); // or 0xdeadbeef bsod
}

fn corrupt_and_exit() -> ! {
    silent_exit()
}

#[cfg(not(all(target_os = "windows", target_arch = "x86_64")))]
fn spawn_syscall_watchdog() {}
