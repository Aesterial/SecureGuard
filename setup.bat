@echo off
chcp 65001 >nul 2>&1
title SecureGuard - Setup
color 0A

echo.
echo  ══════════════════════════════════════════
echo   SECURE GUARD - PROJECT SETUP
echo  ══════════════════════════════════════════
echo.

:: Проверка Rust
echo [1/6] Checking Rust...
where rustc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [!] Rust not found. Installing...
    powershell -Command "Invoke-WebRequest -Uri 'https://win.rustup.rs/x86_64' -OutFile 'rustup-init.exe'"
    if exist rustup-init.exe (
        rustup-init.exe -y
        del rustup-init.exe
        set "PATH=%USERPROFILE%\.cargo\bin;%PATH%"
        echo [+] Rust installed
    ) else (
        echo [X] Failed. Install manually: https://rustup.rs
        pause
        exit /b 1
    )
) else (
    for /f "tokens=*" %%i in ('rustc --version') do echo [+] %%i
)

:: Проверка Node.js
echo [2/6] Checking Node.js...
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [X] Node.js not found. Install from https://nodejs.org
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do echo [+] Node %%i
)

:: Создание структуры
echo [3/6] Creating project structure...

set "P=password-manager"

if exist %P% (
    echo [!] Folder '%P%' exists.
    set /p OW="    Overwrite? (y/n): "
    if /i not "%OW%"=="y" exit /b 0
    rmdir /s /q %P%
)

mkdir %P%
mkdir %P%\src
mkdir %P%\src-tauri
mkdir %P%\src-tauri\src
mkdir %P%\src-tauri\icons

echo [+] Folders created

:: Создание пустых файлов
echo [4/6] Creating empty files...

type nul > %P%\package.json
type nul > %P%\src-tauri\Cargo.toml
type nul > %P%\src-tauri\tauri.conf.json
type nul > %P%\src-tauri\build.rs
type nul > %P%\src-tauri\src\main.rs
type nul > %P%\src-tauri\src\crypto.rs
type nul > %P%\src-tauri\src\api.rs
type nul > %P%\src-tauri\src\protection.rs
type nul > %P%\src-tauri\src\screenshot_guard.rs
type nul > %P%\src\index.html
type nul > %P%\src\styles.css
type nul > %P%\src\main.js

echo [+] Files created:
echo.
echo     password-manager/
echo     ├── package.json
echo     ├── src/
echo     │   ├── index.html
echo     │   ├── styles.css
echo     │   └── main.js
echo     └── src-tauri/
echo         ├── Cargo.toml
echo         ├── tauri.conf.json
echo         ├── build.rs
echo         ├── icons/
echo         └── src/
echo             ├── main.rs
echo             ├── crypto.rs
echo             ├── api.rs
echo             ├── protection.rs
echo             └── screenshot_guard.rs
echo.

:: Иконка-заглушка
echo [5/6] Creating placeholder icon...
powershell -Command "Add-Type -AssemblyName System.Drawing; $b=New-Object System.Drawing.Bitmap(32,32); for($x=0;$x-lt32;$x++){for($y=0;$y-lt32;$y++){$b.SetPixel($x,$y,[System.Drawing.Color]::FromArgb(99,102,241))}}; $b.Save('password-manager\src-tauri\icons\icon.png'); $b.Dispose()" 2>nul
if not exist %P%\src-tauri\icons\icon.png (
    fsutil file createnew %P%\src-tauri\icons\icon.ico 1024 >nul 2>&1
)
echo [+] Icon ready

:: Инструкция
echo [6/6] Done!
echo.
echo  ══════════════════════════════════════════
echo   NOW:
echo   2. cd password-manager
echo   3. npm install
echo   4. Run 'run.bat'
echo  ══════════════════════════════════════════
echo.

pause