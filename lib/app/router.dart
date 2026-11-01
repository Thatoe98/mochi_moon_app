import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/shell_scaffold.dart';
import 'package:mochi_moon/features/breathe/presentation/breathe_screen.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_screen.dart';
import 'package:mochi_moon/features/cosmic/presentation/cosmic_screen.dart';
import 'package:mochi_moon/features/cosmic/report/presentation/natal_report_screen.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_screen.dart';
import 'package:mochi_moon/features/cosmic/unlock/presentation/unlock_screen.dart';
import 'package:mochi_moon/features/custom_cards/presentation/own_cards_screen.dart';
import 'package:mochi_moon/features/deck/presentation/deck_screen.dart';
import 'package:mochi_moon/features/gratitude/presentation/gratitude_screen.dart';
import 'package:mochi_moon/features/hard_day/presentation/hard_day_screen.dart';
import 'package:mochi_moon/features/journal/presentation/journal_screen.dart';
import 'package:mochi_moon/features/journeys/presentation/journey_day_screen.dart';
import 'package:mochi_moon/features/journeys/presentation/journey_screen.dart';
import 'package:mochi_moon/features/journeys/presentation/journeys_screen.dart';
import 'package:mochi_moon/features/letters/presentation/letter_screen.dart';
import 'package:mochi_moon/features/letters/presentation/letters_screen.dart';
import 'package:mochi_moon/features/letters/presentation/write_letter_screen.dart';
import 'package:mochi_moon/features/mascot/presentation/mascot_room_screen.dart';
import 'package:mochi_moon/features/me/presentation/me_screen.dart';
import 'package:mochi_moon/features/mood/presentation/mood_screen.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/domain/onboarding_repository.dart';
import 'package:mochi_moon/features/onboarding/presentation/profile_setup_screen.dart';
import 'package:mochi_moon/features/onboarding/presentation/sample_cards_screen.dart';
import 'package:mochi_moon/features/onboarding/presentation/welcome_screen.dart';
import 'package:mochi_moon/features/partners/presentation/partner_edit_screen.dart';
import 'package:mochi_moon/features/partners/presentation/partner_result_screen.dart';
import 'package:mochi_moon/features/partners/presentation/partners_screen.dart';
import 'package:mochi_moon/features/profile/presentation/profile_edit_screen.dart';
import 'package:mochi_moon/features/ritual/presentation/today_screen.dart';
import 'package:mochi_moon/features/settings/presentation/about_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

abstract final class AppRoutes {
  static const today = '/today';
  static const deck = '/deck';
  static const cosmic = '/cosmic';
  static const retrogrades = '/cosmic/retrogrades';
  static const chart = '/cosmic/chart';
  static const cosmicUnlock = '/cosmic/unlock';
  static const chartReport = '/cosmic/chart/report';
  static const me = '/me';
  static const journal = '/me/journal';
  static const mood = '/me/mood';
  static const gratitude = '/me/gratitude';
  static const journeys = '/me/journeys';
  static const letters = '/me/letters';
  static const mascotRoom = '/me/room';
  static const ownCards = '/me/cards';
  static const breathe = '/me/breathe';
  static const hardDay = '/me/hard-day';
  static const profileEdit = '/me/profile';
  static const about = '/me/about';
  static const partners = '/me/partners';
  static const partnerEdit = '/me/partners/edit';
  static const partnerResult = '/me/partners/result';
  static const welcome = '/welcome';
  static const welcomeCards = '/welcome/cards';
  static const welcomeProfile = '/welcome/profile';
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Finishing the first-run flow re-runs the redirect; the router itself must
  // not be rebuilt, or it would lose its place.
  final firstRun = ValueNotifier(ref.read(onboardingCompleteProvider));
  ref
    ..listen(
      onboardingCompleteProvider,
      (_, complete) => firstRun.value = complete,
    )
    ..onDispose(firstRun.dispose);

  return GoRouter(
    initialLocation: AppRoutes.today,
    refreshListenable: firstRun,
    redirect: (context, state) => onboardingRedirect(
      complete: ref.read(onboardingCompleteProvider),
      location: state.matchedLocation,
      welcomeRoute: AppRoutes.welcome,
      homeRoute: AppRoutes.today,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
        routes: [
          GoRoute(
            path: 'cards',
            builder: (context, state) => const SampleCardsScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileSetupScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            ShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.today,
                builder: (context, state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.deck,
                builder: (context, state) => const DeckScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cosmic,
                builder: (context, state) => const CosmicScreen(),
                routes: [
                  GoRoute(
                    path: 'unlock',
                    builder: (context, state) => const UnlockScreen(),
                  ),
                  GoRoute(
                    path: 'retrogrades',
                    builder: (context, state) => const RetrogradeScreen(),
                  ),
                  GoRoute(
                    path: 'chart',
                    builder: (context, state) => const ChartScreen(),
                    routes: [
                      GoRoute(
                        path: 'report',
                        builder: (context, state) => const NatalReportScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.me,
                builder: (context, state) => const MeScreen(),
                routes: [
                  GoRoute(
                    path: 'journal',
                    builder: (context, state) => const JournalScreen(),
                  ),
                  GoRoute(
                    path: 'room',
                    builder: (context, state) => const MascotRoomScreen(),
                  ),
                  GoRoute(
                    path: 'letters',
                    builder: (context, state) => const LettersScreen(),
                    routes: [
                      GoRoute(
                        path: 'write',
                        builder: (context, state) => const WriteLetterScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (context, state) =>
                            LetterScreen(letterId: state.pathParameters['id']!),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'journeys',
                    builder: (context, state) => const JourneysScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) => JourneyScreen(
                          journeyId: state.pathParameters['id']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'day',
                            builder: (context, state) => JourneyDayScreen(
                              journeyId: state.pathParameters['id']!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'gratitude',
                    builder: (context, state) => const GratitudeScreen(),
                  ),
                  GoRoute(
                    path: 'cards',
                    builder: (context, state) => const OwnCardsScreen(),
                  ),
                  GoRoute(
                    path: 'hard-day',
                    builder: (context, state) => HardDayScreen(
                      source: state.uri.queryParameters['source'] ?? '',
                    ),
                  ),
                  GoRoute(
                    path: 'breathe',
                    builder: (context, state) => const BreatheScreen(),
                  ),
                  GoRoute(
                    path: 'mood',
                    builder: (context, state) => const MoodScreen(),
                  ),
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfileEditScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutScreen(),
                  ),
                  GoRoute(
                    path: 'partners',
                    builder: (context, state) => const PartnersScreen(),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => PartnerEditScreen(
                          partnerId: state.uri.queryParameters['id'],
                        ),
                      ),
                      GoRoute(
                        path: 'result',
                        builder: (context, state) => PartnerResultScreen(
                          partnerId: state.uri.queryParameters['id'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
