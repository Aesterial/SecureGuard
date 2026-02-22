create extension if not exists "pgcrypto";

create table if not exists users (
    id uuid primary key default pg_catalog.gen_random_uuid(),
    username varchar(16) not null,
    password varchar(255) not null,
    seed_phrase varchar(255),
    joined timestamptz not null default now()
);

create unique index if not exists users_username_idx on users (username);

create table if not exists passwords (
    id uuid primary key default pg_catalog.gen_random_uuid(),
    owner uuid not null references users (id) on delete cascade,
    pass text not null,
    created_at timestamptz not null default now()
);

create index if not exists passwords_owner_idx on passwords (owner);

create table if not exists sessions (
    id uuid primary key default pg_catalog.gen_random_uuid(),
    owner uuid not null references users (id) on delete cascade,
    phrase_pass boolean not null default false,
    client_hash text not null,
    created timestamptz not null default now()
);

create index if not exists sessions_owner_idx on sessions (owner);
