import 'package:mochi_moon/features/letters/domain/weekly_letter_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'quest_done_days';

/// The most recent days kept; the weekly letter needs only the last two weeks.
const _keep = 21;

/// The days she finished a quest, as a short list of dates in
/// `shared_preferences` (a tiny flag, not content).
class PrefsQuestDoneLog implements QuestDoneLog {
  PrefsQuestDoneLog(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<List<String>> days() async =>
      await _prefs.getStringList(_key) ?? const [];

  @override
  Future<void> add(String dateKey) async {
    final all = {...await days(), dateKey}.toList()..sort();
    await _prefs.setStringList(
      _key,
      all.length > _keep ? all.sublist(all.length - _keep) : all,
    );
  }
}
