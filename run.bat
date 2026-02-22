@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul 2>&1
title SecureGuard - Run
color 0B

cls

REM Always run relative to this .bat file location
cd /d "%~dp0" || (
    echo [X] Failed to access script directory.
    pause
    exit /b 1
)

REM Enter project folder
cd /d "password-manager" 2>nul || (
    echo [X] Folder 'password-manager' not found.
    echo     Run setup.bat first.
    pause
    exit /b 1
)

echo [*] Stopping previous app instances...
taskkill /F /IM SecureGuard.exe        >nul 2>&1
taskkill /F /IM secureguard.exe        >nul 2>&1
taskkill /F /IM password-manager.exe   >nul 2>&1

REM Install deps only if needed
if not exist "node_modules\" (
    echo [*] Installing npm dependencies...

    REM Prefer npm ci when lockfile exists (more consistent)
    if exist "package-lock.json" (
        call npm ci
    ) else (
        call npm install
    )

    if errorlevel 1 (
        echo [X] npm install failed
        pause
        exit /b 1
    )
    echo [+] Dependencies installed
)

echo.
echo  Starting SecureGuard...
echo.
echo  [DEV]   npm run dev
echo  [BUILD] npm run build
echo.

set "MODE="
set /p MODE="Mode (dev/build): "
if not defined MODE set "MODE=dev"

cls

if /i "%MODE%"=="build" (
    echo  SecureGuard - BUILD
    echo.
    echo [*] Building release EXE...
    echo [*] First build can take several minutes.
    echo.
    call npm run build

    if errorlevel 1 (
        echo [X] Build failed
        pause
        exit /b 1
    )

    echo.
    echo [+] BUILD SUCCESS
    echo [+] EXE:       src-tauri\target\release\
    echo [+] Installer: src-tauri\target\release\bundle\nsis\
    echo.

    set "OPEN="
    set /p OPEN="Open folder? (y/n): "
    if /i "%OPEN%"=="y" (
        explorer "src-tauri\target\release"
    )
) else (
    echo  ==================================
    echo   SecureGuard - DEV
    echo  ==================================
    echo.
    echo [*] Starting dev mode...
    echo.
    call npm run dev
)

pause