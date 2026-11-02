# Mochi Moon — Product Requirements Document

| | |
| --- | --- |
| Product | Mochi Moon: Self-Love & Zodiac |
| Owner | Thatoe |
| Version | 1.1 (draft) |
| Date | 2026-10-31 |
| Platforms | Android first; iOS later |
| Languages | English (source), Burmese; Thai when a native reviewer exists |
| Engineering rules | See `CLAUDE.md` (it wins on engineering; this PRD wins on product behavior) |

---

## 1. Summary

Mochi Moon is a cute, illustrated **self-love app** for young women. The core promise is a **2-minute daily self-love ritual**: say how she feels, read three affirmation cards aloud, write one thing she is grateful for, and watch her streak and her moon bunny grow. Around the ritual sit a swipe deck of affirmation cards, a gratitude and wins jar, her own cards, a mood calendar, breathing, tiny kindness quests, self-love journeys, letters to her future self and a hard-day kit.

Astrology is a **supporting layer**, not the identity: a "Cosmic you" tab with Western astrology (daily guidance, lucky colors, things to avoid, retrograde alerts, moon phase, birth chart, love compatibility). Birth data is asked for the first time she opens that tab. AI works in the background only (written readings, the weekly letter from Mochi, personalized deck ranking); there is no chat.

## 2. Goals and non-goals

### Goals

1. Build a daily self-love ritual: open, check in, read 3 cards aloud, one grateful line, streak, come back tomorrow (about 2 minutes).
2. Be useful on hard days: breathing, comforting cards, her own wins, and help resources, without ever posing as therapy.
3. Go deeper over time: self-love journeys, her own cards, letters to her future self, and a moon bunny that grows with her.
4. Make astrology a gentle reward and a curiosity, personal and warm, computed from her real birth data.
5. Monetize through a freemium subscription (self-love value first) and one-off compatibility reports.
6. Work offline for core features; stay cheap to run (on-device astro math, on-device insights, cached readings).

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

Bottom navigation (4 tabs):

1. **Today** (home) — the daily ritual (§6.15), streak, the "Hard day?" button (§6.26), today's quest (§6.20), and today's cosmic card as the ritual's last reward (or the "Unlock your cosmic side" prompt until she has given birth data).
2. **Deck** — the self-love swipe deck (§6.2) with her own cards in the rotation (§6.17), the mood check-in, and the hard-day button.
3. **Cosmic** — a locked state ("Unlock your cosmic side") until birth data is given, then Today, Retrogrades, Moon, Birth chart, Love match and the Premium natal report. Everything in §6.7–§6.12.
4. **Me** — Journal, gratitude jar (§6.16), mood calendar (§6.18), journeys (§6.21), letters (§6.22, §6.24), Mochi's room (§6.23), monthly recap (§6.25), profile, partners, Premium, settings.

Paywall is a modal route reachable from locked items (§6.13 lists every entry point) and from one dismissible trial offer (§6.13). It is never reachable from inside the ritual, the hard-day kit, breathing or Help.

---

## 6. Feature specifications

Each feature lists user stories and acceptance criteria (AC). "Free" and "Premium" mark entitlement.

### 6.1 Onboarding and sign-in

**Flow (v1.1):** Splash → **language** (first step, before anything else) → 3 sample cards (no account) → "Save your cards and your streak" → Google sign-in → name → focus areas (up to 3) → reminder time → done → Today. **Birth date, birth time and birthplace are no longer part of onboarding**; they are asked the first time she opens the Cosmic tab ("Unlock your cosmic side", see below).

*Built today (v1.0): the order was sample cards, sign-in, name, birth date, birth time, birthplace, reminder, focus. The v1.1 items below change it.*

**User stories**
- As a new user, I pick my language before I see anything else, so I never have to read a language I do not know.
- As a new user, I can try 3 cards before signing in, so I understand the app first.
- As a user, I can sign in with Google in one tap.
- As a user, I can say "I don't know my birth time" and still continue (in the Cosmic unlock flow).
- As a user who only wants self-love, I am never asked for birth data.

**AC**
- [ ] **(Post-launch)** **Ask the language first.** *Deferred 2026-11-02: v1 launches in English only. The language screen, the Me picker and `app_my.arb` stay in the repo; flip `burmeseEnabledProvider` to bring them back and re-add the `LanguageScreen` route.* Original spec: The very first screen after the splash is a language choice (System / English / Burmese, the same choices as the Me tab picker), shown before the welcome screen and the 3 sample cards. Each option is written in its own language and script so it reads before any language is set. The choice is saved at once and applies to the cards, the profile steps, the Cosmic readings (`lang`) and the reminder texts. It is also the first screen after account deletion restarts the app. — *planned for the next session (owner request, 2026-10-30); today the cards start in the device language and the picker is only on the Me tab (§12 M2).*
- [x] 3 sample cards work without network or account; the timer gate applies. — *shown after a welcome screen; the "save your cards" step is the Google sign-in button*
- [x] Google sign-in via Firebase Auth; on success a `users/{uid}` doc is created (§8.1). — *verified on the Android emulator against the dev project (`mochi-moon-dev`): the Auth user is created, the profile steps run, and `users/{uid}` appears in Firestore with name, locale, profile and settings. Sign-in waits up to 10 s for the first Firestore read when the network is slow. Without Firebase config the button carries on signed out. An account that already has a complete `users/{uid}` profile skips the profile steps.*
- [x] Birth date is required **to unlock Cosmic** (date picker; year range 1940–current year; no future dates).
- [x] Birth time is optional; "I don't know" sets `timeKnown = false`.
- [x] Birthplace is required when birth time is given, optional otherwise. Search is offline over the bundled cities list (§8.5), showing "City, Region, Country". — *the step sits between birth time and reminder; picking a city stores `place` with its `tzId`.*
- [x] On save, the app computes and stores sun sign (always), moon sign (always; flagged approximate when time unknown), rising sign (only when time known). — *the signs are derived in `signsOfProfile` and written into `users/{uid}.profile` on every Firestore upsert; the device copy recomputes them from the birth data.*
- [x] Reminder time defaults to 08:00 local; user can skip. — *v1.1 puts it after focus areas, as the last step.*
- [x] Focus areas: Self-love, Confidence, Healing, Study & work, Body kindness, Calm (multi-select, up to 3).
- [ ] The whole flow works in en/th/my and respects text scaling. — *text scaling 1.3× is tested; the new profile strings are English only (`my` falls back to English, `th` is deferred)*
- [x] Back navigation never loses entered data within the flow.

**Changes in v1.1 (self-love first)**
- [x] Onboarding order is: language, 3 sample cards, Google sign-in, name, focus areas, reminder time, done. No birth data is asked. A profile is complete with a name alone (`hasAccountProfile`); birth data is a separate state (`hasBirthData`).
- [x] **Unlock your cosmic side:** the first time she opens the Cosmic tab without birth data, it shows a friendly locked state (mascot, one sentence, one button) instead of an error. The button opens the birth steps (birth date, then birth time or "I don't know", then birthplace when the time is given), then Cosmic opens. She can leave at any step and keep using every self-love feature; the locked state shows again next time.
- [x] The chart, the compatibility result, the natal report and Cosmic Today show the locked state with an "Unlock" button when birth data is missing. The Moon card and the retrograde calendar need no birth data and stay visible. *Today's cosmic reward card is built (P12): it shows the unlock prompt until birth data is given.*
- [ ] Editing birth data from Me → Profile still works; clearing it is not offered.
- [x] **Profile astro fields are nullable.** `birthDate`, `birthTime`, `place`, `sunSign`, `moonSign`, `moonApproximate` and `risingSign` may all be absent, in Firestore and in the local profile. `timeKnown` only matters with a birth date.
- [ ] **Migration for existing users:** nothing is erased. A profile that already has birth data keeps it and its derived signs and skips the Cosmic unlock. A profile with a name but no birth date is now complete. The app must accept Firestore documents without `profile.birthDate` (the codec already returns empty fields instead of failing). The security rules do not validate the `profile` map, so they need no change for this, and the local drift `ProfileCache` stores the same JSON map, so it needs no migration. Tests: a name-only profile, a legacy full profile, and a Firestore document missing the signs.

### 6.2 Self-love deck (Free: 5 new cards a day; Premium unlimited)

**User stories**
- As a user, I see one illustrated affirmation card at a time and must read it aloud before swiping.
- I swipe right to save ("This is me"), left for the next card, up to share.

**Behavior**
- Card layout: illustration (top ~60%), affirmation text, small category chip, timer ring.
- **Timer gate:** lock duration = `max(3.0, wordCount / 2.5)` seconds, capped at 8 s. The ring fills while locked; card swipes and the action buttons are disabled until full. A gentle haptic + sparkle plays when unlocked. A small hint under the ring reads "Read it out loud ✨" (localized).
- Swipe right → saved to Journal, heart animation. Swipe left → next. Swipe up → share sheet (§6.4). Undo the last swipe (1 level).
- Deck source order: For You ranking (§6.9) if enough history, otherwise focus-area weighted random without repeats in 30 days.
- **Free limit (M4b, 2026-11-02; was 10):** 5 new cards per local day, **ritual and deck cards only**. Cards read inside the daily ritual (§6.15) count toward the same 5 (ritual 3, then 2 more in the deck). The 3 onboarding sample cards, cards read on a journey day (§6.21) and the hard-day kit's cards do **not** use up the 5, but they still count for the streak. After the limit, show a friendly "You're glowing — come back tomorrow" card with a gentle Premium invitation (`deck_limit`, no countdown, no guilt copy). Premium has no limit. Journal and reshares stay unlimited.
- If fewer than 3 cards are left when the ritual starts, the ritual uses what is left and still completes (§6.15).
- Mood check-in (optional) at the top: 6 emoji moods (happy, calm, tired, sad, anxious, in love). Choosing one re-ranks the next cards. v1.1: the choice is also stored as the day's mood (§6.18). *Built (P9): the Deck has the check-in; a mood she already chose today re-ranks the deck when she opens it.*
- Her own cards (§6.17) join the rotation.

**AC**
- [x] Swipe attempts before the timer completes are cancelled and the card springs back. — *widget test `a swipe before the timer ends is cancelled`.*
- [x] After the timer completes, all three swipe directions work, plus button equivalents for accessibility. — *widget tests cover right, left and up, and that the three buttons are disabled until the ring is full and enabled after.*
- [x] The daily counter resets at local midnight; it is stored locally and synced to Firestore. — *synced since M2 (`users/{uid}.deck`); an open deck is dealt again by a timer at local midnight, and on returning to the app if the day changed meanwhile (unlocked cards are cleared, so the read-aloud timer applies again). The Firestore copy updates with the next swipe, not at midnight itself*
- [x] "Reduce motion" disables tilt and sparkle animations but keeps the ring. — *follows the system setting and the new Me-tab switch (tested)*
- [x] Works offline using bundled quotes. — *the deck reads the bundled `quotes.json` and the local drift database; the only network part is the Firestore counter sync, which is local-first and retried later.*
- [x] Streak: a day counts when ≥ 1 card is completed; streak shown on the Deck header. — *v1.1: a day also counts when the daily ritual (§6.15) is completed, and the streak shows on Today too. Missing a day never shows punishing copy.* — *`deck_planner_test` covers the count (a streak reaching yesterday stays alive until today ends); `the streak shows in the app bar once a card is done` covers the header.*

### 6.3 Journal (Free)

- [x] Lists saved cards newest first with illustration thumbnails; tap opens full card; long-press to remove.
- [x] Filter by category. Synced via Firestore so it survives reinstall. — *sync is done (`users/{uid}/journal/{quoteId}`); the category filter is in `journal_screen.dart` and tested (`filters by category`)*
- [x] Empty state with the mascot and a prompt to swipe right on cards she loves. — *uses `ill_empty_deck.webp`*

### 6.4 Share as image (Free)

- [x] Generates a 1080×1920 PNG story image: card illustration, text, subtle "Mochi Moon" wordmark and handle. — *handle comes from `--dart-define=SHARE_HANDLE`, omitted until set; the illustration is the card's theme art*
- [x] Uses the system share sheet (`share_plus`). No social SDKs.
- [ ] Rendering works in all three scripts with correct fonts. — *blocked on bundling fonts (M0 leftover); Burmese renders through the `Noto Sans Myanmar` fallback once bundled*

### 6.5 Home-screen widget (Free default theme; extra themes Premium, later)

Extra widget themes are Premium but are not built; they are listed under "Later" (§12). The default theme stays free.

- [x] Android widget (2×2 and 4×2) shows today's card text (short form) and a thumbnail. — *the thumbnail is the card's theme art (decoded before capture, not yet seen on a device); English only; builds and is unit-tested but not yet seen on a device*
- [x] Updates at local midnight and whenever the deck is opened. — *the app stocks the next 14 days on each open; midnight refreshes are scheduled with `home_widget` (inexact, may drift a few minutes); a 1-hour system refresh is the safety net*
- [x] Tapping opens the Deck at today's card. — *the launch intent carries `mochimoon://widget/deck`; the deck deals the card of the day first unless it was already completed today*

### 6.6 Notifications (Free)

- [x] Daily reminder at the chosen time with today's card first line (scheduled locally). — *set from a tile on the Me tab until onboarding exists; the next 14 days are scheduled and rebuilt on each app open; inexact alarms, so it can drift a few minutes*
- [x] Retrograde alerts: 1 day before a station and on the station day, scheduled locally from the computed calendar (§9.5) for Mercury (default on), Venus and Mars (default off). — *M4b: **Mercury alerts stay free; Venus and Mars alerts are Premium** (`retro_alerts`). A free user sees those two switches locked with a soft preview and nothing is scheduled for them. If Premium lapses, the two switches turn off and are shown locked again; her choice is kept so it comes back on re-subscribing.*
- [x] FCM topic `announcements` for rare app news (default on, can be turned off). — *done: an "App news" switch on the Me tab (on by default, saved locally as `announcements`) joins or leaves the `announcements` topic through `firebase_messaging`, and the app matches the topic to the switch on every open, so a change made offline is retried. Without Firebase (an early dev build) the choice is saved and no topic is touched. Not yet tried on a device: nothing sends to the topic until the owner's Firebase project does (a server or console message to `/topics/announcements`). Burmese is machine-translated and unreviewed.*
- [x] Android 13+ notification permission requested after onboarding with a pre-prompt explaining why. — *pre-prompt and request are in place, triggered from the Me tile; moving the trigger to the end of onboarding is part of the onboarding item*

### 6.7 Cosmic — Today (Free: headline, text, one lucky color; depth and personal layer Premium)

Shows for the user's local date. **M4b (2026-11-02) rebalance:** the free page is a short, pretty daily reading; depth is Premium. Locked blocks show a soft preview (the first line, or a blurred block, with a lock chip) and never disappear; one tap opens the paywall with source `cosmic_today` (`sign_chooser` for the chooser).

| Block | Free | Premium |
| --- | --- | --- |
| Headline + daily text for her sun sign | ✓ | ✓ |
| Moon card (§6.8) | ✓ | ✓ |
| Lucky color #1 (from the sign palette) | ✓ | ✓ |
| Lucky color #2 (from the Moon's element) | — | ✓ |
| Love line | — | ✓ |
| Lucky number | — | ✓ |
| Things to avoid (3 short items) | — | ✓ |
| Personalized text based on transits to her natal chart (`POST /daily/personal`, not built) | — | ✓ |
| Today's energy card (daily mix, §6.10) | ✓ | ✓ |
| Thai birthday color + today's Thai day color (toggle, Thailand phones only) | ✓ | ✓ |
| Read another sign's page (sign chooser, a row of 12 chips above the art; the user's own sign is marked "(you)") | — | ✓ |

The ritual's cosmic reward card (§6.15) shows the energy line and the first lucky color to everyone; it carries no upsell. The locked blocks are gated in the app only: `GET /daily` is nightly cached content with no per-call cost (§8.2).

**Lucky colors**
- Each sign has a palette of 4–6 named colors in `signs.json`.
- Today's lucky color = `palette[(dayOfYear + signIndex) % palette.length]`, plus a second color from the element of the Moon's current sign (fire: warm reds/oranges, earth: greens/browns, air: yellows/sky blues, water: blues/sea greens).
- Thai colors (setting `showThaiColors`; **only for phones whose region is Thailand** (`inThailandProvider`), never shown anywhere else, default on there): Sunday red, Monday yellow, Tuesday pink, Wednesday green, Thursday orange, Friday blue, Saturday purple. Show "Your birthday color" (weekday of birth date) and "Today's color".

**Sign chooser (owner decision, 2026-10-29):** Premium. It is a stack-of-cards icon at the top right of the Cosmic app bar (owner decision, 2026-10-30; it replaced the scrolling chip row) that opens a bottom sheet with the 12 signs; the user's own sign is marked "(you)" and picking a sign closes the sheet. Until billing exists (M4), `hasPremiumProvider` returns true, so everyone has it; M4 replaces that one provider with the real entitlement. The choice is view state only: it resets when the Cosmic tab is left, and the user's birthday color is hidden on another sign's page.

**AC**
- [x] Text comes from the Readings API (§8.2), cached per date/sign/lang; offline falls back to cache, then bundled fallback text. — *client, drift cache and fallback order are done and tested; the app uses them once `READINGS_API_URL` is set, so real calls wait for the server (repo `mochi-moon-api`). Premium endpoints come later.*
- [x] Every reading block shows the note "For entertainment and self-reflection". — *checked: it shows on Cosmic Today, Retrogrades, the birth chart, the compatibility result and About, each with a widget test. Premium report screens (M4) must add it too.*
- [x] Changing app language refetches in the new language.

### 6.8 Cosmic — Retrogrades and Moon (Free; Venus and Mars alerts Premium)

The retrograde status, the banner, the calendar, the tips and the Moon card are free. Mercury alerts are free; Venus and Mars alerts are Premium (§6.6).

**Retrogrades**
- [x] ~~Status card~~ replaced (owner decision, 2026-10-29): an always-visible "Retrogrades" button opens the Retrogrades screen; since 2026-10-30 it is a full-width banner pinned under the Cosmic app bar so it is easy to see. The card appeared only after the ~2 s calendar scan and vanished again when scrolled away. The scan now runs once per session (`retrogradePeriodsProvider` is kept alive) and starts when the Cosmic tab opens, so the screen opens with it ready.
- [x] ~~Timeline with pre-shadow, retrograde, post-shadow bands~~ replaced (owner decision, 2026-10-29): the Retrogrades screen shows only the planets that are retrograde now, each with its gentle tips as the main content, then a month calendar (this year and next) that colors the retrograde days per planet. No shadow bands and no date lists. Upcoming retrogrades reach the user through the heads-up notifications, whose switches now sit on this screen.
- [x] Each period has short evergreen tips per planet (bundled content). — *one tip per planet, in the ARB files, shown on each planet's card rather than on each period.*
- [x] Dates computed on-device (§9.5) and displayed in the user's local time zone.

**Moon**
- [x] Current phase name, illumination %, moon sign, next new and full moon dates. — *a "Moon" card on Cosmic → Today (`lib/features/cosmic/moon/`), shown with or without a birth date: a drawn moon glyph, phase name, "% lit", "Moon in X", and the next new and full moon as local dates. Computed on the phone (`moonNowProvider`, no isolate) from the clock; it is recomputed when the provider is rebuilt, not at midnight while the app stays open. The "Moon in X" line that used to sit under the page header moved into this card. Owner decision, 2026-10-30: a card on Today, not a separate screen.*
- [x] Pairs with a matching affirmation (e.g. new moon → intentions). — *eight short bundled affirmations, one per phase, in the ARB files (`moonAffirmation*`). They are not drawn from `quotes.json`, which has no moon tags; matching quotes by tag waits for the content milestone and the daily-mix card (§6.10).*

### 6.9 For You deck (Premium)

- Ranks cards using quote embeddings (§7.2): her right-swipes, shares and mood check-ins form a preference vector; cards are ranked by cosine similarity with exploration.
- [ ] Requires ≥ 10 right-swipes; before that, show a progress state ("Mochi is learning what you love — 6/10").
- [ ] Mix: 70% top-ranked, 30% exploration from unseen categories.
- [ ] Runs fully on-device; no swipe data leaves the phone except the synced Journal.

### 6.10 Daily mix — "Today's energy" (Free)

- [ ] A card on Cosmic → Today combining the server's per-sign "energy" line with a matching affirmation (selected by tag/embedding match on-device).
- [ ] Tapping it opens the card in the deck flow (timer applies).

### 6.11 Birth chart (wheel, Big 3 and signs Free; details and full reading Premium)

**Display**
- Chart wheel (CustomPainter): zodiac ring, Whole Sign houses (if time known), planet glyphs at their degrees, aspect lines (major aspects only). **M4b: free users see the wheel without aspect lines; Premium draws them** (`chart_details`).
- Placements list: Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto, plus Ascendant and MC if time known. **Free rows: glyph, sign, ℞ if retrograde. Premium rows add the degree (e.g. 12°34′) and the house**; locked degree and house cells show a soft preview.
- Premium also gets a plain-language **aspects list** (deferred in §12 M3; it is built as part of M4b).

**Readings**
- Free: Big 3 cards (Sun, Moon, Rising) with short bundled texts.
- Premium: full AI natal report (§8.2 `POST /v1/reports/natal`) as a 5 to 10 minute read of 13 parts (12 without a birth time): Overview, Core self (Sun), Emotions (Moon), First impression (Rising, needs a birth time), Mind (Mercury), Love (Venus), Drive (Mars), Work (Midheaven, Saturn), Money (values and habits only, never earnings or outcomes), Friends and family, Growth (Jupiter, Saturn), Gentle edges (hard aspects, retrogrades), Self-love ritual. Written part by part, so the screen fills in as the server works. Generated once per chart per language and saved on the device; asked for again only if the birth data changes.

**AC**
- [x] Unknown birth time: no Ascendant, no houses, Moon marked "approximate"; banner invites adding the time. *(the banner explains why but cannot link anywhere yet: there is no screen to edit birth data)*
- [ ] Editing birth data recomputes everything and invalidates cached reports. — *on the device the chart, Cosmic Today and compatibility follow a saved edit (tested); invalidating server-side cached reports waits for the Readings API in M4.*
- [x] Golden tests pass (§9.7). — *`golden_charts.json` holds 32 charts (both hemispheres, DST, pre-1970, sign cusps, Bangkok and Yangon, 69.6°N, unknown time); signs of all bodies and the Ascendant match, planets within 0.5° and the Sun within 0.3° (`natal_chart_test.dart`).*

### 6.12 Love compatibility (overall score Free; sub-scores, aspects and 5 partners Premium; full report Premium or one-off purchase)

**Input:** partner nickname + birth date (required), birth time and place (optional). Up to 5 saved partners (Free: 1; the 2nd opens the paywall, source `partners`).

**Output**
- Overall score 35–98% with a cute meter and a one-line summary. **Free.**
- Three sub-scores: Romance, Emotional, Communication. **Premium** (`compat_details`; free users see them blurred with a lock chip).
- Top 3 supportive aspects and top 2 growth aspects in plain language (bundled short texts per aspect type). **Premium** (`compat_details`).
- If Premium lapses, saved partners stay listed and keep their overall score; adding a new one is blocked above the free limit.
- Premium / one-off: full AI compatibility report (§8.2) with sections: Your chemistry, How you love, How you talk, Where you grow, A gentle tip.

**AC**
- [x] Scoring follows §9.6 exactly and is deterministic for the same inputs.
- [x] Sun-sign-only mode when partner time/place unknown is clearly labeled "Light reading".
- [x] Partner data is stored only in the user's Firestore subcollection and can be deleted individually.
- [x] Copy never says a relationship will fail or succeed.

### 6.13 Paywall and purchases

| Product ID | Type | Notes |
| --- | --- | --- |
| `mochi_premium_monthly` | Auto-renewing subscription | No trial |
| `mochi_premium_yearly` | Auto-renewing subscription | 7-day free trial |
| `mochi_compat_report` | Consumable (one report credit) | Unlocks one full compatibility report |

**Free/Premium rebalance (M4b, 2026-11-02).** The free tier was too generous (Play median download-to-paid is under 1%), so Premium must feel clearly worth it. Free keeps the daily habit and every safety feature; Premium is depth, personalization, collection and AI.

**Principles (apply to every decision and every future feature)**
1. The daily ritual (§6.15) stays fully usable for free. The habit itself is never paywalled.
2. Safety is always free: the hard-day kit, the breathing inside it and the Help section (§6.26). No paywall or upsell appears inside them, and the trial offer is not shown on a day she opened the kit.
3. Never take away what she made. Saved Journal cards, gratitude entries, written and sealed letters, own cards, partners, mood days, journey progress and a saved natal report stay readable and deletable even when she is over a free limit (for example after Premium lapses). Limits block only creating **new** ones. Over-limit own cards stay in her rotation; saved partners stay listed with their overall score; a cached report stays readable; an equipped Premium outfit stays equipped until she changes it.
4. Upsells are gentle and follow the tone rules: no guilt, no countdown pressure, no "you're missing out" copy.
5. AI that costs money per call is Premium, and **the server enforces it** (§8.2), not only the app.

**What is Free and what is Premium**

| Feature | Before | After | Reason |
| --- | --- | --- | --- |
| Daily ritual §6.15 | Free | Free, unchanged | The habit is never paywalled |
| Deck §6.2 | 10 a day, all sources count | 5 a day (ritual and deck only); Premium unlimited | Depth; day 1 and journeys never run short |
| Journal §6.3 | Unlimited | Unlimited | Saving what she loves |
| Mood check-in and calendar §6.18 | All history free | Current and previous calendar month free; older months soft preview; insights Premium | Depth; her data is kept |
| Gratitude jar §6.16 | Free | Free | Habit and hard-day use |
| Own cards §6.17 | 3 free | 1 free; Premium unlimited | Collection |
| Breathe §6.19, hard-day kit §6.26 | Free | Always free, no upsell inside | Safety |
| Quests §6.20 | Quest and 1 swap free | Quest free; swap Premium | Small personalization perk |
| Journeys §6.21 | 1 free | 1 free (Confidence), the other three Premium | Unchanged |
| Letter to future me §6.22 | Unlimited | 1 sealed letter at a time free; Premium unlimited; opened letters are always readable | Collection |
| Mochi §6.23 | Free items earned; Premium items need Premium | Unchanged | — |
| Weekly letter §6.24 | Premium, app-only check | Premium, server-enforced | Per-call AI cost |
| Monthly glow recap §6.25 | Free | Free | Sharing and growth |
| Widget §6.5 | Free | Default theme free; extra themes Premium (not built) | Collection |
| Cosmic Today §6.7 | Most blocks free | Headline, text, first lucky color, energy card, Thai colors free; second color, love line, lucky number, avoid, personal text, sign chooser Premium | Depth |
| Retrogrades and Moon §6.8 | Free, all alerts free | Status, calendar, tips, Moon card and Mercury alerts free; Venus and Mars alerts Premium | Depth |
| Birth chart §6.11 | Wheel, list, Big 3 free | Wheel without aspect lines, Big 3, signs-only list free; aspect lines, degrees, houses, aspects list and natal report Premium | Depth and AI cost |
| Compatibility §6.12 | Score, sub-scores, aspects free; 1 partner | Overall score and summary, 1 partner free; sub-scores, aspects, up to 5 partners Premium; full report Premium or `mochi_compat_report` | Depth and AI cost |
| For You deck §6.9 | Premium | Premium | — |

All quotes are free to read (§8.3): Premium means more cards per day and personal ranking, not exclusive quotes.

Premium unlocks, in this order on the paywall (self-love value first): unlimited deck and the For You deck, all self-love journeys (§6.21), the weekly letter from Mochi (§6.24), mood history and insights (§6.18), unlimited own cards (§6.17) and sealed letters (§6.22), the daily quest swap (§6.20), Mochi's premium outfits and room items (§6.23), then the astrology extras: love line, lucky number, things to avoid, second lucky color, the sign chooser, personalized Today, full placements and aspects, the full natal report, compatibility sub-scores and aspects, up to 5 partners, full compatibility reports, Venus and Mars retrograde alerts, and widget themes (later).

**Soft previews.** A locked item never disappears. It shows a soft preview (blurred content or its first line) with a small lock chip; one tap opens the paywall with the right `source`. One shared widget (`PremiumPreview`) does this, with a TalkBack label that says what is locked. The preview text is not a pressure message.

**Paywall entry points** (each logs `paywall_viewed {source}`, §11)

| Place | What is locked | `source` |
| --- | --- | --- |
| Deck limit card | More cards today | `deck_limit` |
| Deck "For You" | The For You deck | `for_you` |
| Journeys list or page | Journeys after Confidence | `journey` |
| Own cards, 2nd card | Unlimited own cards | `own_cards` |
| Letters, 2nd sealed letter | Unlimited sealed letters | `letters` |
| Quest card, swap | The daily swap | `quest_swap` |
| Mood calendar, older month | Full history | `mood_history` |
| Mood insights card | Insights | `mood_insights` |
| Mochi's room, Premium item | Premium outfits and items | `mascot_item` |
| Weekly letter teaser (Sundays) | The weekly letter | `weekly_letter` |
| Cosmic Today locked blocks | Love, number, avoid, 2nd color, personal text | `cosmic_today` |
| Sign chooser icon | Other signs | `sign_chooser` |
| Chart: wheel aspects, list degrees, houses, aspects list | Chart details | `chart_details` |
| Chart: natal report card | The full reading | `natal_report` |
| Compatibility details | Sub-scores, aspects | `compat_details` |
| Compatibility report | The full report (Premium or one-off) | `compat_report` |
| Partners, 2nd partner | Up to 5 partners | `partners` |
| Retrogrades, Venus or Mars switch | Venus and Mars alerts | `retro_alerts` |
| Today, once after the ritual on day 2 or 3 | The trial offer | `trial_offer` |
| Me, Premium tile | — | `me` |
| Server answers 402 `premium_required` | — | `server_402` |

The paywall is **never** opened from the ritual flow, the hard-day kit, breathing, Help or onboarding.

**Trial offer (owner decision, 2026-11-02).** Shown once, as a dismissible card or sheet on Today, right after she finishes the ritual on her 2nd or 3rd active day (ritual days). It is not shown at the end of onboarding, never on a day she opened the hard-day kit, never to a Premium user, and not again once dismissed or seen (a flag in `shared_preferences`; logs `trial_offer_shown` and `trial_offer_dismissed`). The copy says what the 7 days include and when billing starts, with no countdown and no "last chance" wording. Dismissing it costs nothing.

**No grandfathering.** The app is not launched, so there are no existing users to protect. Testers' data that exceeds a new limit simply follows the lapse rule above (principle 3).

**AC**
- [x] Prices come from Play Billing (localized currency); never hardcoded. — *Done 2026-11-02: `PlayPurchaseCatalog` (`features/paywall/data/`, `in_app_purchase`) reads the store price (the recurring phase, not the free trial phase) and picks the trial offer for yearly. Not tried on a device yet: it needs the two products in Play Console. `in_app_purchase_android` was added as a direct dependency (it is the platform half of `in_app_purchase`, already in the build) to read offer details.*
- [ ] Purchases are verified server-side (`POST /v1/purchases/verify`), which writes `entitlement` to Firestore; the app reads entitlement from Firestore only. — *App side done 2026-11-02: `hasPremiumProvider` reads `users/{uid}.entitlement` (`features/paywall/`), false until known or without an account; debug builds can pass `--dart-define=PREMIUM_OVERRIDE=true` to try Premium screens. Server side built 2026-11-02 in `mochi-moon-api` (commits 254176c, cbc0e9f): `POST /v1/purchases/verify` asks Google Play, acknowledges, and writes the entitlement; `POST /v1/purchases/notifications` (Pub/Sub push) keeps it right on renewal, lapse and cancellation. NOT deployed or tried against Play: waiting on the owner's Play developer account (identity verification pending), the Play service account (`PLAY_PACKAGE_NAME`, `PLAY_SERVICE_ACCOUNT_FILE`), and the Pub/Sub topic and push subscription (`RTDN_AUDIENCE`, `RTDN_SERVICE_ACCOUNT_EMAIL`). Box stays open until a real test purchase works.*
- [ ] Restore purchases button. Clear trial terms and a link to manage subscriptions in Play. — *Restore and trial terms done 2026-11-02. A purchase is sent to `POST /purchases/verify` as `{productId, purchaseToken}` and acknowledged to Play only after the server accepts it; until that endpoint exists, nothing is acknowledged (Play refunds unacknowledged purchases after 3 days). Manage-subscription link done 2026-11-02 (`url_launcher`, owner-approved): a button on the paywall and a "Mochi Moon Premium" tile on Me (free → paywall, Premium → the Play subscriptions page). Open: the compat-report credit product.*
- [ ] **(M4b)** The paywall's 3 bullets read, self-love value first: "Unlimited cards and the For You deck", "Every self-love journey", "A weekly letter from Mochi"; the full benefit list follows in the order above. Every entry point in the table logs its `source`.
- [x] Paywall shows: mascot, 3 benefit bullets (journeys, weekly letter, unlimited cards first), yearly plan preselected with trial, monthly option, close button visible immediately. *Built 2026-11-02 as `features/paywall/presentation/paywall_screen.dart` at `/paywall?source=...`; prices come from a `PurchaseCatalog` interface (stub `UnavailablePurchaseCatalog` until Play Billing is connected, so the buy button is off and says so); Restore button; logs `paywall_viewed {source}`. Entry points: locked journey, own-card limit dialog. Still open: real Play Billing, server `POST /v1/purchases/verify`, entitlement from Firestore, a manage-subscriptions link, `hasPremiumProvider` stays true.*

### 6.14 Settings and account

- [x] Language: System / English / ไทย / မြန်မာ. Done as System / English / မြန်မာ (Me tab → Language); Thai joins when it has a native reviewer.
- [x] Notifications: reminder time, retrograde alerts per planet, announcements. — *all three are on the Me tab (reminder time, retrograde alerts for Mercury/Venus/Mars, and App news; see §6.6).*
- [x] Show Thai colors toggle. Reduce motion toggle (also follows system). — *the switch speaks to every screen as the system "remove animations" signal; Burmese text is machine-translated and unreviewed*
- [x] Edit profile from the Me tab: name, birthday, birth time (and later birthplace) and focus areas, reusing the onboarding profile steps. Manage partners. — *requested during M2; done as `/me/profile` (name, birthday, birth time with "I don't know", birthplace, focus areas; Save is off until the form is valid and changed). Partners are managed from the Me tab too. The Burmese strings for it are machine-translated and unreviewed.*
- [ ] Privacy policy, Terms, "About readings" (entertainment notice), licenses. — *"About readings" and the open-source licenses are done (Me → About, `/me/about`). Privacy policy and Terms are built as draft pages on the Readings API server (`/privacy`, `/terms`) and linked from Me → About via `url_launcher`. Open: deploy the server, and the owner fills the `TODO_CONTENT` items (contact, legal name, effective date, AI provider, retention, minimum age, governing law, liability, refunds) and reviews the text.*
- [x] Analytics consent toggle (default off until the consent prompt is answered). — *done: a one-time friendly dialog the first time the main screens show (both answers equally easy), and a "Share anonymous usage" switch on the Me tab; the answer is stored locally (`analytics_consent`; unanswered counts as off). `AnalyticsLogger` does nothing unless consent is on and drops any parameter an event does not list (§11 events only). Deferred: the sink is a no-op until `firebase_analytics` is approved (nothing leaves the device), and syncing `settings.analyticsConsent` to Firestore. Account deletion clears the answer with the other local data. The Burmese strings are machine-translated and unreviewed.*
- [ ] **Delete account** (audited 2026-11-02: `FirestoreAccountRemote.subcollections` lists journal, partners, gratitude, customCards, moods, letters, journeyProgress and state, a test keeps it in step with `firestore.rules`, and the server uses `recursive_delete`; every future subcollection must be added to both): two confirmations ("Delete your account?", then "Are you completely sure?"), a silent Google re-check of the signed-in account before anything is erased (backing out of it changes nothing), a progress dialog, and then the whole app restarts at the first-run screens → calls `DELETE /v1/account` → server deletes Firestore data (the user document and **every subcollection**: `journal`, `partners`, `reports`, `gratitude`, `customCards`, `moods`, `letters`, `journeyProgress`, `state`), reports, weekly letters, and the Auth user → app clears local DB and signs out. A web deletion page (`https://<domain>/delete-account`) offers the same.

### 6.15 Daily ritual (Today tab, Free)

**Story:** As a user, I open the app and get one gentle 2-minute routine, so self-love becomes a habit.

**Flow:** mood check-in (6 moods, may be skipped) → 3 cards, each with the read-aloud timer gate (§6.2) → one gratitude line (§6.16, may be skipped) → completion sparkle and streak update → today's cosmic card shown last as a reward (or the "Unlock your cosmic side" prompt when she has no birth data).

**AC**
- [x] Today is the home tab and shows the ritual's state: not started, in progress (step n of 4), or done for today.
- [x] The 3 ritual cards use the same timer gate and swipe rules as the Deck; a swipe before the ring is full is cancelled.
- [ ] **(M4b)** Ritual cards count toward the 5 new cards per day free limit (§6.2; was 10). If fewer than 3 are left, the ritual uses what is left and still completes; Premium has no limit. The ritual itself never shows a paywall or upsell. The one trial offer (§6.13) appears on Today only after it is finished on her 2nd or 3rd active day.
- [x] Completing the ritual stores one `ritual_days` row for the local date and updates the streak. The streak counts a day when the ritual is completed **or** at least 1 deck card is completed. A missed day shows no guilt copy. *Streak rule built (P10, 2026-10-31): `currentStreak` counts ritual days and card days; the `ritual_days` table is read and written through the deck repository (`markRitualDay`); the ritual flow that calls it is P11 (built 2026-10-31).* — *`today_screen_test` runs the ritual end to end; the gratitude step is a quiet placeholder until the jar (§6.16, P13).*
- [x] The mood step stores the day's mood (§6.18). Skipping it stores nothing.
- [x] Leaving mid-ritual and coming back the same day resumes at the same step.
- [x] The cosmic reward card shows today's energy line and lucky color when she has birth data; otherwise "Unlock your cosmic side" (§6.1). Neither blocks finishing the ritual.
- [x] Works fully offline. Respects reduce motion (the sparkle is replaced by a still celebration).
- [x] Widget test: the ritual runs end to end; the timer gate holds; the streak counts a ritual-only day.

### 6.16 Gratitude and wins jar (Free)

- [x] She can add 1–3 short entries per local day (max 200 characters each), as part of the ritual or from the jar screen in Me. *(built P13, 2026-10-31)*
- [x] Each entry drops a paper star into the jar with a short fill animation; the jar fills visibly with the count of entries (capped for display).
- [x] "Open the jar" shows random past entries one at a time, never one from today first; an empty jar shows the mascot and an invitation.
- [x] She can delete an entry. Entries are stored locally first and synced to `users/{uid}/gratitude` (§8.1). *(a delete made while offline is not queued: the Firestore copy comes back with the next sync)*
- [x] **Entries are private (§10):** never sent to the AI API or to analytics. *(no analytics event carries text; `gratitude_added` sends only the count)*
- [x] The jar is also reachable from the hard-day kit (§6.26).

### 6.17 My own cards (1 free, unlimited Premium)

*M4b (2026-11-02): the free limit goes from 3 to 1 (`ownCardFreeLimit`). Cards she already has above the limit stay readable, editable, deletable and in the rotation; only creating a new one is blocked (§6.13 principle 3). The paywall source is `own_cards`.*

- [x] She writes an affirmation (max 140 characters) and picks one illustration from the bundled set (§8.4). The card has the same layout and timer gate as a bundled card; its category is `self_love`.
- [x] A custom card joins the deck rotation (and the ritual) and can be chosen as the home-screen widget card. (P15: it joins the card pool used by the deck, ritual, journal and widget rotation; the widget thumbnail uses the category art. Choosing one specific card for the widget is not built.)
- [x] Free users can keep 3 custom cards; the 4th opens the paywall. Premium has no limit. Deleting a card frees a slot. (P14/P15: limit, Premium override and freed slot are done. The 4th card shows an explanation dialog; the real paywall screen does not exist yet, so this stays open.)
- [x] She can edit and delete her cards. Stored locally first, synced to `users/{uid}/customCards`. (P14/P15: storage, sync and the Me → My own cards screens are done. Deleting while offline is not queued; the card returns on the next sync.)
- [x] **Private (§10):** the text never goes to the AI API, analytics, or the For You embeddings server. Custom cards get no embedding; the For You deck ignores them for ranking. (P14: `OwnCard.toQuote()` carries no mood, sign or embedding; the For You ranking must skip ids starting `own_`.)
- [x] Shareable as an image like any card (§6.4).

### 6.18 Mood calendar (this and last month Free; older history and insights Premium)

- [ ] **(M4b)** Check-in stays free. The calendar shows the **current and the previous calendar month** in full. Earlier months show a soft preview (blurred dots and a gentle invitation, source `mood_history`). Nothing is deleted or hidden from the monthly recap, which uses last month. If Premium lapses, older months go back to the soft preview; the data stays and returns with Premium.

- [x] The mood check-in (ritual or Deck) stores **one mood per local date** (the last choice wins). She can also set or change today's mood from Me → Mood.
- [x] Month calendar: one colored mood dot per day, previous and next month, tap a day to see its mood; unlogged days are empty without any warning style.
- [x] **Insights (Premium):** a few simple statements computed on the device from her own data only, for example "You logged calm more often on days you finished your ritual". They need at least 14 logged days. Wording is gentle, never a diagnosis, never about health or mental conditions, and always offers a kind next step. *Built (Q8, 2026-11-02): two statements ("most often" mood, and good moods more often on ritual days) shown on Me → Mood for Premium; free users see an invitation, under 14 logged days shows how many more are needed. More statements can be added later.*
- [ ] Nothing about moods leaves the phone except her own Firestore documents `users/{uid}/moods/{YYYY-MM-DD}`; mood **counts** (not days or text) feed the weekly letter (§6.24).
- [x] Unit tests for the insight rules, including "not enough data" and no-claim wording.

### 6.19 Breathe with Mochi (Free)

- [x] A 1-minute box breathing session (4 seconds in, 4 hold, 4 out, 4 hold) with the mascot growing and shrinking and a text cue ("Breathe in", ...).
- [x] Reduce motion: the mascot stays still and the cue text and a progress ring carry the rhythm. Optional soft haptic on each phase.
- [x] Fully offline, no account, no network, no sound permission needed.
- [ ] Reachable from Today, the hard-day kit, and Me. Finishing shows a gentle line and offers the next step; leaving early is fine. *(Today and Me done 2026-10-31 (P16); the hard-day kit link is done in P17.)*
- [ ] Breathing copy lives in `breathing.json` (§8.3), in en and my. *(Deferred: the copy is in `app_en.arb` / `app_my.arb` instead, so the translation tool covers it; `breathing.json` is not used. Burmese is machine-translated and unreviewed.)*

### 6.20 Tiny kindness quests (daily quest Free; swap Premium)

- [ ] **(M4b)** One quest a day is free. The once-a-day **swap is Premium** (source `quest_swap`); a free user sees the swap button locked with a soft preview. A swap already made today stays made if Premium lapses.

- [x] One small daily task picked from the bundled `quests.json`, matched to her focus areas, chosen deterministically from the date so it is stable all day. *(Q1: `dailyQuest` in `features/quests/domain`; 18 starter quests, the launch set of 120 is still to write.)*
- [x] She can mark it done or **swap it once** per day for another quest. *(Q2: the quest card on Today.)*
- [ ] A quest is never anything about health, money, or others' bodies; it is a tiny kind act toward herself or someone else ("Drink a glass of water slowly", "Send a kind message to a friend").
- [ ] Done quests count toward the weekly letter's aggregates and mascot milestones.
- [x] Quest state is stored locally and synced to `users/{uid}/state/quest`. *(Q2: drift table `quest_states`, schema v5; deleted with the account through the existing `state` cleanup.)*

### 6.21 Self-love journeys (1 free, the rest Premium)

- [ ] A journey is a 7 or 14 day program. Each day has: a set of cards (3), one quest, and one reflection prompt. Launch set: **Confidence (7)**, **Healing after a breakup (14)**, **Exam & work calm (7)**, **Body kindness (7)**. One of the four is free (suggested: Confidence); the others are Premium.
- [x] She can run one journey at a time and see progress (day n of N). *(Q4)*
- [x] **Missing a day pauses; it never resets.** *(Q3: domain logic and tests; UI is Q4.)* The next day she opens it she continues at the same day. No streak-loss messaging.
- [x] The reflection answer is free text she writes for herself. It is **private (§10)**: stored locally and in her Firestore, never sent to the AI API or analytics. *(Q4)*
- [ ] Completing a day counts toward the streak and the mascot's milestones; completing a journey unlocks a mascot item (§6.23) and offers the share image.
- [ ] Journey scripts are in `journeys.json` (§8.3) in en and my. Healing after a breakup follows the style guide: no predictions, no promises about the ex, no clinical language, and shows the hard-day kit link.
- [x] Progress is saved to `users/{uid}/journeyProgress/{journeyId}`. *(Q3: local drift table + sync; her reflections stay private.)*

### 6.22 Letter to future me (1 sealed letter at a time Free; unlimited Premium)

- [ ] **(M4b)** A free user can have **one sealed letter at a time**; writing a second while one is still sealed opens the paywall (source `letters`). Once a letter is opened or deleted she can seal another. Opened letters are always readable and deletable, and a lapse never hides a sealed one.

- [x] She writes a note (max 1,000 characters), chooses to unlock it in 30, 90 or 365 days, and seals it. A sealed letter cannot be read or edited before its date; it can be deleted.
- [x] A local notification fires on the unlock date (permission handled like the reminder, §6.6). Opening the letter shows it with its written date.
- [x] Letters are stored locally and in `users/{uid}/letters/{id}`. **Private (§10).** The notification text never contains the letter.
- [x] Phone clock changes cannot unlock a letter early on a signed-in device: the unlock date is checked against the stored `unlockAt`, and the server-time is not required (document this limitation). **Limitation, accepted:** the check uses the phone clock, so moving the clock forward opens a letter early. There is no server time. The letter is her own, so we accept this.

### 6.23 Mochi grows with you (some items Premium)

- [ ] The mascot earns outfits and room items at streak milestones (3, 7, 14, 30, 60, 100 days) and at journey and quest milestones.
- [x] A simple Room screen (Me → Mochi's room) shows Mochi, the equipped outfit, and placed room items; she can equip one outfit and place items in fixed slots (no free drag, to keep it simple and accessible).
- [x] Items come from `mascot_items.json` (§8.4): each has an id, a slot, an unlock rule and a `premium` flag. Free items are earned; Premium items are earned too but equipping needs Premium.
- [x] **No punishment:** missed days never remove items or make Mochi sad. A streak break shows nothing negative.
- [x] Inventory is stored locally and in `users/{uid}/state/mascot`.
- [x] Every item image has a semantic label.

### 6.24 Weekly letter from Mochi (Premium, AI)

- [x] Every Sunday (local) a short, warm letter (80–150 words) about her week appears on Today and in Me → Letters, with a notification if she allowed it. *Q10 done 2026-11-01: the card stays all week (the letter for the last finished week); the notification is Sunday 18:00 local for the next 4 Sundays (ids 3000+), only while Premium and permission are granted, and its text never carries the letter. An empty week with nothing saved shows no card and makes no call.*
- [x] The letter is generated on the server by `POST /v1/letters/weekly` (§8.2) from **aggregates only**: mood counts, ritual days completed, quests completed, current journey id and day, focus areas, and `lang`. **Never** her gratitude entries, letters, custom cards, journal, or reflection answers. *Q9 done 2026-11-01 (API repo `mochi-moon-api`, e35ac50): strict schema (ids and counts only, any other field is a 400), one letter cached per user, week and language, 3 new letters per week (cached repeats are free), account deletion erases letters. Deployed to the VPS 2026-11-01. Premium is not checked yet: the 402 check is M4b item 1 (launch blocker).*
- [x] Cached per week per language on the device and server; offline shows the last letter or a bundled fallback. *Q10: the device cache reuses the `cached_reports` table (type `weekly_letter`, id `weekly_letter:<lang>:<weekStart>`) instead of a separate `weekly_letters` table, so there is no schema migration. Finished quests are counted from a small on-device day log (`quest_done_days`, last 21 dates) because the quest record keeps only the latest day.*
- [x] Style guide (§7.1) applies: warm, no predictions about health, death, pregnancy, money or legal outcomes, no fear language, no absolute claims, no clinical language.
- [x] If she has fewer than 2 active days in the week, the letter is a gentle "fresh start" letter that does not mention the gap negatively. *Server side done (Q9); the validator also bans blame words such as missed, gap, behind.*
- [x] Free users see the first line and a paywall invitation. *Q10: free users see a teaser plus a Premium invitation on Sundays only and no call is made. There is no paywall screen yet, so the invitation is text only. Premium is checked in the app only (the server has no purchase verification yet).*

### 6.25 Monthly glow recap (Free)

- [ ] On the 1st of each month (or from Me), she can open a recap of last month: days she showed up, most common mood, and her favourite saved card (the Journal card saved most recently that month, or the first one).
- [ ] Rendered **on the device** as a 1080×1920 story image by the share pipeline (§6.4) and shared with the system share sheet. Nothing is uploaded.
- [ ] The recap never shows her written text (gratitude, letters, own cards).
- [ ] If she did not show up at all last month, the recap is replaced by a warm "welcome back" card instead of an empty page.

### 6.26 Hard-day kit (always Free)

- [ ] **(M4b, safety rule)** The kit, its breathing session, its comforting cards, the wins jar link and the Help section never show a paywall, a lock chip or an upsell, and the kit's cards do not use up the daily card limit. A guard test proves it (§12 M4b).

- [x] One calm button, "Hard day?", on Today and on the Deck opens a kit with: a 1-minute breathing session (§6.19), 3 comforting cards from the `calm`/`healing` categories, a way to open the wins jar (§6.16), and a **Help** section.
- [x] The Help section shows a clear note that the app is not a substitute for professional help, and if she is in danger she should contact local emergency services or someone she trusts.
- [x] Helpline **names and numbers per locale are `TODO_CONTENT` entries in `hard_day.json`** until the owner verifies them from official sources. **Do not invent phone numbers.** Until verified, the Help section shows only the note and a "Find a local helpline" instruction without a number. *(No `hard_day.json` yet: the copy is in the ARB files and there are no helpline entries. L4 adds verified ones.)*
- [x] The kit works offline and needs no account. It never asks for her mood, text, or location, and logs only the `hard_day_opened` event (§11, no text).
- [ ] Copy is reviewed by the owner before launch; no medical claims or diagnostic words. *(Built 2026-10-31 (P17); awaiting the owner's review.)*

---

## 7. AI features (no chat)

### 7.1 Server-generated readings

- A nightly job on the VPS generates, for each of the 12 signs × each shipped language (`en` and `my` for now; `th` joins when it ships), the daily reading for **today and tomorrow** (to cover all time zones) with OpenAI `gpt-6-luna` at high reasoning effort, called directly through the OpenAI API (OpenRouter is no longer used).
- The API key lives only in the VPS environment (`OPENAI_API_KEY`); it is never in the app, the repo or a client request. The model ID is a server setting so it can change without an app release.
- Inputs to the prompt are computed facts only (sign, Moon sign and phase, active retrogrades, notable transits to the sign), plus the style guide.
- Personal reports (natal, compatibility) are generated on request from **placements only** (no birth date/time/place), then cached.
- The weekly letter from Mochi (§6.24) is generated on request from **aggregates only** (§8.2), cached per week per language.
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
- Burmese readers are largely English-literate (owner decision, 2026-10-30), so the output is a natural mix: zodiac signs, planets, "Moon"/"Sun", the Moon phase names ("New moon", "Full moon", "Waxing crescent" ...), "retrograde"/"direct", "Self Love" and common loanwords stay in English; numbers use 0-9; dates and times are formatted in English in every language. Pronouns are gender neutral: first person is ငါ, never ကျွန်မ or ကျွန်တော်, and no gendered endings. The tool rejects Burmese digits, and one or two word labels may stay in English.
- Output is **unreviewed machine translation**. A native reviewer must approve each batch before it counts as shipped (see §7.1 and §13). Only Burmese is generated and shipped for now; Thai is not generated or shipped until a reviewer exists.

### 7.2 Embeddings for the For You deck

- Every quote gets a multilingual sentence embedding computed once on the server (any small multilingual embedding model), reduced to 128 dimensions and int8-quantized, shipped in `quotes.json`.
- Mood centroids (6 moods) are shipped the same way.
- On-device preference vector `p = Σ wᵢ·eᵢ / |Σ wᵢ·eᵢ|`, weights: right-swipe 1.0, share 1.5, left-swipe −0.3, with 14-day half-life decay; a selected mood adds its centroid with weight 2.0 for that session.

### 7.3 Store wording

The listing leads with the daily ritual, journeys and affirmations, and mentions astrology after. It may say "AI-personalized affirmations", "a weekly letter from Mochi" and "AI-written birth chart readings" because §7.1–7.2 exist. Never claim the AI "predicts" anything.

---

## 8. Data and interfaces

### 8.1 Firestore

```
users/{uid}
  displayName: string
  locale: "en" | "th" | "my"
  createdAt, updatedAt: timestamp
  profile:
    birthDate: "YYYY-MM-DD" | null
    birthTime: "HH:mm" | null
    timeKnown: bool | null
    place: { name, region, countryCode, lat, lng, tzId } | null
    # v1.1: every astro field below may be absent until she unlocks Cosmic
    sunSign: string | null
    moonSign: string | null
    moonApproximate: bool | null
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

users/{uid}/gratitude/{id}                # id = auto id
  text: string (1-200)
  date: "YYYY-MM-DD"                       # local date
  createdAt: timestamp

users/{uid}/customCards/{id}
  text: string (1-140)
  illustrationId: string                   # from the bundled set
  createdAt, updatedAt: timestamp

users/{uid}/moods/{YYYY-MM-DD}             # one doc per local date
  mood: "happy" | "calm" | "tired" | "sad" | "anxious" | "in_love"
  updatedAt: timestamp

users/{uid}/letters/{id}                   # letters to future me
  text: string (1-1000)
  writtenAt, unlockAt: timestamp
  unlockDays: 30 | 90 | 365

users/{uid}/journeyProgress/{journeyId}
  startedAt: timestamp
  currentDay: int                          # next day to do (pauses, never resets)
  completedDays: int[]
  reflections: map<string, string>         # day -> her own answer (private)
  completedAt: timestamp | null

users/{uid}/state/quest                    # one doc
  date: "YYYY-MM-DD"
  questId: string
  done: bool
  swapped: bool

users/{uid}/state/mascot                   # one doc
  owned: string[]                          # item ids from mascot_items.json
  equipped: { outfit: string | null, room: map<string, string> }
  updatedAt: timestamp

users/{uid}/state/ritual                   # one doc
  completedDates: string[]                 # "YYYY-MM-DD", latest 400

users/{uid}/partners/{partnerId}
  nickname: string
  birthDate, birthTime, timeKnown, place   # same shape as profile
  createdAt: timestamp

users/{uid}/reports/{reportId}       # written by the server only (v1.1 note: natal reports are today kept in the server's SQLite and the device's drift cache; this collection is reserved for later)
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

      // v1.1 self-love data: owner only, with shape and size checks.
      match /gratitude/{id} {
        allow read, delete: if request.auth.uid == uid;
        allow create, update: if request.auth.uid == uid
          && request.resource.data.keys().hasOnly(['text', 'date', 'createdAt'])
          && request.resource.data.text is string
          && request.resource.data.text.size() >= 1
          && request.resource.data.text.size() <= 200
          && request.resource.data.date is string
          && request.resource.data.createdAt is timestamp;
      }
      match /customCards/{id} {
        allow read, delete: if request.auth.uid == uid;
        allow create, update: if request.auth.uid == uid
          && request.resource.data.keys().hasOnly(
            ['text', 'illustrationId', 'createdAt', 'updatedAt'])
          && request.resource.data.text is string
          && request.resource.data.text.size() >= 1
          && request.resource.data.text.size() <= 140
          && request.resource.data.illustrationId is string;
      }
      match /moods/{day} {
        allow read, delete: if request.auth.uid == uid;
        allow create, update: if request.auth.uid == uid
          && request.resource.data.keys().hasOnly(['mood', 'updatedAt'])
          && request.resource.data.mood in
            ['happy', 'calm', 'tired', 'sad', 'anxious', 'in_love'];
      }
      match /letters/{id} {
        allow read, delete: if request.auth.uid == uid;
        allow create, update: if request.auth.uid == uid
          && request.resource.data.keys().hasOnly(
            ['text', 'writtenAt', 'unlockAt', 'unlockDays'])
          && request.resource.data.text is string
          && request.resource.data.text.size() >= 1
          && request.resource.data.text.size() <= 1000
          && request.resource.data.unlockDays in [30, 90, 365];
      }
      match /journeyProgress/{id} {
        allow read, delete: if request.auth.uid == uid;
        allow create, update: if request.auth.uid == uid
          && request.resource.data.keys().hasOnly(
            ['startedAt', 'currentDay', 'completedDays', 'reflections', 'completedAt']);
      }
      match /state/{doc} {
        allow read, delete: if request.auth.uid == uid;
        allow create, update: if request.auth.uid == uid
          && doc in ['quest', 'mascot', 'ritual'];
      }
    }
  }
}
```

Notes for the rules: every new subcollection is owner-only; `entitlement` stays server-only. Premium-only mascot items are enforced in the app and in the server's weekly-letter check; the `mascot` document is cosmetic, so a user editing it only changes how her own room looks. Every collection above must be covered by emulator tests (owner can read and write valid data, another user cannot, oversized text and unknown keys are rejected) and added to account deletion (§6.14).

### 8.2 Readings API (VPS)

Base: `https://api.<domain>/v1`. Auth: `Authorization: Bearer <Firebase ID token>` (verified with the Firebase Admin SDK). JSON only. Errors: `{ "error": { "code": "premium_required", "message": "..." } }` with HTTP 400/401/402/404/429/500.

| Method | Path | Access | Purpose |
| --- | --- | --- | --- |
| GET | `/daily?sign=scorpio&date=2026-10-27&lang=th` | Signed-in | Daily sign reading |
| POST | `/daily/personal` | Premium (server-enforced; not built) | Transit-personalized daily text from placements |
| POST | `/reports/natal` | Premium (server-enforced) | Full natal report |
| GET | `/reports/natal/{reportId}` | Signed-in, owner of the report | Poll or re-read her own existing report; stays allowed after a lapse |
| POST | `/reports/compatibility` | Premium or 1 credit (server-enforced; not built) | Full compatibility report |
| POST | `/letters/weekly` | Premium (server-enforced) | Weekly letter from Mochi, from aggregates only |
| POST | `/purchases/verify` | Signed-in | Verify Play purchase, write entitlement |
| DELETE | `/account` | Signed-in | Delete all user data and the Auth user |

**Premium is enforced on the server (M4b, launch blocker)**
- [ ] Every Premium endpoint above reads `users/{uid}.entitlement` with the Firebase Admin SDK and allows the call only when `premium` is true and `expiresAt` is in the future. Otherwise it returns **HTTP 402** `{ "error": { "code": "premium_required", "message": "..." } }`, before any model call, any rate-limit count and any cache lookup, so AI costs cannot be abused with a modified app. A cached repeat still needs Premium.
- [ ] `POST /reports/compatibility` is allowed with Premium **or** one `reportCredits`; the credit is spent only when a new report is generated, never on a cached repeat or a failed generation.
- [ ] `GET /reports/natal/{reportId}` returns her own existing report without Premium (principle 3, §6.13); creating a new one needs Premium.
- [ ] pytest covers a free user, an expired user and a Premium user for each Premium endpoint, and that the 402 body carries no request data.
- [ ] The app maps a 402 to a soft paywall invitation (source `server_402`), never to an error screen.
- `GET /daily` is gated **in the app only**: its Premium fields (`love`, `avoid`, `luckyNumber`) are nightly cached content with no per-call cost, so a server check adds nothing. `POST /purchases/verify` and `DELETE /account` need only sign-in.
- Testing Premium against the server needs a real entitlement: use Play license testers (free test purchases). There is no server backdoor or debug bypass. The app's `PREMIUM_OVERRIDE` flag only unlocks screens on the device.

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

`midheaven` is sent like `ascendant`; both and every `house` are left out when `timeKnown` is false. Any other field (a birth date, for example) is rejected with 400.

Response: `{ "reportId": "...", "lang": "en", "version": 1, "status": "generating" | "ready" | "failed", "total": 13, "sections": [ { "key": "overview", "title": "...", "body": "..." } ] }`. The call returns at once: **202** while the server writes the parts in the background, **200** when the report is ready (sending the same chart again finds the same report, no new cost). `GET /reports/natal/{reportId}` returns the same shape; the app polls it every ~3 s and shows the parts as they arrive (`sections` is always an unbroken run from the first). A failed report keeps its finished parts, and posting again writes only the missing ones. 5 new reports an hour per user (429). Reports are kept in the server's SQLite database, owner-only, and erased with the account. The server checks Premium (see "Premium is enforced on the server" above; built in M4b).

**`POST /reports/compatibility` request:** `{ "lang", "partnerId", "a": <placements block>, "b": <placements block>, "score": { "overall", "romance", "emotional", "communication" }, "topAspects": [...] }`.

**`POST /letters/weekly` request** (aggregates only; any other field, and in particular any text she wrote, is rejected with 400):

```json
{
  "lang": "en",
  "weekStart": "2026-11-01",
  "moodCounts": { "happy": 2, "calm": 3, "tired": 1, "sad": 0, "anxious": 1, "in_love": 0 },
  "ritualDays": 5,
  "questsCompleted": 4,
  "journey": { "id": "confidence", "day": 3 },
  "focusAreas": ["self_love", "confidence"]
}
```

`journey` is `null` when she has none running. Response: `{ "weekStart": "2026-11-01", "lang": "en", "version": 1, "title": "string", "body": "string (80–150 words)", "generatedBy": "ai" }`. The server checks Premium (402 `premium_required`, M4b), caches one letter per user per `weekStart` and `lang`, and serves the same one on repeat calls with no new cost. Rate limit: 3 requests per week per user (429). Logs never contain the request body.

**Rate limits:** 60 requests/min per user; report endpoints 5/hour per user; weekly letter 3/week per user.

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
- Launch target: 500 quotes, all three languages. *M4b: every quote is free to read (`premium: false`); Premium means more cards per day and the For You ranking (§6.13), not exclusive quotes. The old "≥ 150 free" target no longer applies.*
- Authors: only original (null) or public-domain authors.

**Self-love content files** (all loaded through `ContentRepository`; every text has `en` and `my`, `th` later; unreviewed machine translation is flagged like the quotes):

`assets/content/quests/quests.json`
```json
{ "version": 1, "quests": [
  { "id": "qst_001", "text": { "en": "Drink a glass of water slowly.", "my": "..." },
    "focusAreas": ["self_love", "calm"], "premium": false } ] }
```
Launch target: 120 quests (20 per focus area), none about health outcomes, money, or others' bodies. *Done 2026-11-02: 120 English quests (20–24 per focus area, all free). The 102 new ones have no Burmese text (post-launch). The owner should read them for tone.*

`assets/content/journeys/journeys.json`
```json
{ "version": 1, "journeys": [
  { "id": "confidence", "days": 7, "premium": false,
    "title": { "en": "Confidence", "my": "..." },
    "summary": { "en": "...", "my": "..." },
    "illustrationId": "ill_journey_confidence",
    "daysPlan": [
      { "day": 1, "quoteIds": ["q_0101", "q_0102", "q_0103"], "questId": "qst_014",
        "reflection": { "en": "What is one thing you did well this week?", "my": "..." } } ] } ] }
```
Launch set: Confidence (7, free), Healing after a breakup (14), Exam & work calm (7), Body kindness (7). Each day references existing quotes and quests by id so nothing is duplicated.

`assets/content/breathing/breathing.json`: the box breathing cues ("Breathe in", "Hold", "Breathe out", "Hold"), the intro and the finish lines, in en and my.

`assets/content/hard_day/hard_day.json`: the kit's intro, the "not a substitute for professional help" note, the quote ids for the 3 comforting cards, and a `helplines` list per locale. **Every helpline name and number is a `TODO_CONTENT` entry until the owner verifies it from an official source.** Never invent one.

`assets/content/mascot/mascot_items.json`
```json
{ "version": 1, "items": [
  { "id": "outfit_scarf_01", "slot": "outfit", "premium": false,
    "name": { "en": "Cozy scarf", "my": "..." },
    "unlock": { "type": "streak", "value": 7 }, "illustrationId": "ill_mascot_scarf_01" } ] }
```
Unlock types: `streak`, `journey`, `quests`. Launch target: 12 outfits and 12 room items (about a third Premium).

### 8.4 Illustrations

- `assets/illustrations/ill_<theme>_<nn>.webp`, 1080×1350, pastel background, consistent moon-bunny mascot.
- 12 zodiac outfit variants: `ill_zodiac_<sign>.webp`.
- Launch target: 60–100 illustrations, each reused across many quotes.
- v1.1 additions: `ill_journey_<id>.webp` (one per journey, 4 at launch), `ill_mascot_<item>.webp` for outfits and room items (24 at launch), and a mood set of 6 small mood icons. Custom cards (§6.17) pick from the same bundled set. Every image has a semantic label.

### 8.5 Cities dataset

- Bundled GeoNames-derived list (cities with population ≥ 15,000): name, ASCII name, alternate names in Thai and Burmese where available, admin region, country code, lat, lng. Attribution in the licenses screen.
- Time zone from `lat_lng_to_timezone` at selection time; store `tzId`.

### 8.6 Local database (drift)

Tables: `cached_readings` (date, sign, lang, version, json, fetchedAt), `cached_reports`, `deck_history` (quoteId, action, at), `journal_cache`, `retro_calendar` (planet, year, json), `preference_vector`. v1.1 adds: `mood_entries` (date, mood), `gratitude_entries` (id, date, text, createdAt, synced), `custom_cards` (id, text, illustrationId, createdAt, synced), `ritual_days` (date, completedAt), `ritual_progress` (date, step, quoteIds), `future_letters` (id, text, writtenAt, unlockAt, unlockDays, synced), `journey_progress` (journeyId, currentDay, completedDays, reflections, completedAt), `quest_state` (date, questId, done, swapped), `mascot_inventory` (itemId, earnedAt, equipped), `weekly_letters` (weekStart, lang, version, json). Each synced table keeps the same local-first rule as the journal. The schema version goes from 3 to 4 (and later), each with a migration test.

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
- Implementation notes (`astro/synastry.dart`): a rule with two different points is scored both ways round (A's Sun with B's Moon, and A's Moon with B's Sun); a same-point rule once. Sub-scores include the element bonus, like the overall. Light mode applies when either chart has no birth time; a chart's Moon counts only if it is in the same sign 12 hours before and after its noon; the Ascendant is never used in light mode, and outside it a pair needs the Ascendant of the chart it takes it from. Calibration (seeded, 10,000 pairs from 1,000 random charts born 1960–2008): full readings median 74, 1.21% at 40 or lower; light readings median 69, 0.80% at 40 or lower. Base 60 and multiplier 8 are unchanged.

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
| Localization | 100% of UI strings in en and my at release (th when a native reviewer exists); Burmese in Unicode |
| Private writing | Anything she writes herself (gratitude, letters, own cards, journal, reflection answers) is synced only to her own Firestore, never sent to the AI API or to analytics, and always deleted with the account |
| Reliability | Crash-free sessions ≥ 99.5% (Firebase Crashlytics) |
| Security | Firestore rules tested in the emulator; API verifies ID tokens; HTTPS only |

## 11. Analytics events (only after consent)

`onboarding_started`, `onboarding_completed`, `sign_in_success`, `card_completed`, `card_swiped {direction}`, `card_shared`, `daily_limit_reached`, `mood_selected {mood}`, `cosmic_today_viewed`, `chart_viewed`, `compat_created {mode}`, `paywall_viewed {source}`, `trial_started`, `purchase_completed {productId}`, `trial_offer_shown`, `trial_offer_dismissed`, `widget_added`, `notification_opened {type}`, `account_deleted`.

v1.1 events: `ritual_started`, `ritual_completed`, `gratitude_added {count}`, `jar_opened`, `custom_card_created`, `mood_logged {mood}`, `breathe_completed`, `quest_completed`, `quest_swapped`, `journey_started {journeyId}`, `journey_day_completed {journeyId, day}`, `journey_completed {journeyId}`, `letter_sealed {unlockDays}`, `letter_opened`, `mascot_item_unlocked {itemId}`, `weekly_letter_viewed`, `recap_shared`, `hard_day_opened {source}`, `cosmic_unlocked`.
`paywall_viewed {source}` takes one of these values (M4b, table in §6.13): `deck_limit`, `for_you`, `journey`, `own_cards`, `letters`, `quest_swap`, `mood_history`, `mood_insights`, `mascot_item`, `weekly_letter`, `cosmic_today`, `sign_chooser`, `chart_details`, `natal_report`, `compat_details`, `compat_report`, `partners`, `retro_alerts`, `trial_offer`, `me`, `server_402`. Never any other text.
Never include birth data, partner names, quote text, or anything she wrote (gratitude, letters, own cards, reflections) in event params.

---

## 12. Milestones and checklist

Tick items as they're completed (Claude Code: update this list at the end of each task).

### M0 — Foundation
- [x] Flutter project with dev/prod flavors, lints, CI script (`analyze` + `test`)
- [ ] Theme tokens, bundled fonts incl. Noto Sans Thai/Myanmar, dark mode — *partial (audit 2026-10-31): tokens + dark mode done; update 2026-11-02: Fredoka (display) and Nunito (body) are bundled and wired in `app_typography.dart`, plus `MochiSymbols.ttf`. The Noto Sans Myanmar/Thai fallbacks are post-launch with those languages (English-only launch)*
- [x] gen-l10n set up with en/th/my ARB files — *en + my done; th deferred until a Thai reviewer is available*
- [x] go_router shell with 3 tabs and placeholder screens — *v1.1 restructures it to 4 tabs, see M5a*
- [x] drift database scaffold
- [x] Content loader for `quotes.json` and `signs.json` with 20 sample quotes — *quotes are en only; my/th text pending*

### M1 — Self-love deck (Android closed test)
- [x] Deck with timer gate (§6.2) and tests — *deferred: Firestore counter sync (M2), mood check-in, share sheet on swipe-up (§6.4, records `shared` only), heart animation, premium upsell on the limit card (M4), premium-quote filtering, `my` strings need native review*
- [x] Journal (local first, §6.3) — *deferred: Firestore sync (M2), per-card art beyond the 5 theme pieces, entry to the journal from the Deck header, `my` strings need native review*
- [x] Share as image (§6.4) — *deferred: font check in all scripts (fonts not bundled), share handle value, share-sheet position origin for iPad*
- [x] Daily reminder notification (§6.6, first box; retrograde alerts and FCM are separate)
- [x] Home-screen widget (§6.5)
- [x] Sample-cards-before-sign-in flow — *deferred: Google sign-in and profile steps (M2), mascot art, Burmese strings; sample swipes count toward the day's 10 cards*

### M2 — Accounts and Cosmic basics
- [x] Ask the language first in onboarding (§6.1) — *(hidden for the English-only launch on 2026-11-02; see §6.1)* *`/welcome` is now the language screen (System / English / မြန်မာ, each in its own script, saved and applied at once via the Me tab provider); the welcome moved to `/welcome/hello`. It is first on every first run, including after account deletion restarts the app. Burmese copy generated with the translate tool (unreviewed). Tested: first-run order and the instant switch; the restart case relies on the same redirect.*
- [ ] Firebase project, Google sign-in, onboarding (§6.1) — *code done and tested with fakes: sign-in, local-first profile (drift) with Firestore sync, name / birth date / birth time / reminder / focus steps. Done: dev Firebase project (`mochi-moon-dev`), `google-services.json` for dev, SHA-1, Google sign-in enabled, real sign-in tried on the emulator. Firestore database (`asia-southeast1`) created, rules from §8.1 deployed to dev, and the profile document confirmed in the console. Still open: a prod project with its own `google-services.json` and release SHA-1. Deferred to later M2 items: sun/moon/rising signs.*
- [x] Firestore sync for profile, Journal, deck counters; security rules + emulator tests — *the device stays the source of truth: the journal and the counters (streak, last day, today's count) are mirrored to Firestore while signed in, and cards that only Firestore has are added back on start. Rules tests run with `scripts/test_rules.ps1` (or `.sh`; needs Node, Java, Firebase CLI). Deferred: restoring the streak and today's count after a reinstall (the history is not synced), a removal made offline comes back on the next start (no tombstones), the tightened journal rule is not yet deployed to `mochi-moon-dev`, no prod project.*
- [x] Cities dataset + birthplace search + time zone resolution — *`assets/content/cities/` is built from GeoNames `cities15000` by `tool/build_cities.dart` (34,191 cities, English names only). Search is offline, ignores case and accents, ranks prefix matches first and then by population, and can be narrowed by region or country ("springfield illinois"). The zone comes from `lat_lng_to_timezone` when the city is picked and is stored as `tzId`; a test checks that those ids exist in the `timezone` data. GeoNames (CC BY 4.0) is credited on Flutter's licenses page; there is no Settings licenses screen yet. Deferred: Thai and Burmese alternate names (the dump has no language tags, and Thai waits for a reviewer), editing the birthplace from the Me tab, and the tz database is not initialised at start-up (the astro engine item will do it).*
- [x] Astro engine: Sun/Moon/planets + sun/moon sign (§9.1–9.2) — *`lib/features/cosmic/astro/`: `planetPositions(utc)` (Sun from VSOP87, Moon from Meeus ch. 47 plus nutation, planets with light-time, Pluto precessed from J2000), speed and retrograde flag, `birthInstantUtc` (local time + `tzId` to UTC, noon when unknown; initialises the tz database on first use) and `sunMoonSigns`. `test/features/cosmic/astro/golden_positions.json` holds 23 instants x 10 bodies from JPL Horizons; the worst error is 0.012° (Moon), the rest under 0.007°. Deferred: the Ascendant and `golden_charts.json` with birth data (M3, §9.3 and §9.7), annual aberration (about 20", left out on purpose), ΔT (TT is taken as UT, §9.1), and wiring the signs into the profile on save (see §6.1).*
- [x] Cosmic Today with bundled fallback texts, lucky colors, Thai colors toggle (§6.7) — *the Cosmic tab shows the Sun sign, "Moon in X", a headline and text, energy, love, lucky colors (one from the sign palette, one from the element of the Moon's sign), lucky number, three things to avoid, and the disclaimer. Texts are bundled (`assets/content/fallback_readings/en.json`, two per sign, rotated by day of year) behind a `DailyReadingRepository` so the Readings API can replace them. Thai colors (birthday color and today's color) are off unless switched on in Me, and default on for the `th` locale. Without a birth date the tab asks for one. The sign's bunny art (`ill_zodiac_<sign>.webp`) sits above the header via `ZodiacArt`, which the M3 Big 3 cards and compatibility screen can reuse. A sign chooser (a chip row above the art) lets the user read any sign's page; it is a Premium feature switched on for everyone through `hasPremiumProvider` until M4, and it hides the user's birthday color on other signs' pages. Deferred: Thai texts and strings (`TODO_CONTENT`; English is shown instead), color names in English only, the Sun sign uses UTC when no birthplace was given (can be wrong for a birth within a day of a sign change), signs are computed on the fly and not stored on save (§6.1), the "Today's energy" daily-mix card (§6.10), and Premium personalized text.*
- [x] Cosmic Today from the Readings API with drift cache and language refetch (§6.7, §8.2) — *done on the device (`ApiDailyReadingRepository`); real readings arrive once the M4 server exists and `READINGS_API_URL` is set.*
- [x] Retrograde calendar + moon phase engine (§9.5) — *`retrogrades(year)` gives every Mercury, Venus, Mars, Jupiter and Saturn period whose shadows touch the year: both stations (bisected to 1 hour), pre- and post-shadow edges, and the station longitudes. `moonPhase(utc)` gives elongation, illumination, one of eight names, the Moon sign and the next new and full moon (to 1 minute). Checked against hourly JPL Horizons data for 2026–2027 (`golden_events.json`): stations within 2.7 h, shadow edges within 1.8 h, new and full moons within 105 s; the three published Mercury windows match. The scan margin is wider than the 2 months above (120 days for Mercury up to 400 for Jupiter and Saturn), because the slow planets' shadows reach about 3 months past the station. `retrogrades()` takes about 2 s for one year in the test VM; not yet timed on a phone. Outer planets (Uranus to Pluto) are not in the calendar.*
- [x] Translation tool for Burmese strings and readings via OpenAI (§7.1a) — *`tool/translate_content.dart` with validation; Burmese only; Thai is not generated or shipped. Model `gpt-6-luna`, high reasoning. Run on 2026-10-29: all 78 ARB strings in `app_my.arb`, the 12 fallback readings in `my.json`, and the 20 quotes (`text.my` in `quotes.json`, via `--quotes`). **Unreviewed machine translation; the owner reviews the Burmese.** Reviewer notes: `cosmicHeader` appends "ရက်နေ့" after the date; readings use informal "မင်း" while ARB strings mix polite and informal registers; quotes used the feminine "ကျွန်မ" for "I" until the 2026-10-30 rerun. Rerun on 2026-10-30 with the English-terms and gender-neutral rules (§7.1a): all 202 ARB strings, 12 readings and 20 quotes regenerated; quotes now use ငါ. Still unreviewed. Strings added to `app_en.arb` later need another run.*
- [x] Retrograde status card, timeline and tips (§6.8) — *(timeline and date lists since replaced by the current-retrogrades-plus-calendar screen, see §6.8)* *the Cosmic tab shows Mercury's status card ("Mercury is retrograde until Nov 13" or "Next Mercury retrograde: Feb 9" with a countdown) that opens `/cosmic/retrogrades`: a card per planet (Mercury, Venus, Mars; Jupiter and Saturn under "More planets") with the status, a year bar for this year and the next showing pre-shadow, retrograde and post-shadow bands and today, the dates as text, and an evergreen tip. Dates are shown in the local time zone. The calendar is computed in an isolate behind `retrogradeCalendarSourceProvider` and cached for the session; the status card was replaced by an always-visible "Retrogrades" button in the Cosmic app bar (§6.8). Burmese strings are generated and unreviewed (§12 translation note). Deferred: caching the calendar between launches, the Moon block (§6.8), and per-period tips.*
- [x] Retrograde alerts (local notifications, §6.6) — *Mercury on by default, Venus and Mars off, switches on the Me tab. Both stations (turning retrograde, turning direct) get a note the day before and on the day, at 09:00 local, planned 90 days ahead and re-planned on each app open and language change; ids 2000–2099, own channel. Alerts only fire once notification permission is granted (asked with a pre-prompt when a switch is turned on). Burmese text is machine-translated and unreviewed. Still open: asking permission at the end of onboarding so the Mercury default works from day one.*
- [x] Moon card with phase, illumination, Moon sign, next new and full moon, and a phase affirmation (§6.8) — *on Cosmic → Today, also without a birth date; drawn glyph (`MoonGlyph`, decorative, the phase name carries the meaning for TalkBack); eight bundled affirmations, one per phase. Burmese generated with the English-keywords rule (phase names, "new moon" and "full moon" stay English) and **unreviewed**. Deferred: a midnight refresh while the app stays open, matching affirmations from `quotes.json` by tag (content milestone, §6.10), a phase calendar.*
- [ ] Account deletion (in-app + web page) — *in-app part done: Me tab → "Delete my account" asks twice (the second time "Are you completely sure?"), re-checks the signed-in Google account silently before anything is erased (backing out changes nothing), shows a progress dialog, deletes `users/{uid}` with its `journal` and `partners` from Firestore, then the Auth user (asks for Google again if the sign-in is old), cancels scheduled notifications, wipes the drift database and every saved preference, and restarts the app so onboarding begins again. Signed out it only wipes the phone, so it doubles as a full reset for testing. The Firestore rule for `users/{uid}` now lets the owner delete the document (tested with the emulator); deployed to `mochi-moon-dev` on 2026-10-29. The server `DELETE /v1/account` now exists (live on the VPS) and the app calls it after the silent Google re-check whenever the build has `READINGS_API_URL`, then signs out and wipes the phone; without a URL the client path above still runs. The web page `/delete-account` is built and served in English and Burmese (`?lang=my`, or the browser language; the Burmese comes from `tool/translate_content.dart --web` and is unreviewed). Still open: trying the server call from the emulator, switching the web page on (needs the Firebase web config on the server), and a Burmese review of the new strings.*

### M3 — Charts and compatibility
- [x] Ascendant/MC/Whole Sign houses (§9.3–9.4) + golden tests — *`chartAngles` (`astro/angles.dart`) uses the §9.3 formulas with astronomia's apparent sidereal time and true obliquity; `computeNatalChart(BirthData)` (`astro/natal_chart.dart`) returns the ten placements, Ascendant, Midheaven, Whole Sign `houseOf`, `moonIsApproximate` and `risingMayBeUnreliable` (|lat| > 66°). Unknown time or place: no angles or houses. `golden_charts.json` holds 32 charts (both hemispheres, DST, pre-1970, Bangkok and Yangon incl. the +6:30 era, Sun and Ascendant sign-change pairs, Tromsø at 69.6°N, one unknown time). The numbers come from Swiss Ephemeris (pyswisseph, Moshier) run once as a dev-time oracle outside the repo; nothing from it is a dependency. Deferred: the chart wheel and Big 3 UI, writing the signs on profile save (§6.1), aspects.*
- [x] Chart wheel and placements list; Big 3 cards — *the birth chart screen (`/cosmic/chart`, opened by a banner on the Cosmic tab above the Retrogrades banner) shows the Big 3 cards (Sun, Moon, Rising; Rising only with a known time, Moon "approximate" without) and the placements list (glyph, sign, degree like 12°34′, house, "Rx" when retrograde, plus Ascendant and Midheaven), with a banner inviting the birth time when it is unknown, an empty state without a birth date, and the entertainment note. `natalChartProvider` is built from the profile, so a changed profile recomputes it. The Big 3 texts (36, soft, never fatalistic) are in the ARB files like the Moon affirmations rather than in a JSON file; Burmese is generated and **unreviewed**. Glyphs come from a 4 KB bundled font, `assets/fonts/MochiSymbols.ttf` (a subset of Noto Sans Symbols and Symbols 2, OFL, listed on the licenses page), because the system fonts turn them into color emoji or tofu; the retrograde mark is the ASCII "Rx" since ℞ is in neither font. The wheel (`chart_wheel.dart`, a `CustomPainter`) sits above the Big 3: a zodiac ring with the 12 sign glyphs, the ten planets at their degrees (glyphs that would overlap are nudged apart by `spreadLongitudes`, with a tick at the true degree) and a line for every major aspect. With a known time the Ascendant is at 9 o'clock with AC and MC marks and Whole Sign house numbers; without a time 0° Aries is at 9 o'clock and there are no houses. Trines and sextiles use the primary color, squares and oppositions the tertiary, conjunctions a neutral one, and the opacity follows the strength. The aspects come from the pure-Dart §9.6 engine (`astro/aspects.dart`: the five angles, orbs 8/4/6/6/8, +2° when the Sun or Moon is involved, `strength = 1 − deviation/orb`); the pair weights and compatibility scoring are still to come. The wheel is a picture for TalkBack with one label (`chartWheelLabel`, Burmese generated and **unreviewed**); the placements list carries the data. Deferred: a plain-language aspects list, a screen to edit birth data (so the no-time banner can link to it, and "editing recomputes" can be tried by hand), and the Premium natal report (M4).*
- [x] Partners CRUD; compatibility scoring (§9.6) + calibration test; result screen — *the scoring engine and calibration test are in (`astro/synastry.dart`, `synastry_calibration_test.dart`: `synastry(a, b)` returns the overall and Romance/Emotional/Communication scores, the element bonus, the "light" flag and every counted aspect with its weight and contribution, plus `supportive` and `growth` lists for the result screen). Partners CRUD is in too: `features/partners/` (domain `Partner` and `PartnerDraft`, drift `PartnerCache` at schema 3, `FirestorePartnerRemote` at `users/{uid}/partners/{id}` with the same local-first sync as the journal, tightened Firestore rules with 7 emulator tests, a Partners row on the Me tab, a list screen with delete-with-confirmation and a form with nickname, birthday, optional time and optional place; Free limit 1, Premium 5 via the `hasPremium` stub until M4). Burmese strings are generated and unreviewed. Deferred: a delete that fails while offline is not remembered, so that partner can come back on the next start; the tightened partners rule is not deployed yet. The result screen is in too: `PartnerResultScreen` at `/me/partners/result?id=…` (tap a partner row; a pencil on the row and an Edit button in the app bar open the form). It runs `synastry(you, partner)` on the device, shows "You (sign) + name (sign)", a meter ring with a three-band summary (35–54, 55–74, 75–98), the "Light reading" chip when a birth time is missing, the three sub-score bars, up to 3 "What flows" and 2 "Where you grow" aspects with bundled per-type texts, and the entertainment note; it handles loading, error, not-found and no-birthday states. Burmese is generated and unreviewed. Deferred: the Premium AI compatibility report is M4.*

### M4 — AI and monetization
- [x] Readings API client + caching (§8.2) — *client, drift cache and fallback order are done and tested; the app uses them once `READINGS_API_URL` is set, so real calls wait for the server (repo `mochi-moon-api`). Premium endpoints come later.*
- [ ] Server: nightly generation, reports endpoints, purchase verification (separate repo) — *nightly generation and the natal report endpoints are built (see the next item); the compatibility report is still to do. Purchase verification and renewal notifications are built and tested (2026-11-02) but not deployed, pending the Play developer account.*
- [ ] Paywall, Play Billing products, entitlement from Firestore, restore
- [ ] Full natal and compatibility reports — *the **natal** report is built: server `POST/GET /reports/natal` (13 parts, one OpenAI call each, validated and retried; restart-safe; owner-only; erased with the account) and the app's `features/cosmic/report/` (a "Your full reading" card at the bottom of the birth chart, shown when `hasPremiumProvider` is true, which is a stub that returns true until the paywall; the report screen shows the parts as they arrive with "n of total parts ready, about X min read", then the entertainment note). A finished report is saved in the `CachedReports` table keyed by language and the chart's request, so editing the birth data replaces it and a saved one needs no network. Burmese titles and texts come from the server's prompt and are **unreviewed**. Deferred: the Premium check on the server and the paywall teaser for free users (M4), the compatibility report, and sharing or exporting the reading.*
- [ ] For You deck with embeddings (§7.2); daily mix card
- [ ] Analytics with consent, Crashlytics

### M4b — Free/Premium rebalance (2026-11-02; rules in §6.13)

PRD edits are done. The app is not launched, so no grandfathering is needed. Items run in this safe order; the first is a launch blocker.
- [x] 1. Server: an entitlement check helper (Admin SDK read of `users/{uid}.entitlement`); 402 `premium_required` on `POST /reports/natal` and `POST /letters/weekly`; `GET /reports/natal/{id}` stays open to the owner; pytest for free, expired and Premium users; deploy with the owner's go-ahead (§8.2). *(done and deployed 2026-11-02, `3a90cd9`.)*
- [x] 2. App: the natal report and weekly letter clients map 402 to a soft paywall invitation (`server_402`); tests. *(done: natal screen shows the invitation; the weekly card is Premium-only and hides on error; its free teaser link comes with item 13.)*
- [x] 3. A shared `PremiumPreview` soft-lock widget (`core/widgets/`) and one `free_limits.dart` (deck 5, own cards 1, sealed letters 1, partners 1, mood months 2); widget tests incl. TalkBack labels. *(done: `core/widgets/premium_preview.dart`, `core/premium/free_limits.dart`; each limit is wired to it in its own item below.)*
- [x] 4. Deck: `deck_history` records where a card was read (drift migration plus migration test); the limit counts ritual and deck cards only; `dailyCardLimitProvider` follows `hasPremiumProvider`; the limit card gets the gentle upsell (`deck_limit`); tests for day 1 (3 sample cards, then a full ritual) and a journey day. *(done, drift schema 9: `deck_history.source`; Premium deals at most 50 cards at a time so the deck stays a short list.)*
- [x] 5. Own cards: free limit 1; over-limit cards stay readable, deletable and in the rotation; tests. *(done: `ownCardFreeLimit` follows `FreeLimits.ownCards`; lapse test keeps three cards in the pool.)*
- [x] 6. Letters: one sealed letter at a time free; tests. *(done: `sealedLettersLeft`, `LetterRejection.limitReached`, a gentle dialog with `letters` source; opened letters free the slot.)*
- [ ] 7. Quests: the swap is Premium; tests.
- [ ] 8. Mood calendar: the current and previous month free, older months soft preview; the recap is unaffected; tests.
- [ ] 9. Cosmic Today: second color, love line, lucky number and avoid behind `PremiumPreview`; the ritual reward card unchanged; tests.
- [ ] 10. Chart: no aspect lines for free users, a signs-only list, and the new Premium aspects list with degrees and houses; tests.
- [ ] 11. Compatibility: sub-scores and aspects behind preview; partner limit source; tests.
- [ ] 12. Retrograde alerts: Venus and Mars are Premium (locked switches, nothing scheduled for free users); tests.
- [ ] 13. Paywall: the new 3 bullets and benefit order; every entry point wired with its `source`; analytics sources.
- [ ] 14. Trial offer after the day 2–3 ritual (once, dismissible, skipped on hard-day days and for Premium); tests.
- [ ] 15. Guard test: the ritual, the hard-day kit, breathing and Help never show a paywall or lock.
- [ ] 16. Lapse tests: a Premium user goes free and nothing she made disappears.
- [ ] 17. As each is built later (`/daily/personal`, the compatibility endpoint and credit, For You, widget themes): gated on the server from day one.

### M5 — Self-love expansion (v1.1)

Audit on 2026-10-31: M0–M4 are as ticked above, with the font item unticked. Nothing in M5 is built. Order of risk is in `docs/PLAN.md`.

#### M5a — Ritual home, onboarding change and the first self-love features
- [x] Profile astro fields nullable, `hasAccountProfile` vs `hasBirthData`, migration tests (§6.1) — *done 2026-10-31: `isComplete` replaced; reconcile keeps remote birth data; the onboarding flow itself changes in P7*
- [x] Onboarding reordered, birth data moved to the Cosmic unlock flow (§6.1) — *onboarding asks name, focus areas, reminder; the Cosmic unlock flow (birth date, time, place) saves only on the last step.*
- [x] 4-tab shell: Today (home), Deck, Cosmic, Me; routes, deep links, notification and widget targets updated (§5) — *shell done 2026-10-31 (P5): Today opens first with a stub (streak + button to the deck); the /deck route the widget link uses is unchanged and the reminder opens the app on Today (neither re-tried on a device); the ritual itself is P11+*
- [x] Firestore rules and emulator tests for the new subcollections; account deletion covers them (§8.1, §6.14) — *rules + 83 emulator tests done 2026-10-31 (P3, committed, not yet deployed to dev); account deletion coverage done in P4 (2026-10-31); rules still to deploy*
- [x] Drift schema v4 with the first new tables (§8.6) — *done 2026-10-31: `mood_entries`, `gratitude_entries`, `custom_cards`, `ritual_days`, `ritual_progress`; the text columns are named `body`; the other §8.6 tables follow in their own tasks*
- [x] Daily mood check-in stored per date (§6.18, month view) — *done 2026-10-31: Deck check-in, Me → Mood, Firestore sync of `moods/{date}`; the ritual's mood step comes with the ritual flow*
- [x] Daily ritual on Today with streak and cosmic reward (§6.15)
- [x] Gratitude and wins jar (§6.16) — *done 2026-10-31 (P13); the hard-day kit link comes with P17*
- [x] My own cards, 3 free (§6.17; M4b lowers the free limit to 1)
- [x] Breathe with Mochi (§6.19) — *done 2026-10-31 (P16, with the hard-day link in P17)*
- [x] Hard-day kit with `TODO_CONTENT` helplines (§6.26) — *done 2026-10-31 (P17)*
- [x] Strings and Burmese for M5a — *checked 2026-10-31 (P18): all 492 keys of `app_en.arb` have a Burmese string in `app_my.arb` with matching placeholders, and the translate tool reports nothing left to translate. Generated per feature with `tool/translate_content.dart`. **Unreviewed machine translation:** a native reviewer must approve the M5a strings (ritual, gratitude, own cards, mood, breathe, hard-day) before they count as shipped. Thai is not generated.*

#### M5b — Depth and retention
- [x] Tiny kindness quests (§6.20) — *Q1 + Q2 done 2026-11-01. Only 18 starter quests; the 120-quest launch set, the weekly-letter aggregate and mascot milestones come later.*
- [ ] Self-love journeys, 1 free (§6.21) — *Q3 done 2026-11-01: schema, loader, progress model, drift table (schema v6), Firestore sync, one starter journey (Confidence, 7 days, en + my). *Q4 done 2026-11-01: Me → Journeys list, journey page, day screen (3 gated cards, quest, private reflection), Premium lock via `hasPremiumProvider`, completion share image. Completing a day counts toward the streak; the mascot unlock on completion is Q6; the other three scripts are L2 (done 2026-11-02, English only: `healing`, `calm_work`, `body_kindness`; the healing page links to the hard-day kit; cards reuse the 20 launch quotes until L6); the paywall itself is unbuilt.*
- [x] Letter to future me with unlock notification (§6.22) — *Q5 done 2026-11-02: Me → Letters (write, seal with confirm, list, read once open, delete), local notification on the unlock day with generic text, drift table (schema v7), Firestore sync. Clock-change limitation documented in §6.22.*
- [ ] Mochi grows with you: items and room (§6.23) — *Q6 done 2026-11-02: `mascot_items.json` (12 starter items, English names only), unlock engine (streak 3/7/14/30/60/100 and journey finish; items are only added), drift `mascot_inventory` (schema v8), Firestore sync to `state/mascot`, equip with the Premium check. Open: Burmese names (the translate tool does not cover `mascot_items.json` yet), quest-count unlocks, the 24 launch items and their art (`ill_mascot_*` files do not exist), Q7 done 2026-11-02: Me → Mochi's room screen (one item per slot, locked hints, Premium note, TalkBack labels, 1.3x text). Not built: an unlock celebration and item art (icons stand in).*
- [ ] Mood insights, Premium (§6.18)
- [x] Weekly letter from Mochi, Premium: server endpoint and app (§6.24, §8.2) — *Q9 server + Q10 app done 2026-11-01; the `weekly_letter_viewed` event waits for Q12.*
- [x] Monthly glow recap (§6.25) — *done: Me → Monthly glow (`/me/recap`) and a Today card on days 1–3 of the month; counts, top mood and last saved bundled card are worked out on the device, the share image is drawn on the device in the light theme and holds no text she wrote; a welcome-back variant when she did not show up; logs `recap_shared`.*
- [x] Analytics events for the new features (§11) — *done: every §11 event is wired (ritual, gratitude count only, jar, own card, mood id, breathe, quests, journeys, letters, mascot unlock, weekly letter, recap, cosmic unlock). Params are ids, counts and days only; `AnalyticsLogger` drops unlisted params and does nothing without consent. Still a no-op sink until `firebase_analytics` is approved.*
- [ ] **(Post-launch)** Strings and Burmese for M5b — *Owner decision (repeated 2026-11-02): v1 launches in English only; Burmese is postponed to after launch, so do not translate, run `tool/translate_content.dart`, or ask about Burmese during launch work. All M5b strings are in `app_en.arb`. After launch: add OpenAI credits, run `dart run tool/translate_content.dart --arb` (54 keys have no Burmese yet), and have a native reviewer check it.*

### M6 — Launch
- [ ] Content: 500 quotes and 60–100 illustrations in all shipped languages, human-reviewed — *2026-11-02: 500 English quotes are in (84/84/84/83/83/82 over the six categories). Illustrations: the 54 overall ones are enough for launch (owner decision: no more for now; never one per quote). Still open: human review, and Burmese after launch.*
- [ ] Content for the new features in en and my (th when a reviewer exists): 4 journey scripts, 120 quests, breathing copy, hard-day copy with verified helplines, 24 mascot items, mood icons
- [ ] Store listing leading with the daily ritual, journeys and affirmations (astrology mentioned after), screenshots in en/my (th later), privacy policy, Data safety form
- [ ] Closed test with ≥ 15 testers for 14+ days (Google Play requires 12 for 14 days on new personal accounts)

### Later
- [ ] iOS build with Sign in with Apple and self-love-first App Store positioning
- [ ] Listen mode (TTS) for accessibility
- [ ] Placidus houses option
- [ ] More mascot outfits and seasonal decks
- [ ] Extra home-screen widget themes, Premium (§6.5)

---

## 13. Open questions

- Domain name and API host (`api.<domain>`).
- Final price points per region (set in Play Console; suggested anchors: yearly ≈ 6× monthly).
- Who reviews Thai content (native reviewer needed), and who reviews the OpenAI-generated Burmese (§7.1a).
- Helpline sources and wording per locale for the hard-day kit (the owner verifies every name and number before launch).
- Mascot item art: who draws the 24 launch items and in what style.
- Do existing test users see the new onboarding, or only new installs? (Suggested: only new installs; existing profiles keep their birth data.)
- Price anchors once the paywall leads with self-love. (The free journey is Confidence: decided.)
- M4b: how to test Premium end to end against the server (suggested: Play license testers, no server backdoor).
- M4b: confirm that own cards above the free limit stay in the rotation after a lapse (principle 3 says yes).
- M4b: confirm that the "Today's energy" daily mix card (§6.10) and Thai colors stay free.
- Whether to register a Play **organization** account (needs business verification but skips the closed-testing requirement) or a personal one.
