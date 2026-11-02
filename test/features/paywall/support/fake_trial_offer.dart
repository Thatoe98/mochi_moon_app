import 'package:mochi_moon/features/paywall/domain/trial_offer.dart';

/// In-memory [TrialOfferRepository] for tests.
class FakeTrialOfferRepository implements TrialOfferRepository {
  FakeTrialOfferRepository({this.shown = false});

  bool shown;
  DateTime? hardDay;

  @override
  Future<bool> wasShown() async => shown;

  @override
  Future<void> markShown() async => shown = true;

  @override
  Future<void> noteHardDay(DateTime day) async => hardDay = day;

  @override
  Future<bool> openedHardDayOn(DateTime day) async => hardDay == day;
}
