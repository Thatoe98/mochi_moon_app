import 'package:mochi_moon/features/paywall/domain/trial_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _shownKey = 'trial_offer_shown';
const _hardDayKey = 'trial_offer_hard_day';

/// Two tiny flags in `shared_preferences`: the offer was shown, and the last
/// local day she opened the hard-day kit.
class PrefsTrialOfferRepository implements TrialOfferRepository {
  PrefsTrialOfferRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<bool> wasShown() async => await _prefs.getBool(_shownKey) ?? false;

  @override
  Future<void> markShown() => _prefs.setBool(_shownKey, true);

  @override
  Future<void> noteHardDay(DateTime day) =>
      _prefs.setString(_hardDayKey, _stamp(day));

  @override
  Future<bool> openedHardDayOn(DateTime day) async =>
      await _prefs.getString(_hardDayKey) == _stamp(day);

  String _stamp(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}
