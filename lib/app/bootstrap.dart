import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/app.dart';
import 'package:mochi_moon/app/app_restart.dart';
import 'package:mochi_moon/app/flavors.dart';
import 'package:mochi_moon/core/content/content_licenses.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/data/prefs_onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final flavorConfigProvider = Provider<FlavorConfig>(
  (ref) => throw UnimplementedError('flavorConfigProvider must be overridden'),
);

Future<void> bootstrap(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  registerContentLicenses();
  final firebaseReady = await _initFirebase();
  final onboardingComplete = await _readOnboardingComplete();
  runApp(
    AppRestart(
      builder: (context, generation, restart) => ProviderScope(
        // A new key throws the old provider tree away, so a restart begins
        // with nothing remembered. Everything saved was wiped before it, and
        // the first-run flag is no longer worth re-reading.
        key: ValueKey(generation),
        overrides: [
          flavorConfigProvider.overrideWithValue(config),
          firebaseReadyProvider.overrideWithValue(firebaseReady),
          initialOnboardingCompleteProvider.overrideWithValue(
            generation == 0 && onboardingComplete,
          ),
          appRestartProvider.overrideWithValue(restart),
        ],
        child: const MochiMoonApp(),
      ),
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

/// Starts Firebase. A build with no Firebase config (an early dev build) still
/// runs, signed out; sign-in then reports that it is unavailable.
Future<bool> _initFirebase() async {
  try {
    await Firebase.initializeApp();
    return true;
  } on Exception catch (error) {
    debugPrint('Firebase is not available: $error');
    return false;
  }
}
