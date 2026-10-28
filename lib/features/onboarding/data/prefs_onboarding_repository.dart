import 'package:mochi_moon/features/onboarding/domain/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _completeKey = 'onboarding_complete';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsOnboardingRepository implements OnboardingRepository {
  PrefsOnboardingRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<bool> isComplete() async =>
      await _prefs.getBool(_completeKey) ?? false;

  @override
  Future<void> markComplete() => _prefs.setBool(_completeKey, true);
}
