# Vitals

Turn your Apple Health, COROS, Fitbit, Garmin, and health report PDFs into a calm health dashboard — resting heart rate, VO₂ max, sleep, training, body metrics, bloodwork biomarkers, and the correlations between them.

## Privacy

Exports and health report PDFs are parsed **client-side in your browser**. Raw Apple Health, COROS, Fitbit, Garmin, and PDF files are never uploaded or stored.

Accounts are optional. If Supabase is configured and a user signs in with Google, Vitals stores only:

- profile height and unit preference
- manual body measurements
- derived daily health summaries
- confirmed health report metadata and biomarker observations

## Health report PDFs

Signed-in users can upload lab report PDFs from the dashboard. Vitals extracts selectable PDF text first and falls back to browser OCR for scanned reports. Extracted biomarkers are shown in a review table before saving, so users can correct report date, lab name, value, unit, and reference range.

Vitals stores only the confirmed structured values, not the raw PDF.

## Run locally

```bash
pnpm install
cp .env.example .env
pnpm dev
```

Supabase is optional for anonymous use. To enable Google OAuth and cloud sync, set:

```bash
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
```

Apply the Supabase migrations in order and configure Google OAuth redirect URLs for local and production domains.

## Deploy

Deploy on Vercel with the Vite preset or:

- Build command: `pnpm build`
- Output directory: `dist`
- Environment variables: `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`

## How to get your Garmin export

Sign in at garmin.com/account → **Export Your Data**. Garmin emails a download link within a few days. Upload the `.zip` as-is.

---

*Wellness insights from your own data — not medical advice.*
