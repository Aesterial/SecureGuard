document.addEventListener("DOMContentLoaded", function () {
  bootstrapApp(40);
});

var I18N = {
  ru: {
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
      "Сид-фраза — это резервный ключ для восстановления доступа. Если вы забудете пароль, используйте сид-фразу.",
    "register.warn": "Сохраните сид-фразу. Потеря приведёт к потере доступа.",
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
    "add.namePlaceholder": "Gmail, GitHub, VK...",
    "add.passwordPlaceholder": "Пароль для аккаунта",
    "add.seedPlaceholder": "Или сид-фраза для аккаунта",
    "add.save": "Сохранить и закрыть",

    "settings.title": "Настройки",
    "settings.language.title": "Язык",
    "settings.language.desc": "Выберите язык интерфейса приложения.",
    "settings.language.ru": "Русский",
    "settings.language.en": "English",
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
    "seedModal.desc": "Она необходима для отображения записи",
    "seedModal.placeholder": "Введите сид-фразу",
    "seedModal.copy": "Скопировать",

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
  },
  en: {
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
      "Seed phrase is a secret phrase used to encrypt passwords. If you lose it, data recovery is impossible.",
    "register.warn": "Write this phrase down. Recovery is impossible.",
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
    "add.namePlaceholder": "Gmail, GitHub, VK...",
    "add.passwordPlaceholder": "Password to store",
    "add.seedPlaceholder": "Your seed phrase for encryption",
    "add.save": "Encrypt and save",
    "settings.title": "Settings",
    "settings.language.title": "Language",
    "settings.language.desc": "Choose the application interface language.",
    "settings.language.ru": "Russian",
    "settings.language.en": "English",
    "settings.encryption.title": "Encryption algorithm",
    "settings.encryption.desc":
      "Choose how passwords are encrypted using the seed phrase.",
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
    "seedModal.desc": "Required to reveal this entry",
    "seedModal.placeholder": "Your seed phrase",
    "seedModal.copy": "Copy",
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
};

var SETTINGS_KEY = "secureguard.settings.v1";
var ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID = "aes256gcm-argon2id";
var ENCRYPTION_ALGORITHM_AES256_GCM_SHA256 = "aes256gcm-sha256";

var DEFAULT_SETTINGS = {
  screenshotGuardEnabled: true,
  lightThemeEnabled: false,
  startupEnabled: false,
  autoLockEnabled: false,
  autoLockMinutes: 5,
  confirmDelete: true,
  blockContextMenu: true,
  language: "ru",
  encryptionAlgorithm: ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID,
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
  var nextId = 1;
  var entries = [];
  var screenshotGuardEnabled = true;
  var startupEnabled = false;
  var users = {
    test: { password: "test" },
  };

  return async function (command, args) {
    args = args || {};

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
      return "OK";
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
      users[regUser] = { password: regPass };
      return "Аккаунт создан! Теперь войдите.";
    }

    if (command === "logout") {
      authenticated = false;
      entries = [];
      return;
    }

    if (command === "is_authenticated") {
      return authenticated;
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

    if (!authenticated) {
      throw "Вы не авторизованы";
    }

    if (command === "get_passwords") {
      return entries.map(function (entry) {
        return {
          id: entry.id,
          title: entry.title,
          encrypted_password: entry.encrypted_password,
          salt: entry.salt,
          encryption_algorithm:
            entry.encryption_algorithm ||
            ENCRYPTION_ALGORITHM_AES256_GCM_ARGON2ID,
          created_at: entry.created_at,
        };
      });
    }

    if (command === "add_password") {
      var title = (args.title || "").trim();
      var password = args.password || "";
      var seed = (args.seedPhrase || "").trim();
      var encryptionAlgorithm = normalizeEncryptionAlgorithm(
        args.encryptionAlgorithm,
      );
      if (!title || !password || !seed) {
        throw "Заполните все поля";
      }
      var entry = {
        id: String(nextId++),
        title: title,
        encrypted_password: password,
        salt: "local",
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
  var settingsSyncInProgress = false;
  var startupSyncInProgress = false;
  var weakConfirmResolver = null;
  var cachedSeedPhrase = "";
  var authHandlingInProgress = false;

  var loaded = loadSettings();
  var appSettings = loaded.settings;
  var hasStoredSettings = loaded.hasStored;

  var pages = {
    login: document.getElementById("page-login"),
    register: document.getElementById("page-register"),
    dashboard: document.getElementById("page-dashboard"),
    add: document.getElementById("page-add"),
    settings: document.getElementById("page-settings"),
  };

  var settingsControls = {
    screenshotGuard: document.getElementById("setting-screenshot-guard"),
    lightThemeEnabled: document.getElementById("setting-light-theme"),
    startupEnabled: document.getElementById("setting-startup-enabled"),
    autoLockEnabled: document.getElementById("setting-auto-lock-enabled"),
    autoLockMinutes: document.getElementById("setting-auto-lock-minutes"),
    confirmDelete: document.getElementById("setting-confirm-delete"),
    blockContextMenu: document.getElementById("setting-block-context-menu"),
    language: document.getElementById("setting-language"),
    encryptionAlgorithm: document.getElementById(
      "setting-encryption-algorithm",
    ),
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

  function localizeMessage(raw, fallbackKey) {
    if (raw === undefined || raw === null || raw === "") {
      return fallbackKey ? t(fallbackKey) : "";
    }

    var text = String(raw);
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

    return text;
  }

  function isAuthErrorMessage(raw) {
    if (raw === undefined || raw === null) {
      return false;
    }

    var text = String(raw).toLowerCase();
    return (
      text.indexOf("не авториз") !== -1 ||
      text.indexOf("not authenticated") !== -1 ||
      text.indexOf("unauthenticated") !== -1
    );
  }

  async function handleAuthFailure(err) {
    if (!authenticated || authHandlingInProgress || !isAuthErrorMessage(err)) {
      return false;
    }

    authHandlingInProgress = true;
    try {
      await performLogout(t("error.notAuthenticated"), "err");
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

  function applyTranslations() {
    document.documentElement.lang = getLanguage();

    setText("#page-login .brand p", "login.brandSubtitle");
    setText("#page-login h2", "login.title");
    setText("#page-login .field:nth-of-type(1) label", "common.username");
    setText("#page-login .field:nth-of-type(2) label", "common.password");
    setText("#login-btn .btn-t", "login.submit");
    setText("#page-login .link-row span", "login.noAccount");
    setText("#go-register", "login.create");

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

    setText("#page-dashboard .dash-brand h1", "dashboard.title");
    setText("#settings-btn span", "common.settings");
    setText("#logout-btn span", "common.logout");
    setTitle("#settings-btn", "common.settings");
    setTitle("#logout-btn", "common.logout");
    setText("#empty-state p", "dashboard.emptyTitle");
    setText("#empty-state span", "dashboard.emptySubtitle");
    setText("#add-btn span", "dashboard.addPassword");

    setText("#page-add .dash-brand h1", "add.title");
    setText("#page-add .field:nth-of-type(1) label", "add.name");
    setText("#page-add .field:nth-of-type(2) label", "common.password");
    setText("#page-add .field:nth-of-type(3) label", "common.seedPhrase");
    setText("#save-btn .btn-t", "add.save");

    setText("#page-settings .dash-brand h1", "settings.title");
    setText("#setting-language-title", "settings.language.title");
    setText("#setting-language-desc", "settings.language.desc");
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
    setText("#setting-confirm-delete-title", "settings.confirmDelete.title");
    setText("#setting-confirm-delete-desc", "settings.confirmDelete.desc");
    setText("#setting-block-context-title", "settings.blockContext.title");
    setText("#setting-block-context-desc", "settings.blockContext.desc");

    if (
      settingsControls.language &&
      settingsControls.language.options.length >= 2
    ) {
      settingsControls.language.options[0].text = t("settings.language.ru");
      settingsControls.language.options[1].text = t("settings.language.en");
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
    setText("#modal-yes .btn-t", "seedModal.copy");
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
    setPlaceholder("add-pass", "add.passwordPlaceholder");
    setPlaceholder("add-seed", "add.seedPlaceholder");
    setPlaceholder("modal-seed", "seedModal.placeholder");

    renderAutoLockMinuteOptions();
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
          pages[key].classList.remove("active");
          pages[key].style.opacity = "";
          pages[key].style.transform = "";
          pages[key].style.transition = "";
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
      oldPage.style.transition = "opacity 0.25s ease, transform 0.25s ease";
      oldPage.style.opacity = "0";
      oldPage.style.transform = "translateX(-20px)";
    }

    setTimeout(function () {
      if (oldPage) {
        oldPage.classList.remove("active");
        oldPage.style.opacity = "";
        oldPage.style.transform = "";
        oldPage.style.transition = "";
      }
      newPage.style.opacity = "0";
      newPage.style.transform = "translateX(20px)";
      newPage.classList.add("active");
      void newPage.offsetWidth;
      newPage.style.transition = "opacity 0.3s ease, transform 0.3s ease";
      newPage.style.opacity = "1";
      newPage.style.transform = "translateX(0)";

      currentPage = name;

      setTimeout(function () {
        newPage.style.transition = "";
        isAnimating = false;
      }, 300);
    }, 250);
  }

  function showModal(name) {
    if (modals[name]) modals[name].classList.remove("hidden");
  }

  function hideModal(name) {
    if (modals[name]) modals[name].classList.add("hidden");
    if (name === "seed") document.getElementById("modal-seed").value = "";
    if (name === "weak") {
      document.getElementById("weak-list").innerHTML = "";
      document.getElementById("weak-text").textContent = t("weak.defaultText");
    }
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

  function normalizeSettings(source) {
    var out = {
      screenshotGuardEnabled: DEFAULT_SETTINGS.screenshotGuardEnabled,
      lightThemeEnabled: DEFAULT_SETTINGS.lightThemeEnabled,
      startupEnabled: DEFAULT_SETTINGS.startupEnabled,
      autoLockEnabled: DEFAULT_SETTINGS.autoLockEnabled,
      autoLockMinutes: DEFAULT_SETTINGS.autoLockMinutes,
      confirmDelete: DEFAULT_SETTINGS.confirmDelete,
      blockContextMenu: DEFAULT_SETTINGS.blockContextMenu,
      language: DEFAULT_SETTINGS.language,
      encryptionAlgorithm: DEFAULT_SETTINGS.encryptionAlgorithm,
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
    out.encryptionAlgorithm = normalizeEncryptionAlgorithm(
      source.encryptionAlgorithm,
    );

    var minutes = Number(source.autoLockMinutes);
    if (!isNaN(minutes) && minutes >= 1 && minutes <= 60) {
      out.autoLockMinutes = minutes;
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
    settingsControls.confirmDelete.checked = !!appSettings.confirmDelete;
    settingsControls.blockContextMenu.checked = !!appSettings.blockContextMenu;
    if (settingsControls.language) {
      settingsControls.language.value = getLanguage();
    }
    if (settingsControls.encryptionAlgorithm) {
      settingsControls.encryptionAlgorithm.value = normalizeEncryptionAlgorithm(
        appSettings.encryptionAlgorithm,
      );
    }
  }

  function applyTheme() {
    document.body.classList.toggle(
      "theme-light",
      !!appSettings.lightThemeEnabled,
    );
  }

  function clearAutoLockTimer() {
    if (autoLockTimer) {
      clearTimeout(autoLockTimer);
      autoLockTimer = null;
    }
  }

  async function performLogout(message, type) {
    clearAutoLockTimer();
    authenticated = false;
    cachedSeedPhrase = "";

    try {
      await invoke("logout");
    } catch (e) {}

    resolveWeakConfirmation(false);
    hideModal("seed");
    hideModal("del");
    currentId = null;
    deleteId = null;
    showPage("login", { instant: true });

    if (message) {
      notify(message, type || "ok");
    }
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
      cachedSeedPhrase = "";
      clearAutoLockTimer();
      return;
    }
    scheduleAutoLock();
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

    settingsControls.screenshotGuard.disabled = false;
    settingsSyncInProgress = false;
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

    settingsControls.startupEnabled.disabled = false;
    startupSyncInProgress = false;
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

  async function loadPasswords() {
    var list = document.getElementById("pw-list");
    try {
      var entries = await invoke("get_passwords");
      list.innerHTML = "";
      if (!entries || entries.length === 0) {
        list.innerHTML =
          '<div class="empty">' +
          '<svg viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.8-2.2-5-5-5S7 3.2 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.7 1.4-3.1 3.1-3.1s3.1 1.4 3.1 3.1v2z"/></svg>' +
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

    var initial = entry.title.charAt(0).toUpperCase();

    card.innerHTML =
      '<div class="card-ico">' +
      initial +
      "</div>" +
      '<div class="card-info">' +
      '<div class="card-name">' +
      esc(entry.title) +
      "</div>" +
      '<div class="card-date">' +
      (entry.created_at || t("common.justNow")) +
      "</div>" +
      "</div>" +
      '<button class="card-del" title="' +
      t("common.delete") +
      '">' +
      '<svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>' +
      "</button>";

    card.addEventListener("click", async function (e) {
      if (e.target.closest(".card-del")) return;

      if (cachedSeedPhrase) {
        try {
          await invoke("copy_password", {
            entryId: entry.id,
            seedPhrase: cachedSeedPhrase,
          });
          notify(t("notify.passwordCopied"));
          return;
        } catch (err) {
          if (await handleAuthFailure(err)) {
            return;
          }
          cachedSeedPhrase = "";
          notify(localizeMessage(err, "error.invalidSeed"), "err");
        }
      }

      currentId = entry.id;
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
  applyTheme();
  applyTranslations();

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

  settingsControls.lightThemeEnabled.addEventListener("change", function () {
    appSettings.lightThemeEnabled = settingsControls.lightThemeEnabled.checked;
    saveSettings();
    applyTheme();
    notify(
      appSettings.lightThemeEnabled
        ? t("notify.lightThemeOn")
        : t("notify.lightThemeOff"),
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
    settingsControls.language.addEventListener("change", function () {
      appSettings.language =
        settingsControls.language.value === "en" ? "en" : "ru";
      saveSettings();
      applyTranslations();
      renderSettings();
      notify(t("notify.languageChanged"));
      if (authenticated) {
        loadPasswords();
      }
    });
  }

  if (settingsControls.encryptionAlgorithm) {
    settingsControls.encryptionAlgorithm.addEventListener(
      "change",
      function () {
        appSettings.encryptionAlgorithm = normalizeEncryptionAlgorithm(
          settingsControls.encryptionAlgorithm.value,
        );
        saveSettings();
        renderSettings();
        notify(t("notify.encryptionChanged"));
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
        await invoke("login", { username: u, password: p });
        setAuthenticated(true);
        cachedSeedPhrase = "";
        await syncScreenshotGuardOnStart();
        await syncStartupOnStart();
        notify(t("notify.welcome"));
        document.getElementById("login-form").reset();
        showPage("dashboard");
        await loadPasswords();
      } catch (err) {
        notify(localizeMessage(err, "error.login"), "err");
      }

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
        var msg = await invoke("register", {
          username: u,
          password: p,
          seedPhrase: s,
        });
        notify(localizeMessage(msg, "notify.accountCreated"));
        document.getElementById("register-form").reset();
        document.getElementById("str-bar").className = "str-fill";
        showPage("login");
      } catch (err) {
        notify(localizeMessage(err, "error.register"), "err");
      }

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
      renderSettings();
      showPage("settings");
    });

  document
    .getElementById("settings-back-btn")
    .addEventListener("click", function () {
      showPage("dashboard");
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
      var p = document.getElementById("add-pass").value;
      var s = document.getElementById("add-seed").value;

      if (!title || !p || !s) {
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
        await invoke("add_password", {
          title: title,
          password: p,
          seedPhrase: s,
          encryptionAlgorithm: appSettings.encryptionAlgorithm,
        });
        notify(t("notify.passwordSaved"));
        document.getElementById("add-form").reset();
        showPage("dashboard");
        await loadPasswords();
      } catch (err) {
        if (!(await handleAuthFailure(err))) {
          notify(localizeMessage(err, "error.save"), "err");
        }
      }

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
        await invoke("copy_password", { entryId: currentId, seedPhrase: seed });
        cachedSeedPhrase = seed;
        hideModal("seed");
        notify(t("notify.passwordCopied"));
        currentId = null;
      } catch (err) {
        if (await handleAuthFailure(err)) {
          setLoad("modal-yes", false);
          currentId = null;
          return;
        }
        notify(localizeMessage(err, "error.invalidSeed"), "err");
      }

      setLoad("modal-yes", false);
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
    renderSettings();

    var ok = false;
    try {
      ok = !!(await invoke("is_authenticated"));
    } catch (e) {
      ok = false;
    }

    if (ok) {
      setAuthenticated(true);
      await syncScreenshotGuardOnStart();
      await syncStartupOnStart();
      showPage("dashboard", { instant: true });
      await loadPasswords();
      return;
    }

    setAuthenticated(false);
    showPage("login", { instant: true });
  }

  init();
}
