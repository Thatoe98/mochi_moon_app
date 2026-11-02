import 'package:mochi_moon/features/explore/domain/explore_feature.dart';
import 'package:mochi_moon/features/explore/domain/tips_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _tourKey = 'tour_seen';
String _introKey(ExploreFeature feature) => 'intro_seen_${feature.name}';

class PrefsTipsRepository implements TipsRepository {
  PrefsTipsRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<bool> introSeen(ExploreFeature feature) async =>
      await _prefs.getBool(_introKey(feature)) ?? false;

  @override
  Future<void> markIntroSeen(ExploreFeature feature) =>
      _prefs.setBool(_introKey(feature), true);

  @override
  Future<bool> tourSeen() async => await _prefs.getBool(_tourKey) ?? false;

  @override
  Future<void> markTourSeen() => _prefs.setBool(_tourKey, true);
}
