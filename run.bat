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

set "ROOT=%CD%"
set "CLIENT_ROOT=%ROOT%\client"
set "DESKTOP_CLIENT_DIR=%CLIENT_ROOT%\desktop"
set "CLI_CLIENT_DIR=%CLIENT_ROOT%\cli"
set "SERVER_DIR=%ROOT%\server\starter"
set "SERVER_ENV=%SERVER_DIR%\.env"
set "SERVER_ENV_EXAMPLE=%SERVER_DIR%\.env.example"
set "SCHEMA_FILE=%ROOT%\server\migrations\scheme\sqlc.sql"

if not exist "%CLIENT_ROOT%\" (
    echo [X] Folder 'client' not found.
    pause
    exit /b 1
)

if not exist "%SERVER_DIR%\go.mod" (
    echo [X] Backend folder 'server\starter' not found.
    pause
    exit /b 1
)

set "GIT_BRANCH="
set "GIT_COMMIT=dev"
set "BUILD_TIME=1970-01-01T00:00:00Z"
set "GIT_CAN_UPDATE="

echo [*] Stopping previous app instances...
taskkill /F /IM SecureGuard.exe      >nul 2>&1
taskkill /F /IM secureguard.exe      >nul 2>&1
taskkill /F /IM password-manager.exe >nul 2>&1

echo.
echo  Start target:
echo  [FULL]    backend + client
echo  [BACKEND] backend only
echo  [CLIENT]  client only
echo.

set "RUN_TARGET="
set /p RUN_TARGET="Target (full/backend/client): "
if not defined RUN_TARGET set "RUN_TARGET=full"

set "RUN_BACKEND=1"
set "RUN_CLIENT=1"

if /I "%RUN_TARGET%"=="backend" set "RUN_CLIENT="
if /I "%RUN_TARGET%"=="client" set "RUN_BACKEND="

if /I not "%RUN_TARGET%"=="full" if /I not "%RUN_TARGET%"=="backend" if /I not "%RUN_TARGET%"=="client" (
    echo [!] Unknown target '%RUN_TARGET%'. Using 'full'.
    set "RUN_TARGET=full"
    set "RUN_BACKEND=1"
    set "RUN_CLIENT=1"
)

if defined RUN_CLIENT (
    echo.
    echo  Client variant:
    echo  [DESKTOP] Tauri desktop app
    echo  [CLI]     Dart CLI
    echo.

    set "CLIENT_VARIANT="
    set /p CLIENT_VARIANT="Client (desktop/cli) [desktop]: "
    if not defined CLIENT_VARIANT set "CLIENT_VARIANT=desktop"

    if /I not "%CLIENT_VARIANT%"=="desktop" if /I not "%CLIENT_VARIANT%"=="cli" (
        echo [!] Unknown client '%CLIENT_VARIANT%'. Using 'desktop'.
        set "CLIENT_VARIANT=desktop"
    )

    if /I "%CLIENT_VARIANT%"=="cli" (
        set "CLIENT_DIR=%CLI_CLIENT_DIR%"
    ) else (
        set "CLIENT_DIR=%DESKTOP_CLIENT_DIR%"
        set "CLIENT_VARIANT=desktop"
    )

    if not exist "%CLIENT_DIR%\" (
        echo [X] Client folder for '%CLIENT_VARIANT%' not found: %CLIENT_DIR%
        pause
        exit /b 1
    )
)

if exist "%ROOT%\.git\" (
    where git >nul 2>&1
    if errorlevel 1 (
        echo [!] Git is not installed. Skipping repository update.
    ) else (
        set "GIT_CAN_UPDATE=1"
        for /f "delims=" %%A in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "GIT_BRANCH=%%A"
        if defined GIT_BRANCH (
            echo [*] Checking repository state...
            set "GIT_DIRTY="
            for /f "delims=" %%A in ('git status --porcelain --untracked-files=normal 2^>nul') do (
                set "GIT_DIRTY=1"
            )
            if defined GIT_DIRTY (
                echo [!] Repository has local changes. Skipping git pull.
            ) else (
                if /I "!GIT_BRANCH!"=="HEAD" (
                    echo [!] Detached HEAD detected. Skipping git pull.
                ) else (
                    echo [*] Pulling latest commit for branch !GIT_BRANCH!...
                    git fetch --prune >nul 2>&1
                    if errorlevel 1 (
                        echo [!] git fetch failed. Continuing with current checkout.
                    ) else (
                        git pull --ff-only origin "!GIT_BRANCH!"
                        if errorlevel 1 (
                            echo [!] git pull failed. Continuing with current checkout.
                        )
                    )
                )
            )
        )
    )
)

if defined GIT_CAN_UPDATE (
    for /f "delims=" %%A in ('git rev-parse HEAD 2^>nul') do set "GIT_COMMIT=%%A"
)
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().ToString(\"yyyy-MM-ddTHH:mm:ssZ\")"') do set "BUILD_TIME=%%A"
echo [*] Build metadata: commit !GIT_COMMIT!, build time !BUILD_TIME!

if not exist "%SERVER_ENV%" (
    echo [*] Creating backend .env with local defaults...
    if exist "%SERVER_ENV_EXAMPLE%" (
        copy /Y "%SERVER_ENV_EXAMPLE%" "%SERVER_ENV%" >nul
        >>"%SERVER_ENV%" (
            echo.
            echo # Local overrides added by run.bat
            echo POSTGRES_HOST=127.0.0.1
            echo POSTGRES_PORT=5432
            echo POSTGRES_USER=postgres
            echo POSTGRES_PASSWORD=postgres
            echo POSTGRES_NAME=secureguard
            echo POSTGRES_TLS=false
            echo BOOT_PORT=8080
            echo SERVER_NAME=SecureGuard Server
            echo REDIS_ADDR=127.0.0.1:6379
            echo REDIS_PASSWORD=
            echo REDIS_DB=0
            echo RATE_LIMIT_ENABLED=true
            echo KAFKA_ENABLED=false
        )
    ) else (
        >"%SERVER_ENV%" (
            echo # Auto-generated by run.bat
            echo POSTGRES_HOST=127.0.0.1
            echo POSTGRES_PORT=5432
            echo POSTGRES_USER=postgres
            echo POSTGRES_PASSWORD=postgres
            echo POSTGRES_NAME=secureguard
            echo POSTGRES_TLS=false
            echo BOOT_PORT=8080
            echo LOG_SERVICE=secureguard
            echo LOG_LEVEL=info
            echo SERVER_NAME=SecureGuard Server
            echo REDIS_ADDR=127.0.0.1:6379
            echo REDIS_PASSWORD=
            echo REDIS_DB=0
            echo RATE_LIMIT_ENABLED=true
            echo KAFKA_ENABLED=false
            echo DEBUG_MODE=false
        )
    )
    echo [!] Created server\starter\.env
    echo [!] Edit DB credentials there if they differ from defaults.
)

set "BACKEND_PORT=50051"
set "DB_HOST=127.0.0.1"
set "DB_PORT=5432"
set "DB_USER=postgres"
set "DB_PASSWORD=postgres"
set "DB_NAME=secureguard"
set "REDIS_ADDR=127.0.0.1:6379"
set "REDIS_PASSWORD="
set "REDIS_DB=0"
set "RATE_LIMIT_ENABLED=false"
set "KAFKA_ENABLED=false"
set "KAFKA_BROKERS=127.0.0.1:9092"
set "KAFKA_TOPIC=secureguard.logs"
set "KAFKA_CLIENT_ID=secureguard-backend"
set "SERVER_NAME_EFFECTIVE=SecureGuard Server"

for /f "usebackq tokens=1,* delims==" %%A in ("%SERVER_ENV%") do (
    set "K=%%~A"
    set "V=%%~B"
    if /I "!K!"=="BOOT_PORT" set "BACKEND_PORT=!V!"
    if /I "!K!"=="POSTGRES_HOST" set "DB_HOST=!V!"
    if /I "!K!"=="POSTGRES_PORT" set "DB_PORT=!V!"
    if /I "!K!"=="POSTGRES_USER" set "DB_USER=!V!"
    if /I "!K!"=="POSTGRES_PASSWORD" set "DB_PASSWORD=!V!"
    if /I "!K!"=="POSTGRES_NAME" set "DB_NAME=!V!"
    if /I "!K!"=="POSTGRES_DB" set "DB_NAME=!V!"
    if /I "!K!"=="REDIS_ADDR" set "REDIS_ADDR=!V!"
    if /I "!K!"=="REDIS_PASSWORD" set "REDIS_PASSWORD=!V!"
    if /I "!K!"=="REDIS_DB" set "REDIS_DB=!V!"
    if /I "!K!"=="RATE_LIMIT_ENABLED" set "RATE_LIMIT_ENABLED=!V!"
    if /I "!K!"=="KAFKA_ENABLED" set "KAFKA_ENABLED=!V!"
    if /I "!K!"=="KAFKA_BROKERS" set "KAFKA_BROKERS=!V!"
    if /I "!K!"=="KAFKA_TOPIC" set "KAFKA_TOPIC=!V!"
    if /I "!K!"=="KAFKA_CLIENT_ID" set "KAFKA_CLIENT_ID=!V!"
    if /I "!K!"=="SERVER_NAME" set "SERVER_NAME_EFFECTIVE=!V!"
)

if not defined BACKEND_PORT set "BACKEND_PORT=50051"
set "BACKEND_HOST=127.0.0.1"
set "BACKEND_ENDPOINT=http://%BACKEND_HOST%:%BACKEND_PORT%"
if not defined REDIS_ADDR set "REDIS_ADDR=127.0.0.1:6379"
set "REDIS_EFFECTIVE_ADDR=!REDIS_ADDR!"
set "REDIS_REQUIRED="
if /I "!RATE_LIMIT_ENABLED!"=="true" set "REDIS_REQUIRED=1"
if /I "!RATE_LIMIT_ENABLED!"=="1" set "REDIS_REQUIRED=1"
if /I "!REDIS_EFFECTIVE_ADDR!"=="redis:6379" set "REDIS_EFFECTIVE_ADDR=127.0.0.1:6379"
for /f "tokens=1,2 delims=:" %%A in ("!REDIS_EFFECTIVE_ADDR!") do (
    set "REDIS_HOST=%%~A"
    set "REDIS_PORT=%%~B"
)
if not defined REDIS_HOST set "REDIS_HOST=127.0.0.1"
if not defined REDIS_PORT set "REDIS_PORT=6379"
if /I "!REDIS_HOST!"=="localhost" set "REDIS_HOST=127.0.0.1"
if /I "!REDIS_HOST!"=="redis" (
    set "REDIS_HOST=127.0.0.1"
    set "REDIS_EFFECTIVE_ADDR=127.0.0.1:!REDIS_PORT!"
)
set "REDIS_LOCAL="
if /I "!REDIS_HOST!"=="127.0.0.1" set "REDIS_LOCAL=1"
if /I "!REDIS_HOST!"=="0.0.0.0" set "REDIS_LOCAL=1"

if not defined KAFKA_BROKERS set "KAFKA_BROKERS=127.0.0.1:9092"
set "KAFKA_EFFECTIVE_BROKERS=!KAFKA_BROKERS!"
set "KAFKA_MULTI_BROKER="
if not "!KAFKA_BROKERS:,=!"=="!KAFKA_BROKERS!" set "KAFKA_MULTI_BROKER=1"
set "KAFKA_PRIMARY_BROKER="
for /f "tokens=1 delims=," %%A in ("!KAFKA_EFFECTIVE_BROKERS!") do (
    set "KAFKA_PRIMARY_BROKER=%%~A"
)
if not defined KAFKA_PRIMARY_BROKER set "KAFKA_PRIMARY_BROKER=127.0.0.1:9092"
for /f "tokens=1,2 delims=:" %%A in ("!KAFKA_PRIMARY_BROKER!") do (
    set "KAFKA_HOST=%%~A"
    set "KAFKA_PORT=%%~B"
)
if not defined KAFKA_HOST set "KAFKA_HOST=127.0.0.1"
if not defined KAFKA_PORT set "KAFKA_PORT=9092"
if /I "!KAFKA_HOST!"=="localhost" set "KAFKA_HOST=127.0.0.1"
if /I "!KAFKA_HOST!"=="kafka" (
    set "KAFKA_HOST=127.0.0.1"
    set "KAFKA_PRIMARY_BROKER=127.0.0.1:!KAFKA_PORT!"
)
if not defined KAFKA_MULTI_BROKER set "KAFKA_EFFECTIVE_BROKERS=!KAFKA_PRIMARY_BROKER!"
set "KAFKA_LOCAL="
if /I "!KAFKA_HOST!"=="127.0.0.1" set "KAFKA_LOCAL=1"
if /I "!KAFKA_HOST!"=="0.0.0.0" set "KAFKA_LOCAL=1"

set "BACKEND_RUNNING="
for /f "tokens=5" %%P in ('netstat -ano ^| findstr /R /C:":%BACKEND_PORT% .*LISTENING"') do (
    set "BACKEND_RUNNING=1"
    goto :backend_status_ready
)

:backend_status_ready
if defined BACKEND_RUNNING (
    echo [+] Backend is already listening on port %BACKEND_PORT%.
) else (
    echo [*] Backend is not running on port %BACKEND_PORT%.
)

if not defined RUN_BACKEND goto :after_backend

where go >nul 2>&1
if errorlevel 1 (
    echo [!] Go is not installed or not in PATH.
    echo [!] Backend was not started automatically.
    echo [!] Install Go and run: cd /d server\starter ^&^& go run .
    goto :after_backend
)

if defined BACKEND_RUNNING goto :after_backend

set "REDIS_USE_DEFAULT=n"
if /I "!RATE_LIMIT_ENABLED!"=="true" set "REDIS_USE_DEFAULT=y"
if /I "!RATE_LIMIT_ENABLED!"=="1" set "REDIS_USE_DEFAULT=y"
echo.
set "USE_REDIS="
set /p USE_REDIS="Use Redis for this run? (y/n) [!REDIS_USE_DEFAULT!]: "
if not defined USE_REDIS set "USE_REDIS=!REDIS_USE_DEFAULT!"
if /I "!USE_REDIS!"=="y" (
    set "REDIS_REQUIRED=1"
    set "RATE_LIMIT_EFFECTIVE=true"
) else (
    set "REDIS_REQUIRED="
    set "RATE_LIMIT_EFFECTIVE=false"
)

set "KAFKA_USE_DEFAULT=n"
if /I "!KAFKA_ENABLED!"=="true" set "KAFKA_USE_DEFAULT=y"
if /I "!KAFKA_ENABLED!"=="1" set "KAFKA_USE_DEFAULT=y"
set "KAFKA_EFFECTIVE_ENABLED=false"
echo.
set "USE_KAFKA="
set /p USE_KAFKA="Use Kafka for this run? (y/n) [!KAFKA_USE_DEFAULT!]: "
if not defined USE_KAFKA set "USE_KAFKA=!KAFKA_USE_DEFAULT!"
if /I "!USE_KAFKA!"=="y" (
    set "KAFKA_REQUIRED=1"
    set "KAFKA_EFFECTIVE_ENABLED=true"
    if defined KAFKA_MULTI_BROKER (
        set "KAFKA_EFFECTIVE_BROKERS=!KAFKA_BROKERS!"
    ) else (
        set "KAFKA_EFFECTIVE_BROKERS=!KAFKA_PRIMARY_BROKER!"
    )
) else (
    set "KAFKA_REQUIRED="
    set "KAFKA_EFFECTIVE_ENABLED=false"
)

echo [*] Backend endpoint: %BACKEND_ENDPOINT%
if defined REDIS_REQUIRED (
    echo [*] Redis endpoint: !REDIS_EFFECTIVE_ADDR!
)
if defined KAFKA_REQUIRED (
    echo [*] Kafka brokers: !KAFKA_EFFECTIVE_BROKERS!
)

echo [*] Checking database (PostgreSQL)...
if /I "!DB_HOST!"=="localhost" set "DB_HOST=127.0.0.1"
set "DB_LOCAL="
if /I "!DB_HOST!"=="127.0.0.1" set "DB_LOCAL=1"
if /I "!DB_HOST!"=="0.0.0.0" set "DB_LOCAL=1"

set "DB_READY="
if not defined DB_LOCAL (
    echo [*] Using remote DB !DB_HOST!:!DB_PORT!
    set "DB_READY=1"
    goto :db_ready
)

for /f "tokens=5" %%P in ('netstat -ano ^| findstr /R /C:":!DB_PORT! .*LISTENING"') do (
    set "DB_READY=1"
    goto :db_ready
)

where docker >nul 2>&1
if errorlevel 1 (
    echo [X] PostgreSQL is not listening on !DB_HOST!:!DB_PORT! and Docker is not installed.
    echo [X] Start PostgreSQL manually and rerun run.bat.
    goto :db_ready
)

docker info >nul 2>&1
if errorlevel 1 (
    echo [X] Docker is installed, but Docker Desktop/daemon is not running.
    echo [X] Start Docker and rerun run.bat.
    goto :db_ready
)

echo [*] Starting PostgreSQL in Docker...
set "PG_CONTAINER=secureguard-postgres"
docker container inspect "!PG_CONTAINER!" >nul 2>&1
if not errorlevel 1 (
    docker start "!PG_CONTAINER!" >nul 2>&1
) else (
    docker run -d --name "!PG_CONTAINER!" -e POSTGRES_USER=!DB_USER! -e POSTGRES_PASSWORD=!DB_PASSWORD! -e POSTGRES_DB=!DB_NAME! -p !DB_PORT!:5432 postgres:16-alpine >nul
)

for /l %%I in (1,1,30) do (
    for /f "tokens=5" %%P in ('netstat -ano ^| findstr /R /C:":!DB_PORT! .*LISTENING"') do (
        set "DB_READY=1"
        goto :db_wait_done
    )
    timeout /t 1 /nobreak >nul
)

:db_wait_done
if not defined DB_READY (
    echo [X] PostgreSQL did not become ready on !DB_HOST!:!DB_PORT!.
    goto :db_ready
)

if exist "%SCHEMA_FILE%" (
    echo [*] Applying DB schema...
    docker exec -i "!PG_CONTAINER!" psql -U "!DB_USER!" -d "!DB_NAME!" < "%SCHEMA_FILE%" >nul 2>&1
    if errorlevel 1 (
        echo [!] Could not auto-apply schema. You can apply it manually:
        echo     psql -U !DB_USER! -d !DB_NAME! -f server\migrations\scheme\sqlc.sql
    )
)

:db_ready
if not defined DB_READY (
    echo [X] Database is not ready. Backend start canceled.
    pause
    exit /b 1
)
echo [+] Database is ready.

if defined REDIS_REQUIRED (
    call :ensure_redis
    if errorlevel 1 (
        pause
        exit /b 1
    )
) else (
    echo [*] Redis is disabled for this run.
)

if defined KAFKA_REQUIRED (
    call :ensure_kafka
    if errorlevel 1 (
        pause
        exit /b 1
    )
) else (
    echo [*] Kafka is disabled for this run.
)

echo [*] Starting backend in a separate window...
set "GO_LDFLAGS=-X github.com/aesterial/secureguard/internal/shared/metadata.CommitHash=!GIT_COMMIT! -X github.com/aesterial/secureguard/internal/shared/metadata.BuildTime=!BUILD_TIME!"
set "BACKEND_LAUNCHER=%TEMP%\secureguard-backend-run.cmd"
(
    echo @echo off
    echo setlocal EnableExtensions
    echo set "REDIS_ADDR=!REDIS_EFFECTIVE_ADDR!"
    echo set "RATE_LIMIT_ENABLED=!RATE_LIMIT_EFFECTIVE!"
    echo set "KAFKA_ENABLED=!KAFKA_EFFECTIVE_ENABLED!"
    echo set "KAFKA_BROKERS=!KAFKA_EFFECTIVE_BROKERS!"
    echo set "SERVER_NAME=!SERVER_NAME_EFFECTIVE!"
    echo set "COMMIT_HASH=!GIT_COMMIT!"
    echo set "BUILD_TIME=!BUILD_TIME!"
    echo cd /d "%SERVER_DIR%"
    echo go run -ldflags^="%GO_LDFLAGS%" .
) > "!BACKEND_LAUNCHER!"
start "SecureGuard Backend" cmd /k ""!BACKEND_LAUNCHER!""
set "BACKEND_RUNNING=1"
timeout /t 2 /nobreak >nul

:after_backend
if defined RUN_CLIENT if not defined BACKEND_RUNNING (
    echo [!] Client will use %BACKEND_ENDPOINT%.
    echo [!] Start backend separately if you need live API calls.
)

if not defined RUN_CLIENT goto :done

cd /d "%CLIENT_DIR%" || (
    echo [X] Failed to access client directory.
    pause
    exit /b 1
)

if /I "%CLIENT_VARIANT%"=="desktop" goto :client_desktop
if /I "%CLIENT_VARIANT%"=="cli" goto :client_cli

echo [X] Unsupported client variant '%CLIENT_VARIANT%'.
pause
exit /b 1

:done
pause
exit /b 0

:client_desktop
if not exist "node_modules\" (
    echo [*] Installing npm dependencies...
    if exist "package-lock.json" (
        call npm ci
    ) else (
        call npm install
    )

    if errorlevel 1 (
        echo [X] npm install failed.
        pause
        exit /b 1
    )
    echo [+] Dependencies installed.
)

echo.
echo  Starting SecureGuard desktop client...
echo.
echo  [DEV]   npm run dev
echo  [BUILD] npm run build
echo.

set "MODE="
set /p MODE="Mode (dev/build): "
if not defined MODE set "MODE=dev"

if /I not "%MODE%"=="dev" if /I not "%MODE%"=="build" (
    echo [!] Unknown mode '%MODE%'. Using 'dev'.
    set "MODE=dev"
)

set "CLIENT_SERVER_ENDPOINT=%BACKEND_ENDPOINT%"
if /I "%MODE%"=="build" (
    echo.
    set /p CLIENT_SERVER_ENDPOINT="Server endpoint for built client [%BACKEND_ENDPOINT%]: "
    if not defined CLIENT_SERVER_ENDPOINT set "CLIENT_SERVER_ENDPOINT=%BACKEND_ENDPOINT%"
)
call :normalize_endpoint_var CLIENT_SERVER_ENDPOINT

set "SECUREGUARD_GRPC_ENDPOINT=%CLIENT_SERVER_ENDPOINT%"
set "SECUREGUARD_BACKEND=%CLIENT_SERVER_ENDPOINT%"
set "SECUREGUARD_DEFAULT_BACKEND=%CLIENT_SERVER_ENDPOINT%"

cls

if /i "%MODE%"=="build" (
    echo  SecureGuard Desktop - BUILD
    echo.
    echo [*] Building release EXE...
    echo [*] Built client default backend: %CLIENT_SERVER_ENDPOINT%
    echo.
    call npm run build

    if errorlevel 1 (
        echo [X] Build failed.
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
    if /i "%OPEN%"=="y" explorer "src-tauri\target\release"
    goto :done
)

echo  ==================================
echo   SecureGuard Desktop - DEV
echo  ==================================
echo.
echo [*] Using backend: %CLIENT_SERVER_ENDPOINT%
echo [*] Starting dev mode...
echo.
call npm run dev
goto :done

:client_cli
where dart >nul 2>&1
if errorlevel 1 (
    echo [X] Dart SDK is not installed or not in PATH.
    pause
    exit /b 1
)

if not exist ".dart_tool\package_config.json" (
    echo [*] Installing Dart dependencies...
    call dart pub get

    if errorlevel 1 (
        echo [X] dart pub get failed.
        pause
        exit /b 1
    )
    echo [+] Dependencies installed.
)

echo.
echo  Starting SecureGuard CLI client...
echo.
echo  [DEV]   dart run bin\secureguard_cli.dart
echo  [BUILD] dart compile exe bin\secureguard_cli.dart
echo.

set "MODE="
set /p MODE="Mode (dev/build): "
if not defined MODE set "MODE=dev"

if /I not "%MODE%"=="dev" if /I not "%MODE%"=="build" (
    echo [!] Unknown mode '%MODE%'. Using 'dev'.
    set "MODE=dev"
)

set "CLIENT_SERVER_ENDPOINT=%BACKEND_ENDPOINT%"
if /I "%MODE%"=="build" (
    echo.
    set /p CLIENT_SERVER_ENDPOINT="Server endpoint for built client [%BACKEND_ENDPOINT%]: "
    if not defined CLIENT_SERVER_ENDPOINT set "CLIENT_SERVER_ENDPOINT=%BACKEND_ENDPOINT%"
)
call :normalize_endpoint_var CLIENT_SERVER_ENDPOINT

cls

if /I "%MODE%"=="build" (
    echo  SecureGuard CLI - BUILD
    echo.
    echo [*] Building CLI executable...
    echo [*] Built client default backend: %CLIENT_SERVER_ENDPOINT%
    echo.
    if not exist "build\" mkdir "build"
    call dart compile exe "-DSECUREGUARD_DEFAULT_SERVER=%CLIENT_SERVER_ENDPOINT%" bin\secureguard_cli.dart -o "build\secureguard-cli.exe"

    if errorlevel 1 (
        echo [X] Build failed.
        pause
        exit /b 1
    )

    echo.
    echo [+] BUILD SUCCESS
    echo [+] EXE: build\secureguard-cli.exe
    echo.

    set "OPEN="
    set /p OPEN="Open folder? (y/n): "
    if /i "%OPEN%"=="y" explorer "build"
    goto :done
)

echo  ==================================
echo   SecureGuard CLI - DEV
echo  ==================================
echo.
echo [*] Using backend: %CLIENT_SERVER_ENDPOINT%
echo [*] Starting dev mode...
echo.
call dart run bin\secureguard_cli.dart --server "%CLIENT_SERVER_ENDPOINT%"
goto :done

:ensure_redis
echo [*] Checking Redis...

if not defined REDIS_LOCAL (
    echo [*] Using remote Redis !REDIS_EFFECTIVE_ADDR!
    echo [+] Redis is ready.
    exit /b 0
)

for /f "tokens=5" %%P in ('netstat -ano ^| findstr /R /C:":!REDIS_PORT! .*LISTENING"') do (
    echo [+] Redis is ready.
    exit /b 0
)

where docker >nul 2>&1
if errorlevel 1 (
    echo [X] Redis is not listening on !REDIS_EFFECTIVE_ADDR! and Docker is not installed.
    echo [X] Start Redis manually and rerun run.bat.
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo [X] Docker is installed, but Docker Desktop/daemon is not running.
    echo [X] Start Docker and rerun run.bat.
    exit /b 1
)

echo [*] Starting Redis in Docker...
set "REDIS_CONTAINER=secureguard-redis"
docker container inspect "!REDIS_CONTAINER!" >nul 2>&1
if not errorlevel 1 (
    docker start "!REDIS_CONTAINER!" >nul 2>&1
) else (
    docker run -d --name "!REDIS_CONTAINER!" -p !REDIS_PORT!:6379 redis:7-alpine redis-server --appendonly yes --save 60 1000 >nul
)

for /l %%I in (1,1,30) do (
    docker exec "!REDIS_CONTAINER!" redis-cli ping 2>nul | findstr /I /C:"PONG" >nul
    if not errorlevel 1 (
        echo [+] Redis is ready.
        exit /b 0
    )
    timeout /t 1 /nobreak >nul
)

echo [X] Redis did not become ready on !REDIS_EFFECTIVE_ADDR!.
echo [X] Redis is not ready. Backend start canceled.
exit /b 1

:ensure_kafka
echo [*] Checking Kafka...

if defined KAFKA_MULTI_BROKER (
    echo [*] Using external Kafka brokers !KAFKA_EFFECTIVE_BROKERS!
    echo [+] Kafka is ready.
    exit /b 0
)

if not defined KAFKA_LOCAL (
    echo [*] Using remote Kafka !KAFKA_EFFECTIVE_BROKERS!
    echo [+] Kafka is ready.
    exit /b 0
)

for /f "tokens=5" %%P in ('netstat -ano ^| findstr /R /C:":!KAFKA_PORT! .*LISTENING"') do (
    echo [+] Kafka is ready.
    exit /b 0
)

where docker >nul 2>&1
if errorlevel 1 (
    echo [X] Kafka is not listening on !KAFKA_EFFECTIVE_BROKERS! and Docker is not installed.
    echo [X] Start Kafka manually and rerun run.bat.
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo [X] Docker is installed, but Docker Desktop/daemon is not running.
    echo [X] Start Docker and rerun run.bat.
    exit /b 1
)

echo [*] Starting Kafka in Docker...
set "KAFKA_CONTAINER=secureguard-kafka"
docker container inspect "!KAFKA_CONTAINER!" >nul 2>&1
if not errorlevel 1 (
    docker start "!KAFKA_CONTAINER!" >nul 2>&1
) else (
    docker run -d --name "!KAFKA_CONTAINER!" -p !KAFKA_PORT!:9092 -e KAFKA_NODE_ID=1 -e KAFKA_PROCESS_ROLES=broker,controller -e KAFKA_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://127.0.0.1:!KAFKA_PORT! -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT -e KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER -e KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT -e KAFKA_CONTROLLER_QUORUM_VOTERS=1@127.0.0.1:9093 -e CLUSTER_ID=MDEyMzQ1Njc4OWFiY2RlZg -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 -e KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 -e KAFKA_AUTO_CREATE_TOPICS_ENABLE=true apache/kafka:3.9.1 >nul
)

for /l %%I in (1,1,45) do (
    docker exec "!KAFKA_CONTAINER!" sh -lc "/opt/kafka/bin/kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --list >/dev/null 2>&1" >nul 2>&1
    if not errorlevel 1 (
        echo [+] Kafka is ready.
        exit /b 0
    )
    timeout /t 1 /nobreak >nul
)

echo [X] Kafka did not become ready on !KAFKA_EFFECTIVE_BROKERS!.
echo [X] Kafka is not ready. Backend start canceled.
exit /b 1

:normalize_endpoint_var
setlocal EnableDelayedExpansion
set "VALUE=!%~1!"
if not defined VALUE (
    endlocal
    exit /b 0
)
set "VALUE=!VALUE:"=!"
echo(!VALUE!| findstr /I "://" >nul
if errorlevel 1 set "VALUE=http://!VALUE!"
endlocal & set "%~1=%VALUE%"
exit /b 0
