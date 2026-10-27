import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/shell_scaffold.dart';
import 'package:mochi_moon/features/cosmic/presentation/cosmic_screen.dart';
import 'package:mochi_moon/features/deck/presentation/deck_screen.dart';
import 'package:mochi_moon/features/me/presentation/me_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

abstract final class AppRoutes {
  static const deck = '/deck';
  static const cosmic = '/cosmic';
  static const me = '/me';
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.deck,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            ShellScaffold(navigationShell: shell),
        branches: [
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
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.me,
                builder: (context, state) => const MeScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
