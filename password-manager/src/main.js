document.addEventListener('DOMContentLoaded', function () {
  bootstrapApp(40);
});

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
  if (tauri && tauri.tauri && typeof tauri.tauri.invoke === 'function') {
    return tauri.tauri.invoke;
  }
  if (tauri && tauri.core && typeof tauri.core.invoke === 'function') {
    return tauri.core.invoke;
  }
  return null;
}

function createFallbackInvoke() {
  var authenticated = false;
  var nextId = 1;
  var entries = [];
  var users = {
    test: { password: 'test' },
  };

  return async function (command, args) {
    args = args || {};

    if (command === 'login') {
      var loginUser = (args.username || '').trim();
      var loginPass = args.password || '';
      if (!loginUser || !loginPass) {
        throw 'Введите логин и пароль';
      }
      if (!users[loginUser] || users[loginUser].password !== loginPass) {
        throw 'Неверный логин или пароль';
      }
      authenticated = true;
      return 'OK';
    }

    if (command === 'register') {
      var regUser = (args.username || '').trim();
      var regPass = args.password || '';
      var regSeed = (args.seedPhrase || '').trim();
      if (!regUser || regUser.length < 3) {
        throw 'Логин минимум 3 символа';
      }
      if (!regPass || regPass.length < 8) {
        throw 'Пароль минимум 8 символов';
      }
      if (regSeed.split(/\s+/).filter(Boolean).length < 3) {
        throw 'Сид-фраза минимум 3 слова';
      }
      if (users[regUser]) {
        throw 'Пользователь уже существует';
      }
      users[regUser] = { password: regPass };
      return 'Аккаунт создан! Войдите.';
    }

    if (command === 'logout') {
      authenticated = false;
      entries = [];
      return;
    }

    if (command === 'is_authenticated') {
      return authenticated;
    }

    if (!authenticated) {
      throw 'Не авторизован';
    }

    if (command === 'get_passwords') {
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

    if (command === 'add_password') {
      var title = (args.title || '').trim();
      var password = args.password || '';
      var seed = (args.seedPhrase || '').trim();
      if (!title || !password || !seed) {
        throw 'Заполните все поля';
      }
      var entry = {
        id: String(nextId++),
        title: title,
        encrypted_password: password,
        salt: 'local',
        created_at: new Date().toISOString(),
        _plain: password,
      };
      entries.push(entry);
      return entry;
    }

    if (command === 'copy_password') {
      var copyId = String(args.entryId || '');
      var copyEntry = entries.find(function (item) {
        return item.id === copyId;
      });
      if (!copyEntry) {
        throw 'Запись не найдена';
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        try {
          await navigator.clipboard.writeText(copyEntry._plain || '');
        } catch (e) {}
      }
      return 'Скопировано';
    }

    if (command === 'delete_password') {
      var deleteId = String(args.entryId || '');
      entries = entries.filter(function (item) {
        return item.id !== deleteId;
      });
      return;
    }

    throw 'Команда недоступна: ' + command;
  };
}

function initApp(invoke) {
  let currentId = null;
  let deleteId = null;
  let notifTimer = null;
  const pages = {
    login: document.getElementById('page-login'),
    register: document.getElementById('page-register'),
    dashboard: document.getElementById('page-dashboard'),
    add: document.getElementById('page-add'),
  };

  const modals = {
    seed: document.getElementById('seed-modal'),
    del: document.getElementById('del-modal'),
  };
  let currentPage = 'login';
  let isAnimating = false;

  function showPage(name) {
    if (isAnimating || name === currentPage) return;
    if (!pages[name]) return;

    isAnimating = true;

    const oldPage = pages[currentPage];
    const newPage = pages[name];
    if (oldPage) {
      oldPage.style.transition = 'opacity 0.25s ease, transform 0.25s ease';
      oldPage.style.opacity = '0';
      oldPage.style.transform = 'translateX(-20px)';
    }

    setTimeout(function () {
      if (oldPage) {
        oldPage.classList.remove('active');
        oldPage.style.opacity = '';
        oldPage.style.transform = '';
        oldPage.style.transition = '';
      }
      newPage.style.opacity = '0';
      newPage.style.transform = 'translateX(20px)';
      newPage.classList.add('active');
      void newPage.offsetWidth;
      newPage.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
      newPage.style.opacity = '1';
      newPage.style.transform = 'translateX(0)';

      currentPage = name;

      setTimeout(function () {
        newPage.style.transition = '';
        isAnimating = false;
      }, 300);
    }, 250);
  }

  function showModal(name) {
    if (modals[name]) modals[name].classList.remove('hidden');
  }

  function hideModal(name) {
    if (modals[name]) modals[name].classList.add('hidden');
    if (name === 'seed') document.getElementById('modal-seed').value = '';
  }
  function notify(msg, type) {
    type = type || 'ok';
    var el = document.getElementById('notification');
    var txt = document.getElementById('notif-text');
    if (notifTimer) clearTimeout(notifTimer);

    el.classList.remove('hidden');
    txt.textContent = msg;
    el.className = 'notif ' + type;
    el.style.animation = 'nIn 0.3s cubic-bezier(0.16,1,0.3,1)';

    notifTimer = setTimeout(function () {
      el.style.animation = 'nOut 0.3s ease forwards';
      setTimeout(function () {
        el.classList.add('hidden');
      }, 300);
    }, 2500);
  }
  document.querySelectorAll('.eye').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      e.preventDefault();
      e.stopPropagation();
      var inp = document.getElementById(btn.getAttribute('data-target'));
      var show = btn.querySelector('.eye-show');
      var hide = btn.querySelector('.eye-hide');
      if (inp.type === 'password') {
        inp.type = 'text';
        show.classList.add('hidden');
        hide.classList.remove('hidden');
      } else {
        inp.type = 'password';
        show.classList.remove('hidden');
        hide.classList.add('hidden');
      }
    });
  });
  var regPass = document.getElementById('reg-pass');
  if (regPass) {
    regPass.addEventListener('input', function () {
      var p = regPass.value;
      var bar = document.getElementById('str-bar');
      var s = 0;
      if (p.length >= 6) s++;
      if (p.length >= 10) s++;
      if (/[A-Z]/.test(p) && /[a-z]/.test(p)) s++;
      if (/\d/.test(p)) s++;
      if (/[^A-Za-z0-9]/.test(p)) s++;
      bar.className = 'str-fill' + (s > 0 ? ' s' + s : '');
    });
  }
  function setLoad(id, on) {
    var btn = document.getElementById(id);
    if (!btn) return;
    var t = btn.querySelector('.btn-t');
    var s = btn.querySelector('.btn-spin');
    btn.disabled = on;
    if (t) {
      if (on) t.classList.add('hidden');
      else t.classList.remove('hidden');
    }
    if (s) {
      if (on) s.classList.remove('hidden');
      else s.classList.add('hidden');
    }
  }
  document.getElementById('login-btn').addEventListener('click', async function () {
    var u = document.getElementById('login-user').value.trim();
    var p = document.getElementById('login-pass').value;

    if (!u || !p) {
      notify('Заполните все поля', 'err');
      return;
    }

    setLoad('login-btn', true);

    try {
      await invoke('login', { username: u, password: p });
      notify('Добро пожаловать!');
      document.getElementById('login-form').reset();
      showPage('dashboard');
      await loadPasswords();
    } catch (err) {
      notify(String(err) || 'Ошибка входа', 'err');
    }

    setLoad('login-btn', false);
  });
  document.getElementById('login-pass').addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      document.getElementById('login-btn').click();
    }
  });
  document.getElementById('reg-btn').addEventListener('click', async function () {
    var u = document.getElementById('reg-user').value.trim();
    var p = document.getElementById('reg-pass').value;
    var p2 = document.getElementById('reg-pass2').value;
    var s = document.getElementById('reg-seed').value;

    if (!u || !p || !p2 || !s) {
      notify('Заполните все поля', 'err');
      return;
    }
    if (u.length < 3) {
      notify('Логин: минимум 3 символа', 'err');
      return;
    }
    if (p.length < 8) {
      notify('Пароль: минимум 8 символов', 'err');
      return;
    }
    if (p !== p2) {
      notify('Пароли не совпадают', 'err');
      return;
    }
    if (s.trim().split(/\s+/).length < 3) {
      notify('Сид-фраза: минимум 3 слова', 'err');
      return;
    }

    setLoad('reg-btn', true);

    try {
      var msg = await invoke('register', { username: u, password: p, seedPhrase: s });
      notify(msg || 'Аккаунт создан!');
      document.getElementById('register-form').reset();
      document.getElementById('str-bar').className = 'str-fill';
      showPage('login');
    } catch (err) {
      notify(String(err) || 'Ошибка регистрации', 'err');
    }

    setLoad('reg-btn', false);
  });
  document.getElementById('go-register').addEventListener('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    showPage('register');
  });

  document.getElementById('go-login').addEventListener('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    showPage('login');
  });

  document.getElementById('add-btn').addEventListener('click', function () {
    showPage('add');
  });

  document.getElementById('back-btn').addEventListener('click', function () {
    document.getElementById('add-form').reset();
    showPage('dashboard');
  });
  document.getElementById('logout-btn').addEventListener('click', async function () {
    try {
      await invoke('logout');
    } catch (e) {}
    notify('Вы вышли');
    showPage('login');
  });
  async function loadPasswords() {
    var list = document.getElementById('pw-list');
    try {
      var entries = await invoke('get_passwords');
      list.innerHTML = '';
      if (!entries || entries.length === 0) {
        list.innerHTML =
          '<div class="empty">' +
          '<svg viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.8-2.2-5-5-5S7 3.2 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.7 1.4-3.1 3.1-3.1s3.1 1.4 3.1 3.1v2z"/></svg>' +
          '<p>Паролей пока нет</p>' +
          '<span>Добавьте первую запись</span>' +
          '</div>';
        return;
      }
      for (var i = 0; i < entries.length; i++) {
        list.appendChild(makeCard(entries[i], i));
      }
    } catch (err) {
      notify(String(err) || 'Ошибка загрузки', 'err');
    }
  }

  function esc(text) {
    var d = document.createElement('div');
    d.textContent = text;
    return d.innerHTML;
  }

  function makeCard(entry, idx) {
    var card = document.createElement('div');
    card.className = 'pw-card';
    card.style.animationDelay = idx * 0.06 + 's';

    var initial = entry.title.charAt(0).toUpperCase();

    card.innerHTML =
      '<div class="card-ico">' +
      initial +
      '</div>' +
      '<div class="card-info">' +
      '<div class="card-name">' +
      esc(entry.title) +
      '</div>' +
      '<div class="card-date">' +
      (entry.created_at || 'Только что') +
      '</div>' +
      '</div>' +
      '<button class="card-del" title="Удалить">' +
      '<svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>' +
      '</button>';

    card.addEventListener('click', function (e) {
      if (e.target.closest('.card-del')) return;
      currentId = entry.id;
      showModal('seed');
      setTimeout(function () {
        document.getElementById('modal-seed').focus();
      }, 100);
    });

    card.querySelector('.card-del').addEventListener('click', function (e) {
      e.stopPropagation();
      deleteId = entry.id;
      document.getElementById('del-name').textContent = entry.title;
      showModal('del');
    });

    return card;
  }
  document.getElementById('save-btn').addEventListener('click', async function () {
    var t = document.getElementById('add-title').value.trim();
    var p = document.getElementById('add-pass').value;
    var s = document.getElementById('add-seed').value;

    if (!t || !p || !s) {
      notify('Заполните все поля', 'err');
      return;
    }

    setLoad('save-btn', true);

    try {
      await invoke('add_password', { title: t, password: p, seedPhrase: s });
      notify('Пароль сохранён!');
      document.getElementById('add-form').reset();
      showPage('dashboard');
      await loadPasswords();
    } catch (err) {
      notify(String(err) || 'Ошибка сохранения', 'err');
    }

    setLoad('save-btn', false);
  });
  document.getElementById('modal-yes').addEventListener('click', async function () {
    var seed = document.getElementById('modal-seed').value;
    if (!seed) {
      notify('Введите сид-фразу', 'err');
      return;
    }
    if (!currentId) {
      hideModal('seed');
      return;
    }

    setLoad('modal-yes', true);

    try {
      await invoke('copy_password', { entryId: currentId, seedPhrase: seed });
      hideModal('seed');
      notify('Пароль скопирован! Очистка через 30с');
    } catch (err) {
      notify(String(err) || 'Неверная сид-фраза', 'err');
    }

    setLoad('modal-yes', false);
    currentId = null;
  });

  document.getElementById('modal-no').addEventListener('click', function () {
    hideModal('seed');
    currentId = null;
  });

  document.getElementById('modal-seed').addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      document.getElementById('modal-yes').click();
    }
  });
  document.getElementById('del-yes').addEventListener('click', async function () {
    if (!deleteId) {
      hideModal('del');
      return;
    }
    try {
      await invoke('delete_password', { entryId: deleteId });
      notify('Удалено');
      hideModal('del');
      await loadPasswords();
    } catch (err) {
      notify(String(err) || 'Ошибка удаления', 'err');
    }
    deleteId = null;
  });

  document.getElementById('del-no').addEventListener('click', function () {
    hideModal('del');
    deleteId = null;
  });
  document.querySelectorAll('.modal-bg').forEach(function (bg) {
    bg.addEventListener('click', function () {
      hideModal('seed');
      hideModal('del');
      currentId = null;
      deleteId = null;
    });
  });
  document.addEventListener('contextmenu', function (e) {
    e.preventDefault();
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'F12') e.preventDefault();
    if (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J')) e.preventDefault();
    if (e.ctrlKey && e.key === 'u') e.preventDefault();
    if (e.key === 'PrintScreen') {
      e.preventDefault();
      notify('Скриншоты заблокированы', 'err');
    }
    if (e.key === 'Escape') {
      hideModal('seed');
      hideModal('del');
      currentId = null;
      deleteId = null;
    }
  });
  async function init() {
    try {
      var ok = await invoke('is_authenticated');
      if (ok) {
        currentPage = 'login';
        showPage('dashboard');
        await loadPasswords();
      }
    } catch (e) {
    }
  }

  init();
}



