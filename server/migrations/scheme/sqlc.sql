create extension if not exists "pgcrypto";

create table if not exists users (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  username varchar(32) not null,
  password varchar(255) not null,
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

create table if not exists users_keys (
  owner uuid primary key references users (id) on delete cascade,
  master_key varchar(255) not null,
  salt varchar(255) not null,
  version integer not null,
  memory bigint not null,
  iterations integer not null,
  parallelism integer not null
);

create table if not exists passwords (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  owner uuid not null references users (id) on delete cascade,
  service varchar(64) not null,
  login text not null,
  ciphertext text not null,
  version int not null,
  nonce text not null,
  aad bytea not null,
  metadata jsonb not null,
  created_at timestamptz not null default now()
);

create index if not exists passwords_owner_idx on passwords (owner);

create table if not exists sessions (
  id text primary key,
  owner uuid not null references users (id) on delete cascade,
  client_hash text not null,
  revoked boolean not null default false,
  revoked_at timestamptz,
  created timestamptz not null default now(),
  expires timestamptz not null default (now() + interval '90 minutes'),
  last_seen timestamptz
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

create type localisation_type as enum ('ru', 'en');

create table if not exists localisations
(
  key        varchar(64)       not null,
  content    text              not null,
  locale     localisation_type not null,
  created_at timestamptz       not null default now(),
  updated_at timestamptz,
  unique (key, locale)
);
