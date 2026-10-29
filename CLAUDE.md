# CLAUDE.md — Mochi Moon

This file is the standing brief for Claude Code. Read it fully at the start of every session.
The product spec lives in `docs/PRD.md`; read the section for the feature you're working on before writing code.

---

## 1. What we're building

**Mochi Moon** is a cute, girl-focused self-love app for Android (iOS later) built in Flutter.

Two pillars:

1. **Self-love deck** — illustrated affirmation cards in a Tinder-style swipe deck. Each card is locked for a short read-aloud timer (≥ 3 s) before it can be swiped.
2. **Cosmic you** — Western (tropical) astrology: daily sign guidance, lucky colors, things to avoid, retrograde tracker, moon phase, birth chart, and love compatibility.

Mascot: a moon bunny. Tone: soft, warm, encouraging, never fatalistic.

**Hard product rules**

- There is **no chat feature** of any kind. Never add a chatbot, chat UI, or free-text prompt to an AI.
- AI is used only in the background: written readings (generated server-side), the "For You" quote ranking, and the daily mix. See PRD §7.
- **Western tropical zodiac only.** No Vedic/sidereal calculations.
- Read-aloud gate is a **timer ring only**. Never request microphone permission; never add speech recognition.
- Self-love is the primary identity. The app's home tab is the deck, not astrology.

---

## 2. Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter (latest stable), Dart 3, null safety |
| Platforms | Android first (min SDK 24). iOS code must compile but is not a release target yet |
| State management | Riverpod (current stable) with code generation (`riverpod_annotation`, `riverpod_generator`) |
| Routing | `go_router` with a `StatefulShellRoute` for the bottom tabs |
| Models | `freezed` + `json_serializable` |
| Local storage | `drift` (SQLite) for cache and offline data; `shared_preferences` only for tiny flags |
| Auth | Firebase Auth with Google sign-in (`firebase_auth`, `google_sign_in`) |
| Cloud data | Cloud Firestore (`cloud_firestore`) |
| Push | `firebase_messaging` + `flutter_local_notifications` |
| Swipe deck | `flutter_card_swiper` |
| Home widget | `home_widget` (Android Glance/RemoteViews side written in Kotlin) |
| Astro math | `astronomia` (MIT, pure Dart) |
| Time zones | `lat_lng_to_timezone` + `timezone` |
| Share | `share_plus` + `RepaintBoundary` image capture |
| Purchases | `in_app_purchase` (Google Play Billing) |
| Animation | `lottie` (or `rive` if a feature calls for it) |
| Localization | `flutter_localizations` + `intl` + ARB files (gen-l10n) |
| HTTP | `dio` |
| Testing | `flutter_test`, `mocktail`, golden tests for astro math |
| Lints | `very_good_analysis` (or `flutter_lints` if it becomes too noisy) |

### Licensing rule

Only MIT, BSD, Apache-2.0 or similarly permissive dependencies. **Never add AGPL or GPL packages** (this includes `sweph`/Swiss Ephemeris bindings). Ask before adding any dependency not listed above.

---

## 3. Commands

```bash
flutter pub get
dart run build_runner build                                # after editing freezed/riverpod/drift/json files (the --delete-conflicting-outputs flag was removed in current build_runner)
dart run build_runner watch                                # during active development
flutter gen-l10n                                           # after editing ARB files
flutter analyze                                            # must be clean before you finish a task
flutter test                                               # all tests must pass
flutter test test/features/cosmic/astro/                   # astro engine tests only
flutter test path/to/file_test.dart --plain-name "<name>"  # a single test
scripts/ci.ps1 (Windows) or scripts/ci.sh                  # pub get + codegen + l10n + analyze + test
flutter run --flavor dev -t lib/main_dev.dart              # dev flavor
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

Before telling me a task is done: run `flutter analyze` and `flutter test`, and report the result.

---

## 4. Architecture

Feature-first folders, with four layers inside each feature. Dependencies point inward only:
`presentation → application → domain ← data`.

- **domain**: pure Dart entities, value objects, repository interfaces. No Flutter imports, no Firebase imports.
- **data**: repository implementations, DTOs, Firestore/drift/HTTP data sources.
- **application**: Riverpod providers/notifiers that orchestrate use cases.
- **presentation**: widgets and screens. No business logic beyond simple view state.

```
lib/
  main_dev.dart
  main_prod.dart
  app/
    app.dart                 # MaterialApp.router, theme, localization delegates
    router.dart              # go_router config, auth redirect
    flavors.dart
  core/
    theme/                   # color tokens, typography, spacing, radii
    l10n/                    # generated localizations (do not edit by hand)
    widgets/                 # shared UI: MochiButton, MochiCard, TimerRing, Sparkle, EmptyState
    errors/                  # AppFailure sealed class, error mapping
    network/                 # dio client, auth interceptor (Firebase ID token)
    storage/                 # drift database, DAOs
    analytics/               # consent-gated event logger (no-op until consent)
    utils/
  features/
    auth/                    # Google sign-in, onboarding, account deletion
    deck/                    # self-love swipe deck, timer gate, share
    journal/                 # saved cards ("This is me")
    cosmic/
      astro/                 # PURE DART astro engine (see §6) — no Flutter imports
      today/                 # daily guidance, lucky colors, things to avoid
      retrograde/
      moon/
      chart/                 # birth chart screen + wheel painter
      compatibility/
    for_you/                 # AI-ranked deck
    paywall/                 # premium, purchases, entitlement
    settings/                # language, notifications, privacy, delete account
    widget_bridge/           # home_widget sync
assets/
  content/
    quotes/quotes.json       # see PRD §8.3
    signs/signs.json         # sign metadata, palettes, base texts
    fallback_readings/       # offline fallback readings per sign per language
  illustrations/             # webp, named by id (see PRD §8.4)
  fonts/
  lottie/
l10n/
  app_en.arb
  app_th.arb
  app_my.arb
test/                        # mirrors lib/
docs/
  PRD.md
```

### Riverpod conventions

- One provider per concern; name providers by what they return (`dailyReadingProvider`, not `getDailyReading`).
- Use `AsyncNotifier` for anything that loads data. Never call repositories directly from widgets.
- Repositories are injected through providers so tests can override them.

### Error handling

- Data layer throws; repositories catch and return `Result<T, AppFailure>` (or throw a typed `AppFailure`). Pick one approach in the first feature and use it everywhere.
- Every screen handles loading, error, empty, and offline states. Offline must still show cached or fallback content.

---

## 5. UI and design rules

- Theme tokens live in `core/theme`. **Never hardcode colors, font sizes, radii or spacing in widgets.**
- Palette: pastel. Primary lavender, accent peach/pink, background cream, ink deep plum. Dark mode supported from day one.
- Corners rounded (cards 24, buttons 16). Soft shadows only.
- Fonts are **bundled** (no runtime font fetching):
  - Latin display: a rounded display font (e.g. Fredoka or Quicksand)
  - Body: Nunito (or similar)
  - Thai fallback: Noto Sans Thai
  - Burmese fallback: Noto Sans Myanmar
  Set `fontFamilyFallback` so Thai and Myanmar glyphs always render.
- Minimum touch target 48 dp. Support system text scaling up to 1.3× without overflow.
- Every image has a semantic label. Every interactive element is reachable by TalkBack.
- Animations: subtle and short (≤ 400 ms) except celebratory sparkles. Respect "reduce motion".

---

## 6. Astro engine rules (`features/cosmic/astro/`)

- **Pure Dart.** No Flutter, Firebase or I/O imports. It must run in plain `dart test`.
- All times inside the engine are **UTC**. Convert local birth time → UTC at the boundary using the IANA zone from `lat_lng_to_timezone` and historical offsets from `timezone`.
- Angles in degrees, normalized to [0, 360).
- Public API (keep it small):
  - `NatalChart computeNatalChart(BirthData data)`
  - `List<Placement> planetPositions(DateTime utc)`
  - `RetrogradeCalendar retrogrades(int year)`
  - `MoonPhase moonPhase(DateTime utc)`
  - `Synastry synastry(NatalChart a, NatalChart b)`
- Houses: **Whole Sign** only for v1.
- Unknown birth time → noon local time, `timeKnown = false`, no Ascendant, no houses.
- Formulas and scoring rules are in PRD §9. Do not invent different ones.
- **Golden tests are mandatory**: `test/features/cosmic/astro/golden_charts.json` holds known charts. Sun/Moon/planet signs must match exactly; degrees within 0.5°; Ascendant sign must match.

---

## 7. Content and localization

- **No hardcoded user-facing strings.** Everything goes through `AppLocalizations` (UI) or the content JSON files (quotes, sign texts).
- Supported locales: `en`, `th`, `my`. English is the source of truth; add keys to `app_en.arb` first, then the others.
- **Thai (`th`) is implemented last**, once a native reviewer exists. Until then do not add `app_th.arb`, Thai quote text, or Thai fonts/fallbacks; ship `en` and `my` only.
- Burmese text must be **Unicode**, never Zawgyi.
- Content JSON is loaded through a `ContentRepository`; never `rootBundle.loadString` from widgets.
- **Translations are generated with OpenAI, not by Claude.** Burmese strings and content texts come from `tool/translate_content.dart`, a dev-time script (plain `dart:io` HTTP, no new app dependency). Claude Code writes and runs the tool but does not hand-write `my` text itself. Only Burmese is generated and shipped for now; Thai is not generated until the owner asks.
  - The English files are the only source: `app_en.arb`, `assets/content/fallback_readings/en.json`, and the quote texts. Output goes to `app_my.arb` and the per-language content JSON (`my.json`).
  - Model: `gpt-6-luna` with high reasoning effort (defaults in the tool; `OPENAI_MODEL` overrides). The key is `OPENAI_API_KEY`, read from the environment or from a local `.env` in the project root (gitignored). Never put the key in the repo, a commit, a log, or chat.
  - Only app copy and content texts are sent. Never send birth data, profile data, journal entries, partner names, or user ids.
  - The prompt demands Unicode (never Zawgyi), the soft, warm, never-fatalistic tone, and no predictions about health, death, pregnancy, money outcomes, or legal matters.
  - The tool validates its output: same keys as English, `{placeholders}` and JSON shape intact, no Zawgyi, 30–120 words for readings, and three `avoid` items. It skips strings already translated unless `--force` is passed.
  - Machine-translated text is **unreviewed** until a native reviewer signs off; note that in `docs/PRD.md` §12.
- Readings from the server carry a `lang`; if the requested language is missing, fall back to English, then to bundled fallback readings.

---

## 8. Backend contract

- The app talks to two backends:
  1. **Firebase** (Auth, Firestore, Cloud Messaging). Schema and rules in PRD §8.1.
  2. **Readings API** on the Hostinger VPS (`https://api.<domain>/v1/...`). Contract in PRD §8.2.
- Every Readings API call sends `Authorization: Bearer <Firebase ID token>`.
- **Privacy rule:** for personalized reports, send **computed chart placements only**, never raw birth date/time/place.
- Cache every reading in drift with its `date`, `sign`, `lang`, and `version`. Show cached content immediately, refresh in the background.
- Base URLs and keys come from flavor config. **Never commit secrets** (`google-services.json` for prod, API keys, keystores). Use `.env`/`--dart-define` and keep them in `.gitignore`.

---

## 9. Security, privacy and store compliance

- Users can only read/write their own Firestore documents (rules in PRD §8.1). Test the rules with the emulator.
- Account deletion must work **in-app** (Settings → Delete account) and through a web page; it deletes Firestore data and the Auth user.
- No ads SDKs. Analytics only after explicit consent, and never log birth data, partner names, or journal contents.
- Every reading screen shows a small "For entertainment and self-reflection" note.
- Never write predictions about health, death, pregnancy, money outcomes, or legal matters (the server prompt enforces this too; the app must not add such copy).
- Store metadata must lead with self-love/affirmations (relevant for the future iOS review).

---

## 10. Testing

- Unit tests for every repository and notifier; widget tests for every screen's main states (loading, data, error, offline).
- Astro engine: golden tests (see §6) plus property tests (angles always in range, retrograde periods ordered).
- Timer gate: widget test proving a swipe is cancelled before the timer completes and allowed after.
- Use `mocktail` for fakes; override providers in tests rather than reaching into globals.
- Firestore rules: test with the Firebase emulator suite.

---

## 11. How to work in this repo

- Work on **one feature or one PRD milestone item per session**. Read its PRD section first.
- Plan briefly before coding: list files you will create or change.
- Keep commits small and use Conventional Commits (`feat(deck): add timer gate`).
- After finishing, tick the matching checkbox in `docs/PRD.md` §12 and note anything deferred.
- If the PRD is ambiguous or conflicts with this file, **stop and ask** rather than guessing. This file wins on engineering rules; the PRD wins on product behavior.
- Don't refactor unrelated code in the same change.
- Don't generate placeholder lorem ipsum in shipped content; use clearly marked `TODO_CONTENT` keys instead.

---

## 12. Never do

- Add a chat feature, chatbot, or free-text AI prompt.
- Request microphone, contacts, location (background), or camera permissions. (Birthplace is searched by name; no GPS needed.)
- Add AGPL/GPL dependencies.
- Hardcode strings, colors, or secrets.
- Send raw birth data to the Readings API or any third party.
- Commit or print the OpenAI key, or send anything but app copy and content texts to OpenAI.
- Use sidereal/Vedic calculations.
- Put business logic in widgets.
- Mark a task complete with failing tests or analyzer warnings.
