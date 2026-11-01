# Mochi Moon — Self-love expansion: implementation plan

Companion to `docs/PRD.md` v1.1 (2026-10-31). Nothing here is started. Each task fits one Claude Code session (about 3–9 h of focused work, including tests, `flutter analyze` and `flutter test`). Work them in order; do not start M5b before M5a is merged.

Conventions for every task: read the PRD section first; new strings go to `app_en.arb` first (Burmese comes from `tool/translate_content.dart`, never by hand); no hardcoded colors, sizes or strings; private text never goes to the AI API or to analytics; tick the PRD §12 box at the end.

## 1. Gaps found (audit, 2026-10-31)

PRD §12 ticks were checked against code and tests.

**Checkbox changes made in the PRD**
- §6.3 category filter: **now ticked** (built in `journal_screen.dart`, test `filters by category`).
- §12 M0 bundled fonts: **now unticked**. Only `assets/fonts/MochiSymbols.ttf` is bundled. The display font, Nunito and the Noto Sans Myanmar/Thai fallbacks are missing. This also blocks §6.4 (share image in all scripts). → task L1.

**Still open or partial (left unticked, nothing in M5 depends on them except where noted)**
- Language-first onboarding (§6.1, planned). → P6.
- §6.1 whole flow in en/my: new profile strings fall back to English.
- Prod Firebase project, `google-services.json`, release SHA-1 (M2).
- Account deletion: the web page is not switched on; the server call is untested from the emulator. The client erases only `journal` and `partners`. → P4.
- Deck mood check-in and the heart animation (§6.2) were never built. The ritual needs the mood step. → P9.
- Premium upsell on the daily-limit card is not built; `hasPremiumProvider` returns `true` for everyone (`paywall/application/entitlement_providers.dart`). M5 gating is built against that provider and tested with overrides; the real paywall and Play Billing (M4) are not part of this plan.
- Paywall, billing, server purchase verification, compatibility report, For You deck, daily mix, analytics sink and Crashlytics (M4) remain open.
- §6.14 privacy policy and Terms; §6.11 server-side cache invalidation.

**Code conflicts with the PRD (docs were corrected where noted)**
- `firestore.rules` lets the owner delete `users/{uid}`; the old outline said `delete: if false`. The outline in §8.1 now matches the code and adds the new collections.
- Natal reports are kept by the server (SQLite) and the device (drift `CachedReports`), not in `users/{uid}/reports` (note added in §8.1).
- `UserProfile.isComplete` requires a birth date (`profile/domain/user_profile.dart`); it gates onboarding in `sign_in_step.dart`, `profile_providers.dart` and `app/bootstrap.dart`. → P1.
- Signs are written to Firestore unconditionally from `signsOfProfile`. → P1.
- Header and §10 promised en/th/my; changed to en + my, th when a reviewer exists.
- Working tree already has unrelated edits (`thai_colors_section.dart`, `deck_providers.g.dart`, `.vscode/`); commit or stash them before P1.

## 2. Risky changes (do first, in this order)

| # | Risk | Why it is risky | Mitigation |
| --- | --- | --- | --- |
| 1 | Nullable astro profile fields + migration (P1) | Existing profiles and Firestore docs must still load; a wrong `isComplete` locks users out or sends them through onboarding again | Split into `hasAccountProfile` and `hasBirthData`; tests with a legacy full profile, a name-only profile and a doc missing signs |
| 2 | Drift schema v4 (P2) | A bad migration loses local journal and profile | Migration test from v3 with data; additive tables only |
| 3 | Firestore rules (P3) | A too-strict rule silently stops sync; a loose one leaks data | Emulator tests per collection; deploy to `mochi-moon-dev` first |
| 4 | Account deletion coverage (P4) | A missed subcollection keeps user data after deletion (a store and privacy problem) | One list of subcollections shared by client, server and a test |
| 5 | 4-tab shell (P5) | Routes, widget deep link `mochimoon://widget/deck`, notification payloads and the redirect all assume 3 tabs with Deck first | Update and test every entry point before building Today |
| 6 | Onboarding reorder + Cosmic unlock (P6–P8) | The first-run path is the most used; existing users must skip it | Widget tests for first-run order, legacy user, and restart after deletion |

## 3. Task list

Hours are rough focused-work estimates. "Dep" lists tasks that must be done first.

### M5a — Ritual home, onboarding change, first features (95 h)

**P1 — Nullable astro profile fields** (4 h) · Dep: none
- Goal: a profile is complete with a name alone; birth data is optional (PRD §6.1).
- Files: `profile/domain/user_profile.dart` (`hasAccountProfile`, `hasBirthData`), `profile_codec.dart`, `profile_providers.dart`, `firestore_profile_remote.dart`, `onboarding/application/sign_in_step.dart`, `app/bootstrap.dart`, every reader of `birthDate` in `cosmic/` and `partners/`.
- Tests: legacy full profile loads; name-only profile; Firestore doc without signs; signs not written when birth date is null; existing profile tests stay green.

**P2 — Drift schema v4** (4 h) · Dep: none
- Goal: add `mood_entries`, `gratitude_entries`, `custom_cards`, `ritual_days`, `ritual_progress` (more tables arrive in their own tasks, as additive migrations).
- Files: `core/storage/tables.dart`, `app_database.dart`, generated files, `DriftLocalDataEraser` (wipe new tables).
- Tests: migration v3 → v4 keeps data; eraser clears the new tables.

**P3 — Firestore rules for self-love data** (5 h) · Dep: none
- Goal: owner-only rules with shape and size checks for `gratitude`, `customCards`, `moods`, `letters`, `journeyProgress`, `state/{quest|mascot|ritual}` (PRD §8.1).
- Files: `firestore.rules`, `test/firestore_rules/firestore.rules.test.js`.
- Tests: emulator tests per collection (owner ok; other user denied; 201-char gratitude, 141-char card, unknown keys, bad mood denied). Deploy to dev with the owner's go-ahead.

**P4 — Account deletion covers new data** (4 h) · Dep: P3
- Goal: client and server erase every new subcollection (PRD §6.14).
- Files: `auth/data/firestore_account_remote.dart` (shared list `_subcollections`), `drift_local_data_eraser.dart`; server repo `mochi-moon-api` (`DELETE /v1/account`, weekly letters table once it exists).
- Tests: fake Firestore with data in every collection ends empty; a test that fails if a collection named in §8.1 is missing from the list.

**P5 — Four-tab shell with Today stub** (6 h) · Dep: P1 (so Today can render without birth data)
- Goal: Today (home), Deck, Cosmic, Me; Today is a stub with the streak and a start button.
- Files: `app/router.dart` (new branch, `AppRoutes.today`), shell scaffold/nav bar, widget deep link and notification payload handlers, `l10n`.
- Tests: tab switching; initial location is Today; widget deep link still opens the Deck at today's card; reminder notification opens Today.

**P6 — Language-first onboarding screen** (4 h) · Dep: none (planned earlier in PRD §6.1)
- Goal: the first screen after splash is the language choice; it is also first after account-deletion restart.
- Files: `onboarding/presentation/` (new `language_screen.dart`), reuse `settings` language providers/section, router redirect.
- Tests: first-run order; restart after deletion shows it; choice applies immediately.

**P7 — Reorder onboarding** (6 h) · Dep: P1, P5, P6
- Goal: language → samples → sign-in → name → focus → reminder → Today (PRD §6.1).
- Files: `onboarding/domain/profile_setup_state.dart` (`ProfileStep`: name, focus, reminder), `profile_steps.dart`, `profile_setup_screen.dart`, `onboarding_providers.dart`, router redirect.
- Tests: step order and `canContinue`; legacy user with a complete profile skips setup; back navigation keeps data; 1.3× text scale.

**P8 — Cosmic unlock flow and locked states** (7 h) · Dep: P1, P5
- Goal: "Unlock your cosmic side" with birth date → time → place steps; locked state on Cosmic, chart, compatibility and the Today reward card.
- Files: `cosmic/presentation/cosmic_screen.dart`, new `cosmic/unlock/` (or reuse the onboarding birth steps), `chart_screen.dart`, `partners/` entry points, `cosmic_today_providers.dart`.
- Tests: locked state without birth data; unlock saves birth data and signs and opens Cosmic; leaving mid-flow keeps the locked state; Moon and retrograde stay visible.

**P9 — Daily mood: store, chips, month calendar** (7 h) · Dep: P2, P3
- Goal: 6-mood check-in component; one mood per date; month view; Deck check-in (the §6.2 gap); Firestore sync of `moods/{date}`.
- Files: new `features/mood/` (domain, data drift + Firestore, application, presentation), `deck/presentation/deck_screen.dart`, Me tab entry, `l10n`.
- Tests: last choice per date wins; calendar month navigation; sync mapping; mood re-ranks the next cards as before.

**P10 — Streak rule** (3 h) · Dep: P2
- Goal: a day counts for a completed ritual or ≥ 1 completed deck card (PRD §6.2/§6.15).
- Files: `deck/domain/deck_planner.dart` (streak function), `deck/domain/deck_counters.dart`, `ritual` day source, `firestore_deck_counters_remote.dart`.
- Tests: ritual-only day; card-only day; gap day; streak alive until today ends; sync mapping.

**P11 — Daily ritual flow** (9 h) · Dep: P5, P9, P10
- Goal: mood → 3 gated cards → gratitude line (stubbed until P13) → completion sparkle → streak; resume mid-ritual; free limit counting (PRD §6.15).
- Files: new `features/ritual/`, reuse `deck/presentation/gated_card_deck.dart` and `read_aloud_gate.dart`, `deck_planner.dart` (limit), `core/widgets/` sparkle, Today screen.
- Tests: timer gate holds in the ritual; fewer than 3 cards left; resume at the same step; reduce motion; offline.

**P12 — Cosmic reward card on Today** (3 h) · Dep: P8, P11
- Goal: last step of the ritual shows today's energy and lucky color, or the unlock prompt.
- Files: `ritual/presentation/`, `cosmic/today/application/cosmic_today_providers.dart`.
- Tests: with and without birth data; neither blocks completion.

**P13 — Gratitude and wins jar** (7 h) · Dep: P2, P3, P11
- Goal: 1–3 entries/day (≤ 200 chars), jar animation, "Open the jar", delete, sync, wire into the ritual step.
- Files: new `features/gratitude/`, Me tab entry, ritual step, `l10n`.
- Tests: 200-char limit; 3-per-day limit; random past entry excludes today; private (no analytics param); sync mapping.

**P14 — Own cards: data, limit, sync** (6 h) · Dep: P2, P3
- Goal: create/edit/delete cards (≤ 140 chars), 3 free via `hasPremiumProvider`, sync.
- Files: new `features/custom_cards/` (domain, drift, Firestore), `core/content/quote.dart` mapping, entitlement provider.
- Tests: free limit and Premium override; slot freed on delete; no embedding.

**P15 — Own cards: UI, deck rotation, widget, share** (6 h) · Dep: P14
- Goal: editor with illustration picker, cards enter the deck and ritual, can be the widget card, shareable.
- Files: `custom_cards/presentation/`, `deck/domain/deck_planner.dart`, `widget_bridge/`, `share_*`.
- Tests: card appears in rotation; widget picks it; timer gate applies; paywall opens on the 4th.

**P16 — Breathe with Mochi** (5 h) · Dep: P5
- Goal: 1-minute 4-4-4-4 session, reduce-motion variant, `breathing.json` copy.
- Files: new `features/breathe/`, `assets/content/breathing/breathing.json`, `ContentRepository`, Today/Me entries.
- Tests: phase timing with fake clock; reduce-motion layout; offline; finish and early exit.

**P17 — Hard-day kit** (6 h) · Dep: P13, P16
- Goal: button on Today and Deck; breathing, 3 comforting cards, the jar, Help section with the not-a-substitute note and `TODO_CONTENT` helplines (PRD §6.26).
- Files: new `features/hard_day/`, `assets/content/hard_day/hard_day.json`, entries on Today and Deck.
- Tests: Help shows the note and no numbers while entries are `TODO_CONTENT`; works offline and signed out; no text logged.

**P18 — Strings and Burmese for M5a** (3 h) · Dep: P1–P17
- Goal: all new keys in `app_en.arb`; run `tool/translate_content.dart` for `my`; mark unreviewed in PRD §12.
- Files: `l10n/*.arb`, `docs/PRD.md`. Tests: `my` has every `en` key and placeholders match (the translation tool already validates this).

### M5b — Depth and retention (80 h)

**Q1 — Quests: content, loader, daily pick** (5 h) · Dep: M5a
- Goal: `quests.json` schema, loader, deterministic daily pick by focus areas, one swap.
- Files: `assets/content/quests/`, `core/content/`, new `features/quests/domain`. Tests: same pick all day; swap once; focus-area match; JSON shape.

**Q2 — Quests: UI, state, sync** (5 h) · Dep: Q1, P2, P3
- Goal: quest card on Today, done/swap, `state/quest` sync, eraser.
- Files: `features/quests/`, Today screen, drift table, Firestore remote. Tests: state across days; sync mapping.

**Q3 — Journeys: domain, content, progress** (7 h) · Dep: M5a
- Goal: `journeys.json` schema/loader, progress model with pause-never-reset, sync of `journeyProgress`.
- Files: `features/journeys/domain|data`, `assets/content/journeys/`, drift table. Tests: skipped days pause, never reset; day n content resolves to quotes and quests; sync mapping.

**Q4 — Journeys: UI and gating** (8 h) · Dep: Q3, Q1
- Goal: list, journey page, day screen (3 gated cards + quest + reflection), progress, free/Premium gating, completion share.
- Files: `features/journeys/presentation/`, router, paywall hook. Tests: one free journey; Premium locked state via override; reflection stored privately; counts toward streak.

**Q5 — Letter to future me** (8 h) · Dep: P2, P3
- Goal: write, seal for 30/90/365 days, unlock notification, open, delete, sync.
- Files: `features/letters/`, notification scheduler (like `local_notifications_reminder_scheduler.dart`), drift, Firestore. Tests: cannot open early; notification text excludes the letter; eraser and sync.

**Q6 — Mascot items: engine, inventory, sync** (6 h) · Dep: P10, Q3
- Goal: `mascot_items.json`, unlock rules (streak, journey, quests), inventory, `state/mascot` sync, no loss on missed days.
- Files: `features/mascot/domain|data`, drift table. Tests: unlock at thresholds; missed days never remove items; Premium flag.

**Q7 — Mascot room UI** (7 h) · Dep: Q6
- Goal: room screen with fixed slots, outfit equip, unlock celebration, semantic labels.
- Files: `features/mascot/presentation/`, Me entry, art references. Tests: equip/unequip; Premium item locked state; labels.

**Q8 — Mood insights (Premium)** (5 h) · Dep: P9, P11
- Goal: on-device gentle insights from ≥ 14 logged days.
- Files: `features/mood/domain/insights.dart`, mood screen. Tests: thresholds; wording keys contain no diagnostic terms (lint-style test over the strings); not enough data state.

**Q9 — Weekly letter: server** (8 h) · Dep: none (repo `mochi-moon-api`)
- Goal: `POST /v1/letters/weekly` per PRD §8.2: strict aggregate-only schema (400 on any other field), cache per user/week/lang, 3/week limit, style-guide post-check, erased with the account.
- Tests: schema rejects text fields; cache hit costs nothing; rate limit; deletion.

**Q10 — Weekly letter: app** (7 h) · Dep: Q9, P9, Q2
- Goal: aggregates builder (counts only), API client with the Firebase token, drift cache `weekly_letters`, Sunday notification, Today/Me display, bundled fallback, free-user teaser.
- Files: `features/letters/`, `core/network`. Tests: the request body contains only the allowed keys (test fails if a text field is added); offline fallback; cache per week/lang.

**Q11 — Monthly glow recap** (7 h) · Dep: P9, P10
- Goal: on-device story image from days shown up, top mood, favourite saved card; welcome-back variant.
- Files: `features/recap/`, reuse `deck/presentation/share_image_renderer.dart`. Tests: aggregation; empty-month variant; no user text rendered.

**Q12 — Analytics events** (4 h) · Dep: M5a features
- Goal: add the §11 events to `analytics_event.dart` with allowed params only; wire call sites.
- Tests: logger drops unknown params; no event carries text; consent off logs nothing.

**Q13 — Strings and Burmese for M5b** (3 h) · Dep: Q1–Q12
- **Postponed to after launch (owner, 2026-11-02): v1 is English-only. Skip this item.** Only check that every new string is in `app_en.arb`. Burmese later = P18 steps (translate tool, native review).

### M6 — Launch (67 h, mostly content and owner work)

**L1 — Bundle fonts** (3 h) · Dep: owner picks fonts
- Rounded display font, Nunito, Noto Sans Myanmar (and Thai later) in `assets/fonts`, `pubspec.yaml`, theme `fontFamilyFallback`; check the share image in en/my. Fixes the M0 and §6.4 gaps.

**L2 — Journey scripts** (8 h) · Dep: Q3. Four journeys (7/14/7/7 days) in en, then my via the tool; owner reviews tone.

**L3 — Quests** (4 h) · Dep: Q1. 120 quests in en, then my.

**L4 — Breathing and hard-day copy** (3 h) · Dep: P16, P17. **The owner verifies helpline names and numbers for each locale from official sources**; until then they stay `TODO_CONTENT`.

**L5 — Mascot art and items** (8 h) · Dep: Q6. 24 items (12 outfits, 12 room items) with names, unlock rules and semantic labels.

**L6 — Quotes (500) and illustrations (60–100)** (20 h) · existing launch item; includes the 6 mood icons and the 4 journey covers.

**L7 — Translation run and native review** (5 h) · Dep: L2–L5. Run the tool, record unreviewed status in PRD §12, hand to the reviewer.

**L8 — Store listing and compliance** (8 h) · Leads with the ritual, journeys and affirmations, astrology after; screenshots en/my; privacy policy; Data safety form (user-written text stays private).

**L9 — Closed test and fixes** (8 h) · ≥ 15 testers for 14+ days, then fixes.

## 4. Totals

| Block | Hours |
| --- | --- |
| M5a (18 tasks) | 95 |
| M5b (13 tasks) | 80 |
| M6 (9 tasks) | 67 |
| **Total** | **242** |

About 175 h are app and server code (M5a + M5b); the other 67 h are content, art, owner review and launch work that can overlap with coding. This is more than a first guess because the ritual, mood and streak work touch the deck, onboarding and the router at once.
