# Mochi Moon — Product Requirements Document

| | |
| --- | --- |
| Product | Mochi Moon: Self-Love & Zodiac |
| Owner | Thatoe |
| Version | 1.0 (draft) |
| Date | 2026-10-27 |
| Platforms | Android first; iOS later |
| Languages | English (source), Thai, Burmese |
| Engineering rules | See `CLAUDE.md` (it wins on engineering; this PRD wins on product behavior) |

---

## 1. Summary

Mochi Moon is a cute, illustrated self-love app for young women. Its home is a swipe deck of affirmation cards, each of which she reads aloud during a short timer before swiping. A second tab, "Cosmic you", adds Western astrology: daily guidance, lucky colors, things to avoid, retrograde alerts, moon phase, birth chart and love compatibility. AI works in the background (written readings, personalized deck ranking); there is no chat.

## 2. Goals and non-goals

### Goals

1. Build a daily self-love ritual: open → read 1–10 cards aloud → feel good → come back tomorrow.
2. Make astrology personal and gentle: computed from her real birth data, written warmly.
3. Monetize through a freemium subscription and one-off compatibility reports.
4. Work offline for core features; stay cheap to run (on-device astro math, cached readings).

### Non-goals (v1)

- Any chat, chatbot, or free-text AI interaction.
- Vedic/sidereal astrology, tarot, palm reading, numerology.
- Social feed, friends, comments, or messaging.
- Speech recognition or microphone use.
- Ads.
- iOS release (code stays iOS-compatible).

## 3. Users

| Persona | Description | Main need |
| --- | --- | --- |
| Mia, 19, student (international) | Uses TikTok/Pinterest, loves cute aesthetics, knows her sun sign | A pretty daily ritual and shareable cards |
| Ploy, 24, office worker (Bangkok) | Checks lucky colors before work, likes Thai day colors | Practical daily guidance in Thai |
| Su, 22, university student (Yangon) | Reads in Burmese, curious about compatibility with her partner | Burmese content and a love-match reading |

## 4. Success metrics (first 6 months after launch)

| Metric | Target |
| --- | --- |
| Day-1 retention | ≥ 35% |
| Day-7 retention | ≥ 15% |
| Onboarding completion | ≥ 70% of installs that start it |
| Trial start rate | ≥ 5% of new users |
| Trial → paid | ≥ 30% |
| Cards shared | ≥ 3% of daily active users per day |
| Crash-free sessions | ≥ 99.5% |

## 5. App structure

Bottom navigation (3 tabs):

1. **Deck** (home) — self-love swipe deck, mood check-in, entry to Journal.
2. **Cosmic** — Today, Retrogrades, Moon, Birth chart, Love match.
3. **Me** — Journal, profile, premium, settings.

Paywall is a modal route reachable from locked items.

---

## 6. Feature specifications

Each feature lists user stories and acceptance criteria (AC). "Free" and "Premium" mark entitlement.

### 6.1 Onboarding and sign-in

**Flow:** Splash → 3 sample cards (no account) → "Save your cards and get your cosmic reading" → Google sign-in → name → birth date → birth time (optional) → birthplace (search) → reminder time → pick up to 3 focus areas → Deck.

**User stories**
- As a new user, I can try 3 cards before signing in, so I understand the app first.
- As a user, I can sign in with Google in one tap.
- As a user, I can say "I don't know my birth time" and still continue.

**AC**
- [x] 3 sample cards work without network or account; the timer gate applies. — *shown after a welcome screen; the "save your cards" step is the Google sign-in button*
- [x] Google sign-in via Firebase Auth; on success a `users/{uid}` doc is created (§8.1). — *verified on the Android emulator against the dev project (`mochi-moon-dev`): the Auth user is created, the profile steps run, and `users/{uid}` appears in Firestore with name, locale, profile and settings. Sign-in waits up to 10 s for the first Firestore read when the network is slow. Without Firebase config the button carries on signed out. An account that already has a complete `users/{uid}` profile skips the profile steps.*
- [x] Birth date is required (date picker; year range 1940–current year; no future dates).
- [x] Birth time is optional; "I don't know" sets `timeKnown = false`.
- [x] Birthplace is required when birth time is given, optional otherwise. Search is offline over the bundled cities list (§8.5), showing "City, Region, Country". — *the step sits between birth time and reminder; picking a city stores `place` with its `tzId`.*
- [ ] On save, the app computes and stores sun sign (always), moon sign (always; flagged approximate when time unknown), rising sign (only when time known).
- [x] Reminder time defaults to 08:00 local; user can skip.
- [x] Focus areas: Self-love, Confidence, Healing, Study & work, Body kindness, Calm (multi-select, up to 3).
- [ ] The whole flow works in en/th/my and respects text scaling. — *text scaling 1.3× is tested; the new profile strings are English only (`my` falls back to English, `th` is deferred)*
- [x] Back navigation never loses entered data within the flow.

### 6.2 Self-love deck (Free with daily limit)

**User stories**
- As a user, I see one illustrated affirmation card at a time and must read it aloud before swiping.
- I swipe right to save ("This is me"), left for the next card, up to share.

**Behavior**
- Card layout: illustration (top ~60%), affirmation text, small category chip, timer ring.
- **Timer gate:** lock duration = `max(3.0, wordCount / 2.5)` seconds, capped at 8 s. The ring fills while locked; card swipes and the action buttons are disabled until full. A gentle haptic + sparkle plays when unlocked. A small hint under the ring reads "Read it out loud ✨" (localized).
- Swipe right → saved to Journal, heart animation. Swipe left → next. Swipe up → share sheet (§6.4). Undo the last swipe (1 level).
- Deck source order: For You ranking (§6.9) if enough history, otherwise focus-area weighted random without repeats in 30 days.
- **Free limit:** 10 new cards per local day. After that, show a friendly "You're glowing — come back tomorrow" card with a premium upsell. Journal and reshares stay unlimited.
- Mood check-in (optional) at the top: 6 emoji moods (happy, calm, tired, sad, anxious, in love). Choosing one re-ranks the next cards.

**AC**
- [ ] Swipe attempts before the timer completes are cancelled and the card springs back.
- [ ] After the timer completes, all three swipe directions work, plus button equivalents for accessibility.
- [ ] The daily counter resets at local midnight; it is stored locally and synced to Firestore. — *synced since M2 (`users/{uid}.deck`); the reset while the app stays open past midnight is still deferred*
- [ ] "Reduce motion" disables tilt and sparkle animations but keeps the ring.
- [ ] Works offline using bundled quotes.
- [ ] Streak: a day counts when ≥ 1 card is completed; streak shown on the Deck header.

### 6.3 Journal (Free)

- [x] Lists saved cards newest first with illustration thumbnails; tap opens full card; long-press to remove.
- [ ] Filter by category. Synced via Firestore so it survives reinstall. — *sync is done (`users/{uid}/journal/{quoteId}`); the category filter is not*
- [x] Empty state with the mascot and a prompt to swipe right on cards she loves. — *uses `ill_empty_deck.webp`*

### 6.4 Share as image (Free)

- [x] Generates a 1080×1920 PNG story image: card illustration, text, subtle "Mochi Moon" wordmark and handle. — *handle comes from `--dart-define=SHARE_HANDLE`, omitted until set; the illustration is the card's theme art*
- [x] Uses the system share sheet (`share_plus`). No social SDKs.
- [ ] Rendering works in all three scripts with correct fonts. — *blocked on bundling fonts (M0 leftover); Burmese renders through the `Noto Sans Myanmar` fallback once bundled*

### 6.5 Home-screen widget (Free)

- [x] Android widget (2×2 and 4×2) shows today's card text (short form) and a thumbnail. — *the thumbnail is the card's theme art (decoded before capture, not yet seen on a device); English only; builds and is unit-tested but not yet seen on a device*
- [x] Updates at local midnight and whenever the deck is opened. — *the app stocks the next 14 days on each open; midnight refreshes are scheduled with `home_widget` (inexact, may drift a few minutes); a 1-hour system refresh is the safety net*
- [x] Tapping opens the Deck at today's card. — *the launch intent carries `mochimoon://widget/deck`; the deck deals the card of the day first unless it was already completed today*

### 6.6 Notifications (Free)

- [x] Daily reminder at the chosen time with today's card first line (scheduled locally). — *set from a tile on the Me tab until onboarding exists; the next 14 days are scheduled and rebuilt on each app open; inexact alarms, so it can drift a few minutes*
- [ ] Retrograde alerts: 1 day before a station and on the station day, scheduled locally from the computed calendar (§9.5) for Mercury (default on), Venus and Mars (default off).
- [ ] FCM topic `announcements` for rare app news (default on, can be turned off).
- [x] Android 13+ notification permission requested after onboarding with a pre-prompt explaining why. — *pre-prompt and request are in place, triggered from the Me tile; moving the trigger to the end of onboarding is part of the onboarding item*

### 6.7 Cosmic — Today (Free; personalized layer Premium)

Shows for the user's local date:

| Block | Free | Premium |
| --- | --- | --- |
| Headline + daily text for her sun sign | ✓ | — |
| Personalized text based on transits to her natal chart | — | ✓ |
| Lucky color(s) | ✓ | — |
| Lucky number | ✓ | — |
| Things to avoid (3 short items) | ✓ | — |
| Today's energy card (daily mix, §6.10) | ✓ | — |
| Thai birthday color + today's Thai day color (toggle) | ✓ | — |

**Lucky colors**
- Each sign has a palette of 4–6 named colors in `signs.json`.
- Today's lucky color = `palette[(dayOfYear + signIndex) % palette.length]`, plus a second color from the element of the Moon's current sign (fire: warm reds/oranges, earth: greens/browns, air: yellows/sky blues, water: blues/sea greens).
- Thai colors (setting `showThaiColors`, default on for `th` locale, off otherwise): Sunday red, Monday yellow, Tuesday pink, Wednesday green, Thursday orange, Friday blue, Saturday purple. Show "Your birthday color" (weekday of birth date) and "Today's color".

**AC**
- [ ] Text comes from the Readings API (§8.2), cached per date/sign/lang; offline falls back to cache, then bundled fallback text.
- [ ] Every reading block shows the note "For entertainment and self-reflection".
- [ ] Changing app language refetches in the new language.

### 6.8 Cosmic — Retrogrades and Moon (Free)

**Retrogrades**
- [x] Status card: "Mercury is retrograde until Nov 13" style, or "Next Mercury retrograde: Feb 9" with a countdown.
- [x] Timeline for the current and next year for Mercury, Venus, Mars (and Jupiter–Saturn under "More"): pre-shadow, retrograde, post-shadow bands.
- [x] Each period has short evergreen tips per planet (bundled content). — *one tip per planet, in the ARB files, shown on each planet's card rather than on each period.*
- [x] Dates computed on-device (§9.5) and displayed in the user's local time zone.

**Moon**
- [ ] Current phase name, illumination %, moon sign, next new and full moon dates.
- [ ] Pairs with a matching affirmation (e.g. new moon → intentions).

### 6.9 For You deck (Premium)

- Ranks cards using quote embeddings (§7.2): her right-swipes, shares and mood check-ins form a preference vector; cards are ranked by cosine similarity with exploration.
- [ ] Requires ≥ 10 right-swipes; before that, show a progress state ("Mochi is learning what you love — 6/10").
- [ ] Mix: 70% top-ranked, 30% exploration from unseen categories.
- [ ] Runs fully on-device; no swipe data leaves the phone except the synced Journal.

### 6.10 Daily mix — "Today's energy" (Free)

- [ ] A card on Cosmic → Today combining the server's per-sign "energy" line with a matching affirmation (selected by tag/embedding match on-device).
- [ ] Tapping it opens the card in the deck flow (timer applies).

### 6.11 Birth chart (Big 3 Free; full reading Premium)

**Display**
- Chart wheel (CustomPainter): zodiac ring, Whole Sign houses (if time known), planet glyphs at their degrees, aspect lines (major aspects only).
- Placements list: Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto, plus Ascendant and MC if time known. Each row: glyph, sign, degree (e.g. 12°34′), house, ℞ if retrograde.

**Readings**
- Free: Big 3 cards (Sun, Moon, Rising) with short bundled texts.
- Premium: full AI natal report (§8.2 `POST /v1/reports/natal`) with sections: Overview, Core self (Sun), Emotions (Moon), First impression (Rising), Love style (Venus), Drive (Mars), Mind (Mercury), Growth (Jupiter/Saturn). Generated once per user per language and cached; regenerated only if birth data changes.

**AC**
- [ ] Unknown birth time: no Ascendant, no houses, Moon marked "approximate"; banner invites adding the time.
- [ ] Editing birth data recomputes everything and invalidates cached reports.
- [ ] Golden tests pass (§9.7).

### 6.12 Love compatibility (score Free; full report Premium or one-off purchase)

**Input:** partner nickname + birth date (required), birth time and place (optional). Up to 5 saved partners (Free: 1).

**Output**
- Overall score 35–98% with a cute meter and a one-line summary.
- Three sub-scores: Romance, Emotional, Communication.
- Top 3 supportive aspects and top 2 growth aspects in plain language (bundled short texts per aspect type).
- Premium / one-off: full AI compatibility report (§8.2) with sections: Your chemistry, How you love, How you talk, Where you grow, A gentle tip.

**AC**
- [ ] Scoring follows §9.6 exactly and is deterministic for the same inputs.
- [ ] Sun-sign-only mode when partner time/place unknown is clearly labeled "Light reading".
- [ ] Partner data is stored only in the user's Firestore subcollection and can be deleted individually.
- [ ] Copy never says a relationship will fail or succeed.

### 6.13 Paywall and purchases

| Product ID | Type | Notes |
| --- | --- | --- |
| `mochi_premium_monthly` | Auto-renewing subscription | No trial |
| `mochi_premium_yearly` | Auto-renewing subscription | 7-day free trial |
| `mochi_compat_report` | Consumable (one report credit) | Unlocks one full compatibility report |

Premium unlocks: unlimited deck, For You deck, personalized Today, full natal report, full compatibility reports, up to 5 partners, all widget themes and mascot outfits.

**AC**
- [ ] Prices come from Play Billing (localized currency); never hardcoded.
- [ ] Purchases are verified server-side (`POST /v1/purchases/verify`), which writes `entitlement` to Firestore; the app reads entitlement from Firestore only.
- [ ] Restore purchases button. Clear trial terms and a link to manage subscriptions in Play.
- [ ] Paywall shows: mascot, 3 benefit bullets, yearly plan preselected with trial, monthly option, close button visible immediately.

### 6.14 Settings and account

- [x] Language: System / English / ไทย / မြန်မာ. Done as System / English / မြန်မာ (Me tab → Language); Thai joins when it has a native reviewer.
- [ ] Notifications: reminder time, retrograde alerts per planet, announcements.
- [ ] Show Thai colors toggle. Reduce motion toggle (also follows system).
- [ ] Edit profile from the Me tab: name, birthday, birth time (and later birthplace) and focus areas, reusing the onboarding profile steps. Manage partners. — *requested during M2; the profile steps and `ProfileController.save` already exist, so this is a presentation task for this phase, not before.*
- [ ] Privacy policy, Terms, "About readings" (entertainment notice), licenses.
- [ ] Analytics consent toggle (default off until the consent prompt is answered).
- [ ] **Delete account**: confirmation dialog → calls `DELETE /v1/account` → server deletes Firestore data, reports, and the Auth user → app clears local DB and signs out. A web deletion page (`https://<domain>/delete-account`) offers the same.

---

## 7. AI features (no chat)

### 7.1 Server-generated readings

- A nightly job on the VPS generates, for each of the 12 signs × each shipped language (`en` and `my` for now; `th` joins when it ships), the daily reading for **today and tomorrow** (to cover all time zones) with OpenAI `gpt-6-luna` at high reasoning effort, called directly through the OpenAI API (OpenRouter is no longer used).
- The API key lives only in the VPS environment (`OPENAI_API_KEY`); it is never in the app, the repo or a client request. The model ID is a server setting so it can change without an app release.
- Inputs to the prompt are computed facts only (sign, Moon sign and phase, active retrogrades, notable transits to the sign), plus the style guide.
- Personal reports (natal, compatibility) are generated on request from **placements only** (no birth date/time/place), then cached.
- Output is strict JSON matching §8.2 schemas; invalid output is retried once, then the bundled fallback is served.

**Style guide (enforced in the system prompt and by a post-check)**
- Warm, encouraging, second person, 60–120 words for daily texts.
- Never predict health, illness, death, pregnancy, accidents, money outcomes, legal outcomes, or breakups.
- No fear language ("danger", "curse", "bad luck") and no absolute claims ("will", "definitely").
- Suggest small, kind actions.
- Native-quality Thai and Burmese (Unicode). First batches of each language are human-reviewed before launch.

### 7.1a Translation of static content (build time)

Burmese UI strings, bundled fallback readings and quote texts are generated from the English source by an OpenAI model (`gpt-6-luna`, high reasoning effort), run by the developer through `tool/translate_content.dart`. This is a dev-time step, separate from §7.1, and the app never calls it.

- The key is read from `OPENAI_API_KEY` (environment or a gitignored local `.env`); `OPENAI_MODEL` overrides the default model. Neither is stored in the repo.
- Only app copy and content texts are sent; no user, birth or journal data.
- The style guide in §7.1 applies, plus Unicode Burmese (never Zawgyi). The tool checks keys, placeholders, JSON shape, word counts and Zawgyi before writing files.
- Output is **unreviewed machine translation**. A native reviewer must approve each batch before it counts as shipped (see §7.1 and §13). Only Burmese is generated and shipped for now; Thai is not generated or shipped until a reviewer exists.

### 7.2 Embeddings for the For You deck

- Every quote gets a multilingual sentence embedding computed once on the server (any small multilingual embedding model), reduced to 128 dimensions and int8-quantized, shipped in `quotes.json`.
- Mood centroids (6 moods) are shipped the same way.
- On-device preference vector `p = Σ wᵢ·eᵢ / |Σ wᵢ·eᵢ|`, weights: right-swipe 1.0, share 1.5, left-swipe −0.3, with 14-day half-life decay; a selected mood adds its centroid with weight 2.0 for that session.

### 7.3 Store wording

The listing may say "AI-personalized affirmations" and "AI-written birth chart readings" because §7.1–7.2 exist. Never claim the AI "predicts" anything.

---

## 8. Data and interfaces

### 8.1 Firestore

```
users/{uid}
  displayName: string
  locale: "en" | "th" | "my"
  createdAt, updatedAt: timestamp
  profile:
    birthDate: "YYYY-MM-DD"
    birthTime: "HH:mm" | null
    timeKnown: bool
    place: { name, region, countryCode, lat, lng, tzId } | null
    sunSign: string
    moonSign: string
    moonApproximate: bool
    risingSign: string | null
    focusAreas: string[]
  settings:
    reminderTime: "HH:mm" | null
    retroAlerts: { mercury: bool, venus: bool, mars: bool }
    showThaiColors: bool
    analyticsConsent: bool
  deck:
    streak: int
    lastCompletedDate: "YYYY-MM-DD"
    todayCount: int
    todayDate: "YYYY-MM-DD"
  entitlement:            # written by the server only
    premium: bool
    productId: string | null
    expiresAt: timestamp | null
    reportCredits: int

users/{uid}/journal/{quoteId}
  savedAt: timestamp

users/{uid}/partners/{partnerId}
  nickname: string
  birthDate, birthTime, timeKnown, place   # same shape as profile
  createdAt: timestamp

users/{uid}/reports/{reportId}       # written by the server only
  type: "natal" | "compatibility"
  partnerId: string | null
  lang: string
  version: int
  createdAt: timestamp
  sections: [{ key, title, body }]
```

**Security rules (outline)**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid} {
      allow read: if request.auth.uid == uid;
      allow create: if request.auth.uid == uid
        && !('entitlement' in request.resource.data);
      allow update: if request.auth.uid == uid
        && !request.resource.data.diff(resource.data).affectedKeys().hasAny(['entitlement']);
      allow delete: if false;   // deletion goes through the server

      match /journal/{id}  { allow read, write: if request.auth.uid == uid; }
      match /partners/{id} { allow read, write: if request.auth.uid == uid; }
      match /reports/{id}  { allow read: if request.auth.uid == uid; allow write: if false; }
    }
  }
}
```

### 8.2 Readings API (VPS)

Base: `https://api.<domain>/v1`. Auth: `Authorization: Bearer <Firebase ID token>` (verified with the Firebase Admin SDK). JSON only. Errors: `{ "error": { "code": "premium_required", "message": "..." } }` with HTTP 400/401/402/404/429/500.

| Method | Path | Access | Purpose |
| --- | --- | --- | --- |
| GET | `/daily?sign=scorpio&date=2026-10-27&lang=th` | Signed-in | Daily sign reading |
| POST | `/daily/personal` | Premium | Transit-personalized daily text from placements |
| POST | `/reports/natal` | Premium | Full natal report |
| POST | `/reports/compatibility` | Premium or 1 credit | Full compatibility report |
| POST | `/purchases/verify` | Signed-in | Verify Play purchase, write entitlement |
| DELETE | `/account` | Signed-in | Delete all user data and the Auth user |

**`GET /daily` response**

```json
{
  "date": "2026-10-27",
  "sign": "scorpio",
  "lang": "th",
  "version": 1,
  "headline": "string",
  "body": "string (60–120 words)",
  "energy": "one short line for the daily mix",
  "love": "one or two sentences",
  "avoid": ["string", "string", "string"],
  "luckyNumber": 7,
  "generatedBy": "ai",
  "reviewed": false
}
```

**`POST /reports/natal` request**

```json
{
  "lang": "en",
  "timeKnown": true,
  "placements": [
    { "body": "sun", "sign": "scorpio", "degree": 4.27, "house": 10, "retrograde": false }
  ],
  "ascendant": { "sign": "aquarius", "degree": 18.5 },
  "aspects": [ { "a": "sun", "b": "moon", "type": "trine", "orb": 2.1 } ]
}
```

Response: `{ "reportId": "...", "lang": "en", "version": 1, "sections": [ { "key": "overview", "title": "...", "body": "..." } ] }`. The server also writes it to `users/{uid}/reports/{reportId}`.

**`POST /reports/compatibility` request:** `{ "lang", "partnerId", "a": <placements block>, "b": <placements block>, "score": { "overall", "romance", "emotional", "communication" }, "topAspects": [...] }`.

**Rate limits:** 60 requests/min per user; report endpoints 5/hour per user.

**Server notes (separate repo `mochi-moon-api`)**
- FastAPI (Python) behind Nginx on the existing Hostinger VPS, Docker Compose, SQLite or Postgres for the reading cache.
- Cron at 17:00 UTC generates the next two dates for all signs × languages.
- Uses the Google Play Developer API to verify purchases and Real-time Developer Notifications for renewals/cancellations.
- Logs never contain request bodies with placements.

### 8.3 Content: `assets/content/quotes/quotes.json`

```json
{
  "version": 1,
  "quotes": [
    {
      "id": "q_0001",
      "text": { "en": "I am allowed to take up space.", "th": "…", "my": "…" },
      "author": null,
      "category": "self_love",
      "moods": ["sad", "anxious"],
      "signs": ["all"],
      "illustrationId": "ill_bunny_hug_01",
      "premium": false,
      "embedding": "<base64 int8, 128 dims>"
    }
  ]
}
```

- Categories: `self_love`, `confidence`, `healing`, `study_work`, `body_kindness`, `calm`.
- Launch target: 500 quotes (≥ 150 free), all three languages.
- Authors: only original (null) or public-domain authors.

### 8.4 Illustrations

- `assets/illustrations/ill_<theme>_<nn>.webp`, 1080×1350, pastel background, consistent moon-bunny mascot.
- 12 zodiac outfit variants: `ill_zodiac_<sign>.webp`.
- Launch target: 60–100 illustrations, each reused across many quotes.

### 8.5 Cities dataset

- Bundled GeoNames-derived list (cities with population ≥ 15,000): name, ASCII name, alternate names in Thai and Burmese where available, admin region, country code, lat, lng. Attribution in the licenses screen.
- Time zone from `lat_lng_to_timezone` at selection time; store `tzId`.

### 8.6 Local database (drift)

Tables: `cached_readings` (date, sign, lang, version, json, fetchedAt), `cached_reports`, `deck_history` (quoteId, action, at), `journal_cache`, `retro_calendar` (planet, year, json), `preference_vector`.

---

## 9. Astro engine specification

All in `lib/features/cosmic/astro/`, pure Dart. Library: `astronomia` (check its API docs for exact function names).

### 9.1 Time

1. Local birth date/time + `tzId` → UTC using the `timezone` package (historical offsets and DST).
2. UTC → Julian Day (TT ≈ UT is acceptable for this accuracy; optionally add ΔT).
3. Unknown time → 12:00 local.

### 9.2 Positions

- Sun: apparent geocentric ecliptic longitude.
- Moon: geocentric ecliptic longitude (Meeus ch. 47).
- Mercury–Neptune: geocentric ecliptic longitude from VSOP87 with light-time correction; Pluto from the library's Pluto module.
- Sign index = `floor(λ / 30)`; degree in sign = `λ mod 30`.
- Retrograde flag: longitude speed < 0 (compare λ at t−12h and t+12h, unwrapping across 0°/360°).

### 9.3 Ascendant and MC

- `ε` = true obliquity of date. `θ` = local apparent sidereal time in degrees (Greenwich apparent sidereal time + east longitude). `φ` = latitude.
- `MC = atan2(sin θ, cos θ · cos ε)`
- `ASC = atan2(cos θ, −(sin θ · cos ε + tan φ · sin ε))`
- Normalize both to [0, 360). Sanity check: at φ = 0 and ε = 0, ASC = θ + 90°.
- For |φ| > 66°, still compute but show a note that Rising may be unreliable.

### 9.4 Houses

Whole Sign: house 1 = Ascendant's sign; house *n* = sign `(ascSign + n − 1) mod 12`. A planet's house = `((planetSign − ascSign) mod 12) + 1`.

### 9.5 Retrogrades, shadows and moon phase

- For a target year (plus a 2-month margin each side), sample daily longitudes; find sign changes of speed; refine each station by bisection to 1 hour.
- Retrograde period = [retrograde station, direct station].
- Pre-shadow start = last time **before** the retrograde station when the planet's longitude equals the direct-station longitude. Post-shadow end = first time **after** the direct station when longitude equals the retrograde-station longitude.
- Moon phase: elongation `E = (λ_moon − λ_sun) mod 360`; illumination = `(1 − cos E) / 2`. Phase names by E: New [0, 22.5) ∪ [337.5, 360), Waxing crescent, First quarter (67.5–112.5), Waxing gibbous, Full (157.5–202.5), Waning gibbous, Last quarter (247.5–292.5), Waning crescent.
- Next new/full moon: search forward for E crossing 0° / 180°, refine by bisection.
- Validation: the computed 2026–2027 Mercury retrograde stations must fall within ±1 day of Oct 24–Nov 13 2026, Feb 9–Mar 3 2027, Jun 10–Jul 4 2027 (published dates).

### 9.6 Aspects and compatibility scoring

**Aspects** (orb in degrees; +2° when Sun or Moon is involved):

| Aspect | Angle | Orb | Value |
| --- | --- | --- | --- |
| Conjunction | 0° | 8 | +0.8 |
| Sextile | 60° | 4 | +0.7 |
| Square | 90° | 6 | −0.6 |
| Trine | 120° | 6 | +1.0 |
| Opposition | 180° | 8 | −0.3 |

`strength = 1 − |deviation| / orb` (0–1).

**Pairs and weights** (A's body × B's body, both directions where different):

| Pair | Weight | Sub-score |
| --- | --- | --- |
| Sun–Moon | 3.0 | Emotional |
| Moon–Moon | 3.0 | Emotional |
| Venus–Mars | 3.0 | Romance |
| Sun–Sun | 2.0 | Communication |
| Venus–Venus | 2.0 | Romance |
| Moon–Venus | 2.0 | Emotional |
| Mercury–Mercury | 1.5 | Communication |
| Sun–Venus | 1.5 | Romance |
| Mercury–Moon | 1.0 | Communication |
| Ascendant–Sun, Ascendant–Moon (only if both times known) | 1.0 | Romance |

**Score**
- `raw = Σ weight × value × strength` over all pairs that form an aspect.
- Element bonus (sun signs): same element +4; fire–air or earth–water +2; otherwise 0.
- `overall = clamp(round(60 + 8 × raw + bonus), 35, 98)`.
- Sub-scores: same formula using only that sub-score's pairs, with multiplier 12 instead of 8, clamped 35–98.
- **Calibration test:** across 10,000 random chart pairs (seeded), the median overall score must be between 62 and 78 and fewer than 5% may be ≤ 40. If not, adjust the base (60) or multiplier (8) — never the clamp — and update this section.
- Light mode (partner time/place unknown): only Sun, Mercury, Venus, Mars pairs (Moon excluded unless it stays in one sign all day), labeled "Light reading".

### 9.7 Golden tests

- `test/features/cosmic/astro/golden_charts.json`: at least 20 charts with known placements (verified against a reputable chart calculator), covering: both hemispheres, DST births, pre-1970 births, births near sign cusps, Bangkok and Yangon births, and one high-latitude birth.
- Assertions: sign match for all bodies and the Ascendant; longitude within 0.5° for planets, 0.3° for the Sun.

---

## 10. Non-functional requirements

| Area | Requirement |
| --- | --- |
| Performance | Cold start < 2.5 s on a mid-range Android (e.g. 4 GB RAM); deck swipes at 60 fps; natal chart computed < 200 ms |
| Size | App bundle download < 40 MB at launch (webp illustrations, subset fonts) |
| Offline | Deck, Journal (cached), Big 3, lucky colors, retrogrades, moon, compatibility score all work offline |
| Accessibility | TalkBack labels, 48 dp targets, text scaling to 1.3×, contrast AA, reduce motion |
| Privacy | Minimal data; no raw birth data to the API; no ads; consent-gated analytics; account deletion in-app and on web |
| Localization | 100% of UI strings in en/th/my at release; Burmese in Unicode |
| Reliability | Crash-free sessions ≥ 99.5% (Firebase Crashlytics) |
| Security | Firestore rules tested in the emulator; API verifies ID tokens; HTTPS only |

## 11. Analytics events (only after consent)

`onboarding_started`, `onboarding_completed`, `sign_in_success`, `card_completed`, `card_swiped {direction}`, `card_shared`, `daily_limit_reached`, `mood_selected {mood}`, `cosmic_today_viewed`, `chart_viewed`, `compat_created {mode}`, `paywall_viewed {source}`, `trial_started`, `purchase_completed {productId}`, `widget_added`, `notification_opened {type}`, `account_deleted`.
Never include birth data, partner names or quote text in event params.

---

## 12. Milestones and checklist

Tick items as they're completed (Claude Code: update this list at the end of each task).

### M0 — Foundation
- [x] Flutter project with dev/prod flavors, lints, CI script (`analyze` + `test`)
- [x] Theme tokens, bundled fonts incl. Noto Sans Thai/Myanmar, dark mode — *partial: tokens + dark mode done; font files not bundled yet, Thai deferred*
- [x] gen-l10n set up with en/th/my ARB files — *en + my done; th deferred until a Thai reviewer is available*
- [x] go_router shell with 3 tabs and placeholder screens
- [x] drift database scaffold
- [x] Content loader for `quotes.json` and `signs.json` with 20 sample quotes — *quotes are en only; my/th text pending*

### M1 — Self-love deck (Android closed test)
- [x] Deck with timer gate (§6.2) and tests — *deferred: Firestore counter sync (M2), mood check-in, share sheet on swipe-up (§6.4, records `shared` only), heart animation, premium upsell on the limit card (M4), midnight reset while open, premium-quote filtering, `my` strings need native review*
- [x] Journal (local first, §6.3) — *deferred: Firestore sync (M2), per-card art beyond the 5 theme pieces, entry to the journal from the Deck header, `my` strings need native review*
- [x] Share as image (§6.4) — *deferred: font check in all scripts (fonts not bundled), share handle value, share-sheet position origin for iPad*
- [x] Daily reminder notification (§6.6, first box; retrograde alerts and FCM are separate)
- [x] Home-screen widget (§6.5)
- [x] Sample-cards-before-sign-in flow — *deferred: Google sign-in and profile steps (M2), mascot art, Burmese strings; sample swipes count toward the day's 10 cards*

### M2 — Accounts and Cosmic basics
- [ ] Firebase project, Google sign-in, onboarding (§6.1) — *code done and tested with fakes: sign-in, local-first profile (drift) with Firestore sync, name / birth date / birth time / reminder / focus steps. Done: dev Firebase project (`mochi-moon-dev`), `google-services.json` for dev, SHA-1, Google sign-in enabled, real sign-in tried on the emulator. Firestore database (`asia-southeast1`) created, rules from §8.1 deployed to dev, and the profile document confirmed in the console. Still open: a prod project with its own `google-services.json` and release SHA-1. Deferred to later M2 items: sun/moon/rising signs.*
- [x] Firestore sync for profile, Journal, deck counters; security rules + emulator tests — *the device stays the source of truth: the journal and the counters (streak, last day, today's count) are mirrored to Firestore while signed in, and cards that only Firestore has are added back on start. Rules tests run with `scripts/test_rules.ps1` (or `.sh`; needs Node, Java, Firebase CLI). Deferred: restoring the streak and today's count after a reinstall (the history is not synced), a removal made offline comes back on the next start (no tombstones), the tightened journal rule is not yet deployed to `mochi-moon-dev`, no prod project.*
- [x] Cities dataset + birthplace search + time zone resolution — *`assets/content/cities/` is built from GeoNames `cities15000` by `tool/build_cities.dart` (34,191 cities, English names only). Search is offline, ignores case and accents, ranks prefix matches first and then by population, and can be narrowed by region or country ("springfield illinois"). The zone comes from `lat_lng_to_timezone` when the city is picked and is stored as `tzId`; a test checks that those ids exist in the `timezone` data. GeoNames (CC BY 4.0) is credited on Flutter's licenses page; there is no Settings licenses screen yet. Deferred: Thai and Burmese alternate names (the dump has no language tags, and Thai waits for a reviewer), editing the birthplace from the Me tab, and the tz database is not initialised at start-up (the astro engine item will do it).*
- [x] Astro engine: Sun/Moon/planets + sun/moon sign (§9.1–9.2) — *`lib/features/cosmic/astro/`: `planetPositions(utc)` (Sun from VSOP87, Moon from Meeus ch. 47 plus nutation, planets with light-time, Pluto precessed from J2000), speed and retrograde flag, `birthInstantUtc` (local time + `tzId` to UTC, noon when unknown; initialises the tz database on first use) and `sunMoonSigns`. `test/features/cosmic/astro/golden_positions.json` holds 23 instants x 10 bodies from JPL Horizons; the worst error is 0.012° (Moon), the rest under 0.007°. Deferred: the Ascendant and `golden_charts.json` with birth data (M3, §9.3 and §9.7), annual aberration (about 20", left out on purpose), ΔT (TT is taken as UT, §9.1), and wiring the signs into the profile on save (see §6.1).*
- [x] Cosmic Today with bundled fallback texts, lucky colors, Thai colors toggle (§6.7) — *the Cosmic tab shows the Sun sign, "Moon in X", a headline and text, energy, love, lucky colors (one from the sign palette, one from the element of the Moon's sign), lucky number, three things to avoid, and the disclaimer. Texts are bundled (`assets/content/fallback_readings/en.json`, two per sign, rotated by day of year) behind a `DailyReadingRepository` so the Readings API can replace them. Thai colors (birthday color and today's color) are off unless switched on in Me, and default on for the `th` locale. Without a birth date the tab asks for one. The sign's bunny art (`ill_zodiac_<sign>.webp`) sits above the header via `ZodiacArt`, which the M3 Big 3 cards and compatibility screen can reuse. Deferred: Thai texts and strings (`TODO_CONTENT`; English is shown instead), color names in English only, the Sun sign uses UTC when no birthplace was given (can be wrong for a birth within a day of a sign change), signs are computed on the fly and not stored on save (§6.1), the "Today's energy" daily-mix card (§6.10), and Premium personalized text.*
- [ ] Cosmic Today from the Readings API with drift cache and language refetch (§6.7, §8.2) — *needs the M4 server; the screen already reads through `DailyReadingRepository`, so only a new implementation and the cache are missing.*
- [x] Retrograde calendar + moon phase engine (§9.5) — *`retrogrades(year)` gives every Mercury, Venus, Mars, Jupiter and Saturn period whose shadows touch the year: both stations (bisected to 1 hour), pre- and post-shadow edges, and the station longitudes. `moonPhase(utc)` gives elongation, illumination, one of eight names, the Moon sign and the next new and full moon (to 1 minute). Checked against hourly JPL Horizons data for 2026–2027 (`golden_events.json`): stations within 2.7 h, shadow edges within 1.8 h, new and full moons within 105 s; the three published Mercury windows match. The scan margin is wider than the 2 months above (120 days for Mercury up to 400 for Jupiter and Saturn), because the slow planets' shadows reach about 3 months past the station. `retrogrades()` takes about 2 s for one year in the test VM; not yet timed on a phone. Outer planets (Uranus to Pluto) are not in the calendar.*
- [x] Translation tool for Burmese strings and readings via OpenAI (§7.1a) — *`tool/translate_content.dart` with validation; Burmese only; Thai is not generated or shipped. Model `gpt-6-luna`, high reasoning. Run on 2026-10-29: all 78 ARB strings in `app_my.arb`, the 12 fallback readings in `my.json`, and the 20 quotes (`text.my` in `quotes.json`, via `--quotes`). **Unreviewed machine translation; the owner reviews the Burmese.** Reviewer notes: `cosmicHeader` appends "ရက်နေ့" after the date; readings use informal "မင်း" while ARB strings mix polite and informal registers; quotes use the feminine "ကျွန်မ" for "I". Strings added to `app_en.arb` later need another run.*
- [x] Retrograde status card, timeline and tips (§6.8) — *the Cosmic tab shows Mercury's status card ("Mercury is retrograde until Nov 13" or "Next Mercury retrograde: Feb 9" with a countdown) that opens `/cosmic/retrogrades`: a card per planet (Mercury, Venus, Mars; Jupiter and Saturn under "More planets") with the status, a year bar for this year and the next showing pre-shadow, retrograde and post-shadow bands and today, the dates as text, and an evergreen tip. Dates are shown in the local time zone. The calendar is computed in an isolate behind `retrogradeCalendarSourceProvider`, so the Cosmic tab shows the card a couple of seconds after it opens. Burmese strings are generated and unreviewed (§12 translation note). Deferred: caching the calendar between launches, the Moon block (§6.8), and per-period tips.*
- [ ] Retrograde alerts (local notifications, §6.6) — *needs the notification setup per planet (Mercury on by default, Venus and Mars off), scheduled 1 day before and on each station from the calendar above. Also open: pairing moon phases with affirmations.*
- [ ] Account deletion (in-app + web page)

### M3 — Charts and compatibility
- [ ] Ascendant/MC/Whole Sign houses (§9.3–9.4) + golden tests
- [ ] Chart wheel and placements list; Big 3 cards
- [ ] Partners CRUD; compatibility scoring (§9.6) + calibration test; result screen

### M4 — AI and monetization
- [ ] Readings API client + caching (§8.2)
- [ ] Server: nightly generation, reports endpoints, purchase verification (separate repo)
- [ ] Paywall, Play Billing products, entitlement from Firestore, restore
- [ ] Full natal and compatibility reports
- [ ] For You deck with embeddings (§7.2); daily mix card
- [ ] Analytics with consent, Crashlytics

### M5 — Launch
- [ ] 500 quotes and 60–100 illustrations in all languages, human-reviewed
- [ ] Store listing (self-love first), screenshots in en/th/my, privacy policy, Data safety form
- [ ] Closed test with ≥ 15 testers for 14+ days (Google Play requires 12 for 14 days on new personal accounts)
- [ ] Production release timed with a retrograde window (Feb 9, 2027 is the next Mercury retrograde)

### Later
- [ ] iOS build with Sign in with Apple and self-love-first App Store positioning
- [ ] Listen mode (TTS) for accessibility
- [ ] Placidus houses option
- [ ] More mascot outfits and seasonal decks

---

## 13. Open questions

- Domain name and API host (`api.<domain>`).
- Final price points per region (set in Play Console; suggested anchors: yearly ≈ 6× monthly).
- Who reviews Thai content (native reviewer needed), and who reviews the OpenAI-generated Burmese (§7.1a).
- Whether to register a Play **organization** account (needs business verification but skips the closed-testing requirement) or a personal one.
