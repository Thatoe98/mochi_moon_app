import 'package:mochi_moon/features/onboarding/domain/onboarding_repository.dart';

/// In-memory [OnboardingRepository] for tests.
class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({this.complete = false, this.error});

  bool complete;

  /// When set, saving the flag fails with it.
  final Exception? error;

  @override
  Future<bool> isComplete() async => complete;

  @override
  Future<void> markComplete() async {
    if (error case final error?) throw error;
    complete = true;
  }
}
