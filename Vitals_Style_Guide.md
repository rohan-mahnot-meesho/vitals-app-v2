# Vitals — Design System (Console · Clay · Warm Light)

*The build-ready spec for the Vitals health dashboard. Hand this to any developer — or back to me — and the UI comes out consistent. Direction: a warm, light "console" — a calm data cockpit that borrows Anthropic's warmth, Todoist's clarity, and Slack's structured navigation.*

---

## 1. Principles (the "why", so choices stay consistent)

1. **One accent, one role.** Clay is the only brand color and it appears *only* on interactive things (buttons, links, active nav, focus). It never colors data. This is the single most important rule — it's what lets a user instantly tell "this is a control" from "this is a signal."
2. **Health states live in a separate world.** Calm / Watch / Elevated is a learnable three-state code (like Whoop's green/yellow/red). It uses its own tinted-pill treatment, distinct from the clay accent.
3. **Never color alone.** Every state also carries an icon and a word. Meaning must survive grayscale and colorblindness — non-negotiable for a health product.
4. **Neutrals do the heavy lifting.** ~90% of the surface is warm paper and ink. Color is rare, so it means something when it appears.
5. **Numbers align.** Inter's tabular figures everywhere data appears, so columns line up with zero effort.
6. **Restraint over options.** Default to the quieter choice. "Too cluttered" is the most common design failure.

---

## 2. Color

### Neutrals (the base — warm, never pure black/white)

| Token | Hex | Use |
|---|---|---|
| `--paper` | `#FAF7F0` | Page background |
| `--sidebar` | `#F1EADE` | Left nav background |
| `--card` | `#FFFDF9` | Panels, tiles, cards |
| `--line` | `#E7E0D4` | Default hairline border |
| `--line-strong` | `#DCD4C6` | Emphasis / hover border |
| `--ink` | `#26221E` | Primary text, values |
| `--ink-2` | `#6B6459` | Secondary text, row labels |
| `--ink-muted` | `#9A9184` | Captions, axis labels, hints |

### Brand accent — Clay (interactive only)

| Token | Hex | Use |
|---|---|---|
| `--clay` | `#B5502F` | Primary buttons, active nav fill, key links |
| `--clay-hover` | `#933F24` | Hover/pressed |
| `--clay-bg` | `#F4E7DF` | Active-nav tint, subtle highlight |
| `--clay-ink` | `#8A3A20` | Text/icon on clay tint |

Rule: if it's clay, it's clickable. Never use clay for a chart series, a metric value, or a status.

### Health states (data only — always with icon + label)

| State | Fill (bg) | Text/icon | Meaning | Icon |
|---|---|---|---|---|
| Calm | `#EAF0DE` | `#3F6326` | In range / healthy | `ti-check` |
| Watch | `#F7ECD6` | `#8A5F12` | Drifting / borderline | `ti-alert-triangle` |
| Elevated | `#F7E2E0` | `#98302E` | Off target / concern | `ti-trending-up` |

Solid versions for chart marks / tile top-borders: Calm `#5B8C3E`, Watch `#C08A2B`, Elevated `#C0392B`. (Elevated red is deliberately redder than clay so brand and status never blur.)

### Chart series (categorical — cool-leaning, to sit apart from the warm status colors)

Running `#3F72A6` · Swimming `#2F8F6F` · Cycling `#7A5EA6` · HIIT `#B5567E` · Treadmill `#4C9BD1` · Walking `#C08A2B` · Hiking `#5B8C3E` · Cardio `#6B7A8F` · Other `#B4B2A9`

Single-series distributions use one calm color per metric: RHR `#3F72A6`, VO₂ `#7A5EA6`, Pace `#2F8F6F`, Sleep `#C08A2B`. Grid lines `#EDE6D9`, axis text `#9A9184`.

### Accessibility

Body text meets WCAG AA (≥4.5:1); large text and graphic marks ≥3:1. Test the state colors in a colorblindness simulator (Coblis) — but because every state also has an icon + word, comprehension never depends on hue. Don't drop below 11px. Don't convey anything with color as the *only* channel.

---

## 3. Typography

One typeface, loaded from Google Fonts:

- **Inter** — everything, no exceptions: wordmark, nav, headlines, labels, body, tables, chart text, and all data. Ships tabular figures; enable with `font-feature-settings:'tnum' 1` (or `font-variant-numeric: tabular-nums`).

A single typeface is a deliberate choice: it keeps the console calm and coherent. Hierarchy comes from size and weight, not from mixing fonts. (An earlier draft reserved a serif — Fraunces — for the hero headline; that was dropped for consistency.)

### Scale

| Role | Font / size / weight | Notes |
|---|---|---|
| Hero headline | Inter 22px / 500 | Overview only; tight letter-spacing (−0.01em) |
| Wordmark | Inter 20–40px / 500 | Sidebar 20px, upload screen 40px; letter-spacing −0.02em |
| Section title | Inter 15px / 500 | Sentence case |
| Body / controls | Inter 13px / 400 | Console workhorse; line-height 1.4–1.5 |
| Data value (tile) | Inter 21–26px / 500 | Tabular |
| Caption / label | Inter 11–12px / 400 | `--ink-muted` |

Two weights only: 400 and 500. Sentence case everywhere. No ALL CAPS headers.

---

## 4. Spacing, density & shape

Console density is tighter than a consumer app but never cramped.

- **Radius:** 10px tiles/panels, 8px controls, 7px pills. Full borders only — no rounded corners on single-sided (top-border) accents.
- **Borders:** always `0.5px solid var(--line)`.
- **Elevation:** none. No shadows or gradients anywhere (except a focus ring). Depth comes from the sidebar tint and hairlines, not shadow.
- **Padding:** panels 12–16px; tiles 11–12px; sidebar items 7–8px.
- **Gaps:** 10–14px between tiles/panels; 1.5–2rem vertical rhythm between sections.
- **Grid:** metric tiles in 4-up (`repeat(auto-fit,minmax(150px,1fr))`); chart panels 2-up; wide charts full width.

---

## 5. Components

**Left nav (sidebar).** `--sidebar` background, grouped sections ("Explore", "Data") with small muted group labels. Items: 13px Inter, icon + label, 7px padding. Active item = `--clay-bg` fill + `--clay-ink` text. "New upload" is a clay action.

**Top bar (main).** Section title (Inter 15) on the left; date-range chip ("All time · 940 days") and a refresh control on the right, both as 11px hairline-bordered chips.

**Metric tile.** `--card` bg, 0.5px border, 10px radius, a 2px top border in the state's solid color. Muted 11px label → 21px value + unit → 10–11px trend line with icon (`ti-trending-up/down`, colored by state).

**Chart panel.** `--card` bg, 0.5px border, 10px radius, 12–16px padding. 13px title, 12px muted subtitle, then canvas. Chart.js styled to warm-light (ink-2 text, `#EDE6D9` grid, series colors from §2).

**Insight card.** The one place clay-tinted (`--clay-bg`, `--clay` left context) — a bulb icon + a short takeaway in `--clay-ink`. Reserved for the single most actionable insight per view.

**Table.** Hairline row dividers (`#EDE6D9`), no zebra. Labels `--ink-2` left, values `--ink` right, tabular. 13px.

**Pill / badge.** State pills use the §2 fills + icon + word. Neutral pills use `--card`/`--line`.

**Buttons.** Primary = clay fill, `#FFFDF9` text. Secondary = transparent, 0.5px `--line-strong` border, hover `--sidebar`. At most one primary (clay) action per view.

### Microcopy (Anthropic voice)

Sentence case, contractions, verb-first buttons ("New upload", not "Upload File"). No "successfully", no "please", no exclamation marks on system copy. Errors say what happened + what to do. Always frame insights as reflection, not diagnosis ("wellness insights, not medical advice").

---

## 6. Navigation model

Single-page console. Nav items scroll to in-page sections rather than loading pages (keeps it fast and simple for v1):

`Overview` · `Distributions` · `Trends` · `Training` · `Correlations` · `Body` · `Reports` — plus `New upload` under a "Data" group.

`Overview` leads with the Inter headline + the four state-colored metric tiles + coverage + the single top insight. Everything else is drill-down below.

## 7. Health Reports

The Reports surface follows the same console pattern as Body:

- A compact PDF upload row, not a marketing-style panel.
- A review table before save. Extracted values are editable because report PDFs vary by lab and OCR can be imperfect.
- Metric tiles show the latest confirmed biomarkers with state pills.
- Trend charts appear only after at least two observations exist for a biomarker.
- Report history and biomarker history are shown as quiet tables.

Raw PDFs stay client-side. Persist only report metadata and confirmed biomarker observations.

---

*This spec is implemented in `index.html` (the re-skinned app). Any new surface — a weekly recap, a settings page — should be built from these tokens and rules, not redesigned from scratch.*
