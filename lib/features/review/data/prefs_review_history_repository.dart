import 'package:mochi_moon/features/review/domain/review_policy.dart';
import 'package:mochi_moon/features/review/domain/review_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lastAskedKey = 'review_last_asked';
const _timesAskedKey = 'review_times_asked';

/// Two tiny flags, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsReviewHistoryRepository implements ReviewHistoryRepository {
  PrefsReviewHistoryRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<ReviewHistory> load() async {
    final last = await _prefs.getString(_lastAskedKey);
    final times = await _prefs.getInt(_timesAskedKey);
    return ReviewHistory(
      lastAsked: last == null ? null : DateTime.tryParse(last),
      timesAsked: times ?? 0,
    );
  }

  @override
  Future<void> markAsked(DateTime now) async {
    final times = await _prefs.getInt(_timesAskedKey) ?? 0;
    await _prefs.setString(_lastAskedKey, now.toIso8601String());
    await _prefs.setInt(_timesAskedKey, times + 1);
  }
}
