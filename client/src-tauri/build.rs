#[cfg(target_os = "windows")]
fn main() {
    let windows =
        tauri_build::WindowsAttributes::new().app_manifest(include_str!("windows-app-manifest.xml"));
    let attributes = tauri_build::Attributes::new().windows_attributes(windows);
    tauri_build::try_build(attributes).expect("failed to run tauri-build");
}

#[cfg(not(target_os = "windows"))]
fn main() {
    tauri_build::build()
}
