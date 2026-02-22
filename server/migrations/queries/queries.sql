-- name: CreateUser :one
insert into users (
    username,
    password,
    seed_phrase
)
values ($1, $2, $3)
returning id, username, password, seed_phrase, joined;

-- name: GetUserByID :one
select id, username, password, seed_phrase, joined
from users
where id = $1
limit 1;

-- name: GetUserByUsername :one
select id, username, password, seed_phrase, joined
from users
where username = $1
limit 1;

-- name: ListUsers :many
select id, username, password, seed_phrase, joined
from users
order by joined desc
limit $1
offset $2;

-- name: DeleteUser :exec
delete from users
where id = $1;

-- name: CreatePassword :one
insert into passwords (
    owner,
    pass
)
values ($1, $2)
returning id, owner, pass, created_at;

-- name: GetPasswordByID :one
select id, owner, pass, created_at
from passwords
where id = $1
limit 1;

-- name: ListPasswordsByOwner :many
select id, owner, pass, created_at
from passwords
where owner = $1
order by created_at desc
limit $2
offset $3;

-- name: DeletePassword :exec
delete from passwords
where id = $1
  and owner = $2;

-- name: CreateSession :one
insert into sessions (
    owner,
    phrase_pass,
    client_hash
)
values ($1, $2, $3)
returning id, owner, phrase_pass, client_hash, created;

-- name: GetSessionByID :one
select id, owner, phrase_pass, client_hash, created
from sessions
where id = $1
limit 1;

-- name: ListSessionsByOwner :many
select id, owner, phrase_pass, client_hash, created
from sessions
where owner = $1
order by created desc
limit $2
offset $3;

-- name: DeleteSession :exec
delete from sessions
where id = $1
  and owner = $2;
