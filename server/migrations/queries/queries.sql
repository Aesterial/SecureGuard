-- name: CreateUser :one
insert into users (
    username,
    password
)
values ($1, $2)
returning id, username, password, admin_access, joined;

-- name: GetIsUserExists :one
select exists (select 1 from users where id = $1);

-- name: GetIsUsernameExists :one
select exists (select 1 from users where username = $1);

-- name: GetIsUserAdmin :one
select admin_access = true from users where id = $1 limit 1;

-- name: GetUserByID :one
select id, username, password, admin_access, joined
from users
where id = $1
limit 1;

-- name: GetUserByUsername :one
select id, username, password, admin_access, joined
from users
where username = $1
limit 1;

-- name: GetListUsers :many
select id, username, password, admin_access, joined
from users
order by joined desc
limit $1
offset $2;

-- name: GetUserPreferences :one
select theme, lang, crypt from preferences where owner = $1 limit 1;

-- name: GetUserPassword :one
select password from users where id = $1 limit 1;

-- name: GetUserPasswordByUsername :one
select password from users where username = $1 limit 1;

-- name: CreateUserKey :exec
insert into users_keys (master_key, salt, version, memory, iterations, parallelism) values ($1, $2, $3, $4, $5, $6);

-- name: CreatePassword :one
insert into passwords (
    owner,
    service,
    login,
    ciphertext,
    version,
    nonce,
    aad,
    metadata
)
values ($1, $2, $3, $4, $5, $6, $7, $8)
returning id, owner, service, login, ciphertext, version, nonce, aad, metadata, created_at;

-- name: UpdatePasswordService :exec
update passwords set service = $1 where id = $2;

-- name: UpdatePasswordLogin :exec
update passwords set login = $1 where id = $2;

-- name: UpdatePasswordPass :exec
update passwords set ciphertext = $1 where id = $2;

-- name: DeletePassword :exec
delete from passwords where id = $1;

-- name: IsPasswordExists :one
select exists (select 1 from passwords where id = $1);

-- name: GetPasswordByID :one
select id, owner, service, login, ciphertext, version, nonce, aad, metadata, created_at
from passwords
where id = $1
limit 1;

-- name: ListPasswordsByOwner :many
select id, owner, service, login, ciphertext, version, nonce, aad, metadata, created_at
from passwords
where owner = $1
order by created_at desc
limit $2
offset $3;

-- name: GetPasswordOwner :one
select owner from passwords where id = $1 limit 1;

-- name: GetSessionByID :one
select id, owner, client_hash, created, revoked
from sessions
where id = $1
limit 1;

-- name: InitPreferences :exec
insert into preferences (owner) values ($1);

-- name: IsPreferencesExists :one
select exists (select 1 from preferences where owner = $1);

-- name: UpdatePreferenceCrypt :exec
update preferences set crypt = $1 where owner = $2;

-- name: UpdatePreferenceLanguage :exec
update preferences set lang = $1 where owner = $2;

-- name: UpdatePreferenceTheme :exec
update preferences set theme = $1 where owner = $2;

-- name: UpdateMasterKey :exec
update users_keys set master_key = $1 where owner = $2;

-- name: GetSessionOwner :one
select owner from sessions where id = $1 limit 1;

-- name: GetSessionInfo :one
select owner, client_hash, revoked, created, expires from sessions where id = $1 limit 1;

-- name: CreateSession :one
insert into sessions (id, owner, client_hash) values ($1, $2, $3) returning id;

-- name: RevokeSession :exec
update sessions set revoked = true, revoked_at = now() where id = $1;

-- name: SetLastSeenSession :exec
update sessions set last_seen = $1 where id = $2;

-- name: IsSessionExists :one
select exists (select 1 from sessions where id = $1);

-- name: GetListSessionsByOwner :many
select id, owner, client_hash, revoked, revoked_at, created, expires, last_seen
from sessions
where owner = $1
order by created desc
limit $2
offset $3;

-- name: GetSavedStatsLatency :one
select p50, p90 from statistics where at = $1 limit 1;

-- name: GetServicesTopStats :one
select services_top from statistics where at = $1 limit 1;

-- name: CreateStatisticsSnapshot :exec
insert into statistics (
    p50,
    p90,
    services_top,
    crypt_uses,
    at
)
select $1, $2, $3, $4, $5
where not exists (
    select 1 from statistics where at = $5
);

-- name: GetTotalUsers :one
select COUNT(*) from users limit 1;

-- name: GetTotalPasswords :one
select COUNT(*) from users limit 1;

-- name: GetTotalAdmins :one
select COUNT(*) from users where admin_access = true limit 1;

-- name: GetTotalActiveSessions :one
select count(*) from sessions where not revoked and expires > now();

-- name: GetChoosenPreferencesCrypt :many
select crypt from preferences;

-- name: GetChoosenPreferencesLanguage :many
select lang from preferences;

-- name: GetChoosenPreferencesTheme :many
select theme from preferences;

-- name: CountUsersRegisteredBetween :one
select COUNT(*)
from users
where joined >= $1 and joined < $2;

-- name: CreateActivitySnapshot :exec
insert into activity (
    users,
    registers,
    at
)
select $1, $2, $3
where not exists (
    select 1 from activity where at = $3
);

-- name: GetActivityStatistics :many
select users, registers, at from activity where at >= $1 AND at < $2;

-- name: GetExpiredSessions :many
select id from sessions where expires < now();
