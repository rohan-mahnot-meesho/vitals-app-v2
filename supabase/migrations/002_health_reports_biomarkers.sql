create table if not exists public.health_reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  report_date date not null,
  lab_name text,
  file_name text not null,
  parser_version text not null default 'pdf-v1',
  extraction_method text,
  page_count integer,
  created_at timestamptz not null default now()
);

create table if not exists public.biomarker_observations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  report_id uuid not null references public.health_reports(id) on delete cascade,
  observed_on date not null,
  biomarker_key text not null,
  biomarker_name text not null,
  value numeric not null,
  unit text,
  ref_low numeric,
  ref_high numeric,
  flag text not null default 'unknown' check (flag in ('low', 'normal', 'high', 'unknown')),
  source_text text,
  created_at timestamptz not null default now()
);

create index if not exists health_reports_user_date_idx on public.health_reports(user_id, report_date);
create index if not exists biomarker_observations_user_key_date_idx on public.biomarker_observations(user_id, biomarker_key, observed_on);
create index if not exists biomarker_observations_report_idx on public.biomarker_observations(report_id);

alter table public.health_reports enable row level security;
alter table public.biomarker_observations enable row level security;

drop policy if exists "own reports select" on public.health_reports;
drop policy if exists "own reports insert" on public.health_reports;
drop policy if exists "own reports update" on public.health_reports;
drop policy if exists "own reports delete" on public.health_reports;
drop policy if exists "own biomarkers select" on public.biomarker_observations;
drop policy if exists "own biomarkers insert" on public.biomarker_observations;
drop policy if exists "own biomarkers update" on public.biomarker_observations;
drop policy if exists "own biomarkers delete" on public.biomarker_observations;

create policy "own reports select" on public.health_reports for select using (user_id = auth.uid());
create policy "own reports insert" on public.health_reports for insert with check (user_id = auth.uid());
create policy "own reports update" on public.health_reports for update using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own reports delete" on public.health_reports for delete using (user_id = auth.uid());

create policy "own biomarkers select" on public.biomarker_observations for select using (user_id = auth.uid());
create policy "own biomarkers insert" on public.biomarker_observations for insert with check (user_id = auth.uid());
create policy "own biomarkers update" on public.biomarker_observations for update using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own biomarkers delete" on public.biomarker_observations for delete using (user_id = auth.uid());