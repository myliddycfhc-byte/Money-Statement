-- Run this once in Supabase: SQL Editor -> New query -> paste -> Run

create table if not exists public.money_members (
  name text primary key,
  created_at timestamptz not null default now()
);

create table if not exists public.money_entries (
  id uuid primary key,
  name text not null references public.money_members(name) on update cascade,
  date date not null,
  type text not null check (type in ('given','received')),
  amount numeric(12,2) not null check (amount > 0),
  reason text not null default '',
  created bigint not null
);

alter table public.money_members enable row level security;
alter table public.money_entries enable row level security;

drop policy if exists "anon read members" on public.money_members;
drop policy if exists "anon insert members" on public.money_members;
drop policy if exists "anon read entries" on public.money_entries;
drop policy if exists "anon insert entries" on public.money_entries;
drop policy if exists "anon delete entries" on public.money_entries;

create policy "anon read members" on public.money_members for select to anon using (true);
create policy "anon insert members" on public.money_members for insert to anon with check (true);
create policy "anon read entries" on public.money_entries for select to anon using (true);
create policy "anon insert entries" on public.money_entries for insert to anon with check (true);
create policy "anon delete entries" on public.money_entries for delete to anon using (true);
