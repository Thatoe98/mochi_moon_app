import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/utils/url_opener.dart';
import 'package:mochi_moon/features/me/presentation/me_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/paywall/domain/play_links.dart';
import 'package:mochi_moon/features/review/application/review_providers.dart';
import 'package:mochi_moon/features/review/domain/review_repositories.dart';

class _FakeReviewService implements ReviewService {
  _FakeReviewService({required this.opens});

  final bool opens;
  int listingOpened = 0;

  @override
  Future<void> requestReview() async {}

  @override
  Future<bool> openStoreListing() async {
    listingOpened++;
    return opens;
  }
}

Widget _app({
  required bool premium,
  required UrlOpener opener,
  ReviewService? review,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const MeScreen()),
      GoRoute(
        path: '/paywall',
        builder: (_, state) =>
            Text('PAYWALL ${state.uri.queryParameters['source']}'),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      hasPremiumProvider.overrideWithValue(premium),
      urlOpenerProvider.overrideWithValue(opener),
      if (review != null) reviewServiceProvider.overrideWithValue(review),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  void tall(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('a free user is taken to the paywall', (tester) async {
    tall(tester);
    await tester.pumpWidget(_app(premium: false, opener: (_) async => true));
    await tester.tap(find.text('Mochi Moon Premium'));
    await tester.pumpAndSettle();
    expect(find.text('PAYWALL me'), findsOneWidget);
  });

  testWidgets('a Premium user opens Google Play subscriptions', (tester) async {
    tall(tester);
    final opened = <Uri>[];
    await tester.pumpWidget(
      _app(
        premium: true,
        opener: (url) async {
          opened.add(url);
          return true;
        },
      ),
    );
    await tester.tap(find.text('Mochi Moon Premium'));
    await tester.pumpAndSettle();
    expect(opened, [manageSubscriptionUrl]);
    expect(find.textContaining('PAYWALL'), findsNothing);
  });

  testWidgets('the Rate row opens the Play listing', (tester) async {
    tall(tester);
    final service = _FakeReviewService(opens: true);
    await tester.pumpWidget(
      _app(premium: false, opener: (_) async => true, review: service),
    );
    await tester.tap(find.text('Rate Mochi Moon'));
    await tester.pumpAndSettle();
    expect(service.listingOpened, 1);
    expect(find.textContaining('could not open Google Play'), findsNothing);
  });

  testWidgets('the Rate row says so when Play cannot be opened', (
    tester,
  ) async {
    tall(tester);
    final service = _FakeReviewService(opens: false);
    await tester.pumpWidget(
      _app(premium: false, opener: (_) async => true, review: service),
    );
    await tester.tap(find.text('Rate Mochi Moon'));
    await tester.pumpAndSettle();
    expect(find.textContaining('could not open Google Play'), findsOneWidget);
  });

  testWidgets('says so when the link cannot be opened', (tester) async {
    tall(tester);
    await tester.pumpWidget(_app(premium: true, opener: (_) async => false));
    await tester.tap(find.text('Mochi Moon Premium'));
    await tester.pumpAndSettle();
    expect(find.textContaining('could not open Google Play'), findsOneWidget);
  });
}
