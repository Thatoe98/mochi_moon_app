import 'package:mochi_moon/features/explore/domain/explore_feature.dart';

/// Which first-time tips she has already seen. Tiny flags only, kept on the
/// device.
abstract interface class TipsRepository {
  Future<bool> introSeen(ExploreFeature feature);

  Future<void> markIntroSeen(ExploreFeature feature);

  Future<bool> tourSeen();

  Future<void> markTourSeen();
}
