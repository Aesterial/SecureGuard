document.addEventListener("DOMContentLoaded", function () {
  bootstrapApp(40);
});

var SETTINGS_KEY = "secureguard.settings.v1";
var DEFAULT_SETTINGS = {
  screenshotGuardEnabled: true,
  startupEnabled: false,
  autoLockEnabled: false,
  autoLockMinutes: 5,
  confirmDelete: true,
  blockContextMenu: true,
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
        throw "Логин минимум 3 символа";
      }
      if (!regPass || regPass.length < 8) {
        throw "Пароль минимум 8 символов";
      }
      if (regSeed.split(/\s+/).filter(Boolean).length < 3) {
        throw "Сид-фраза минимум 3 слова";
      }
      if (users[regUser]) {
        throw "Пользователь уже существует";
      }
      users[regUser] = { password: regPass };
      return "Аккаунт создан! Войдите.";
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
        throw "Не авторизован";
      }
      return startupEnabled;
    }

    if (command === "set_screenshot_guard_enabled") {
      if (!authenticated) {
        throw "Не авторизован";
      }
      screenshotGuardEnabled = !!args.enabled;
      return screenshotGuardEnabled;
    }

    if (command === "set_startup_enabled") {
      if (!authenticated) {
        throw "Не авторизован";
      }
      startupEnabled = !!args.enabled;
      return startupEnabled;
    }

    if (!authenticated) {
      throw "Не авторизован";
    }

    if (command === "get_passwords") {
      return entries.map(function (entry) {
        return {
          id: entry.id,
          title: entry.title,
          encrypted_password: entry.encrypted_password,
          salt: entry.salt,
          created_at: entry.created_at,
        };
      });
    }

    if (command === "add_password") {
      var title = (args.title || "").trim();
      var password = args.password || "";
      var seed = (args.seedPhrase || "").trim();
      if (!title || !password || !seed) {
        throw "Заполните все поля";
      }
      var entry = {
        id: String(nextId++),
        title: title,
        encrypted_password: password,
        salt: "local",
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
    startupEnabled: document.getElementById("setting-startup-enabled"),
    autoLockEnabled: document.getElementById("setting-auto-lock-enabled"),
    autoLockMinutes: document.getElementById("setting-auto-lock-minutes"),
    confirmDelete: document.getElementById("setting-confirm-delete"),
    blockContextMenu: document.getElementById("setting-block-context-menu"),
  };

  var modals = {
    seed: document.getElementById("seed-modal"),
    del: document.getElementById("del-modal"),
  };

  var currentPage = "login";
  var isAnimating = false;

  function showPage(name) {
    if (isAnimating || name === currentPage) return;
    if (!pages[name]) return;

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

  function normalizeSettings(source) {
    var out = {
      screenshotGuardEnabled: DEFAULT_SETTINGS.screenshotGuardEnabled,
      startupEnabled: DEFAULT_SETTINGS.startupEnabled,
      autoLockEnabled: DEFAULT_SETTINGS.autoLockEnabled,
      autoLockMinutes: DEFAULT_SETTINGS.autoLockMinutes,
      confirmDelete: DEFAULT_SETTINGS.confirmDelete,
      blockContextMenu: DEFAULT_SETTINGS.blockContextMenu,
    };

    if (!source || typeof source !== "object") {
      return out;
    }

    out.screenshotGuardEnabled = !!source.screenshotGuardEnabled;
    out.startupEnabled = !!source.startupEnabled;
    out.autoLockEnabled = !!source.autoLockEnabled;
    out.confirmDelete = source.confirmDelete !== false;
    out.blockContextMenu = source.blockContextMenu !== false;

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
    settingsControls.screenshotGuard.checked =
      !!appSettings.screenshotGuardEnabled;
    settingsControls.startupEnabled.checked = !!appSettings.startupEnabled;
    settingsControls.autoLockEnabled.checked = !!appSettings.autoLockEnabled;
    settingsControls.autoLockMinutes.value = String(
      appSettings.autoLockMinutes,
    );
    settingsControls.confirmDelete.checked = !!appSettings.confirmDelete;
    settingsControls.blockContextMenu.checked = !!appSettings.blockContextMenu;
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

    try {
      await invoke("logout");
    } catch (e) {}

    hideModal("seed");
    hideModal("del");
    currentId = null;
    deleteId = null;
    showPage("login");

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
        performLogout("Сессия закрыта из-за бездействия", "err");
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
            ? "Screenshot Guard включён"
            : "Screenshot Guard выключен",
        );
      }
    } catch (err) {
      renderSettings();
      notify(String(err) || "Не удалось изменить Screenshot Guard", "err");
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
            ? "Автозапуск с Windows включён"
            : "Автозапуск с Windows выключен",
        );
      }
    } catch (err) {
      renderSettings();
      notify(String(err) || "Не удалось изменить автозапуск", "err");
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
      notify(String(err) || "Не удалось получить статус автозапуска", "err");
    }
  }

  async function deleteEntry(entryId) {
    if (!entryId) return;

    try {
      await invoke("delete_password", { entryId: entryId });
      notify("Удалено");
      hideModal("del");
      await loadPasswords();
    } catch (err) {
      notify(String(err) || "Ошибка удаления", "err");
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
          "<p>Паролей пока нет</p>" +
          "<span>Добавьте первую запись</span>" +
          "</div>";
        return;
      }
      for (var i = 0; i < entries.length; i++) {
        list.appendChild(makeCard(entries[i], i));
      }
    } catch (err) {
      notify(String(err) || "Ошибка загрузки", "err");
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
      (entry.created_at || "Только что") +
      "</div>" +
      "</div>" +
      '<button class="card-del" title="Удалить">' +
      '<svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>' +
      "</button>";

    card.addEventListener("click", function (e) {
      if (e.target.closest(".card-del")) return;
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

  settingsControls.autoLockEnabled.addEventListener("change", function () {
    appSettings.autoLockEnabled = settingsControls.autoLockEnabled.checked;
    saveSettings();
    renderSettings();
    scheduleAutoLock();
    notify(
      appSettings.autoLockEnabled
        ? "Авто-локаут включён"
        : "Авто-локаут выключен",
    );
  });

  settingsControls.autoLockMinutes.addEventListener("change", function () {
    var minutes = Number(settingsControls.autoLockMinutes.value);
    if (isNaN(minutes) || minutes < 1) {
      minutes = DEFAULT_SETTINGS.autoLockMinutes;
    }
    appSettings.autoLockMinutes = minutes;
    saveSettings();
    scheduleAutoLock();
    notify("Таймер авто-локаута: " + minutes + " мин.");
  });

  settingsControls.confirmDelete.addEventListener("change", function () {
    appSettings.confirmDelete = settingsControls.confirmDelete.checked;
    saveSettings();
    notify(
      appSettings.confirmDelete
        ? "Подтверждение удаления включено"
        : "Подтверждение удаления выключено",
    );
  });

  settingsControls.blockContextMenu.addEventListener("change", function () {
    appSettings.blockContextMenu = settingsControls.blockContextMenu.checked;
    saveSettings();
    notify(
      appSettings.blockContextMenu
        ? "Блокировка контекстного меню включена"
        : "Блокировка контекстного меню выключена",
    );
  });

  document
    .getElementById("login-btn")
    .addEventListener("click", async function () {
      var u = document.getElementById("login-user").value.trim();
      var p = document.getElementById("login-pass").value;

      if (!u || !p) {
        notify("Заполните все поля", "err");
        return;
      }

      setLoad("login-btn", true);

      try {
        await invoke("login", { username: u, password: p });
        setAuthenticated(true);
        await syncScreenshotGuardOnStart();
        await syncStartupOnStart();
        notify("Добро пожаловать!");
        document.getElementById("login-form").reset();
        showPage("dashboard");
        await loadPasswords();
      } catch (err) {
        notify(String(err) || "Ошибка входа", "err");
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
        notify("Заполните все поля", "err");
        return;
      }
      if (u.length < 3) {
        notify("Логин: минимум 3 символа", "err");
        return;
      }
      if (p.length < 8) {
        notify("Пароль: минимум 8 символов", "err");
        return;
      }
      if (p !== p2) {
        notify("Пароли не совпадают", "err");
        return;
      }
      if (s.trim().split(/\s+/).length < 3) {
        notify("Сид-фраза: минимум 3 слова", "err");
        return;
      }

      setLoad("reg-btn", true);

      try {
        var msg = await invoke("register", {
          username: u,
          password: p,
          seedPhrase: s,
        });
        notify(msg || "Аккаунт создан!");
        document.getElementById("register-form").reset();
        document.getElementById("str-bar").className = "str-fill";
        showPage("login");
      } catch (err) {
        notify(String(err) || "Ошибка регистрации", "err");
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
      await performLogout("Вы вышли");
    });

  document
    .getElementById("save-btn")
    .addEventListener("click", async function () {
      var t = document.getElementById("add-title").value.trim();
      var p = document.getElementById("add-pass").value;
      var s = document.getElementById("add-seed").value;

      if (!t || !p || !s) {
        notify("Заполните все поля", "err");
        return;
      }

      setLoad("save-btn", true);

      try {
        await invoke("add_password", { title: t, password: p, seedPhrase: s });
        notify("Пароль сохранён!");
        document.getElementById("add-form").reset();
        showPage("dashboard");
        await loadPasswords();
      } catch (err) {
        notify(String(err) || "Ошибка сохранения", "err");
      }

      setLoad("save-btn", false);
    });

  document
    .getElementById("modal-yes")
    .addEventListener("click", async function () {
      var seed = document.getElementById("modal-seed").value;
      if (!seed) {
        notify("Введите сид-фразу", "err");
        return;
      }
      if (!currentId) {
        hideModal("seed");
        return;
      }

      setLoad("modal-yes", true);

      try {
        await invoke("copy_password", { entryId: currentId, seedPhrase: seed });
        hideModal("seed");
        notify("Пароль скопирован! Очистка через 30с");
      } catch (err) {
        notify(String(err) || "Неверная сид-фраза", "err");
      }

      setLoad("modal-yes", false);
      currentId = null;
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
      e.preventDefault();
      notify("Скриншоты заблокированы", "err");
    }

    if (e.key === "Escape") {
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

    try {
      var ok = await invoke("is_authenticated");
      if (ok) {
        setAuthenticated(true);
        await syncScreenshotGuardOnStart();
        await syncStartupOnStart();
        currentPage = "login";
        showPage("dashboard");
        await loadPasswords();
      }
    } catch (e) {}
  }

  init();
}
