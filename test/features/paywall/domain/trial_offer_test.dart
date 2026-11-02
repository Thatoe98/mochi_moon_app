import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/paywall/domain/trial_offer.dart';

bool _due({
  int days = 2,
  bool finished = true,
  bool premium = false,
  bool shown = false,
  bool hardDay = false,
}) => trialOfferDue(
  ritualDayCount: days,
  finishedToday: finished,
  premium: premium,
  alreadyShown: shown,
  hardDayToday: hardDay,
);

void main() {
  test('is due after the ritual on the 2nd and 3rd ritual day', () {
    expect(_due(), isTrue);
    expect(_due(days: 3), isTrue);
  });

  test('is never due on day 1, or from day 4 on', () {
    expect(_due(days: 1), isFalse);
    expect(_due(days: 0), isFalse);
    expect(_due(days: 4), isFalse);
  });

  test('needs a finished ritual and no Premium', () {
    expect(_due(finished: false), isFalse);
    expect(_due(premium: true), isFalse);
  });

  test('is not repeated and never shows on a hard day', () {
    expect(_due(shown: true), isFalse);
    expect(_due(hardDay: true), isFalse);
  });
}
