import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
const enabled = Boolean(
  supabaseUrl &&
  supabaseAnonKey &&
  !supabaseUrl.includes('your-project') &&
  !supabaseAnonKey.includes('your-public')
);

const supabase = enabled
  ? createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        autoRefreshToken: true,
        detectSessionInUrl: true,
        persistSession: true,
      },
    })
  : null;

function requireClient() {
  if (!supabase) throw new Error('Supabase is not configured. Add VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY.');
  return supabase;
}

function userIdentity(user) {
  const meta = user?.user_metadata || {};
  return {
    display_name: meta.full_name || meta.name || user?.email || null,
    email: user?.email || null,
  };
}

async function signInWithGoogle() {
  const client = requireClient();
  const { error } = await client.auth.signInWithOAuth({
    provider: 'google',
    options: { redirectTo: window.location.origin + window.location.pathname },
  });
  if (error) throw error;
}

async function signOut() {
  const client = requireClient();
  const { error } = await client.auth.signOut();
  if (error) throw error;
}

async function getSession() {
  if (!supabase) return null;
  const { data, error } = await supabase.auth.getSession();
  if (error) throw error;
  return data.session || null;
}

function onAuthStateChange(callback) {
  if (!supabase) return { unsubscribe() {} };
  const { data } = supabase.auth.onAuthStateChange((_event, session) => callback(session || null));
  return data.subscription;
}

async function ensureProfile(user) {
  const client = requireClient();
  const identity = userIdentity(user);
  const { error } = await client
    .from('profiles')
    .upsert({ user_id: user.id, ...identity }, { onConflict: 'user_id', ignoreDuplicates: false });
  if (error) throw error;
}

async function loadAccountData(user) {
  const client = requireClient();
  await ensureProfile(user);
  const [profileRes, bodyRes, summariesRes] = await Promise.all([
    client.from('profiles').select('*').eq('user_id', user.id).maybeSingle(),
    client.from('body_measurements').select('*').eq('user_id', user.id).order('measured_on', { ascending: true }),
    client.from('daily_health_summaries').select('*').eq('user_id', user.id).order('summary_date', { ascending: true }),
  ]);
  for (const res of [profileRes, bodyRes, summariesRes]) {
    if (res.error) throw res.error;
  }
  return {
    profile: profileRes.data || null,
    bodyMeasurements: bodyRes.data || [],
    dailySummaries: summariesRes.data || [],
  };
}

async function upsertProfile(profile) {
  const client = requireClient();
  const { data: userData, error: userError } = await client.auth.getUser();
  if (userError) throw userError;
  const user = userData.user;
  const { error } = await client
    .from('profiles')
    .upsert({ ...profile, user_id: user.id, updated_at: new Date().toISOString() }, { onConflict: 'user_id' });
  if (error) throw error;
}

async function upsertBodyMeasurement(entry) {
  const client = requireClient();
  const { data: userData, error: userError } = await client.auth.getUser();
  if (userError) throw userError;
  const user = userData.user;
  const row = { ...entry, user_id: user.id, source: entry.source || 'manual' };
  const { error } = await client
    .from('body_measurements')
    .upsert(row, { onConflict: 'user_id,measured_on,source' });
  if (error) throw error;
}

async function deleteBodyMeasurement(id) {
  const client = requireClient();
  const { error } = await client.from('body_measurements').delete().eq('id', id);
  if (error) throw error;
}

async function upsertDailySummaries(source, summaries) {
  if (!summaries.length) return;
  const client = requireClient();
  const { data: userData, error: userError } = await client.auth.getUser();
  if (userError) throw userError;
  const user = userData.user;
  const rows = summaries.map(row => ({
    ...row,
    user_id: user.id,
    source,
    updated_at: new Date().toISOString(),
  }));
  const { error } = await client
    .from('daily_health_summaries')
    .upsert(rows, { onConflict: 'user_id,summary_date,source' });
  if (error) throw error;
}

window.VitalsCloud = {
  enabled,
  signInWithGoogle,
  signOut,
  getSession,
  onAuthStateChange,
  loadAccountData,
  upsertProfile,
  upsertBodyMeasurement,
  deleteBodyMeasurement,
  upsertDailySummaries,
};
