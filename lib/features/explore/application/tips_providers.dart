import 'package:mochi_moon/features/explore/data/prefs_tips_repository.dart';
import 'package:mochi_moon/features/explore/domain/explore_feature.dart';
import 'package:mochi_moon/features/explore/domain/tips_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tips_providers.g.dart';

@Riverpod(keepAlive: true)
TipsRepository tipsRepository(Ref ref) =>
    PrefsTipsRepository(SharedPreferencesAsync());

/// Whether she has taken (or skipped) the "How Mochi works" tour. Loading
/// until known, so the Today prompt never flashes.
@Riverpod(keepAlive: true)
class TourSeen extends _$TourSeen {
  @override
  Future<bool> build() => ref.watch(tipsRepositoryProvider).tourSeen();

  Future<void> markSeen() async {
    await ref.read(tipsRepositoryProvider).markTourSeen();
    state = const AsyncData(true);
  }
}

/// The first-time intro sheets on Explore.
@Riverpod(keepAlive: true)
class FeatureIntros extends _$FeatureIntros {
  @override
  void build() {}

  Future<bool> isSeen(ExploreFeature feature) =>
      ref.read(tipsRepositoryProvider).introSeen(feature);

  Future<void> markSeen(ExploreFeature feature) =>
      ref.read(tipsRepositoryProvider).markIntroSeen(feature);
}
