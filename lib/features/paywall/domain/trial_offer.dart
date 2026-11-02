/// Where the one-time trial offer remembers what it needs (PRD §6.13).
abstract interface class TrialOfferRepository {
  /// Whether the offer was already shown (and so never shows again).
  Future<bool> wasShown();

  /// Remembers that the offer was shown.
  Future<void> markShown();

  /// Remembers that she opened the hard-day kit on [day].
  Future<void> noteHardDay(DateTime day);

  /// Whether she opened the hard-day kit on [day].
  Future<bool> openedHardDayOn(DateTime day);
}

/// The ritual days (including today) on which the offer may show: her 2nd or
/// 3rd active day (PRD §6.13).
const int trialOfferFirstDay = 2;
const int trialOfferLastDay = 3;

/// Whether the trial offer is due right now. It needs a finished ritual today
/// on her 2nd or 3rd ritual day, no Premium, no earlier showing, and no hard
/// day today (never an upsell next to a hard day).
bool trialOfferDue({
  required int ritualDayCount,
  required bool finishedToday,
  required bool premium,
  required bool alreadyShown,
  required bool hardDayToday,
}) =>
    finishedToday &&
    !premium &&
    !alreadyShown &&
    !hardDayToday &&
    ritualDayCount >= trialOfferFirstDay &&
    ritualDayCount <= trialOfferLastDay;
