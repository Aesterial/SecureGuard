create extension if not exists "pgcrypto";

create table if not exists users (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  username varchar(32) not null,
  password varchar(255) not null,
  seed_phrase varchar(255) not null,
  admin_access boolean not null default false,
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
  expires timestamptz not null default (now() + interval '90 minutes')
);

create index if not exists sessions_owner_idx on sessions (owner);

create table if not exists statistics (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  p50 double precision not null,
  p90 double precision not null,
  services_top jsonb not null,
  crypt_uses jsonb not null,
  at timestamptz not null
);
create index if not exists statistics_at_idx on statistics (at);

create table if not exists activity (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  users integer not null check (users >= 0),
  registers integer not null check (registers >= 0),
  at timestamptz not null
);
create index if not exists activity_at_idx on activity (at);
