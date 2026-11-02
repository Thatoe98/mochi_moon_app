import 'package:mochi_moon/features/explore/domain/explore_feature.dart';
import 'package:mochi_moon/features/explore/domain/tips_repository.dart';

class FakeTipsRepository implements TipsRepository {
  FakeTipsRepository({this.tourDone = true, Set<ExploreFeature>? seen})
    : seenIntros = {...?seen};

  bool tourDone;
  final Set<ExploreFeature> seenIntros;

  @override
  Future<bool> introSeen(ExploreFeature feature) async =>
      seenIntros.contains(feature);

  @override
  Future<void> markIntroSeen(ExploreFeature feature) async =>
      seenIntros.add(feature);

  @override
  Future<bool> tourSeen() async => tourDone;

  @override
  Future<void> markTourSeen() async => tourDone = true;
}
