create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  email text,
  height_cm numeric,
  unit_system text not null default 'metric' check (unit_system in ('metric', 'imperial')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.body_measurements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  measured_on date not null,
  weight_kg numeric not null check (weight_kg > 0 and weight_kg < 500),
  note text,
  source text not null default 'manual',
  created_at timestamptz not null default now(),
  unique(user_id, measured_on, source)
);

create table if not exists public.daily_health_summaries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  summary_date date not null,
  source text not null check (source in ('apple', 'coros', 'fitbit', 'garmin')),
  steps integer,
  resting_hr numeric,
  sleep_hours numeric,
  vo2_max numeric,
  active_minutes numeric,
  moderate_minutes numeric,
  vigorous_minutes numeric,
  stress numeric,
  body_battery_high numeric,
  body_battery_low numeric,
  workout_count integer,
  raw_summary jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, summary_date, source)
);

alter table public.profiles enable row level security;
alter table public.body_measurements enable row level security;
alter table public.daily_health_summaries enable row level security;

drop policy if exists "own profile select" on public.profiles;
drop policy if exists "own profile insert" on public.profiles;
drop policy if exists "own profile update" on public.profiles;
drop policy if exists "own body select" on public.body_measurements;
drop policy if exists "own body insert" on public.body_measurements;
drop policy if exists "own body update" on public.body_measurements;
drop policy if exists "own body delete" on public.body_measurements;
drop policy if exists "own summaries select" on public.daily_health_summaries;
drop policy if exists "own summaries insert" on public.daily_health_summaries;
drop policy if exists "own summaries update" on public.daily_health_summaries;
drop policy if exists "own summaries delete" on public.daily_health_summaries;

create policy "own profile select" on public.profiles for select using (user_id = auth.uid());
create policy "own profile insert" on public.profiles for insert with check (user_id = auth.uid());
create policy "own profile update" on public.profiles for update using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "own body select" on public.body_measurements for select using (user_id = auth.uid());
create policy "own body insert" on public.body_measurements for insert with check (user_id = auth.uid());
create policy "own body update" on public.body_measurements for update using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own body delete" on public.body_measurements for delete using (user_id = auth.uid());

create policy "own summaries select" on public.daily_health_summaries for select using (user_id = auth.uid());
create policy "own summaries insert" on public.daily_health_summaries for insert with check (user_id = auth.uid());
create policy "own summaries update" on public.daily_health_summaries for update using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own summaries delete" on public.daily_health_summaries for delete using (user_id = auth.uid());
