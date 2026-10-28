import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/app.dart';
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
  runApp(
    ProviderScope(
      overrides: [
        flavorConfigProvider.overrideWithValue(config),
        firebaseReadyProvider.overrideWithValue(firebaseReady),
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
