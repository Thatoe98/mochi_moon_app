import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/app.dart';
import 'package:mochi_moon/app/flavors.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/data/prefs_onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final flavorConfigProvider = Provider<FlavorConfig>(
  (ref) => throw UnimplementedError('flavorConfigProvider must be overridden'),
);

Future<void> bootstrap(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [
        flavorConfigProvider.overrideWithValue(config),
        initialOnboardingCompleteProvider.overrideWithValue(
          await _readOnboardingComplete(),
        ),
      ],
      child: const MochiMoonApp(),
    ),
  );
}

/// The router needs the first-run flag before the first frame. If it cannot be
/// read, the flow simply shows again.
Future<bool> _readOnboardingComplete() async {
  try {
    return await PrefsOnboardingRepository(SharedPreferencesAsync())
        .isComplete();
  } on Exception catch (error) {
    debugPrint('Could not read the onboarding flag: $error');
    return false;
  }
}
