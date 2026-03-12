create extension if not exists "pgcrypto";

create table if not exists users (
    id uuid primary key default pg_catalog.gen_random_uuid(),
    username varchar(32) not null,
    password varchar(255) not null,
    seed_phrase varchar(255) not null,
    joined timestamptz not null default now()
);

create table if not exists preferences (
    owner uuid primary key references users (id),
    theme varchar(16) not null default 'black',
    lang varchar(32) not null default 'ru',
    crypt varchar(32) not null default 'argon2id'
);

create unique index if not exists users_username_idx on users (username);
create unique index if not exists users_preferences_owner_idx on preferences (owner);

create table if not exists passwords (
    id uuid primary key default pg_catalog.gen_random_uuid(),
    owner uuid not null references users (id) on delete cascade,
    service varchar(64) not null,
    login text not null,
    pass text not null,
    salt text not null,
    created_at timestamptz not null default now()
);

create index if not exists passwords_owner_idx on passwords (owner);

create table if not exists sessions (
    id uuid primary key default pg_catalog.gen_random_uuid(),
    owner uuid not null references users (id) on delete cascade,
    client_hash text not null,
    revoked boolean not null default false,
    created timestamptz not null default now(),
    expires timestamptz not null default (now() + interval '30 minutes')
);

create index if not exists sessions_owner_idx on sessions (owner);
