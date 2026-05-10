document.addEventListener("DOMContentLoaded", function () {
  bootstrapApp(40);
});

var I18N = {
  ru: {
    "common.admin": "Админ-панель",
    "admin.title": "Админ-панель",
    "admin.refresh": "Обновить",
    "admin.readonly":
      "Только просмотр статистики. Управление пользователями недоступно.",
    "admin.totalUsers": "Пользователи",
    "admin.totalAdmins": "Администраторы",
    "admin.totalPasswords": "Пароли",
    "admin.totalSessions": "Активные сессии",
    "admin.activityGraph": "Активность пользователей",
    "admin.registerGraph": "Регистрации",
    "admin.topServices": "Топ сервисов",
    "admin.cryptUsage": "Использование шифрования",
    "admin.noData": "Данных пока нет",
    "error.statsLoad": "Не удалось загрузить статистику",
    "common.username": "Логин",
    "common.password": "Пароль",
    "common.seedPhrase": "Сид-фраза",
    "common.login": "Войти",
    "common.logout": "Выйти",
    "common.settings": "Настройки",
    "common.cancel": "Отмена",
    "common.delete": "Удалить",
    "common.justNow": "только что",

    "login.brandSubtitle": "Безопасное хранение паролей",
    "login.title": "Вход",
    "login.submit": "Войти",
    "login.noAccount": "Нет аккаунта?",
    "login.create": "Создать",
    "login.usernamePlaceholder": "Введите логин",
    "login.passwordPlaceholder": "Введите пароль",

    "register.brandSubtitle": "Создание нового аккаунта",
    "register.title": "Регистрация",
    "register.confirmPassword": "Подтвердите пароль",
    "register.seedInfo":
      "Сид-фраза используется только локально для шифрования и расшифровки ваших паролей. Сервер не хранит и не возвращает её в исходном виде.",
    "register.warn":
      "Запишите сид-фразу и храните локально. Без неё расшифровать данные не получится.",
    "register.submit": "Создать аккаунт",
    "register.haveAccount": "Уже есть аккаунт?",
    "register.usernamePlaceholder": "Минимум 3 символа",
    "register.passwordPlaceholder": "Минимум 8 символов",
    "register.passwordConfirmPlaceholder": "Повторите пароль",
    "register.seedPlaceholder": "Введите сид-фразу (мин. 1 слово)",

    "dashboard.title": "Хранилище",
    "dashboard.addPassword": "Добавить пароль",
    "dashboard.emptyTitle": "Записей пока нет",
    "dashboard.emptySubtitle": "Добавьте первый пароль",

    "add.title": "Новая запись",
    "add.name": "Название",
    "add.login": "Логин",
    "add.namePlaceholder": "Gmail, GitHub, VK...",
    "add.loginPlaceholder": "Логин для сохранения",
    "add.passwordPlaceholder": "Пароль для аккаунта",
    "add.seedPlaceholder": "Локальная сид-фраза для шифрования",
    "add.save": "Сохранить и закрыть",

    "settings.title": "Настройки",
    "settings.language.title": "Язык",
    "settings.language.desc": "Выберите язык интерфейса приложения.",
    "settings.language.ru": "Русский",
    "settings.language.en": "English",
    "settings.dpi.title": "Масштаб интерфейса",
    "settings.dpi.desc":
      "Меняет DPI/масштаб самой приложухи без изменения системного масштаба.",
    "settings.encryption.title": "Алгоритм шифрования",
    "settings.encryption.desc":
      "Выберите способ шифрования паролей сид-фразой.",
    "settings.encryption.argon2id": "AES-256-GCM + Argon2id (рекомендуется)",
    "settings.encryption.sha256": "AES-256-GCM + SHA-256 (быстро)",

    "settings.screenshotGuard.title": "Screenshot Guard",
    "settings.screenshotGuard.desc":
      "Блокирует создание скриншотов окна приложения.",

    "settings.lightTheme.title": "Светлая тема",
    "settings.lightTheme.desc": "Использовать светлую тему интерфейса.",

    "settings.startup.title": "Запуск с Windows",
    "settings.startup.desc":
      "Автоматически запускать SecureGuard при входе в систему.",

    "settings.autoLock.title": "Автоблокировка",
    "settings.autoLock.desc": "Автоматически блокировать приложение.",

    "settings.autoLockMinutes.title": "Таймер автоблокировки",
    "settings.autoLockMinutes.desc":
      "Через сколько минут блокировать приложение.",

    "settings.confirmDelete.title": "Подтверждение удаления",
    "settings.confirmDelete.desc": "Запрашивать подтверждение перед удалением.",

    "settings.blockContext.title": "Блокировать контекстное меню",
    "settings.blockContext.desc": "Отключает правый клик внутри приложения.",

    "weak.title": "Слабый пароль",
    "weak.defaultText": "Использовать простой пароль/сид-фразу?",
    "weak.passwordOnly":
      "Использовать простой пароль? Это может быть небезопасно.",
    "weak.seedOnly":
      "Использовать простую сид-фразу? Это может быть небезопасно.",
    "weak.both":
      "Использовать простой пароль и сид-фразу? Это может быть небезопасно.",
    "weak.passwordTip":
      "Пароль должен быть длиннее. Используйте буквы, цифры и символы.",
    "weak.seedTip":
      "Сид-фраза должна быть длиннее. Лучше использовать несколько случайных слов.",
    "weak.use": "Использовать",

    "seedModal.title": "Введите сид-фразу",
    "seedModal.desc":
      "Нужна локальная сид-фраза для расшифровки и копирования записи",
    "seedModal.placeholder": "Введите сид-фразу",
    "seedModal.decrypt": "Расшифровать",
    "seedModal.copy": "Копировать",
    "seedModal.login": "Логин",
    "seedModal.password": "Пароль",

    "deleteModal.title": "Удалить запись?",
    "deleteModal.desc": "Это действие необратимо",

    "notify.sessionExpired": "Сессия завершена из-за бездействия",
    "notify.screenshotGuardOn": "Screenshot Guard включён",
    "notify.screenshotGuardOff": "Screenshot Guard отключён",
    "notify.startupOn": "Автозапуск с Windows включён",
    "notify.startupOff": "Автозапуск с Windows отключён",
    "notify.deleted": "Удалено",
    "notify.lightThemeOn": "Светлая тема включена",
    "notify.lightThemeOff": "Светлая тема отключена",
    "notify.autoLockOn": "Автоблокировка включена",
    "notify.autoLockOff": "Автоблокировка отключена",
    "notify.autoLockTimer": "Таймер автоблокировки: {minutes}.",
    "notify.confirmDeleteOn": "Подтверждение удаления включено",
    "notify.confirmDeleteOff": "Подтверждение удаления отключено",
    "notify.blockContextOn": "Контекстное меню отключено",
    "notify.blockContextOff": "Контекстное меню включено",
    "notify.welcome": "Добро пожаловать!",
    "notify.accountCreated": "Аккаунт создан!",
    "notify.accountCreatedLogin": "Аккаунт создан! Теперь войдите.",
    "notify.loggedOut": "Вы вышли",
    "notify.passwordSaved": "Пароль сохранён!",
    "notify.passwordCopied": "Пароль скопирован! Очистка через 30с",
    "notify.copied": "Скопировано",
    "notify.screenshotsBlocked": "Скриншоты заблокированы",
    "notify.languageChanged": "Язык интерфейса изменён",
    "notify.dpiChanged": "Масштаб интерфейса: {value}",
    "notify.encryptionChanged": "Алгоритм шифрования обновлён",

    "error.fillAllFields": "Заполните все поля",
    "error.loginMin": "Логин: минимум 3 символа",
    "error.passwordMin": "Пароль: минимум 8 символов",
    "error.passwordsMismatch": "Пароли не совпадают",
    "error.seedMin": "Сид-фраза: минимум 1 слово",
    "error.enterSeed": "Введите сид-фразу",
    "error.invalidSeed": "Неверная сид-фраза",
    "error.load": "Ошибка загрузки",
    "error.delete": "Ошибка удаления",
    "error.login": "Ошибка входа",
    "error.register": "Ошибка регистрации",
    "error.save": "Ошибка сохранения",
    "error.copy": "Ошибка копирования",
    "error.screenshotGuardChange": "Не удалось изменить Screenshot Guard",
    "error.startupChange": "Не удалось изменить автозапуск",
    "error.startupStatus": "Не удалось определить статус автозапуска",
    "error.loginCredentialsRequired": "Введите логин и пароль",
    "error.invalidCredentials": "Неверный логин или пароль",
    "error.loginMinRaw": "Логин должен быть минимум 3 символа",
    "error.passwordMinRaw": "Пароль должен быть минимум 8 символов",
    "error.seedMinRaw": "Сид-фраза должна быть минимум 1 слово",
    "error.userExists": "Пользователь уже существует",
    "error.notAuthenticated": "Вы не авторизованы",
    "error.entryNotFound": "Запись не найдена",
    "error.commandUnavailable": "Команда недоступна: {command}",
    "error.backendTransport":
      "Не удалось подключиться к серверу. Проверьте endpoint, TLS и доступность gRPC.",
    "settings.backend.title": "Backend",
    "settings.backend.desc":
      "Выберите production endpoint или укажите свой HTTP/HTTPS-адрес без path и query.",
    "settings.backend.production": "Production",
    "settings.backend.custom": "Custom URL",
    "settings.backend.customPlaceholder": "http://127.0.0.1:8080",
    "settings.backend.effective": "Effective endpoint",
    "settings.backend.statusTitle": "Статус сервера",
    "settings.backend.statusIdle":
      "Укажите endpoint и нажмите «Применить», чтобы проверить сервер.",
    "settings.backend.statusChecking": "Проверка сервера...",
    "settings.backend.statusHealthy": "Сервер доступен и отвечает.",
    "settings.backend.statusUnreachable":
      "Не удалось подключиться к серверу.",
    "settings.backend.compatible": "Совместим",
    "settings.backend.incompatible": "Несовместим",
    "settings.backend.unreachable": "Недоступен",
    "settings.backend.checking": "Проверка",
    "settings.backend.notChecked": "Не проверен",
    "settings.backend.serverName": "Сервер",
    "settings.backend.serverVersion": "Версия сборки",
    "settings.backend.runtimeVersion": "Go runtime",
    "settings.backend.buildTime": "Время сборки",
    "settings.backend.commit": "Commit",
    "settings.backend.repository": "Repository",
    "settings.backend.clientApi": "API клиента",
    "settings.backend.supportedApi": "Поддерживаемые API",
    "settings.backend.reasons": "Причины несовместимости",
    "settings.backend.unknown": "Нет данных",
    "settings.backend.apply": "Применить",
    "settings.sessions.title": "Активные сессии",
    "settings.sessions.desc":
      "Просмотр активных устройств и отключение других сессий пользователя.",
    "settings.sessions.refresh": "Обновить",
    "settings.sessions.loading": "Загрузка сессий...",
    "settings.sessions.empty": "Других активных сессий пока нет.",
    "settings.sessions.authRequired": "Войдите в аккаунт, чтобы управлять сессиями.",
    "settings.sessions.current": "Текущее устройство",
    "settings.sessions.other": "Устройство",
    "settings.sessions.disconnect": "Отключить",
    "settings.sessions.created": "Создана",
    "settings.sessions.lastSeen": "Последняя активность",
    "settings.sessions.expires": "Истекает",
    "settings.sessions.id": "ID",
    "settings.sessions.unknown": "Нет данных",
    "notify.backendApplied": "Backend endpoint обновлён",
    "notify.backendChangedReauth":
      "Backend изменён. Войдите заново, чтобы продолжить.",
    "notify.sessionRevoked": "Сессия отключена",
    "error.backendEndpointInvalid": "Некорректный backend endpoint",
    "error.backendApply": "Не удалось применить backend endpoint",
    "error.sessionsLoad": "Не удалось загрузить список сессий",
    "error.sessionRevoke": "Не удалось отключить сессию",
  },
  en: {
    "common.admin": "Admin panel",
    "admin.title": "Admin panel",
    "admin.refresh": "Refresh",
    "admin.readonly":
      "Statistics only. User editing and management are not available.",
    "admin.totalUsers": "Users",
    "admin.totalAdmins": "Admins",
    "admin.totalPasswords": "Passwords",
    "admin.totalSessions": "Active sessions",
    "admin.activityGraph": "User activity",
    "admin.registerGraph": "Registrations",
    "admin.topServices": "Top services",
    "admin.cryptUsage": "Encryption usage",
    "admin.noData": "No data yet",
    "error.statsLoad": "Failed to load statistics",
    "common.username": "Username",
    "common.password": "Password",
    "common.seedPhrase": "Seed phrase",
    "common.login": "Log in",
    "common.logout": "Log out",
    "common.settings": "Settings",
    "common.cancel": "Cancel",
    "common.delete": "Delete",
    "common.justNow": "Just now",
    "login.brandSubtitle": "Reliable password vault",
    "login.title": "Sign in",
    "login.submit": "Sign in",
    "login.noAccount": "No account?",
    "login.create": "Create",
    "login.usernamePlaceholder": "Enter username",
    "login.passwordPlaceholder": "Enter password",
    "register.brandSubtitle": "Create a secure account",
    "register.title": "Sign up",
    "register.confirmPassword": "Confirm password",
    "register.seedInfo":
      "The seed phrase is used locally to encrypt and decrypt your passwords. The server does not store or return the raw phrase.",
    "register.warn":
      "Write this phrase down and keep it locally. Without it, your data cannot be decrypted.",
    "register.submit": "Create account",
    "register.haveAccount": "Already have an account?",
    "register.usernamePlaceholder": "At least 3 characters",
    "register.passwordPlaceholder": "At least 8 characters",
    "register.passwordConfirmPlaceholder": "Repeat password",
    "register.seedPlaceholder": "Secret phrase (min. 1 word)",
    "dashboard.title": "Vault",
    "dashboard.addPassword": "Add password",
    "dashboard.emptyTitle": "No passwords yet",
    "dashboard.emptySubtitle": "Add your first entry",
    "add.title": "New password",
    "add.name": "Name",
    "add.login": "Login",
    "add.namePlaceholder": "Gmail, GitHub, VK...",
    "add.loginPlaceholder": "Login for this entry",
    "add.passwordPlaceholder": "Password to store",
    "add.seedPlaceholder": "Your local seed phrase for encryption",
    "add.save": "Encrypt and save",
    "settings.title": "Settings",
    "settings.language.title": "Language",
    "settings.language.desc": "Choose the application interface language.",
    "settings.language.ru": "Russian",
    "settings.language.en": "English",
    "settings.dpi.title": "Interface scale",
    "settings.dpi.desc":
      "Adjusts the app DPI/scale without changing system display settings.",
    "settings.encryption.title": "Encryption algorithm",
    "settings.encryption.desc":
      "Choose how passwords are encrypted with your local seed phrase.",
    "settings.encryption.argon2id": "AES-256-GCM + Argon2id (recommended)",
    "settings.encryption.sha256": "AES-256-GCM + SHA-256 (fast)",
    "settings.screenshotGuard.title": "Screenshot Guard",
    "settings.screenshotGuard.desc":
      "Blocks taking screenshots of the app window.",
    "settings.lightTheme.title": "Light theme",
    "settings.lightTheme.desc": "Use a light interface appearance.",
    "settings.startup.title": "Start with Windows",
    "settings.startup.desc": "Launch SecureGuard automatically on sign-in.",
    "settings.autoLock.title": "Auto-lock",
    "settings.autoLock.desc": "Automatically lock the app after inactivity.",
    "settings.autoLockMinutes.title": "Auto-lock timer",
    "settings.autoLockMinutes.desc": "Inactivity time before the app is locked.",
    "settings.confirmDelete.title": "Delete confirmation",
    "settings.confirmDelete.desc": "Show a dialog before deleting an entry.",
    "settings.blockContext.title": "Block context menu",
    "settings.blockContext.desc":
      "Disables right-click menu inside the application.",
    "weak.title": "Weak secrets",
    "weak.defaultText": "Use this weak password/seed phrase anyway?",
    "weak.passwordOnly":
      "Use this weak password anyway? This may be insecure.",
    "weak.seedOnly":
      "Use this weak seed phrase anyway? This may be insecure.",
    "weak.both":
      "Use this weak password and seed phrase anyway? This may be insecure.",
    "weak.passwordTip":
      "Password is easy to guess. Add length, digits, and symbols.",
    "weak.seedTip": "Seed phrase is too simple. Use more unique words.",
    "weak.use": "Use anyway",
    "seedModal.title": "Enter seed phrase",
    "seedModal.desc":
      "Required to decrypt and copy this entry with your local seed phrase",
    "seedModal.placeholder": "Your seed phrase",
    "seedModal.decrypt": "Decrypt",
    "seedModal.copy": "Copy",
    "seedModal.login": "Login",
    "seedModal.password": "Password",
    "deleteModal.title": "Delete entry?",
    "deleteModal.desc": "This action cannot be undone",
    "notify.sessionExpired": "Session expired due to inactivity",
    "notify.screenshotGuardOn": "Screenshot Guard enabled",
    "notify.screenshotGuardOff": "Screenshot Guard disabled",
    "notify.startupOn": "Start with Windows enabled",
    "notify.startupOff": "Start with Windows disabled",
    "notify.deleted": "Deleted",
    "notify.lightThemeOn": "Light theme enabled",
    "notify.lightThemeOff": "Light theme disabled",
    "notify.autoLockOn": "Auto-lock enabled",
    "notify.autoLockOff": "Auto-lock disabled",
    "notify.autoLockTimer": "Auto-lock timer: {minutes}.",
    "notify.confirmDeleteOn": "Delete confirmation enabled",
    "notify.confirmDeleteOff": "Delete confirmation disabled",
    "notify.blockContextOn": "Context menu blocked",
    "notify.blockContextOff": "Context menu unblocked",
    "notify.welcome": "Welcome!",
    "notify.accountCreated": "Account created!",
    "notify.accountCreatedLogin": "Account created! Sign in.",
    "notify.loggedOut": "Logged out",
    "notify.passwordSaved": "Password saved!",
    "notify.passwordCopied": "Password copied! Clipboard clears in 30s",
    "notify.copied": "Copied",
    "notify.screenshotsBlocked": "Screenshots are blocked",
    "notify.languageChanged": "Interface language changed",
    "notify.dpiChanged": "Interface scale: {value}",
    "notify.encryptionChanged": "Encryption algorithm updated",
    "error.fillAllFields": "Fill in all fields",
    "error.loginMin": "Username: minimum 3 characters",
    "error.passwordMin": "Password: minimum 8 characters",
    "error.passwordsMismatch": "Passwords do not match",
    "error.seedMin": "Seed phrase: minimum 1 word",
    "error.enterSeed": "Enter seed phrase",
    "error.invalidSeed": "Invalid seed phrase",
    "error.load": "Load error",
    "error.delete": "Delete error",
    "error.login": "Login error",
    "error.register": "Registration error",
    "error.save": "Save error",
    "error.copy": "Copy error",
    "error.screenshotGuardChange": "Failed to update Screenshot Guard",
    "error.startupChange": "Failed to update startup option",
    "error.startupStatus": "Failed to get startup status",
    "error.loginCredentialsRequired": "Enter username and password",
    "error.invalidCredentials": "Invalid username or password",
    "error.loginMinRaw": "Username must be at least 3 characters",
    "error.passwordMinRaw": "Password must be at least 8 characters",
    "error.seedMinRaw": "Seed phrase must be at least 1 word",
    "error.userExists": "User already exists",
    "error.notAuthenticated": "Not authenticated",
    "error.entryNotFound": "Entry not found",
    "error.commandUnavailable": "Command unavailable: {command}",
    "error.backendTransport":
      "Could not connect to the server. Check the endpoint, TLS, and gRPC availability.",
    "settings.backend.title": "Backend",
    "settings.backend.desc":
      "Choose the production endpoint or provide a custom HTTP/HTTPS URL without path or query.",
    "settings.backend.production": "Production",
    "settings.backend.custom": "Custom URL",
    "settings.backend.customPlaceholder": "http://127.0.0.1:8080",
    "settings.backend.effective": "Effective endpoint",
    "settings.backend.statusTitle": "Server status",
    "settings.backend.statusIdle":
      "Set an endpoint and click Apply to check the server.",
    "settings.backend.statusChecking": "Checking server...",
    "settings.backend.statusHealthy": "The server is reachable and responding.",
    "settings.backend.statusUnreachable":
      "The client could not connect to the server.",
    "settings.backend.compatible": "Compatible",
    "settings.backend.incompatible": "Incompatible",
    "settings.backend.unreachable": "Unavailable",
    "settings.backend.checking": "Checking",
    "settings.backend.notChecked": "Not checked",
    "settings.backend.serverName": "Server",
    "settings.backend.serverVersion": "Build version",
    "settings.backend.runtimeVersion": "Go runtime",
    "settings.backend.buildTime": "Build time",
    "settings.backend.commit": "Commit",
    "settings.backend.repository": "Repository",
    "settings.backend.clientApi": "Client API",
    "settings.backend.supportedApi": "Supported API",
    "settings.backend.reasons": "Compatibility details",
    "settings.backend.unknown": "Unknown",
    "settings.backend.apply": "Apply",
    "settings.sessions.title": "Active sessions",
    "settings.sessions.desc":
      "View active devices and disconnect other user sessions.",
    "settings.sessions.refresh": "Refresh",
    "settings.sessions.loading": "Loading sessions...",
    "settings.sessions.empty": "No other active sessions yet.",
    "settings.sessions.authRequired": "Sign in to manage sessions.",
    "settings.sessions.current": "Current device",
    "settings.sessions.other": "Device",
    "settings.sessions.disconnect": "Disconnect",
    "settings.sessions.created": "Created",
    "settings.sessions.lastSeen": "Last seen",
    "settings.sessions.expires": "Expires",
    "settings.sessions.id": "ID",
    "settings.sessions.unknown": "No data",
    "notify.backendApplied": "Backend endpoint updated",
    "notify.backendChangedReauth":
      "Backend changed. Sign in again to continue.",
    "notify.sessionRevoked": "Session disconnected",
    "error.backendEndpointInvalid": "Invalid backend endpoint",
    "error.backendApply": "Failed to apply backend endpoint",
    "error.sessionsLoad": "Failed to load sessions",
    "error.sessionRevoke": "Failed to disconnect session",
  },
};

var MESSAGE_KEY_BY_TEXT = {
  "Введите логин и пароль": "error.loginCredentialsRequired",
  "Неверный логин или пароль": "error.invalidCredentials",
  "Логин должен быть минимум 3 символа": "error.loginMinRaw",
  "Пароль должен быть минимум 8 символов": "error.passwordMinRaw",
  "Сид-фраза должна быть минимум 1 слово": "error.seedMinRaw",
  "Seed phrase must contain at least 1 word": "error.seedMinRaw",
  "Пользователь уже существует": "error.userExists",
  "Вы не авторизованы": "error.notAuthenticated",
  "Not authenticated": "error.notAuthenticated",
  "Заполните все поля": "error.fillAllFields",
  "Запись не найдена": "error.entryNotFound",
  "Скопировано": "notify.copied",
  Copied: "notify.copied",
  "Аккаунт создан! Теперь войдите.": "notify.accountCreatedLogin",
  "Account created! Sign in.": "notify.accountCreatedLogin",
  "Invalid backend endpoint": "error.backendEndpointInvalid",
};

var SETTINGS_KEY = "secureguard.settings.v1";
var MASTER_KEY_ENVELOPES_KEY = "secureguard.master-keys.v1";
var ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID = "aes256gcm-argon2id";
var ENCRYPTION_ALGORITHM_AES256_GCM_SHA256 = "aes256gcm-sha256";
var DEFAULT_BACKEND_ENDPOINT = "http://127.0.0.1:8080";
var DEFAULT_BACKEND_FALLBACK_ENDPOINT = "http://127.0.0.1:50051";
var BACKEND_MODE_PRODUCTION = "production";
var BACKEND_MODE_CUSTOM = "custom";
var CLIENT_API_VERSION = 1.0;
var DEFAULT_UI_SCALE = 1;
var UI_SCALE_OPTIONS = [0.9, 1, 1.1, 1.25, 1.5];
var DEFAULT_CLIPBOARD_TIMEOUT_SECONDS = 30;

var DEFAULT_SETTINGS = {
  screenshotGuardEnabled: true,
  lightThemeEnabled: false,
  startupEnabled: false,
  autoLockEnabled: false,
  autoLockMinutes: 5,
  clipboardTimeoutSeconds: DEFAULT_CLIPBOARD_TIMEOUT_SECONDS,
  confirmDelete: true,
  blockContextMenu: true,
  language: "ru",
  uiScale: DEFAULT_UI_SCALE,
  encryptionAlgorithm: ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID,
  backendMode: BACKEND_MODE_PRODUCTION,
  backendCustomUrl: "",
};

function bootstrapApp(retriesLeft) {
  var invoke = resolveTauriInvoke();
  if (invoke) {
    initApp(invoke);
    return;
  }
  if (retriesLeft > 0) {
    setTimeout(function () {
      bootstrapApp(retriesLeft - 1);
    }, 25);
    return;
  }
  initApp(createFallbackInvoke());
}

function resolveTauriInvoke() {
  var tauri = window.__TAURI__;
  if (tauri && tauri.tauri && typeof tauri.tauri.invoke === "function") {
    return tauri.tauri.invoke;
  }
  if (tauri && tauri.core && typeof tauri.core.invoke === "function") {
    return tauri.core.invoke;
  }
  return null;
}

function createFallbackInvoke() {
  var authenticated = false;
  var currentUser = null;
  var nextId = 1;
  var entries = [];
  var backendEndpoint = DEFAULT_BACKEND_ENDPOINT;
  var screenshotGuardEnabled = true;
  var startupEnabled = false;
  var currentSessionId = "";
  var sessions = [];
  var users = {
    test: { password: "test", staff: true },
  };
  var demoStats = {
    top_services: {
      "github.com": 12,
      "gmail.com": 8,
      "figma.com": 5,
      "notion.so": 4,
    },
    activity_graph: [
      { time: 1710658800, value: 2 },
      { time: 1710662400, value: 5 },
      { time: 1710666000, value: 3 },
      { time: 1710669600, value: 7 },
      { time: 1710673200, value: 4 },
    ],
    register_graph: [
      { time: 1710658800, value: 1 },
      { time: 1710666000, value: 0 },
      { time: 1710669600, value: 2 },
      { time: 1710673200, value: 1 },
    ],
    total: {
      users: 24,
      admins: 2,
      passwords: 143,
      active_sessions: 6,
    },
    crypt: {
      argon2id: 18,
      "sha-256": 6,
    },
  };

  function resetFallbackAuth() {
    authenticated = false;
    currentUser = null;
    currentSessionId = "";
    entries = [];
    sessions = [];
  }

  function buildFallbackSession(id, isCurrent, createdAt, expiresAt, lastSeenAt) {
    return {
      id: id,
      is_current: !!isCurrent,
      created_at_unix: createdAt,
      expires_at_unix: expiresAt,
      last_seen_unix: lastSeenAt,
    };
  }

  function buildFallbackSessions() {
    var now = Math.floor(Date.now() / 1000);
    var current = buildFallbackSession(
      currentSessionId,
      true,
      now - 900,
      now + 86400,
      now,
    );
    var otherA = buildFallbackSession(
      "fallback-session-2",
      false,
      now - 7200,
      now + 43200,
      now - 1800,
    );
    var otherB = buildFallbackSession(
      "fallback-session-3",
      false,
      now - 172800,
      now + 21600,
      now - 14400,
    );
    sessions = [current, otherA, otherB];
  }

  return async function (command, args) {
    args = args || {};

    if (command === "get_backend_endpoint") {
      return backendEndpoint;
    }

    if (command === "set_backend_endpoint") {
      var nextEndpoint = validateBackendEndpoint(args.endpoint);
      var changed = nextEndpoint !== backendEndpoint;
      var reauthRequired = changed && authenticated;
      backendEndpoint = nextEndpoint;
      if (changed) {
        resetFallbackAuth();
      }
      return {
        endpoint: backendEndpoint,
        reauth_required: reauthRequired,
      };
    }

    if (command === "probe_backend_server") {
      return {
        endpoint: backendEndpoint,
        healthy: true,
        health_error: "",
        compatibility_checked: true,
        compatible: true,
        compatibility_error: "",
        reasons: [],
        client_api_version: CLIENT_API_VERSION,
        info: {
          name: "SecureGuard Server",
          version: "1.1.1",
          runtime_version: "go1.24.0",
          supported_api_versions: [1.0],
          commit_hash: "fallback-demo",
          repository: "https://github.com/aesterial/secureguard",
          build_time_unix: Math.floor(Date.now() / 1000) - 3600,
        },
      };
    }

    if (command === "login") {
      var loginUser = (args.username || "").trim();
      var loginPass = args.password || "";
      if (!loginUser || !loginPass) {
        throw "Введите логин и пароль";
      }
      if (!users[loginUser] || users[loginUser].password !== loginPass) {
        throw "Неверный логин или пароль";
      }
      authenticated = true;
      currentUser = {
        id: loginUser,
        username: loginUser,
        staff: !!users[loginUser].staff,
        has_preferences: true,
        light_theme_enabled: false,
        language: "ru",
        encryption_algorithm: ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID,
      };
      currentSessionId = "fallback-session-1";
      buildFallbackSessions();
      return currentUser;
    }

    if (command === "register") {
      var regUser = (args.username || "").trim();
      var regPass = args.password || "";
      var regSeed = (args.seedPhrase || "").trim();
      if (!regUser || regUser.length < 3) {
        throw "Логин должен быть минимум 3 символа";
      }
      if (!regPass || regPass.length < 8) {
        throw "Пароль должен быть минимум 8 символов";
      }
      if (regSeed.split(/\s+/).filter(Boolean).length < 1) {
        throw "Seed phrase must contain at least 1 word";
      }
      if (users[regUser]) {
        throw "Пользователь уже существует";
      }
      users[regUser] = { password: regPass, staff: false };
      return "Аккаунт создан! Теперь войдите.";
    }

    if (command === "prepare_local_master_key_envelope") {
      return {
        wrapped_master_key: "local-envelope",
        wrapping_salt: "local-salt",
        encryption_algorithm: normalizeEncryptionAlgorithm(
          args.encryptionAlgorithm,
        ),
      };
    }

    if (command === "logout") {
      resetFallbackAuth();
      return;
    }

    if (command === "is_authenticated") {
      return authenticated;
    }

    if (command === "get_session_user") {
      return currentUser;
    }

    if (command === "list_sessions") {
      if (!authenticated) {
        throw "Р’С‹ РЅРµ Р°РІС‚РѕСЂРёР·РѕРІР°РЅС‹";
      }
      return sessions.slice();
    }

    if (command === "revoke_session") {
      if (!authenticated) {
        throw "Р’С‹ РЅРµ Р°РІС‚РѕСЂРёР·РѕРІР°РЅС‹";
      }
      var revokeId = String(args.sessionId || args.session_id || "").trim();
      if (!revokeId) {
        throw "Not found";
      }
      sessions = sessions.filter(function (item) {
        return item.id !== revokeId;
      });
      return;
    }

    if (command === "get_screenshot_guard_status") {
      return screenshotGuardEnabled;
    }

    if (command === "get_startup_status") {
      if (!authenticated) {
        throw "Вы не авторизованы";
      }
      return startupEnabled;
    }

    if (command === "set_screenshot_guard_enabled") {
      if (!authenticated) {
        throw "Вы не авторизованы";
      }
      screenshotGuardEnabled = !!args.enabled;
      return screenshotGuardEnabled;
    }

    if (command === "set_startup_enabled") {
      if (!authenticated) {
        throw "Вы не авторизованы";
      }
      startupEnabled = !!args.enabled;
      return startupEnabled;
    }
    
    if (command === "set_theme_preference") {
      if (!authenticated) {
        throw "Not authenticated";
      }
      return !!args.lightThemeEnabled;
    }
    
    if (command === "set_language_preference") {
      if (!authenticated) {
        throw "Not authenticated";
      }
      return args.language === "en" ? "en" : "ru";
    }
    
    if (command === "set_encryption_preference") {
      if (!authenticated) {
        throw "Not authenticated";
      }
      return normalizeEncryptionAlgorithm(args.encryptionAlgorithm);
    }
    
    if (command === "get_admin_stats") {
      if (!authenticated) {
        throw "Not authenticated";
      }
      if (!currentUser || !currentUser.staff) {
        throw "Access denied";
      }
      return demoStats;
    }

    if (!authenticated) {
      throw "Вы не авторизованы";
    }

    if (command === "get_passwords") {
      return entries.map(function (entry) {
        return {
          id: entry.id,
          title: entry.title,
          encrypted_login: entry.encrypted_login || "",
          encrypted_password: entry.encrypted_password,
          salt: entry.salt,
          wrapped_master_key: entry.wrapped_master_key || "",
          encryption_algorithm:
            entry.encryption_algorithm ||
            ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID,
          created_at: entry.created_at,
        };
      });
    }

    if (command === "add_password") {
      var title = (args.title || "").trim();
      var login = (args.login || "").trim();
      var password = args.password || "";
      var seed = (args.seedPhrase || "").trim();
      var encryptionAlgorithm = normalizeEncryptionAlgorithm(
        args.encryptionAlgorithm,
      );
      if (!title || !login || !password || !seed) {
        throw "Заполните все поля";
      }
      var entry = {
        id: String(nextId++),
        title: title,
        encrypted_login: login,
        encrypted_password: password,
        salt: args.localWrappingSalt || "local",
        wrapped_master_key: args.localWrappedMasterKey || "",
        encryption_algorithm: encryptionAlgorithm,
        created_at: new Date().toISOString(),
        _plain: password,
      };
      entries.push(entry);
      return entry;
    }

    if (command === "copy_password") {
      var copyId = String(args.entryId || "");
      var copyEntry = entries.find(function (item) {
        return item.id === copyId;
      });
      if (!copyEntry) {
        throw "Запись не найдена";
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        try {
          await navigator.clipboard.writeText(copyEntry._plain || "");
        } catch (e) {}
      }
      return "Скопировано";
    }

    if (command === "decrypt_password_entry") {
      var decryptId = String(args.entryId || "");
      var decryptEntry = entries.find(function (item) {
        return item.id === decryptId;
      });
      if (!decryptEntry) {
        throw "Запись не найдена";
      }
      return {
        login: decryptEntry.encrypted_login || "",
        password: decryptEntry._plain || decryptEntry.encrypted_password || "",
      };
    }

    if (command === "copy_secret_to_clipboard") {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        try {
          await navigator.clipboard.writeText(args.value || "");
        } catch (e) {}
      }
      return "Скопировано";
    }

    if (command === "delete_password") {
      var deleteId = String(args.entryId || "");
      entries = entries.filter(function (item) {
        return item.id !== deleteId;
      });
      return;
    }

    throw "Команда недоступна: " + command;
  };
}

function initApp(invoke) {
  var currentId = null;
  var deleteId = null;
  var notifTimer = null;
  var autoLockTimer = null;
  var authenticated = false;
  var currentBackendEndpoint = DEFAULT_BACKEND_ENDPOINT;
  var backendDraftMode = BACKEND_MODE_PRODUCTION;
  var backendDraftCustomUrl = "";
  var backendSyncInProgress = false;
  var settingsSyncInProgress = false;
  var startupSyncInProgress = false;
  var preferenceSyncInProgress = {
    theme: false,
    language: false,
    encryption: false,
  };
  var weakConfirmResolver = null;
  var authHandlingInProgress = false;
  var settingsReturnPage = "dashboard";
  var currentUser = null;
  var adminStats = null;
  var adminStatsLoading = false;
  var sessionSummaries = [];
  var sessionsLoading = false;
  var currentDecryptedEntry = null;
  var sessionActionId = "";
  var serverProbeInProgress = false;
  var lastProbedBackendEndpoint = "";
  var serverStatus = createEmptyServerStatus();

  var loaded = loadSettings();
  var appSettings = loaded.settings;
  var hasStoredSettings = loaded.hasStored;
  currentBackendEndpoint = getSafeSettingsBackendEndpoint(appSettings);
  backendDraftMode = appSettings.backendMode;
  backendDraftCustomUrl = appSettings.backendCustomUrl;

  var pages = {
    login: document.getElementById("page-login"),
    register: document.getElementById("page-register"),
    dashboard: document.getElementById("page-dashboard"),
    add: document.getElementById("page-add"),
    settings: document.getElementById("page-settings"),
    admin: document.getElementById("page-admin"),
  };

  var settingsControls = {
    screenshotGuard: document.getElementById("setting-screenshot-guard"),
    lightThemeEnabled: document.getElementById("setting-light-theme"),
    startupEnabled: document.getElementById("setting-startup-enabled"),
    autoLockEnabled: document.getElementById("setting-auto-lock-enabled"),
    autoLockMinutes: document.getElementById("setting-auto-lock-minutes"),
    clipboardTimeout: document.getElementById("setting-clipboard-timeout"),
    confirmDelete: document.getElementById("setting-confirm-delete"),
    blockContextMenu: document.getElementById("setting-block-context-menu"),
    language: document.getElementById("setting-language"),
    uiScale: document.getElementById("setting-ui-scale"),
    encryptionAlgorithm: document.getElementById(
      "setting-encryption-algorithm",
    ),
    backendModeProduction: document.getElementById("setting-backend-mode-production"),
    backendModeCustom: document.getElementById("setting-backend-mode-custom"),
    backendCustomUrl: document.getElementById("setting-backend-custom-url"),
    backendApply: document.getElementById("setting-backend-apply-btn"),
    backendEffective: document.getElementById("setting-backend-effective-endpoint"),
    backendStatusCard: document.getElementById("setting-backend-status-card"),
    backendStatusTitle: document.getElementById("setting-backend-status-title"),
    backendStatusBadge: document.getElementById("setting-backend-status-badge"),
    backendStatusSummary: document.getElementById("setting-backend-status-summary"),
    backendStatusDetails: document.getElementById("setting-backend-status-details"),
    sessionsRefresh: document.getElementById("setting-sessions-refresh-btn"),
    sessionsList: document.getElementById("setting-sessions-list"),
  };

  var settingsSections = buildSettingsSections();

  var adminControls = {
    button: document.getElementById("admin-btn"),
    refresh: document.getElementById("admin-refresh-btn"),
    totalUsers: document.getElementById("admin-total-users"),
    totalAdmins: document.getElementById("admin-total-admins"),
    totalPasswords: document.getElementById("admin-total-passwords"),
    totalSessions: document.getElementById("admin-total-sessions"),
    activityGraph: document.getElementById("admin-activity-graph"),
    registerGraph: document.getElementById("admin-register-graph"),
    topServices: document.getElementById("admin-top-services"),
    crypt: document.getElementById("admin-crypt"),
  };

  var modals = {
    weak: document.getElementById("weak-modal"),
    seed: document.getElementById("seed-modal"),
    del: document.getElementById("del-modal"),
  };

  var currentPage = null;
  var isAnimating = false;

  function getLanguage() {
    return appSettings.language === "en" ? "en" : "ru";
  }

  function normalizeSessionUser(source) {
    return {
      id: source && source.id ? String(source.id) : "",
      username: source && source.username ? String(source.username) : "",
      staff: !!(source && source.staff),
      has_preferences: !!(source && source.has_preferences),
      light_theme_enabled: !!(source && source.light_theme_enabled),
      language:
        source && source.language === "en"
          ? "en"
          : source && source.language === "ru"
            ? "ru"
            : "",
      encryption_algorithm: normalizeEncryptionAlgorithm(
        source && source.encryption_algorithm,
      ),
      wrapped_master_key:
        source && source.wrapped_master_key
          ? String(source.wrapped_master_key)
          : "",
      wrapping_salt:
        source && source.wrapping_salt ? String(source.wrapping_salt) : "",
      vault_encryption_algorithm: normalizeEncryptionAlgorithm(
        source && source.vault_encryption_algorithm,
      ),
    };
  }

  function setCurrentUser(source) {
    currentUser = source ? normalizeSessionUser(source) : null;
    if (
      currentUser &&
      currentUser.username &&
      currentUser.wrapped_master_key &&
      currentUser.wrapping_salt
    ) {
      saveMasterKeyEnvelope(currentUser.username, {
        wrapped_master_key: currentUser.wrapped_master_key,
        wrapping_salt: currentUser.wrapping_salt,
        encryption_algorithm: currentUser.vault_encryption_algorithm,
      });
    }
    updateAdminVisibility();
  }

  function applySessionPreferences(profile) {
    var normalized = profile ? normalizeSessionUser(profile) : null;
    if (!normalized || !normalized.has_preferences) {
      return;
    }

    appSettings.lightThemeEnabled = !!normalized.light_theme_enabled;
    if (normalized.language) {
      appSettings.language = normalized.language;
    }
    if (normalized.encryption_algorithm) {
      appSettings.encryptionAlgorithm = normalized.encryption_algorithm;
    }

    saveSettings();
    applyTheme();
    applyTranslations();
    renderSettings();
  }

  function canViewAdmin() {
    return !!(authenticated && currentUser && currentUser.staff);
  }

  function createEmptyServerStatus() {
    return {
      endpoint: "",
      healthy: false,
      health_error: "",
      compatibility_checked: false,
      compatible: false,
      compatibility_error: "",
      reasons: [],
      client_api_version: CLIENT_API_VERSION,
      info: null,
    };
  }

  function normalizeSupportedApiVersions(source) {
    if (!Array.isArray(source)) {
      return [];
    }
    return source
      .map(function (value) {
        var normalized = Number(value);
        return isNaN(normalized) ? null : normalized;
      })
      .filter(function (value) {
        return value !== null;
      });
  }

  function normalizeServerStatus(source) {
    var normalized = createEmptyServerStatus();
    var info = source && source.info ? source.info : null;

    normalized.endpoint = source && source.endpoint ? String(source.endpoint) : "";
    normalized.healthy = !!(source && source.healthy);
    normalized.health_error =
      source && source.health_error ? String(source.health_error) : "";
    normalized.compatibility_checked = !!(
      source && source.compatibility_checked
    );
    normalized.compatible = !!(source && source.compatible);
    normalized.compatibility_error =
      source && source.compatibility_error
        ? String(source.compatibility_error)
        : "";
    normalized.reasons = Array.isArray(source && source.reasons)
      ? source.reasons.map(function (reason) {
          return String(reason);
        })
      : [];
    normalized.client_api_version =
      Number(source && source.client_api_version) || CLIENT_API_VERSION;
    normalized.info = info
      ? {
          name: info.name ? String(info.name) : "",
          version: info.version ? String(info.version) : "",
          runtime_version: info.runtime_version
            ? String(info.runtime_version)
            : "",
          supported_api_versions: normalizeSupportedApiVersions(
            info.supported_api_versions,
          ),
          commit_hash: info.commit_hash ? String(info.commit_hash) : "",
          repository: info.repository ? String(info.repository) : "",
          build_time_unix:
            info.build_time_unix === null || info.build_time_unix === undefined
              ? null
              : Number(info.build_time_unix) || null,
        }
      : null;

    return normalized;
  }

  function getSettingsSection(control) {
    return control && typeof control.closest === "function"
      ? control.closest(".settings-item")
      : null;
  }

  function buildSettingsSections() {
    return {
      language: getSettingsSection(settingsControls.language),
      encryption: getSettingsSection(settingsControls.encryptionAlgorithm),
      backend: getSettingsSection(
        settingsControls.backendApply || settingsControls.backendCustomUrl,
      ),
      screenshotGuard: getSettingsSection(settingsControls.screenshotGuard),
      lightTheme: getSettingsSection(settingsControls.lightThemeEnabled),
      startup: getSettingsSection(settingsControls.startupEnabled),
      autoLock: getSettingsSection(settingsControls.autoLockEnabled),
      autoLockMinutes: getSettingsSection(settingsControls.autoLockMinutes),
      clipboardTimeout: getSettingsSection(settingsControls.clipboardTimeout),
      confirmDelete: getSettingsSection(settingsControls.confirmDelete),
      blockContextMenu: getSettingsSection(settingsControls.blockContextMenu),
      sessions: getSettingsSection(
        settingsControls.sessionsRefresh || settingsControls.sessionsList,
      ),
    };
  }

  function setElementVisible(node, visible) {
    if (!node) {
      return;
    }
    node.classList.toggle("hidden", !visible);
  }

  function t(key, params) {
    var lang = getLanguage();
    var dict = I18N[lang] || I18N.ru;
    var template = dict[key];
    if (template === undefined) {
      template = I18N.ru[key];
    }
    if (template === undefined) {
      return key;
    }
    var out = String(template);
    if (params) {
      Object.keys(params).forEach(function (paramKey) {
        out = out.replace(
          new RegExp("\\{" + paramKey + "\\}", "g"),
          String(params[paramKey]),
        );
      });
    }
    return out;
  }

  function getMinuteLabel(minutes) {
    if (getLanguage() === "en") {
      return minutes + " " + (minutes === 1 ? "minute" : "minutes");
    }

    var rem10 = minutes % 10;
    var rem100 = minutes % 100;
    var word = "минут";

    if (rem10 === 1 && rem100 !== 11) {
      word = "минута";
    } else if (rem10 >= 2 && rem10 <= 4 && (rem100 < 12 || rem100 > 14)) {
      word = "минуты";
    }

    return minutes + " " + word;
  }

  function getClipboardTimeoutLabel(seconds) {
    if (getLanguage() === "en") {
      return seconds + "s";
    }

    return seconds + " с.";
  }

  function getPasswordCopiedMessage() {
    return getSecretCopiedMessage("password");
  }

  function getSecretCopiedMessage(kind) {
    var label = kind === "login" ? "Login" : "Password";
    if (getLanguage() === "en") {
      return (
        label +
        " copied! Clipboard clears in " +
        appSettings.clipboardTimeoutSeconds +
        "s"
      );
    }

    label = kind === "login" ? "Логин" : "Пароль";
    return (
      label +
      " скопирован. Очистка через " +
      appSettings.clipboardTimeoutSeconds +
      " с."
    );
  }

  function getClipboardTimeoutChangedMessage() {
    if (getLanguage() === "en") {
      return "Clipboard timeout: " + getClipboardTimeoutLabel(appSettings.clipboardTimeoutSeconds);
    }

    return (
      "Таймаут буфера обмена: " +
      getClipboardTimeoutLabel(appSettings.clipboardTimeoutSeconds)
    );
  }

  function localizeMessage(raw, fallbackKey) {
    if (raw === undefined || raw === null || raw === "") {
      return fallbackKey ? t(fallbackKey) : "";
    }

    var text = extractErrorText(raw);
    var knownKey = MESSAGE_KEY_BY_TEXT[text];
    if (knownKey) {
      return t(knownKey);
    }

    var unavailablePrefixRu = "Команда недоступна: ";
    var unavailablePrefixEn = "Command unavailable: ";
    if (text.indexOf(unavailablePrefixRu) === 0) {
      return t("error.commandUnavailable", {
        command: text.slice(unavailablePrefixRu.length),
      });
    }
    if (text.indexOf(unavailablePrefixEn) === 0) {
      return t("error.commandUnavailable", {
        command: text.slice(unavailablePrefixEn.length),
      });
    }

    var normalizedText = text.trim().toLowerCase();
    if (
      normalizedText.indexOf("transport error") !== -1 ||
      normalizedText.indexOf("backend connection:") !== -1 ||
      normalizedText.indexOf("tls config:") !== -1 ||
      normalizedText.indexOf("error trying to connect") !== -1 ||
      normalizedText.indexOf("connection refused") !== -1 ||
      normalizedText.indexOf("dns error") !== -1 ||
      normalizedText.indexOf("invalid peer certificate") !== -1 ||
      normalizedText.indexOf("certificate") !== -1
    ) {
      return t("error.backendTransport");
    }

    return text;
  }

  function isAuthErrorMessage(raw) {
    if (raw === undefined || raw === null) {
      return false;
    }

    var grpcCode = extractGrpcCode(raw);
    if (grpcCode === 16) {
      return true;
    }

    var text = extractErrorText(raw).toLowerCase();
    return (
      text === "16" ||
      text.indexOf("не авториз") !== -1 ||
      text.indexOf("not authenticated") !== -1 ||
      text.indexOf("unauthenticated") !== -1
    );
  }

  function extractErrorText(raw) {
    if (raw === undefined || raw === null) {
      return "";
    }

    if (typeof raw === "string") {
      return raw;
    }

    if (typeof raw === "object") {
      if (typeof raw.message === "string" && raw.message.trim() !== "") {
        return raw.message;
      }
      if (typeof raw.error === "string" && raw.error.trim() !== "") {
        return raw.error;
      }
      if (
        raw.details &&
        typeof raw.details === "object" &&
        typeof raw.details.message === "string" &&
        raw.details.message.trim() !== ""
      ) {
        return raw.details.message;
      }
    }

    return String(raw);
  }

  function parseErrorCodeValue(value) {
    if (typeof value === "number" && isFinite(value)) {
      return value;
    }

    if (typeof value === "string") {
      var normalized = value.trim().toLowerCase();
      if (normalized === "unauthenticated") {
        return 16;
      }
      if (/^-?\d+$/.test(normalized)) {
        var parsed = parseInt(normalized, 10);
        return isNaN(parsed) ? null : parsed;
      }
    }

    return null;
  }

  function extractGrpcCode(raw) {
    if (!raw || typeof raw !== "object") {
      return null;
    }

    var candidates = [
      raw.code,
      raw.status,
      raw.grpc_code,
      raw.grpcCode,
      raw.grpc_status,
      raw.grpcStatus,
    ];

    if (raw.details && typeof raw.details === "object") {
      candidates.push(
        raw.details.code,
        raw.details.status,
        raw.details.grpc_code,
        raw.details.grpcCode,
      );
    }

    for (var i = 0; i < candidates.length; i += 1) {
      var parsed = parseErrorCodeValue(candidates[i]);
      if (parsed !== null) {
        return parsed;
      }
    }

    return null;
  }

  async function handleAuthFailure(err) {
    if (!authenticated || authHandlingInProgress || !isAuthErrorMessage(err)) {
      return false;
    }

    authHandlingInProgress = true;
    try {
      finalizeLocalLogout(t("error.notAuthenticated"), "err");
    } finally {
      authHandlingInProgress = false;
    }

    return true;
  }

  function setText(selector, key) {
    var el = document.querySelector(selector);
    if (el) {
      el.textContent = t(key);
    }
  }

  function setTitle(selector, key) {
    var el = document.querySelector(selector);
    if (el) {
      el.title = t(key);
    }
  }

  function setPlaceholder(id, key) {
    var el = document.getElementById(id);
    if (el) {
      el.setAttribute("placeholder", t(key));
    }
  }

  function renderAutoLockMinuteOptions() {
    var values = [1, 3, 5, 10];
    if (values.indexOf(appSettings.autoLockMinutes) === -1) {
      values.push(appSettings.autoLockMinutes);
      values.sort(function (a, b) {
        return a - b;
      });
    }

    settingsControls.autoLockMinutes.innerHTML = "";

    for (var i = 0; i < values.length; i++) {
      var minutes = values[i];
      var option = document.createElement("option");
      option.value = String(minutes);
      option.textContent = getMinuteLabel(minutes);
      settingsControls.autoLockMinutes.appendChild(option);
    }
  }

  function normalizeUiScale(value) {
    var scale = Number(value);
    if (!isFinite(scale)) {
      return DEFAULT_UI_SCALE;
    }

    var nearest = UI_SCALE_OPTIONS[0];
    var distance = Math.abs(scale - nearest);

    for (var i = 1; i < UI_SCALE_OPTIONS.length; i += 1) {
      var candidate = UI_SCALE_OPTIONS[i];
      var candidateDistance = Math.abs(scale - candidate);
      if (candidateDistance < distance) {
        nearest = candidate;
        distance = candidateDistance;
      }
    }

    return nearest;
  }

  function applyTranslations() {
    document.documentElement.lang = getLanguage();

    setText("#page-login .brand p", "login.brandSubtitle");
    setText("#page-login h2", "login.title");
    setText("#page-login .field:nth-of-type(1) label", "common.username");
    setText("#page-login .field:nth-of-type(2) label", "common.password");
    setText("#login-btn .btn-t", "login.submit");
    setText("#page-login .link-row span", "login.noAccount");
    setText("#go-register", "login.create");
    setText("#login-settings-btn span", "common.settings");
    setTitle("#login-settings-btn", "common.settings");

    setText("#page-register .brand p", "register.brandSubtitle");
    setText("#page-register h2", "register.title");
    setText("#page-register .field:nth-of-type(1) label", "common.username");
    setText("#page-register .field:nth-of-type(2) label", "common.password");
    setText(
      "#page-register .field:nth-of-type(3) label",
      "register.confirmPassword",
    );
    setText("#reg-seed-label-text", "common.seedPhrase");
    setText("#reg-seed-info-tip", "register.seedInfo");
    setText("#reg-seed-warn", "register.warn");
    setText("#reg-btn .btn-t", "register.submit");
    setText("#page-register .link-row span", "register.haveAccount");
    setText("#go-login", "common.login");
    setText("#register-settings-btn span", "common.settings");
    setTitle("#register-settings-btn", "common.settings");

    setText("#page-dashboard .dash-brand h1", "dashboard.title");
    setText("#admin-btn span", "common.admin");
    setText("#settings-btn span", "common.settings");
    setText("#logout-btn span", "common.logout");
    setTitle("#admin-btn", "common.admin");
    setTitle("#settings-btn", "common.settings");
    setTitle("#logout-btn", "common.logout");
    setText("#empty-state p", "dashboard.emptyTitle");
    setText("#empty-state span", "dashboard.emptySubtitle");
    setText("#add-btn span", "dashboard.addPassword");

    setText("#page-add .dash-brand h1", "add.title");
    setText("#page-add .field:nth-of-type(1) label", "add.name");
    setText("#page-add .field:nth-of-type(2) label", "add.login");
    setText("#page-add .field:nth-of-type(3) label", "common.password");
    setText("#page-add .field:nth-of-type(4) label", "common.seedPhrase");
    setText("#save-btn .btn-t", "add.save");

    setText("#page-settings .dash-brand h1", "settings.title");
    setText("#setting-language-title", "settings.language.title");
    setText("#setting-language-desc", "settings.language.desc");
    setText("#setting-ui-scale-title", "settings.dpi.title");
    setText("#setting-ui-scale-desc", "settings.dpi.desc");
    setText("#setting-encryption-title", "settings.encryption.title");
    setText("#setting-encryption-desc", "settings.encryption.desc");
    setText("#setting-sg-title", "settings.screenshotGuard.title");
    setText("#setting-sg-desc", "settings.screenshotGuard.desc");
    setText("#setting-light-theme-title", "settings.lightTheme.title");
    setText("#setting-light-theme-desc", "settings.lightTheme.desc");
    setText("#setting-startup-title", "settings.startup.title");
    setText("#setting-startup-desc", "settings.startup.desc");
    setText("#setting-auto-lock-title", "settings.autoLock.title");
    setText("#setting-auto-lock-desc", "settings.autoLock.desc");
    setText(
      "#setting-auto-lock-minutes-title",
      "settings.autoLockMinutes.title",
    );
    setText("#setting-auto-lock-minutes-desc", "settings.autoLockMinutes.desc");
    if (getLanguage() === "en") {
      document.getElementById("setting-clipboard-timeout-title").textContent =
        "Clipboard timeout";
      document.getElementById("setting-clipboard-timeout-desc").textContent =
        "How many seconds to keep a copied password in the clipboard before it is cleared.";
    } else {
      document.getElementById("setting-clipboard-timeout-title").textContent =
        "Таймаут буфера обмена";
      document.getElementById("setting-clipboard-timeout-desc").textContent =
        "Через сколько секунд очищать буфер обмена после копирования пароля.";
    }
    setText("#setting-confirm-delete-title", "settings.confirmDelete.title");
    setText("#setting-confirm-delete-desc", "settings.confirmDelete.desc");
    setText("#setting-block-context-title", "settings.blockContext.title");
    setText("#setting-block-context-desc", "settings.blockContext.desc");
    setText("#setting-backend-title", "settings.backend.title");
    setText("#setting-backend-desc", "settings.backend.desc");
    setText(
      "#setting-backend-mode-production-label",
      "settings.backend.production",
    );
    setText("#setting-backend-mode-custom-label", "settings.backend.custom");
    setText("#setting-backend-effective-label", "settings.backend.effective");
    setText("#setting-backend-apply-btn", "settings.backend.apply");
    setText("#setting-backend-status-title", "settings.backend.statusTitle");
    setText("#setting-sessions-title", "settings.sessions.title");
    setText("#setting-sessions-desc", "settings.sessions.desc");
    setText("#setting-sessions-refresh-btn", "settings.sessions.refresh");
    setText("#page-admin .dash-brand h1", "admin.title");
    setText("#admin-refresh-btn span", "admin.refresh");
    setTitle("#admin-refresh-btn", "admin.refresh");
    setText("#admin-readonly-note", "admin.readonly");
    setText("#admin-total-users-label", "admin.totalUsers");
    setText("#admin-total-admins-label", "admin.totalAdmins");
    setText("#admin-total-passwords-label", "admin.totalPasswords");
    setText("#admin-total-sessions-label", "admin.totalSessions");
    setText("#admin-activity-title", "admin.activityGraph");
    setText("#admin-register-title", "admin.registerGraph");
    setText("#admin-top-services-title", "admin.topServices");
    setText("#admin-crypt-title", "admin.cryptUsage");

    if (
      settingsControls.language &&
      settingsControls.language.options.length >= 2
    ) {
      settingsControls.language.options[0].text = t("settings.language.ru");
      settingsControls.language.options[1].text = t("settings.language.en");
    }

    if (
      settingsControls.uiScale &&
      settingsControls.uiScale.options.length >= UI_SCALE_OPTIONS.length
    ) {
      for (
        var scaleIndex = 0;
        scaleIndex < UI_SCALE_OPTIONS.length;
        scaleIndex += 1
      ) {
        settingsControls.uiScale.options[scaleIndex].text =
          Math.round(UI_SCALE_OPTIONS[scaleIndex] * 100) + "%";
      }
    }

    if (
      settingsControls.encryptionAlgorithm &&
      settingsControls.encryptionAlgorithm.options.length >= 2
    ) {
      settingsControls.encryptionAlgorithm.options[0].text = t(
        "settings.encryption.argon2id",
      );
      settingsControls.encryptionAlgorithm.options[1].text = t(
        "settings.encryption.sha256",
      );
    }

    setText("#weak-title", "weak.title");
    setText("#weak-no", "common.cancel");
    setText("#weak-yes", "weak.use");
    setText("#seed-modal h2", "seedModal.title");
    setText("#seed-modal p", "seedModal.desc");
    setText("#modal-no", "common.cancel");
    setText("#modal-yes .btn-t", "seedModal.decrypt");
    setText("#decrypt-login-label", "seedModal.login");
    setText("#decrypt-password-label", "seedModal.password");
    setText("#copy-login", "seedModal.copy");
    setText("#copy-password", "seedModal.copy");
    setText("#del-modal h2", "deleteModal.title");
    setText("#del-modal p", "deleteModal.desc");
    setText("#del-no", "common.cancel");
    setText("#del-yes", "common.delete");

    setPlaceholder("login-user", "login.usernamePlaceholder");
    setPlaceholder("login-pass", "login.passwordPlaceholder");
    setPlaceholder("reg-user", "register.usernamePlaceholder");
    setPlaceholder("reg-pass", "register.passwordPlaceholder");
    setPlaceholder("reg-pass2", "register.passwordConfirmPlaceholder");
    setPlaceholder("reg-seed", "register.seedPlaceholder");
    setPlaceholder("add-title", "add.namePlaceholder");
    setPlaceholder("add-login", "add.loginPlaceholder");
    setPlaceholder("add-pass", "add.passwordPlaceholder");
    setPlaceholder("add-seed", "add.seedPlaceholder");
    setPlaceholder("modal-seed", "seedModal.placeholder");
    setPlaceholder("setting-backend-custom-url", "settings.backend.customPlaceholder");

    renderAutoLockMinuteOptions();
    renderSessions();
    if (adminStats) {
      renderAdminStats(adminStats);
    }
  }

  function showPage(name, options) {
    if (!pages[name]) return;

    options = options || {};
    var instant = !!options.instant;

    if (name === currentPage && !instant) return;
    if (isAnimating && !instant) return;

    if (instant || !currentPage) {
      Object.keys(pages).forEach(function (key) {
        if (pages[key]) {
          pages[key].classList.remove("active", "page-enter", "page-exit");
          pages[key].style.cssText = "";
        }
      });
      pages[name].classList.add("active");
      currentPage = name;
      isAnimating = false;
      return;
    }

    isAnimating = true;

    var oldPage = pages[currentPage];
    var newPage = pages[name];

    if (oldPage) {
      oldPage.classList.add("page-exit");
    }

    setTimeout(function () {
      if (oldPage) {
        oldPage.classList.remove("active", "page-exit");
      }

      newPage.classList.add("active", "page-enter");

      currentPage = name;

      setTimeout(function () {
        newPage.classList.remove("page-enter");
        isAnimating = false;
      }, 500);
    }, 300);
  }

  function showModal(name) {
    if (modals[name]) modals[name].classList.remove("hidden");
  }

  function hideModal(name) {
    if (modals[name]) modals[name].classList.add("hidden");
    if (name === "seed") resetSeedModal();
    if (name === "weak") {
      document.getElementById("weak-list").innerHTML = "";
      document.getElementById("weak-text").textContent = t("weak.defaultText");
    }
  }

  function resetSeedModal() {
    currentDecryptedEntry = null;
    document.getElementById("modal-seed").value = "";
    document.getElementById("decrypt-login").value = "";
    document.getElementById("decrypt-password").value = "";
    document.getElementById("copy-login").disabled = true;
    document.getElementById("copy-password").disabled = true;
    document.getElementById("seed-prompt").classList.remove("hidden");
    document.getElementById("modal-yes").classList.remove("hidden");
    document.getElementById("decrypt-result").classList.add("hidden");
    setText("#modal-yes .btn-t", "seedModal.decrypt");
  }

  function buildBlurredSecret(value) {
    var length = Math.max(8, Math.min(String(value || "").length, 24));
    return new Array(length + 1).join("*");
  }

  function showDecryptedEntry(entry) {
    currentDecryptedEntry = {
      login: entry && entry.login ? String(entry.login) : "",
      password: entry && entry.password ? String(entry.password) : "",
    };
    document.getElementById("decrypt-login").value = buildBlurredSecret(
      currentDecryptedEntry.login,
    );
    document.getElementById("decrypt-password").value =
      buildBlurredSecret(currentDecryptedEntry.password);
    document.getElementById("copy-login").disabled = !currentDecryptedEntry.login;
    document.getElementById("copy-password").disabled =
      !currentDecryptedEntry.password;
    document.getElementById("seed-prompt").classList.add("hidden");
    document.getElementById("modal-yes").classList.add("hidden");
    document.getElementById("decrypt-result").classList.remove("hidden");
  }

  async function copyVisibleSecret(kind) {
    if (!currentDecryptedEntry) {
      return;
    }
    var value = kind === "login" ? currentDecryptedEntry.login : currentDecryptedEntry.password;
    if (!value) {
      return;
    }

    await invoke("copy_secret_to_clipboard", {
      value: value,
      clipboardTimeoutSeconds: appSettings.clipboardTimeoutSeconds,
    });
    notify(getSecretCopiedMessage(kind));
  }

  function notify(msg, type) {
    type = type || "ok";
    var el = document.getElementById("notification");
    var txt = document.getElementById("notif-text");
    if (notifTimer) clearTimeout(notifTimer);

    el.classList.remove("hidden");
    txt.textContent = msg;
    el.className = "notif " + type;
    el.style.animation = "nIn 0.3s cubic-bezier(0.16,1,0.3,1)";

    notifTimer = setTimeout(function () {
      el.style.animation = "nOut 0.3s ease forwards";
      setTimeout(function () {
        el.classList.add("hidden");
      }, 300);
    }, 2500);
  }

  function evaluatePasswordStrength(password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (/[A-Z]/.test(password) && /[a-z]/.test(password)) score++;
    if (/\d/.test(password)) score++;
    if (/[^A-Za-z0-9]/.test(password)) score++;

    return {
      weak: score < 3,
      score: score,
    };
  }

  function evaluateSeedStrength(seedPhrase) {
    var words = seedPhrase.trim().split(/\s+/).filter(Boolean);
    var score = 0;
    var uniqueWords = {};
    var totalWordLength = 0;

    for (var i = 0; i < words.length; i++) {
      var lower = words[i].toLowerCase();
      uniqueWords[lower] = true;
      totalWordLength += words[i].length;
    }

    var uniqueCount = Object.keys(uniqueWords).length;
    var avgWordLength = words.length > 0 ? totalWordLength / words.length : 0;
    var hasDigits = /\d/.test(seedPhrase);
    var hasSpecial = /[^A-Za-z0-9\s]/.test(seedPhrase);
    var hasMixedCase = /[A-Z]/.test(seedPhrase) && /[a-z]/.test(seedPhrase);

    if (words.length >= 4) score++;
    if (words.length >= 6) score++;
    if (uniqueCount >= Math.max(3, words.length - 1)) score++;
    if (avgWordLength >= 5) score++;
    if (hasDigits || hasSpecial || hasMixedCase) score++;

    return {
      weak: score < 3 || words.length < 4,
      score: score,
    };
  }

  function getWeakSecrets(password, seedPhrase) {
    var weakSecrets = [];
    if (evaluatePasswordStrength(password).weak) {
      weakSecrets.push("password");
    }
    if (evaluateSeedStrength(seedPhrase).weak) {
      weakSecrets.push("seedPhrase");
    }
    return weakSecrets;
  }

  function resolveWeakConfirmation(confirmed) {
    if (weakConfirmResolver) {
      var resolver = weakConfirmResolver;
      weakConfirmResolver = null;
      resolver(confirmed);
    }
    hideModal("weak");
  }

  function confirmWeakSecrets(weakSecrets) {
    if (!weakSecrets || weakSecrets.length === 0) {
      return Promise.resolve(true);
    }

    return new Promise(function (resolve) {
      weakConfirmResolver = resolve;

      var weakText = document.getElementById("weak-text");
      var weakList = document.getElementById("weak-list");
      weakList.innerHTML = "";

      if (weakSecrets.length === 1 && weakSecrets[0] === "password") {
        weakText.textContent = t("weak.passwordOnly");
      } else if (weakSecrets.length === 1 && weakSecrets[0] === "seedPhrase") {
        weakText.textContent = t("weak.seedOnly");
      } else {
        weakText.textContent = t("weak.both");
      }

      for (var i = 0; i < weakSecrets.length; i++) {
        var li = document.createElement("li");
        li.textContent =
          weakSecrets[i] === "password"
            ? t("weak.passwordTip")
            : t("weak.seedTip");
        weakList.appendChild(li);
      }

      showModal("weak");
    });
  }

  function normalizeEncryptionAlgorithm(value) {
    var algorithm = String(value || "")
      .trim()
      .toLowerCase();
    if (
      algorithm === ENCRYPTION_ALGORITHM_AES256_GCM_SHA256 ||
      algorithm === "sha256"
    ) {
      return ENCRYPTION_ALGORITHM_AES256_GCM_SHA256;
    }
    return ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID;
  }

  function normalizeBackendMode(value) {
    return value === BACKEND_MODE_CUSTOM
      ? BACKEND_MODE_CUSTOM
      : BACKEND_MODE_PRODUCTION;
  }

  function validateBackendEndpoint(value) {
    var raw = String(value || "").trim();
    if (!raw) {
      throw "Invalid backend endpoint";
    }

    var url;
    try {
      url = new URL(raw);
    } catch (e) {
      throw "Invalid backend endpoint";
    }

    var isHttp = url.protocol === "http:";
    var isHttps = url.protocol === "https:";

    if (
      (!isHttp && !isHttps) ||
      !url.hostname ||
      url.username ||
      url.password ||
      url.search ||
      url.hash ||
      (url.pathname && url.pathname !== "/")
    ) {
      throw "Invalid backend endpoint";
    }

    return url.origin;
  }

  function resolveSettingsBackendEndpoint(settings) {
    var mode = normalizeBackendMode(settings && settings.backendMode);
    if (mode === BACKEND_MODE_CUSTOM) {
      return validateBackendEndpoint(settings && settings.backendCustomUrl);
    }
    return DEFAULT_BACKEND_ENDPOINT;
  }

  function getSafeSettingsBackendEndpoint(settings) {
    try {
      return resolveSettingsBackendEndpoint(settings);
    } catch (e) {
      return DEFAULT_BACKEND_ENDPOINT;
    }
  }

  function normalizeAppliedBackendEndpoint(value) {
    try {
      return validateBackendEndpoint(value);
    } catch (e) {
      return DEFAULT_BACKEND_ENDPOINT;
    }
  }

  function normalizeSettings(source) {
    var out = {
      screenshotGuardEnabled: DEFAULT_SETTINGS.screenshotGuardEnabled,
      lightThemeEnabled: DEFAULT_SETTINGS.lightThemeEnabled,
      startupEnabled: DEFAULT_SETTINGS.startupEnabled,
      autoLockEnabled: DEFAULT_SETTINGS.autoLockEnabled,
      autoLockMinutes: DEFAULT_SETTINGS.autoLockMinutes,
      clipboardTimeoutSeconds: DEFAULT_SETTINGS.clipboardTimeoutSeconds,
      confirmDelete: DEFAULT_SETTINGS.confirmDelete,
      blockContextMenu: DEFAULT_SETTINGS.blockContextMenu,
      language: DEFAULT_SETTINGS.language,
      uiScale: DEFAULT_SETTINGS.uiScale,
      encryptionAlgorithm: DEFAULT_SETTINGS.encryptionAlgorithm,
      backendMode: DEFAULT_SETTINGS.backendMode,
      backendCustomUrl: DEFAULT_SETTINGS.backendCustomUrl,
    };

    if (!source || typeof source !== "object") {
      return out;
    }

    if (typeof source.screenshotGuardEnabled === "boolean") {
      out.screenshotGuardEnabled = source.screenshotGuardEnabled;
    }
    out.lightThemeEnabled = !!source.lightThemeEnabled;
    out.startupEnabled = !!source.startupEnabled;
    out.autoLockEnabled = !!source.autoLockEnabled;
    out.confirmDelete = source.confirmDelete !== false;
    out.blockContextMenu = source.blockContextMenu !== false;
    out.language = source.language === "en" ? "en" : "ru";
    out.uiScale = normalizeUiScale(source.uiScale);
    out.encryptionAlgorithm = normalizeEncryptionAlgorithm(
      source.encryptionAlgorithm,
    );
    out.backendMode = normalizeBackendMode(source.backendMode);
    out.backendCustomUrl =
      typeof source.backendCustomUrl === "string"
        ? source.backendCustomUrl.trim()
        : DEFAULT_SETTINGS.backendCustomUrl;

    var minutes = Number(source.autoLockMinutes);
    if (!isNaN(minutes) && minutes >= 1 && minutes <= 60) {
      out.autoLockMinutes = minutes;
    }

    var clipboardTimeoutSeconds = Number(source.clipboardTimeoutSeconds);
    if (
      !isNaN(clipboardTimeoutSeconds) &&
      clipboardTimeoutSeconds >= 5 &&
      clipboardTimeoutSeconds <= 300
    ) {
      out.clipboardTimeoutSeconds = clipboardTimeoutSeconds;
    }

    return out;
  }

  function loadSettings() {
    try {
      var raw = localStorage.getItem(SETTINGS_KEY);
      if (!raw) {
        return {
          settings: normalizeSettings(DEFAULT_SETTINGS),
          hasStored: false,
        };
      }
      return { settings: normalizeSettings(JSON.parse(raw)), hasStored: true };
    } catch (e) {
      return {
        settings: normalizeSettings(DEFAULT_SETTINGS),
        hasStored: false,
      };
    }
  }

  function saveSettings() {
    try {
      localStorage.setItem(SETTINGS_KEY, JSON.stringify(appSettings));
      hasStoredSettings = true;
    } catch (e) {}
  }

  function loadMasterKeyEnvelopes() {
    try {
      var raw = localStorage.getItem(MASTER_KEY_ENVELOPES_KEY);
      if (!raw) {
        return {};
      }
      var parsed = JSON.parse(raw);
      return parsed && typeof parsed === "object" ? parsed : {};
    } catch (e) {
      return {};
    }
  }

  function normalizeStoredEnvelope(envelope) {
    if (!envelope || typeof envelope !== "object") {
      return null;
    }

    var wrappedMasterKey = String(
      envelope.wrapped_master_key || envelope.wrappedMasterKey || "",
    ).trim();
    var wrappingSalt = String(
      envelope.wrapping_salt || envelope.wrappingSalt || "",
    ).trim();

    if (!wrappedMasterKey || !wrappingSalt) {
      return null;
    }

    return {
      wrapped_master_key: wrappedMasterKey,
      wrapping_salt: wrappingSalt,
      encryption_algorithm: normalizeEncryptionAlgorithm(
        envelope.encryption_algorithm || envelope.encryptionAlgorithm,
      ),
    };
  }

  function buildEnvelopeStorageKey(username, endpoint) {
    var normalizedUsername = String(username || "").trim();
    if (!normalizedUsername) {
      return "";
    }
    return (
      normalizeAppliedBackendEndpoint(endpoint || currentBackendEndpoint) +
      "|" +
      normalizedUsername
    );
  }

  function saveMasterKeyEnvelope(username, envelope) {
    var normalizedEnvelope = normalizeStoredEnvelope(envelope);
    var storageKey = buildEnvelopeStorageKey(username, currentBackendEndpoint);
    if (!storageKey || !normalizedEnvelope) {
      return;
    }

    var envelopes = loadMasterKeyEnvelopes();
    envelopes[storageKey] = normalizedEnvelope;

    try {
      localStorage.setItem(MASTER_KEY_ENVELOPES_KEY, JSON.stringify(envelopes));
    } catch (e) {}
  }

  function getStoredMasterKeyEnvelope(username) {
    var normalizedUsername = String(username || "").trim();
    if (!normalizedUsername) {
      return null;
    }

    var envelopes = loadMasterKeyEnvelopes();
    var storageKey = buildEnvelopeStorageKey(normalizedUsername, currentBackendEndpoint);
    var envelope = normalizeStoredEnvelope(envelopes[storageKey]);
    if (envelope) {
      return envelope;
    }

    var legacyEnvelope = normalizeStoredEnvelope(envelopes[normalizedUsername]);
    if (legacyEnvelope) {
      envelopes[storageKey] = legacyEnvelope;
      try {
        localStorage.setItem(MASTER_KEY_ENVELOPES_KEY, JSON.stringify(envelopes));
      } catch (e) {}
      return legacyEnvelope;
    }

    return null;
  }

  function persistEnvelopeFromEntries(entries) {
    if (!currentUser || !currentUser.username || !Array.isArray(entries)) {
      return;
    }

    for (var i = 0; i < entries.length; i++) {
      var entry = entries[i] || {};
      if (
        String(entry.wrapped_master_key || "").trim() &&
        String(entry.salt || "").trim()
      ) {
        saveMasterKeyEnvelope(currentUser.username, {
          wrapped_master_key: entry.wrapped_master_key,
          wrapping_salt: entry.salt,
          encryption_algorithm: entry.encryption_algorithm,
        });
        return;
      }
    }
  }

  function shouldShowBackendSettings() {
    return !authenticated;
  }

  function updateSettingsVisibility() {
    setElementVisible(settingsSections.backend, shouldShowBackendSettings());
    setElementVisible(settingsSections.screenshotGuard, authenticated);
    setElementVisible(settingsSections.startup, authenticated);
    setElementVisible(settingsSections.encryption, authenticated);
    setElementVisible(settingsSections.sessions, authenticated);
  }

  function formatApiVersion(value) {
    var version = Number(value);
    if (isNaN(version)) {
      return t("settings.backend.unknown");
    }
    if (Math.abs(version - Math.round(version)) < 0.001) {
      return version.toFixed(1);
    }
    return version.toFixed(2).replace(/0+$/, "").replace(/\.$/, "");
  }

  function formatSupportedApiVersions(values) {
    if (!Array.isArray(values) || values.length === 0) {
      return t("settings.backend.unknown");
    }
    return values
      .map(function (value) {
        return formatApiVersion(value);
      })
      .join(", ");
  }

  function formatBuildTime(value) {
    if (value === null || value === undefined) {
      return t("settings.backend.unknown");
    }
    var unix = Number(value);
    if (!unix) {
      return t("settings.backend.unknown");
    }
    var date = new Date(unix * 1000);
    if (isNaN(date.getTime())) {
      return t("settings.backend.unknown");
    }
    return date.toLocaleString(getLanguage() === "en" ? "en-US" : "ru-RU");
  }

  function localizeCompatibilityReason(reason) {
    var text = String(reason || "");
    var normalized = text.trim().toLowerCase();

    if (normalized === "unsupported api version") {
      return getLanguage() === "en"
        ? "Unsupported client API version"
        : "Неподдерживаемая версия API клиента";
    }

    if (normalized === "unsupported client type") {
      return getLanguage() === "en"
        ? "Unsupported client type"
        : "Неподдерживаемый тип клиента";
    }

    return text;
  }

  function buildServerStatusMeta(label, value) {
    return (
      '<div class="backend-status-meta">' +
      "<span>" +
      esc(label) +
      "</span>" +
      "<b>" +
      esc(value) +
      "</b>" +
      "</div>"
    );
  }

  function renderServerStatus() {
    if (
      !settingsControls.backendStatusBadge ||
      !settingsControls.backendStatusSummary ||
      !settingsControls.backendStatusDetails
    ) {
      return;
    }

    var badgeClass = "is-idle";
    var badgeText = t("settings.backend.notChecked");
    var summaryText = t("settings.backend.statusIdle");
    var details = "";
    var hasStatus =
      serverStatus.endpoint === currentBackendEndpoint &&
      !!(
        serverStatus.healthy ||
        serverStatus.health_error ||
        serverStatus.compatibility_checked ||
        serverStatus.compatibility_error
      );

    if (serverProbeInProgress) {
      badgeClass = "is-checking";
      badgeText = t("settings.backend.checking");
      summaryText = t("settings.backend.statusChecking");
    } else if (hasStatus && !serverStatus.healthy) {
      badgeClass = "is-error";
      badgeText = t("settings.backend.unreachable");
      summaryText = localizeMessage(
        serverStatus.health_error,
        "settings.backend.statusUnreachable",
      );
    } else if (hasStatus && serverStatus.healthy) {
      if (serverStatus.compatibility_checked) {
        badgeClass = serverStatus.compatible ? "is-ok" : "is-warn";
        badgeText = t(
          serverStatus.compatible
            ? "settings.backend.compatible"
            : "settings.backend.incompatible",
        );
      } else if (serverStatus.compatibility_error) {
        badgeClass = "is-warn";
        badgeText = t("settings.backend.checking");
      } else {
        badgeClass = "is-ok";
        badgeText = t("settings.backend.compatible");
      }

      summaryText = serverStatus.compatibility_error
        ? localizeMessage(serverStatus.compatibility_error)
        : serverStatus.compatible ||
            !serverStatus.compatibility_checked ||
            serverStatus.reasons.length === 0
          ? t("settings.backend.statusHealthy")
          : localizeCompatibilityReason(serverStatus.reasons[0]);

      if (serverStatus.info) {
        details += buildServerStatusMeta(
          t("settings.backend.serverName"),
          serverStatus.info.name || t("settings.backend.unknown"),
        );
        details += buildServerStatusMeta(
          t("settings.backend.serverVersion"),
          serverStatus.info.version || t("settings.backend.unknown"),
        );
        details += buildServerStatusMeta(
          t("settings.backend.runtimeVersion"),
          serverStatus.info.runtime_version || t("settings.backend.unknown"),
        );
        details += buildServerStatusMeta(
          t("settings.backend.buildTime"),
          formatBuildTime(serverStatus.info.build_time_unix),
        );
        details += buildServerStatusMeta(
          t("settings.backend.commit"),
          serverStatus.info.commit_hash || t("settings.backend.unknown"),
        );
        details += buildServerStatusMeta(
          t("settings.backend.repository"),
          serverStatus.info.repository || t("settings.backend.unknown"),
        );
        details += buildServerStatusMeta(
          t("settings.backend.clientApi"),
          formatApiVersion(serverStatus.client_api_version),
        );
        details += buildServerStatusMeta(
          t("settings.backend.supportedApi"),
          formatSupportedApiVersions(serverStatus.info.supported_api_versions),
        );
      }

      if (serverStatus.reasons.length > 0) {
        details +=
          '<div class="backend-status-reasons">' +
          "<span>" +
          esc(t("settings.backend.reasons")) +
          "</span>" +
          "<ul>" +
          serverStatus.reasons
            .map(function (reason) {
              return "<li>" + esc(localizeCompatibilityReason(reason)) + "</li>";
            })
            .join("") +
          "</ul>" +
          "</div>";
      }
    }

    settingsControls.backendStatusBadge.className =
      "backend-status-badge " + badgeClass;
    settingsControls.backendStatusBadge.textContent = badgeText;
    settingsControls.backendStatusSummary.textContent = summaryText;
    settingsControls.backendStatusDetails.innerHTML = details;
    setElementVisible(settingsControls.backendStatusDetails, !!details);
  }

  function updateSettingsAvailability() {
    updateSettingsVisibility();
    if (settingsControls.screenshotGuard) {
      settingsControls.screenshotGuard.disabled =
        !authenticated || settingsSyncInProgress;
    }
    if (settingsControls.startupEnabled) {
      settingsControls.startupEnabled.disabled =
        !authenticated || startupSyncInProgress;
    }
    if (settingsControls.encryptionAlgorithm) {
      settingsControls.encryptionAlgorithm.disabled =
        !authenticated || !!preferenceSyncInProgress.encryption;
    }
    if (settingsControls.language) {
      settingsControls.language.disabled = !!preferenceSyncInProgress.language;
    }
    if (settingsControls.lightThemeEnabled) {
      settingsControls.lightThemeEnabled.disabled = !!preferenceSyncInProgress.theme;
    }
    if (settingsControls.backendModeProduction) {
      settingsControls.backendModeProduction.disabled =
        backendSyncInProgress || serverProbeInProgress;
    }
    if (settingsControls.backendModeCustom) {
      settingsControls.backendModeCustom.disabled =
        backendSyncInProgress || serverProbeInProgress;
    }
    if (settingsControls.backendCustomUrl) {
      settingsControls.backendCustomUrl.disabled =
        backendSyncInProgress ||
        serverProbeInProgress ||
        backendDraftMode !== BACKEND_MODE_CUSTOM;
    }
    if (settingsControls.backendApply) {
      settingsControls.backendApply.disabled =
        backendSyncInProgress || serverProbeInProgress;
    }
    if (settingsControls.sessionsRefresh) {
      settingsControls.sessionsRefresh.disabled =
        !authenticated || sessionsLoading || backendSyncInProgress;
    }
  }

  function normalizeSessionSummary(source) {
    return {
      id: source && source.id ? String(source.id) : "",
      is_current: !!(source && (source.is_current || source.isCurrent)),
      created_at_unix: Number(source && source.created_at_unix) || 0,
      expires_at_unix: Number(source && source.expires_at_unix) || 0,
      last_seen_unix:
        source && source.last_seen_unix !== null && source.last_seen_unix !== undefined
          ? Number(source.last_seen_unix) || 0
          : null,
    };
  }

  function formatSessionDateTime(unixSeconds) {
    if (!unixSeconds) {
      return t("settings.sessions.unknown");
    }
    return new Date(unixSeconds * 1000).toLocaleString(
      getLanguage() === "en" ? "en-US" : "ru-RU",
      {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      },
    );
  }

  function truncateSessionId(value) {
    var sessionId = String(value || "");
    if (sessionId.length <= 20) {
      return sessionId;
    }
    return sessionId.slice(0, 10) + "..." + sessionId.slice(-6);
  }

  function renderSessions() {
    if (!settingsControls.sessionsList) {
      return;
    }

    if (!authenticated) {
      settingsControls.sessionsList.innerHTML =
        '<div class="settings-empty">' +
        esc(t("settings.sessions.authRequired")) +
        "</div>";
      return;
    }

    if (sessionsLoading) {
      settingsControls.sessionsList.innerHTML =
        '<div class="settings-empty">' +
        esc(t("settings.sessions.loading")) +
        "</div>";
      return;
    }

    if (!sessionSummaries.length) {
      settingsControls.sessionsList.innerHTML =
        '<div class="settings-empty">' +
        esc(t("settings.sessions.empty")) +
        "</div>";
      return;
    }

    settingsControls.sessionsList.innerHTML = sessionSummaries
      .map(function (item) {
        var sessionId = String(item.id || "");
        var isCurrent = !!item.is_current;
        var isBusy = sessionActionId === sessionId;
        var lastSeenText =
          item.last_seen_unix === null
            ? t("settings.sessions.unknown")
            : formatSessionDateTime(item.last_seen_unix);
        return (
          '<div class="session-row">' +
          '<div class="session-main">' +
          '<div class="session-top">' +
          '<strong>' +
          esc(isCurrent ? t("settings.sessions.current") : t("settings.sessions.other")) +
          "</strong>" +
          (isCurrent
            ? '<span class="session-badge">' +
              esc(t("settings.sessions.current")) +
              "</span>"
            : "") +
          "</div>" +
          '<div class="session-meta"><span>' +
          esc(t("settings.sessions.id")) +
          ": " +
          esc(truncateSessionId(sessionId)) +
          "</span></div>" +
          '<div class="session-grid">' +
          '<span><b>' +
          esc(t("settings.sessions.created")) +
          ":</b> " +
          esc(formatSessionDateTime(item.created_at_unix)) +
          "</span>" +
          '<span><b>' +
          esc(t("settings.sessions.lastSeen")) +
          ":</b> " +
          esc(lastSeenText) +
          "</span>" +
          '<span><b>' +
          esc(t("settings.sessions.expires")) +
          ":</b> " +
          esc(formatSessionDateTime(item.expires_at_unix)) +
          "</span>" +
          "</div>" +
          "</div>" +
          '<button class="btn-exit session-action" data-session-id="' +
          esc(sessionId) +
          '"' +
          (isCurrent || isBusy ? " disabled" : "") +
          ">" +
          esc(t("settings.sessions.disconnect")) +
          "</button>" +
          "</div>"
        );
      })
      .join("");

    settingsControls.sessionsList
      .querySelectorAll("[data-session-id]")
      .forEach(function (button) {
        button.addEventListener("click", async function () {
          var sessionId = button.getAttribute("data-session-id");
          if (!sessionId || button.disabled) {
            return;
          }
          await revokeSession(sessionId);
        });
      });
  }

  async function loadSessions() {
    if (!authenticated) {
      sessionSummaries = [];
      sessionActionId = "";
      renderSessions();
      return;
    }

    if (sessionsLoading) {
      return;
    }

    sessionsLoading = true;
    renderSessions();
    updateSettingsAvailability();

    try {
      var list = await invoke("list_sessions");
      sessionSummaries = Array.isArray(list)
        ? list.map(normalizeSessionSummary)
        : [];
    } catch (err) {
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, "error.sessionsLoad"), "err");
      }
    } finally {
      sessionsLoading = false;
      sessionActionId = "";
      renderSessions();
      updateSettingsAvailability();
    }
  }

  async function revokeSession(sessionId) {
    if (!authenticated || !sessionId || sessionActionId) {
      return;
    }

    sessionActionId = String(sessionId);
    renderSessions();

    try {
      await invoke("revoke_session", { sessionId: sessionId });
      notify(t("notify.sessionRevoked"));
      await loadSessions();
      if (canViewAdmin()) {
        await loadAdminStats();
      }
    } catch (err) {
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, "error.sessionRevoke"), "err");
      }
      sessionActionId = "";
      renderSessions();
    }
  }

  function updateAdminVisibility() {
    if (adminControls.button) {
      adminControls.button.classList.toggle("hidden", !canViewAdmin());
    }
    if (!canViewAdmin() && currentPage === "admin") {
      showPage(authenticated ? "dashboard" : "login");
    }
  }

  function normalizeCountMap(source) {
    var out = {};
    if (!source || typeof source !== "object") {
      return out;
    }
    Object.keys(source).forEach(function (key) {
      var value = Number(source[key]);
      out[String(key)] = isNaN(value) ? 0 : value;
    });
    return out;
  }

  function normalizeGraphPoints(source) {
    if (!Array.isArray(source)) {
      return [];
    }
    return source
      .map(function (point) {
        return {
          time: Number(point && point.time) || 0,
          value: Number(point && point.value) || 0,
        };
      })
      .sort(function (a, b) {
        return a.time - b.time;
      });
  }

  function normalizeAdminStats(source) {
    source = source || {};
    return {
      top_services: normalizeCountMap(source.top_services),
      activity_graph: normalizeGraphPoints(source.activity_graph),
      register_graph: normalizeGraphPoints(source.register_graph),
      total: {
        users: Number(source.total && source.total.users) || 0,
        admins: Number(source.total && source.total.admins) || 0,
        passwords: Number(source.total && source.total.passwords) || 0,
        active_sessions:
          Number(source.total && source.total.active_sessions) || 0,
      },
      crypt: normalizeCountMap(source.crypt),
    };
  }

  function formatGraphPointTime(unixSeconds) {
    if (!unixSeconds) {
      return "--:--";
    }
    return new Date(unixSeconds * 1000).toLocaleTimeString(
      getLanguage() === "en" ? "en-US" : "ru-RU",
      {
        hour: "2-digit",
        minute: "2-digit",
      },
    );
  }

  function formatAdminLabel(kind, raw) {
    var value = String(raw || "");
    if (kind !== "crypt") {
      return value;
    }
    var normalized = value.toLowerCase();
    if (normalized === "argon2id" || normalized === "aes256gcm-argon2id") {
      return "Argon2id";
    }
    if (normalized === "sha-256" || normalized === "aes256gcm-sha256") {
      return "SHA-256";
    }
    return value;
  }

  function renderAdminBarList(element, source, kind) {
    if (!element) {
      return;
    }
    var items = Object.keys(source || {})
      .map(function (key) {
        return {
          label: key,
          value: Number(source[key]) || 0,
        };
      })
      .sort(function (a, b) {
        return b.value - a.value;
      });

    if (!items.length) {
      element.innerHTML = '<div class="admin-empty">' + esc(t("admin.noData")) + "</div>";
      return;
    }

    var max = items[0].value || 1;
    element.innerHTML = items
      .map(function (item) {
        var width = Math.max(8, Math.round((item.value / max) * 100));
        return (
          '<div class="admin-bar-row">' +
          '<div class="admin-bar-label" title="' +
          esc(formatAdminLabel(kind, item.label)) +
          '">' +
          esc(formatAdminLabel(kind, item.label)) +
          "</div>" +
          '<div class="admin-bar-value">' +
          item.value +
          "</div>" +
          '<div class="admin-bar-track"><div class="admin-bar-fill" style="width:' +
          width +
          '%"></div></div>' +
          "</div>"
        );
      })
      .join("");
  }

  function renderAdminChart(element, points) {
    if (!element) {
      return;
    }
    if (!points || !points.length) {
      element.innerHTML = '<div class="admin-empty">' + esc(t("admin.noData")) + "</div>";
      return;
    }

    var max = 1;
    for (var i = 0; i < points.length; i += 1) {
      if (points[i].value > max) {
        max = points[i].value;
      }
    }

    element.innerHTML =
      '<div class="admin-chart-scroll"><div class="admin-chart-track">' +
      points
        .map(function (point) {
          var height = Math.max(10, Math.round((point.value / max) * 140));
          var label = formatGraphPointTime(point.time);
          return (
            '<div class="admin-chart-col" title="' +
            esc(label + " • " + point.value) +
            '">' +
            '<div class="admin-chart-value">' +
            point.value +
            "</div>" +
            '<div class="admin-chart-bar" style="height:' +
            height +
            'px"></div>' +
            '<div class="admin-chart-label">' +
            esc(label) +
            "</div>" +
            "</div>"
          );
        })
        .join("") +
      "</div></div>";
  }

  function renderAdminStats(source) {
    adminStats = normalizeAdminStats(source);
    adminControls.totalUsers.textContent = String(adminStats.total.users);
    adminControls.totalAdmins.textContent = String(adminStats.total.admins);
    adminControls.totalPasswords.textContent = String(adminStats.total.passwords);
    adminControls.totalSessions.textContent = String(
      adminStats.total.active_sessions,
    );
    renderAdminChart(adminControls.activityGraph, adminStats.activity_graph);
    renderAdminChart(adminControls.registerGraph, adminStats.register_graph);
    renderAdminBarList(adminControls.topServices, adminStats.top_services, "service");
    renderAdminBarList(adminControls.crypt, adminStats.crypt, "crypt");
  }

  function renderSettings() {
    renderAutoLockMinuteOptions();
    settingsControls.screenshotGuard.checked =
      !!appSettings.screenshotGuardEnabled;
    settingsControls.lightThemeEnabled.checked =
      !!appSettings.lightThemeEnabled;
    settingsControls.startupEnabled.checked = !!appSettings.startupEnabled;
    settingsControls.autoLockEnabled.checked = !!appSettings.autoLockEnabled;
    settingsControls.autoLockMinutes.value = String(
      appSettings.autoLockMinutes,
    );
    if (settingsControls.clipboardTimeout) {
      settingsControls.clipboardTimeout.value = String(
        appSettings.clipboardTimeoutSeconds,
      );
    }
    settingsControls.confirmDelete.checked = !!appSettings.confirmDelete;
    settingsControls.blockContextMenu.checked = !!appSettings.blockContextMenu;
    if (settingsControls.language) {
      settingsControls.language.value = getLanguage();
    }
    if (settingsControls.uiScale) {
      settingsControls.uiScale.value = String(normalizeUiScale(appSettings.uiScale));
    }
    if (settingsControls.encryptionAlgorithm) {
      settingsControls.encryptionAlgorithm.value = normalizeEncryptionAlgorithm(
        appSettings.encryptionAlgorithm,
      );
    }
    if (settingsControls.backendModeProduction) {
      settingsControls.backendModeProduction.checked =
        backendDraftMode !== BACKEND_MODE_CUSTOM;
    }
    if (settingsControls.backendModeCustom) {
      settingsControls.backendModeCustom.checked =
        backendDraftMode === BACKEND_MODE_CUSTOM;
    }
    if (settingsControls.backendCustomUrl) {
      settingsControls.backendCustomUrl.value = backendDraftCustomUrl;
    }
    if (settingsControls.backendEffective) {
      settingsControls.backendEffective.textContent = currentBackendEndpoint;
    }
    renderServerStatus();
    renderSessions();
    updateSettingsAvailability();
  }

  function applyTheme() {
    document.body.classList.toggle(
      "theme-light",
      !!appSettings.lightThemeEnabled,
    );
  }

  function applyUiScale() {
    var scale = normalizeUiScale(appSettings.uiScale);
    appSettings.uiScale = scale;
    document.documentElement.style.setProperty("--ui-scale", String(scale));
  }

  function clearAutoLockTimer() {
    if (autoLockTimer) {
      clearTimeout(autoLockTimer);
      autoLockTimer = null;
    }
  }

  function finalizeLocalLogout(message, type) {
    clearAutoLockTimer();
    setAuthenticated(false);
    setCurrentUser(null);
    resolveWeakConfirmation(false);
    hideModal("seed");
    hideModal("del");
    currentId = null;
    deleteId = null;
    var list = document.getElementById("pw-list");
    if (list) {
      list.innerHTML = "";
    }
    showPage("login", { instant: true });

    if (message) {
      notify(message, type || "ok");
    }
  }

  async function performLogout(message, type) {
    try {
      await invoke("logout");
    } catch (e) {}
    finalizeLocalLogout(message, type);
  }

  function scheduleAutoLock() {
    clearAutoLockTimer();

    if (!authenticated || !appSettings.autoLockEnabled) {
      return;
    }

    autoLockTimer = setTimeout(
      function () {
        performLogout(t("notify.sessionExpired"), "err");
      },
      appSettings.autoLockMinutes * 60 * 1000,
    );
  }

  function onUserActivity() {
    if (!authenticated) return;
    scheduleAutoLock();
  }

  function setAuthenticated(value) {
    authenticated = !!value;
    if (!authenticated) {
      clearAutoLockTimer();
      adminStats = null;
      sessionsLoading = false;
      sessionSummaries = [];
      sessionActionId = "";
      renderSessions();
      updateSettingsAvailability();
      updateAdminVisibility();
      return;
    }

    renderSessions();
    updateSettingsAvailability();
    updateAdminVisibility();
    scheduleAutoLock();
  }


  async function syncPreference(command, payload, key, fallback) {
    if (!authenticated || preferenceSyncInProgress[key]) {
      return false;
    }

    preferenceSyncInProgress[key] = true;
    updateSettingsAvailability();

    try {
      await invoke(command, payload);
      return true;
    } catch (err) {
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, fallback || "error.save"), "err");
      }
      return false;
    } finally {
      preferenceSyncInProgress[key] = false;
      renderSettings();
    }
  }

  function hasCurrentServerProbe() {
    return (
      lastProbedBackendEndpoint === currentBackendEndpoint &&
      serverStatus.endpoint === currentBackendEndpoint &&
      !!(
        serverStatus.healthy ||
        serverStatus.health_error ||
        serverStatus.compatibility_checked ||
        serverStatus.compatibility_error
      )
    );
  }

  function resetServerProbe() {
    serverStatus = createEmptyServerStatus();
    serverStatus.endpoint = currentBackendEndpoint;
    lastProbedBackendEndpoint = "";
  }

  async function probeBackendServer(force) {
    if (!shouldShowBackendSettings()) {
      return null;
    }
    if (serverProbeInProgress) {
      return null;
    }
    if (!force && hasCurrentServerProbe()) {
      return serverStatus;
    }

    serverProbeInProgress = true;
    serverStatus = createEmptyServerStatus();
    serverStatus.endpoint = currentBackendEndpoint;
    renderSettings();
    updateSettingsAvailability();

    try {
      serverStatus = normalizeServerStatus(await invoke("probe_backend_server"));
      if (!serverStatus.endpoint) {
        serverStatus.endpoint = currentBackendEndpoint;
      }
      lastProbedBackendEndpoint = currentBackendEndpoint;
      return serverStatus;
    } catch (err) {
      serverStatus = createEmptyServerStatus();
      serverStatus.endpoint = currentBackendEndpoint;
      serverStatus.health_error = localizeMessage(
        err,
        "settings.backend.statusUnreachable",
      );
      lastProbedBackendEndpoint = currentBackendEndpoint;
      return serverStatus;
    } finally {
      serverProbeInProgress = false;
      renderSettings();
      updateSettingsAvailability();
    }
  }

  function openSettingsPage(returnPage) {
    settingsReturnPage =
      returnPage || currentPage || (authenticated ? "dashboard" : "login");
    renderSettings();
    showPage("settings");
    if (authenticated) {
      loadSessions();
    }
  }

  function buildBackendEndpointCandidates(preferredEndpoint) {
    var out = [];

    function push(value) {
      try {
        var normalized = validateBackendEndpoint(value);
        if (out.indexOf(normalized) === -1) {
          out.push(normalized);
        }
      } catch (e) {}
    }

    push(preferredEndpoint || DEFAULT_BACKEND_ENDPOINT);
    push(DEFAULT_BACKEND_ENDPOINT);
    push(DEFAULT_BACKEND_FALLBACK_ENDPOINT);
    return out;
  }

  async function applyBackendEndpointRuntime(endpoint) {
    var result = await invoke("set_backend_endpoint", {
      endpoint: endpoint,
    });
    currentBackendEndpoint =
      result && result.endpoint ? String(result.endpoint) : endpoint;
    resetServerProbe();
    return {
      endpoint: currentBackendEndpoint,
      reauthRequired: !!(result && result.reauth_required),
    };
  }

  async function resolveProductionBackendRuntime(preferredEndpoint) {
    var candidates = buildBackendEndpointCandidates(preferredEndpoint);
    var selected = null;
    var selectedStatus = null;
    var selectedReauthRequired = false;
    var lastError = null;

    for (var i = 0; i < candidates.length; i++) {
      var candidate = candidates[i];

      try {
        var applied = await applyBackendEndpointRuntime(candidate);
        var status = normalizeServerStatus(await invoke("probe_backend_server"));
        if (!status.endpoint) {
          status.endpoint = applied.endpoint;
        }

        if (!selected) {
          selected = applied;
          selectedStatus = status;
          selectedReauthRequired = applied.reauthRequired;
        }

        if (status.healthy) {
          serverStatus = status;
          lastProbedBackendEndpoint = applied.endpoint;
          return {
            endpoint: applied.endpoint,
            reauthRequired: applied.reauthRequired,
            status: status,
          };
        }
      } catch (err) {
        lastError = err;
      }
    }

    if (selected) {
      currentBackendEndpoint = selected.endpoint;
      serverStatus = selectedStatus || createEmptyServerStatus();
      serverStatus.endpoint = selected.endpoint;
      lastProbedBackendEndpoint = selected.endpoint;
      return {
        endpoint: selected.endpoint,
        reauthRequired: selectedReauthRequired,
        status: selectedStatus,
      };
    }

    if (lastError) {
      throw lastError;
    }

    throw "Invalid backend endpoint";
  }

  async function applyBackendSelection() {
    if (backendSyncInProgress) {
      return;
    }

    var requestedEndpoint;
    try {
      requestedEndpoint = resolveSettingsBackendEndpoint({
        backendMode: backendDraftMode,
        backendCustomUrl: backendDraftCustomUrl,
      });
    } catch (err) {
      notify(localizeMessage(err, "error.backendEndpointInvalid"), "err");
      renderSettings();
      return;
    }

    backendSyncInProgress = true;
    updateSettingsAvailability();

    try {
      var result =
        backendDraftMode === BACKEND_MODE_CUSTOM
          ? await applyBackendEndpointRuntime(requestedEndpoint)
          : await resolveProductionBackendRuntime(requestedEndpoint);
      appSettings.backendMode = backendDraftMode;
      appSettings.backendCustomUrl =
        backendDraftMode === BACKEND_MODE_CUSTOM
          ? currentBackendEndpoint
          : String(backendDraftCustomUrl || "").trim();
      backendDraftCustomUrl = appSettings.backendCustomUrl;
      saveSettings();
      renderSettings();
      if (result && result.reauth_required) {
        finalizeLocalLogout(t("notify.backendChangedReauth"), "err");
        return;
      }
      var probeResult = await probeBackendServer(true);
      if (probeResult && !probeResult.healthy) {
        notify(
          probeResult.health_error || t("settings.backend.statusUnreachable"),
          "err",
        );
        return;
      }
      notify(t("notify.backendApplied"));
      if (authenticated && currentPage === "settings") {
        await loadSessions();
      }
    } catch (err) {
      notify(localizeMessage(err, "error.backendApply"), "err");
    } finally {
      backendSyncInProgress = false;
      renderSettings();
      updateSettingsAvailability();
    }
  }

  async function syncBackendOnStart() {
    var requestedEndpoint = getSafeSettingsBackendEndpoint(appSettings);

    backendSyncInProgress = true;
    updateSettingsAvailability();

    try {
      if (appSettings.backendMode === BACKEND_MODE_CUSTOM) {
        await applyBackendEndpointRuntime(requestedEndpoint);
      } else {
        await resolveProductionBackendRuntime(requestedEndpoint);
      }
      if (appSettings.backendMode === BACKEND_MODE_CUSTOM) {
        appSettings.backendCustomUrl = currentBackendEndpoint;
        backendDraftCustomUrl = currentBackendEndpoint;
        saveSettings();
      }
    } catch (err) {
      currentBackendEndpoint = DEFAULT_BACKEND_ENDPOINT;
      resetServerProbe();
      try {
        await applyBackendEndpointRuntime(DEFAULT_BACKEND_ENDPOINT);
      } catch (ignored) {}
    } finally {
      backendSyncInProgress = false;
      renderSettings();
      updateSettingsAvailability();
    }
  }

  function getSettingsReturnPage() {
    if (!authenticated && settingsReturnPage === "dashboard") {
      return "login";
    }
    return settingsReturnPage || (authenticated ? "dashboard" : "login");
  }

  async function loadAdminStats() {
    if (!canViewAdmin() || adminStatsLoading) {
      return;
    }

    adminStatsLoading = true;
    if (adminControls.refresh) {
      adminControls.refresh.disabled = true;
    }

    try {
      renderAdminStats(await invoke("get_admin_stats"));
    } catch (err) {
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, "error.statsLoad"), "err");
      }
    } finally {
      adminStatsLoading = false;
      if (adminControls.refresh) {
        adminControls.refresh.disabled = false;
      }
    }
  }

  async function openAdminPage() {
    if (!canViewAdmin()) {
      return;
    }
    showPage("admin");
    await loadAdminStats();
  }

  async function applyScreenshotGuardSetting(enabled, silent) {
    if (!authenticated) {
      return;
    }

    if (settingsSyncInProgress) {
      return;
    }

    settingsSyncInProgress = true;
    settingsControls.screenshotGuard.disabled = true;

    try {
      var result = await invoke("set_screenshot_guard_enabled", {
        enabled: !!enabled,
      });
      appSettings.screenshotGuardEnabled = !!result;
      saveSettings();
      renderSettings();
      if (!silent) {
        notify(
          appSettings.screenshotGuardEnabled
            ? t("notify.screenshotGuardOn")
            : t("notify.screenshotGuardOff"),
        );
      }
    } catch (err) {
      renderSettings();
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, "error.screenshotGuardChange"), "err");
      }
    }

    settingsSyncInProgress = false;
    updateSettingsAvailability();
  }

  async function syncScreenshotGuardOnStart() {
    if (!authenticated) {
      return;
    }

    if (hasStoredSettings) {
      await applyScreenshotGuardSetting(
        appSettings.screenshotGuardEnabled,
        true,
      );
      return;
    }

    try {
      var status = await invoke("get_screenshot_guard_status");
      appSettings.screenshotGuardEnabled = !!status;
      saveSettings();
      renderSettings();
    } catch (e) {
      await applyScreenshotGuardSetting(
        appSettings.screenshotGuardEnabled,
        true,
      );
    }
  }

  async function applyStartupSetting(enabled, silent) {
    if (!authenticated) {
      return;
    }

    if (startupSyncInProgress) {
      return;
    }

    startupSyncInProgress = true;
    settingsControls.startupEnabled.disabled = true;

    try {
      var result = await invoke("set_startup_enabled", { enabled: !!enabled });
      appSettings.startupEnabled = !!result;
      saveSettings();
      renderSettings();
      if (!silent) {
        notify(
          appSettings.startupEnabled
            ? t("notify.startupOn")
            : t("notify.startupOff"),
        );
      }
    } catch (err) {
      renderSettings();
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, "error.startupChange"), "err");
      }
    }

    startupSyncInProgress = false;
    updateSettingsAvailability();
  }

  async function syncStartupOnStart() {
    if (!authenticated) {
      return;
    }

    try {
      var status = await invoke("get_startup_status");
      appSettings.startupEnabled = !!status;
      saveSettings();
      renderSettings();
    } catch (err) {
      if (await handleAuthFailure(err)) {
        return;
      }
      notify(localizeMessage(err, "error.startupStatus"), "err");
    }
  }

  async function deleteEntry(entryId) {
    if (!entryId) return;

    try {
      await invoke("delete_password", { entryId: entryId });
      notify(t("notify.deleted"));
      hideModal("del");
      await loadPasswords();
    } catch (err) {
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, "error.delete"), "err");
      }
    }

    deleteId = null;
  }

  function esc(text) {
    var d = document.createElement("div");
    d.textContent = text;
    return d.innerHTML;
  }

  function setLoad(id, on) {
    var btn = document.getElementById(id);
    if (!btn) return;
    var t = btn.querySelector(".btn-t");
    var s = btn.querySelector(".btn-spin");
    btn.disabled = on;
    if (t) {
      if (on) t.classList.add("hidden");
      else t.classList.remove("hidden");
    }
    if (s) {
      if (on) s.classList.remove("hidden");
      else s.classList.add("hidden");
    }
  }

  function buildServiceGlyphSvg(text, fontSize, weight) {
    return (
      '<svg viewBox="0 0 24 24" aria-hidden="true">' +
      '<text x="12" y="15.2" text-anchor="middle" font-size="' +
      (fontSize || 9) +
      '" font-family="Arial, sans-serif" font-weight="' +
      (weight || 700) +
      '" fill="currentColor">' +
      text +
      "</text>" +
      "</svg>"
    );
  }

  var SERVICE_ICON_DEFINITIONS = [
    {
      aliases: ["gmail.com", "gmail", "google mail"],
      accent: "#ea4335",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M4 6.5h16a1 1 0 0 1 1 1V17a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V7.5a1 1 0 0 1 1-1Z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/>' +
        '<path d="M4 8l8 6 8-6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>' +
        '<path d="M4 17V9l8 5.8L20 9v8" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>' +
        "</svg>",
    },
    {
      aliases: ["youtube.com", "youtu.be", "youtube"],
      accent: "#ff0033",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M21 12c0 3.5-.3 4.6-.6 5.3a2.8 2.8 0 0 1-1.6 1.6c-.7.3-1.8.6-6.8.6s-6.1-.3-6.8-.6a2.8 2.8 0 0 1-1.6-1.6C3.3 16.6 3 15.5 3 12s.3-4.6.6-5.3a2.8 2.8 0 0 1 1.6-1.6c.7-.3 1.8-.6 6.8-.6s6.1.3 6.8.6a2.8 2.8 0 0 1 1.6 1.6c.3.7.6 1.8.6 5.3Z" fill="currentColor"/>' +
        '<path d="M10 8.5 16 12l-6 3.5Z" fill="#0b0f14"/>' +
        "</svg>",
    },
    {
      aliases: ["telegram", "t.me"],
      accent: "#229ed9",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M20.7 4.1 4.2 10.5c-1 .4-1 1 .1 1.4l4.2 1.3 1.7 5.1c.2.7.5.9 1 .9.4 0 .7-.2 1-.5l2.4-2.3 4.8 3.5c.9.5 1.5.2 1.7-.8l2.7-13.1c.3-1.3-.5-1.9-1.6-1.4Z" fill="currentColor"/>' +
        '<path d="m9.2 13 8.4-5.2c.4-.3.8-.1.5.2L11.2 14l-.3 3-1.7-4Z" fill="#0b0f14"/>' +
        "</svg>",
    },
    {
      aliases: ["discord", "discordapp"],
      accent: "#5865f2",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M7 7.6c1.5-.7 2.6-.9 3.4-1l.4.8c-1 .2-1.8.5-2.6.9.8-.4 1.8-.7 3.8-.7s3 .3 3.8.7c-.8-.4-1.6-.7-2.6-.9l.4-.8c.8.1 1.9.3 3.4 1 1.6 2.3 2.3 4.6 2.5 6.8-1.1 1.5-2.2 2.4-3.3 3l-.8-1.2c.5-.2 1-.5 1.5-.9-.9.7-2.5 1.4-5 1.4s-4.1-.7-5-1.4c.5.4 1 .7 1.5.9l-.8 1.2c-1.1-.6-2.2-1.5-3.3-3 .2-2.2.9-4.5 2.5-6.8Z" fill="currentColor"/>' +
        '<circle cx="9.7" cy="12.5" r="1.2" fill="#0b0f14"/>' +
        '<circle cx="14.3" cy="12.5" r="1.2" fill="#0b0f14"/>' +
        "</svg>",
    },
    {
      aliases: ["github.com", "github"],
      accent: "#24292f",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M12 3C7 3 3 6.9 3 11.7c0 3.8 2.5 7 6 8.1.4.1.6-.2.6-.5v-1.7c-2.4.5-2.9-1-2.9-1-.4-1-.9-1.2-.9-1.2-.8-.5.1-.5.1-.5.9.1 1.3.9 1.3.9.8 1.3 2 1 2.5.7.1-.5.3-.9.6-1.1-1.9-.2-4-1-4-4.2 0-.9.3-1.7.9-2.3-.1-.2-.4-1.1.1-2.2 0 0 .7-.2 2.4.9.7-.2 1.5-.3 2.3-.3s1.6.1 2.3.3c1.6-1.1 2.4-.9 2.4-.9.5 1.1.2 2 .1 2.2.6.6.9 1.4.9 2.3 0 3.2-2 4-4 4.2.3.3.6.8.6 1.5v2.2c0 .3.2.6.6.5 3.5-1.1 6-4.3 6-8.1C21 6.9 17 3 12 3Z" fill="currentColor"/>' +
        "</svg>",
    },
    {
      aliases: ["gitlab.com", "gitlab"],
      accent: "#fc6d26",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="m12 19.5 3.2-10H8.8L12 19.5Z" fill="currentColor"/>' +
        '<path d="M5.5 9.5 8.8 9.5 7.4 5.3c-.1-.4-.6-.4-.8 0L5.5 9.5Z" fill="currentColor" opacity=".7"/>' +
        '<path d="M18.5 9.5h-3.3l1.4-4.2c.1-.4.6-.4.8 0l1.1 4.2Z" fill="currentColor" opacity=".7"/>' +
        '<path d="M5.5 9.5 4 14.1c-.1.4 0 .7.3 1L12 19.5 5.5 9.5Z" fill="currentColor" opacity=".45"/>' +
        '<path d="m18.5 9.5 1.5 4.6c.1.4 0 .7-.3 1L12 19.5l6.5-10Z" fill="currentColor" opacity=".45"/>' +
        "</svg>",
    },
    {
      aliases: ["figma"],
      accent: "#f24e1e",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="6" y="3" width="6" height="6" rx="3" fill="currentColor"/>' +
        '<rect x="12" y="3" width="6" height="6" rx="3" fill="currentColor" opacity=".88"/>' +
        '<rect x="6" y="9" width="6" height="6" rx="3" fill="currentColor" opacity=".76"/>' +
        '<circle cx="15" cy="12" r="3" fill="currentColor" opacity=".64"/>' +
        '<rect x="6" y="15" width="6" height="6" rx="3" fill="currentColor" opacity=".52"/>' +
        "</svg>",
    },
    {
      aliases: ["notion"],
      accent: "#111111",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="4.3" y="4.3" width="15.4" height="15.4" rx="1.7" fill="none" stroke="currentColor" stroke-width="1.7"/>' +
        '<path d="M8 16V8.2l1.8.1 4.3 5.8V8h1.9v7.8h-1.7L10 10v6Z" fill="currentColor"/>' +
        "</svg>",
    },
    {
      aliases: ["spotify"],
      accent: "#1db954",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M7 9.6c3.3-1 6.8-.8 10 .6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>' +
        '<path d="M8 12.5c2.7-.8 5.5-.6 8 .5" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" opacity=".85"/>' +
        '<path d="M9 15.2c2-.5 4-.4 5.8.4" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" opacity=".7"/>' +
        "</svg>",
    },
    {
      aliases: ["slack"],
      accent: "#4a154b",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="5" y="9.5" width="5" height="2.8" rx="1.4" fill="currentColor"/>' +
        '<rect x="7.2" y="5" width="2.8" height="5.2" rx="1.4" fill="currentColor" opacity=".82"/>' +
        '<rect x="14" y="5" width="2.8" height="5.2" rx="1.4" fill="currentColor"/>' +
        '<rect x="14" y="13.8" width="5" height="2.8" rx="1.4" fill="currentColor" opacity=".82"/>' +
        '<rect x="9.5" y="14" width="5" height="2.8" rx="1.4" fill="currentColor"/>' +
        '<rect x="5" y="14" width="2.8" height="5" rx="1.4" fill="currentColor" opacity=".82"/>' +
        "</svg>",
    },
    {
      aliases: ["trello"],
      accent: "#0079bf",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="4.2" y="5.2" width="15.6" height="13.6" rx="2.2" fill="none" stroke="currentColor" stroke-width="1.7"/>' +
        '<rect x="7" y="8" width="3.3" height="7.5" rx="1.1" fill="currentColor"/>' +
        '<rect x="13.7" y="8" width="3.3" height="5.2" rx="1.1" fill="currentColor" opacity=".78"/>' +
        "</svg>",
    },
    {
      aliases: ["dropbox"],
      accent: "#0061ff",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="m7.2 5 4.3 2.7L7.2 10 3 7.3 7.2 5Zm9.6 0L21 7.3 16.8 10l-4.3-2.3L16.8 5ZM7.2 11l4.3 2.6-4.3 2.7L3 13.6 7.2 11Zm9.6 0 4.2 2.6-4.2 2.7-4.3-2.7 4.3-2.6ZM12 14.7l4.3 2.6L12 20l-4.3-2.7 4.3-2.6Z" fill="currentColor"/>' +
        "</svg>",
    },
    {
      aliases: ["docker"],
      accent: "#2496ed",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="5" y="10" width="2.6" height="2.6" fill="currentColor"/>' +
        '<rect x="8" y="10" width="2.6" height="2.6" fill="currentColor"/>' +
        '<rect x="11" y="10" width="2.6" height="2.6" fill="currentColor"/>' +
        '<rect x="8" y="7" width="2.6" height="2.6" fill="currentColor" opacity=".82"/>' +
        '<rect x="11" y="7" width="2.6" height="2.6" fill="currentColor" opacity=".82"/>' +
        '<path d="M4.5 14c.7 2.7 2.8 4.3 6.2 4.3h3.4c2.5 0 4.5-1.1 5.7-3.2.6.1 1.2-.1 1.7-.4-.2-.5-.7-1-1.2-1.3.1-.6 0-1.2-.2-1.7-.6.2-1.1.7-1.4 1.2-.5-.1-1-.1-1.4 0H4.5Z" fill="currentColor"/>' +
        "</svg>",
    },
    {
      aliases: ["cloudflare"],
      accent: "#f48120",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M8.2 16.8c-.5 0-.9-.3-.8-.8.3-1.4 1.5-2.4 3-2.4h.2c.6-2.2 2.5-3.7 4.9-3.7 2.8 0 5.1 2.2 5.3 4.9.9.1 1.6.9 1.6 1.8 0 .1 0 .2-.1.2H8.2Z" fill="currentColor"/>' +
        '<path d="M6.4 16.8c-.5 0-.9-.4-.8-.9.2-1.2 1.2-2 2.4-2h.6c.3-1.1 1.3-1.9 2.4-1.9.8 0 1.5.3 2 .8-.9.2-1.7.8-2.2 1.5h-.4c-1 0-1.9.6-2.2 1.6 0 .4-.4.7-.8.7H6.4Z" fill="currentColor" opacity=".72"/>' +
        "</svg>",
    },
    {
      aliases: ["instagram.com", "instagram", "insta"],
      accent: "#e4405f",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="5" y="5" width="14" height="14" rx="4" fill="none" stroke="currentColor" stroke-width="1.8"/>' +
        '<circle cx="12" cy="12" r="3.2" fill="none" stroke="currentColor" stroke-width="1.8"/>' +
        '<circle cx="16.2" cy="7.8" r="1.1" fill="currentColor"/>' +
        "</svg>",
    },
    {
      aliases: ["whatsapp"],
      accent: "#25d366",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M12 4.5a7.5 7.5 0 0 0-6.4 11.5L5 19.5l3.6-.5A7.5 7.5 0 1 0 12 4.5Z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/>' +
        '<path d="M9.3 9.1c-.3-.7-.6-.7-.8-.7h-.7c-.3 0-.7.1-1 .5-.3.4-1.1 1-1.1 2.5s1.2 2.9 1.4 3.1c.2.2 2.2 3.4 5.5 4.6 2.7 1 3.3.8 3.9.7.6-.1 1.8-.8 2-1.6.3-.8.3-1.5.2-1.6-.1-.1-.5-.2-1.1-.5-.6-.3-1.4-.7-1.6-.8-.2-.1-.4-.1-.6.2-.2.3-.7.8-.9 1-.2.2-.4.2-.7.1-.3-.2-1.4-.5-2.6-1.6-1-.9-1.6-1.9-1.8-2.2-.2-.3 0-.5.1-.7.2-.2.3-.4.5-.6.2-.2.2-.4.3-.6.1-.2 0-.4-.1-.6-.1-.2-.7-1.7-.9-2.3Z" fill="currentColor"/>' +
        "</svg>",
    },
    {
      aliases: ["linkedin"],
      accent: "#0a66c2",
      svg: buildServiceGlyphSvg("in", 10, 700),
    },
    {
      aliases: ["reddit"],
      accent: "#ff4500",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<circle cx="9" cy="13" r="1.3" fill="currentColor"/>' +
        '<circle cx="15" cy="13" r="1.3" fill="currentColor"/>' +
        '<path d="M8.2 15.8c1 .8 2.3 1.2 3.8 1.2s2.8-.4 3.8-1.2" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>' +
        '<path d="M7 10.8c-1.2.4-2 1.3-2 2.4 0 1.7 3.1 3.3 7 3.3s7-1.6 7-3.3c0-1.1-.8-2-2-2.4" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>' +
        '<circle cx="19" cy="9.2" r="1.4" fill="currentColor"/>' +
        '<path d="M13.2 8.5 14.3 5l2.4.5" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>' +
        "</svg>",
    },
    {
      aliases: ["steam"],
      accent: "#171a21",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<circle cx="15.8" cy="8.1" r="3.2" fill="none" stroke="currentColor" stroke-width="1.8"/>' +
        '<circle cx="8.2" cy="15.6" r="2.4" fill="currentColor"/>' +
        '<path d="m10.4 14.7 3.2-2.2a3.2 3.2 0 1 0 1.2 1.6l-3.1 2.1" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>' +
        "</svg>",
    },
    {
      aliases: ["twitch"],
      accent: "#9146ff",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M6 4h13v9l-3 3h-3l-2 2H8v-2H6V4Z" fill="currentColor"/>' +
        '<rect x="10" y="8" width="1.8" height="4.5" fill="#0b0f14"/>' +
        '<rect x="14" y="8" width="1.8" height="4.5" fill="#0b0f14"/>' +
        "</svg>",
    },
    {
      aliases: ["zoom"],
      accent: "#2d8cff",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="4.5" y="7.5" width="9.8" height="9" rx="2.3" fill="currentColor"/>' +
        '<path d="M15.6 10.3 20 8.2c.5-.2 1 .1 1 .7v6.2c0 .6-.5.9-1 .7l-4.4-2.1v-3.4Z" fill="currentColor" opacity=".82"/>' +
        "</svg>",
    },
    {
      aliases: ["trezor", "ledger"],
      accent: "#101820",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="5" y="6" width="14" height="12" rx="3" fill="none" stroke="currentColor" stroke-width="1.8"/>' +
        '<circle cx="12" cy="12" r="2.2" fill="currentColor"/>' +
        "</svg>",
    },
    {
      aliases: ["bitbucket"],
      accent: "#2684ff",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="M5 6h14l-1.6 10.4a1.4 1.4 0 0 1-1.4 1.2H8a1.4 1.4 0 0 1-1.4-1.2L5 6Z" fill="currentColor"/>' +
        '<path d="M8.4 10.2h7.4l-.7 4.7H9.2l-.8-4.7Z" fill="#0b0f14"/>' +
        "</svg>",
    },
    {
      aliases: ["jira", "atlassian"],
      accent: "#0052cc",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="m12 4 4 4-4 4-4-4 4-4Z" fill="currentColor"/>' +
        '<path d="m8 10 4 4-4 4-4-4 4-4Z" fill="currentColor" opacity=".72"/>' +
        '<path d="m16 10 4 4-4 4-4-4 4-4Z" fill="currentColor" opacity=".5"/>' +
        "</svg>",
    },
    {
      aliases: ["microsoft", "outlook", "hotmail", "live.com", "office", "azure", "onedrive"],
      accent: "#5e5e5e",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<rect x="4.5" y="4.5" width="6.5" height="6.5" fill="currentColor"/>' +
        '<rect x="13" y="4.5" width="6.5" height="6.5" fill="currentColor" opacity=".82"/>' +
        '<rect x="4.5" y="13" width="6.5" height="6.5" fill="currentColor" opacity=".82"/>' +
        '<rect x="13" y="13" width="6.5" height="6.5" fill="currentColor" opacity=".64"/>' +
        "</svg>",
    },
    {
      aliases: ["facebook.com", "facebook"],
      accent: "#1877f2",
      svg: buildServiceGlyphSvg("f", 13, 700),
    },
    {
      aliases: ["twitter.com", "twitter", "x.com"],
      accent: "#111111",
      svg: buildServiceGlyphSvg("X", 11, 700),
    },
    {
      aliases: ["vk.com", "vkontakte", "вконтакте", "vk"],
      accent: "#2787f5",
      svg: buildServiceGlyphSvg("VK", 8.5, 700),
    },
    {
      aliases: ["yandex.ru", "ya.ru", "yandex"],
      accent: "#fc3f1d",
      svg: buildServiceGlyphSvg("Y", 12, 700),
    },
    {
      aliases: ["paypal"],
      accent: "#003087",
      svg: buildServiceGlyphSvg("P", 12, 700),
    },
    {
      aliases: ["amazon web services", "aws", "amazon"],
      accent: "#ff9900",
      svg: buildServiceGlyphSvg("AWS", 6.3, 700),
    },
    {
      aliases: ["google.com", "google", "workspace"],
      accent: "#4285f4",
      svg: buildServiceGlyphSvg("G", 12, 700),
    },
    {
      aliases: ["tiktok"],
      accent: "#111111",
      svg: buildServiceGlyphSvg("TT", 7.5, 700),
    },
    {
      aliases: ["netflix"],
      accent: "#e50914",
      svg: buildServiceGlyphSvg("N", 12, 700),
    },
    {
      aliases: ["epic games", "epic"],
      accent: "#2a2a2a",
      svg: buildServiceGlyphSvg("EP", 7.5, 700),
    },
    {
      aliases: ["roblox"],
      accent: "#e2231a",
      svg:
        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
        '<path d="m8.1 4.5 11.4 3.6-3.6 11.4-11.4-3.6L8.1 4.5Z" fill="currentColor"/>' +
        '<path d="m11 9.7 3.2 1-1 3.2-3.2-1 1-3.2Z" fill="#0b0f14"/>' +
        "</svg>",
    },
    {
      aliases: ["apple", "icloud", "app store"],
      accent: "#1f1f1f",
      svg: buildServiceGlyphSvg("A", 12, 700),
    },
  ];

  function findServiceIcon(title) {
    var raw = String(title || "").trim().toLowerCase();
    if (!raw) {
      return null;
    }

    for (var i = 0; i < SERVICE_ICON_DEFINITIONS.length; i += 1) {
      var definition = SERVICE_ICON_DEFINITIONS[i];
      for (var j = 0; j < definition.aliases.length; j += 1) {
        if (raw.indexOf(definition.aliases[j]) !== -1) {
          return definition;
        }
      }
    }

    return null;
  }

  function renderServiceIcon(title) {
    var matched = findServiceIcon(title);
    if (!matched) {
      var fallback = esc(String(title || "?").trim().charAt(0).toUpperCase() || "?");
      return '<div class="card-ico">' + fallback + "</div>";
    }

    return (
      '<div class="card-ico card-ico-brand" style="--service-accent:' +
      matched.accent +
      '">' +
      matched.svg +
      "</div>"
    );
  }

  function parseEntryDateValue(value) {
    if (value === null || value === undefined) {
      return null;
    }

    if (typeof value === "number" && isFinite(value)) {
      return new Date(value > 1000000000000 ? value : value * 1000);
    }

    if (typeof value === "string") {
      var trimmed = value.trim();
      if (!trimmed) {
        return null;
      }

      if (/^\d+$/.test(trimmed)) {
        var unix = Number(trimmed);
        if (isFinite(unix) && unix > 0) {
          return new Date(unix > 1000000000000 ? unix : unix * 1000);
        }
      }

      var parsed = new Date(trimmed);
      if (!isNaN(parsed.getTime())) {
        return parsed;
      }
    }

    if (typeof value === "object" && isFinite(Number(value.seconds))) {
      return new Date(Number(value.seconds) * 1000);
    }

    return null;
  }

  function formatEntryDate(value) {
    var parsed = parseEntryDateValue(value);
    if (!parsed || isNaN(parsed.getTime())) {
      return value ? String(value) : t("common.justNow");
    }

    return parsed.toLocaleString(getLanguage() === "en" ? "en-US" : "ru-RU", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    });
  }

  async function loadPasswords() {
    var list = document.getElementById("pw-list");
    try {
      var entries = await invoke("get_passwords");
      persistEnvelopeFromEntries(entries);
      list.innerHTML = "";
      if (!entries || entries.length === 0) {
        list.innerHTML =
          '<div class="empty">' +
          '<div class="empty-icon" aria-hidden="true">' +
          '<svg viewBox="0 0 24 24" fill="none">' +
          '<path d="M8 10V7.75C8 5.13 9.79 3 12 3s4 2.13 4 4.75V10" />' +
          '<rect x="5" y="10" width="14" height="11" rx="3" />' +
          '<path d="M12 14.25v2.75" />' +
          '<circle cx="12" cy="14" r="1.1" fill="currentColor" stroke="none" />' +
          '</svg>' +
          '</div>' +
          "<p>" +
          t("dashboard.emptyTitle") +
          "</p>" +
          "<span>" +
          t("dashboard.emptySubtitle") +
          "</span>" +
          "</div>";
        return;
      }
      for (var i = 0; i < entries.length; i++) {
        list.appendChild(makeCard(entries[i], i));
      }
    } catch (err) {
      if (await handleAuthFailure(err)) {
        return;
      }
      notify(localizeMessage(err, "error.load"), "err");
    }
  }

  function makeCard(entry, idx) {
    var card = document.createElement("div");
    card.className = "pw-card";
    card.style.animationDelay = idx * 0.06 + "s";

    card.innerHTML =
      renderServiceIcon(entry.title) +
      '<div class="card-info">' +
      '<div class="card-name">' +
      esc(entry.title) +
      "</div>" +
      '<div class="card-date">' +
      esc(formatEntryDate(entry.created_at)) +
      "</div>" +
      "</div>" +
      '<button class="card-del" title="' +
      t("common.delete") +
      '">' +
      '<svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>' +
      "</button>";

    card.addEventListener("click", async function (e) {
      if (e.target.closest(".card-del")) return;

      currentId = entry.id;
      resetSeedModal();
      showModal("seed");
      setTimeout(function () {
        document.getElementById("modal-seed").focus();
      }, 100);
    });

    card.querySelector(".card-del").addEventListener("click", function (e) {
      e.stopPropagation();
      if (appSettings.confirmDelete) {
        deleteId = entry.id;
        document.getElementById("del-name").textContent = entry.title;
        showModal("del");
      } else {
        deleteEntry(entry.id);
      }
    });

    return card;
  }

  document.querySelectorAll(".eye").forEach(function (btn) {
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      e.stopPropagation();
      var inp = document.getElementById(btn.getAttribute("data-target"));
      var show = btn.querySelector(".eye-show");
      var hide = btn.querySelector(".eye-hide");
      if (inp.type === "password") {
        inp.type = "text";
        show.classList.add("hidden");
        hide.classList.remove("hidden");
      } else {
        inp.type = "password";
        show.classList.remove("hidden");
        hide.classList.add("hidden");
      }
    });
  });

  var regPass = document.getElementById("reg-pass");
  if (regPass) {
    regPass.addEventListener("input", function () {
      var p = regPass.value;
      var bar = document.getElementById("str-bar");
      var s = 0;
      if (p.length >= 6) s++;
      if (p.length >= 10) s++;
      if (/[A-Z]/.test(p) && /[a-z]/.test(p)) s++;
      if (/\d/.test(p)) s++;
      if (/[^A-Za-z0-9]/.test(p)) s++;
      bar.className = "str-fill" + (s > 0 ? " s" + s : "");
    });
  }

  renderSettings();
  applyUiScale();
  applyTheme();
  applyTranslations();

  if (settingsControls.backendModeProduction) {
    settingsControls.backendModeProduction.addEventListener("change", function () {
      if (!settingsControls.backendModeProduction.checked) {
        return;
      }
      backendDraftMode = BACKEND_MODE_PRODUCTION;
      renderSettings();
    });
  }

  if (settingsControls.backendModeCustom) {
    settingsControls.backendModeCustom.addEventListener("change", function () {
      if (!settingsControls.backendModeCustom.checked) {
        return;
      }
      backendDraftMode = BACKEND_MODE_CUSTOM;
      renderSettings();
    });
  }

  if (settingsControls.backendCustomUrl) {
    settingsControls.backendCustomUrl.addEventListener("input", function () {
      backendDraftCustomUrl = settingsControls.backendCustomUrl.value;
    });
  }

  if (settingsControls.backendApply) {
    settingsControls.backendApply.addEventListener("click", async function () {
      await applyBackendSelection();
    });
  }

  if (settingsControls.sessionsRefresh) {
    settingsControls.sessionsRefresh.addEventListener("click", async function () {
      await loadSessions();
    });
  }

  settingsControls.screenshotGuard.addEventListener(
    "change",
    async function () {
      await applyScreenshotGuardSetting(
        settingsControls.screenshotGuard.checked,
        false,
      );
    },
  );

  settingsControls.startupEnabled.addEventListener("change", async function () {
    await applyStartupSetting(settingsControls.startupEnabled.checked, false);
  });

  settingsControls.lightThemeEnabled.addEventListener("change", async function () {
    appSettings.lightThemeEnabled = settingsControls.lightThemeEnabled.checked;
    saveSettings();
    applyTheme();
    renderSettings();
    notify(
      appSettings.lightThemeEnabled
        ? t("notify.lightThemeOn")
        : t("notify.lightThemeOff"),
    );

    await syncPreference(
      "set_theme_preference",
      {
        lightThemeEnabled: appSettings.lightThemeEnabled,
      },
      "theme",
    );
  });

  settingsControls.autoLockEnabled.addEventListener("change", function () {
    appSettings.autoLockEnabled = settingsControls.autoLockEnabled.checked;
    saveSettings();
    renderSettings();
    scheduleAutoLock();
    notify(
      appSettings.autoLockEnabled
        ? t("notify.autoLockOn")
        : t("notify.autoLockOff"),
    );
  });

  settingsControls.autoLockMinutes.addEventListener("change", function () {
    var minutes = Number(settingsControls.autoLockMinutes.value);
    if (isNaN(minutes) || minutes < 1) {
      minutes = DEFAULT_SETTINGS.autoLockMinutes;
    }
    appSettings.autoLockMinutes = minutes;
    saveSettings();
    renderSettings();
    scheduleAutoLock();
    notify(
      t("notify.autoLockTimer", {
        minutes: getMinuteLabel(minutes),
      }),
    );
  });

  if (settingsControls.clipboardTimeout) {
    settingsControls.clipboardTimeout.addEventListener("change", function () {
      var seconds = Number(settingsControls.clipboardTimeout.value);
      if (isNaN(seconds) || seconds < 5) {
        seconds = DEFAULT_SETTINGS.clipboardTimeoutSeconds;
      }
      appSettings.clipboardTimeoutSeconds = seconds;
      saveSettings();
      renderSettings();
      notify(getClipboardTimeoutChangedMessage());
    });
  }

  settingsControls.confirmDelete.addEventListener("change", function () {
    appSettings.confirmDelete = settingsControls.confirmDelete.checked;
    saveSettings();
    notify(
      appSettings.confirmDelete
        ? t("notify.confirmDeleteOn")
        : t("notify.confirmDeleteOff"),
    );
  });

  settingsControls.blockContextMenu.addEventListener("change", function () {
    appSettings.blockContextMenu = settingsControls.blockContextMenu.checked;
    saveSettings();
    notify(
      appSettings.blockContextMenu
        ? t("notify.blockContextOn")
        : t("notify.blockContextOff"),
    );
  });

  if (settingsControls.language) {
    settingsControls.language.addEventListener("change", async function () {
      appSettings.language =
        settingsControls.language.value === "en" ? "en" : "ru";
      saveSettings();
      applyTranslations();
      renderSettings();
      notify(t("notify.languageChanged"));
      if (authenticated) {
        loadPasswords();
      }

      await syncPreference(
        "set_language_preference",
        {
          language: appSettings.language,
        },
        "language",
      );
    });
  }

  if (settingsControls.uiScale) {
    settingsControls.uiScale.addEventListener("change", function () {
      appSettings.uiScale = normalizeUiScale(settingsControls.uiScale.value);
      saveSettings();
      applyUiScale();
      renderSettings();
      notify(
        t("notify.dpiChanged", {
          value: Math.round(appSettings.uiScale * 100) + "%",
        }),
      );
    });
  }

  if (settingsControls.encryptionAlgorithm) {
    settingsControls.encryptionAlgorithm.addEventListener(
      "change",
      async function () {
        appSettings.encryptionAlgorithm = normalizeEncryptionAlgorithm(
          settingsControls.encryptionAlgorithm.value,
        );
        saveSettings();
        renderSettings();
        notify(t("notify.encryptionChanged"));

        await syncPreference(
          "set_encryption_preference",
          {
            encryptionAlgorithm: appSettings.encryptionAlgorithm,
          },
          "encryption",
        );
      },
    );
  }

  document
    .getElementById("login-btn")
    .addEventListener("click", async function () {
      var u = document.getElementById("login-user").value.trim();
      var p = document.getElementById("login-pass").value;

      if (!u || !p) {
        notify(t("error.fillAllFields"), "err");
        return;
      }

      setLoad("login-btn", true);

      try {
        var profile = await invoke("login", { username: u, password: p });
        applySessionPreferences(profile);
        setCurrentUser(profile);
        setAuthenticated(true);
        await syncScreenshotGuardOnStart();
        await syncStartupOnStart();
        notify(t("notify.welcome"));
        document.getElementById("login-form").reset();
        showPage("dashboard");
        await loadPasswords();
      } catch (err) {
        notify(localizeMessage(err, "error.login"), "err");
      }

      p = "";
      document.getElementById("login-pass").value = "";
      setLoad("login-btn", false);
    });

  document
    .getElementById("login-pass")
    .addEventListener("keydown", function (e) {
      if (e.key === "Enter") {
        e.preventDefault();
        document.getElementById("login-btn").click();
      }
    });

  document
    .getElementById("reg-btn")
    .addEventListener("click", async function () {
      var u = document.getElementById("reg-user").value.trim();
      var p = document.getElementById("reg-pass").value;
      var p2 = document.getElementById("reg-pass2").value;
      var s = document.getElementById("reg-seed").value;

      if (!u || !p || !p2 || !s) {
        notify(t("error.fillAllFields"), "err");
        return;
      }
      if (u.length < 3) {
        notify(t("error.loginMin"), "err");
        return;
      }
      if (p.length < 8) {
        notify(t("error.passwordMin"), "err");
        return;
      }
      if (p !== p2) {
        notify(t("error.passwordsMismatch"), "err");
        return;
      }
      if (s.trim().split(/\s+/).filter(Boolean).length < 1) {
        notify(t("error.seedMin"), "err");
        return;
      }

      var regWeakSecrets = getWeakSecrets(p, s);
      if (regWeakSecrets.length > 0) {
        var regConfirmed = await confirmWeakSecrets(regWeakSecrets);
        if (!regConfirmed) {
          return;
        }
      }

      setLoad("reg-btn", true);

      try {
        var preparedEnvelope = await invoke("prepare_local_master_key_envelope", {
          seedPhrase: s,
          encryptionAlgorithm: appSettings.encryptionAlgorithm,
        });
        var msg = await invoke("register", {
          username: u,
          password: p,
          seedPhrase: s,
          encryptionAlgorithm: appSettings.encryptionAlgorithm,
        });
        saveMasterKeyEnvelope(u, preparedEnvelope);
        notify(localizeMessage(msg, "notify.accountCreated"));
        document.getElementById("register-form").reset();
        document.getElementById("str-bar").className = "str-fill";
        showPage("login");
      } catch (err) {
        notify(localizeMessage(err, "error.register"), "err");
      }

      p = "";
      p2 = "";
      s = "";
      document.getElementById("reg-pass").value = "";
      document.getElementById("reg-pass2").value = "";
      document.getElementById("reg-seed").value = "";
      setLoad("reg-btn", false);
    });

  document
    .getElementById("go-register")
    .addEventListener("click", function (e) {
      e.preventDefault();
      e.stopPropagation();
      showPage("register");
    });

  document.getElementById("go-login").addEventListener("click", function (e) {
    e.preventDefault();
    e.stopPropagation();
    showPage("login");
  });

  document.getElementById("add-btn").addEventListener("click", function () {
    showPage("add");
  });

  document
    .getElementById("settings-btn")
    .addEventListener("click", function () {
      openSettingsPage("dashboard");
    });

  document.getElementById("admin-btn").addEventListener("click", async function () {
    await openAdminPage();
  });

  document
    .getElementById("settings-back-btn")
    .addEventListener("click", function () {
      showPage(getSettingsReturnPage());
    });

  document
    .getElementById("admin-back-btn")
    .addEventListener("click", function () {
      showPage("dashboard");
    });

  document
    .getElementById("admin-refresh-btn")
    .addEventListener("click", async function () {
      await loadAdminStats();
    });

  document
    .getElementById("login-settings-btn")
    .addEventListener("click", function () {
      openSettingsPage("login");
    });

  document
    .getElementById("register-settings-btn")
    .addEventListener("click", function () {
      openSettingsPage("register");
    });

  document.getElementById("back-btn").addEventListener("click", function () {
    document.getElementById("add-form").reset();
    showPage("dashboard");
  });

  document
    .getElementById("logout-btn")
    .addEventListener("click", async function () {
      await performLogout(t("notify.loggedOut"));
    });

  document
    .getElementById("save-btn")
    .addEventListener("click", async function () {
      var title = document.getElementById("add-title").value.trim();
      var login = document.getElementById("add-login").value.trim();
      var p = document.getElementById("add-pass").value;
      var s = document.getElementById("add-seed").value;

      if (!title || !login || !p || !s) {
        notify(t("error.fillAllFields"), "err");
        return;
      }

      var addWeakSecrets = getWeakSecrets(p, s);
      if (addWeakSecrets.length > 0) {
        var addConfirmed = await confirmWeakSecrets(addWeakSecrets);
        if (!addConfirmed) {
          return;
        }
      }

      setLoad("save-btn", true);

      try {
        var localEnvelope =
          currentUser && currentUser.username
            ? getStoredMasterKeyEnvelope(currentUser.username)
            : null;
        var savedEntry = await invoke("add_password", {
          title: title,
          login: login,
          password: p,
          seedPhrase: s,
          encryptionAlgorithm: appSettings.encryptionAlgorithm,
          localWrappedMasterKey: localEnvelope
            ? localEnvelope.wrapped_master_key
            : null,
          localWrappingSalt: localEnvelope ? localEnvelope.wrapping_salt : null,
          localWrappingAlgorithm: localEnvelope
            ? localEnvelope.encryption_algorithm
            : null,
        });
        if (currentUser && currentUser.username) {
          saveMasterKeyEnvelope(currentUser.username, {
            wrapped_master_key: savedEntry.wrapped_master_key,
            wrapping_salt: savedEntry.salt,
            encryption_algorithm: savedEntry.encryption_algorithm,
          });
        }
        notify(t("notify.passwordSaved"));
        document.getElementById("add-form").reset();
        showPage("dashboard");
        await loadPasswords();
      } catch (err) {
        if (!(await handleAuthFailure(err))) {
          notify(localizeMessage(err, "error.save"), "err");
        }
      }

      p = "";
      s = "";
      document.getElementById("add-pass").value = "";
      document.getElementById("add-seed").value = "";
      setLoad("save-btn", false);
    });

  document.getElementById("weak-yes").addEventListener("click", function () {
    resolveWeakConfirmation(true);
  });

  document.getElementById("weak-no").addEventListener("click", function () {
    resolveWeakConfirmation(false);
  });

  document
    .getElementById("modal-yes")
    .addEventListener("click", async function () {
      var seed = document.getElementById("modal-seed").value.trim();
      if (!seed) {
        notify(t("error.enterSeed"), "err");
        return;
      }
      if (!currentId) {
        hideModal("seed");
        return;
      }

      setLoad("modal-yes", true);

      try {
        var decryptedEntry = await invoke("decrypt_password_entry", {
          entryId: currentId,
          seedPhrase: seed,
        });
        showDecryptedEntry(decryptedEntry);
      } catch (err) {
        if (await handleAuthFailure(err)) {
          setLoad("modal-yes", false);
          currentId = null;
          return;
        }
        notify(localizeMessage(err, "error.invalidSeed"), "err");
      }

      seed = "";
      document.getElementById("modal-seed").value = "";
      setLoad("modal-yes", false);
    });

  document.getElementById("copy-login").addEventListener("click", async function () {
    try {
      await copyVisibleSecret("login");
    } catch (err) {
      if (!(await handleAuthFailure(err))) {
        notify(localizeMessage(err, "error.copy"), "err");
      }
    }
  });

  document
    .getElementById("copy-password")
    .addEventListener("click", async function () {
      try {
        await copyVisibleSecret("password");
      } catch (err) {
        if (!(await handleAuthFailure(err))) {
          notify(localizeMessage(err, "error.copy"), "err");
        }
      }
    });

  document.getElementById("modal-no").addEventListener("click", function () {
    hideModal("seed");
    currentId = null;
  });

  document
    .getElementById("modal-seed")
    .addEventListener("keydown", function (e) {
      if (e.key === "Enter") {
        e.preventDefault();
        document.getElementById("modal-yes").click();
      }
    });

  document
    .getElementById("del-yes")
    .addEventListener("click", async function () {
      if (!deleteId) {
        hideModal("del");
        return;
      }
      await deleteEntry(deleteId);
    });

  document.getElementById("del-no").addEventListener("click", function () {
    hideModal("del");
    deleteId = null;
  });

  document.querySelectorAll(".modal-bg").forEach(function (bg) {
    bg.addEventListener("click", function () {
      resolveWeakConfirmation(false);
      hideModal("seed");
      hideModal("del");
      currentId = null;
      deleteId = null;
    });
  });

  document.addEventListener("contextmenu", function (e) {
    if (appSettings.blockContextMenu) {
      e.preventDefault();
    }
  });

  document.addEventListener("keydown", function (e) {
    if (e.key === "F12") e.preventDefault();
    if (e.ctrlKey && e.shiftKey && (e.key === "I" || e.key === "J"))
      e.preventDefault();
    if (e.ctrlKey && e.key === "u") e.preventDefault();

    if (e.key === "PrintScreen" && appSettings.screenshotGuardEnabled) {
      notify(t("notify.screenshotsBlocked"), "err");
    }

    if (e.key === "Escape") {
      resolveWeakConfirmation(false);
      hideModal("seed");
      hideModal("del");
      currentId = null;
      deleteId = null;
    }
  });

  document.addEventListener("mousemove", onUserActivity);
  document.addEventListener("mousedown", onUserActivity);
  document.addEventListener("touchstart", onUserActivity);
  document.addEventListener("keydown", onUserActivity);

  async function init() {
    try {
      var initialBackendEndpoint = validateBackendEndpoint(
        await invoke("get_backend_endpoint"),
      );
      DEFAULT_BACKEND_ENDPOINT = initialBackendEndpoint;
      currentBackendEndpoint = initialBackendEndpoint;
    } catch (e) {
      currentBackendEndpoint = DEFAULT_BACKEND_ENDPOINT;
    }

    renderSettings();
    await syncBackendOnStart();

    var ok = false;
    try {
      ok = !!(await invoke("is_authenticated"));
    } catch (e) {
      ok = false;
    }

    if (ok) {
      try {
        var sessionUser = await invoke("get_session_user");
        applySessionPreferences(sessionUser);
        setCurrentUser(sessionUser);
      } catch (e) {
        setCurrentUser(null);
      }
      setAuthenticated(true);
      await syncScreenshotGuardOnStart();
      await syncStartupOnStart();
      showPage("dashboard", { instant: true });
      await loadPasswords();
      return;
    }

    setAuthenticated(false);
    setCurrentUser(null);
    showPage("login", { instant: true });
  }

  init();
}
