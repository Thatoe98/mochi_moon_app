import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

/// At most this many characters a letter (PRD §6.22, matched by the rules).
const letterMaxLength = 1000;

/// The waiting times she can choose, in days (PRD §6.22, matched by the rules).
const letterUnlockChoices = [30, 90, 365];

/// A sealed letter opens at this hour of its unlock day, local time.
const letterUnlockHour = 9;

/// A letter to her future self. It is private writing: it never goes to the AI
/// API or to analytics, and the notification that announces it never carries
/// its text.
///
/// A letter cannot be edited once written; sealing is writing. Reading it is
/// only possible from [unlockAt] on (see [FutureLetter.isOpen]).
@immutable
class FutureLetter {
  const FutureLetter({
    required this.id,
    required this.body,
    required this.writtenAt,
    required this.unlockAt,
    required this.unlockDays,
  });

  final String id;
  final String body;
  final DateTime writtenAt;
  final DateTime unlockAt;
  final int unlockDays;

  /// Whether it may be read at [now]. The check uses the phone's clock: on a
  /// device whose clock is moved forward a letter opens early. There is no
  /// server time to check against (PRD §6.22).
  bool isOpen(DateTime now) => !now.isBefore(unlockAt);

  @override
  bool operator ==(Object other) =>
      other is FutureLetter &&
      other.id == id &&
      other.body == body &&
      other.writtenAt == writtenAt &&
      other.unlockAt == unlockAt &&
      other.unlockDays == unlockDays;

  @override
  int get hashCode => Object.hash(id, body, writtenAt, unlockAt, unlockDays);
}

/// Why a letter was not sealed.
enum LetterRejection { empty, tooLong, badDelay }

/// Checks a letter before it is sealed. Null means it can be.
LetterRejection? checkLetter(String text, {required int unlockDays}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return LetterRejection.empty;
  if (trimmed.runes.length > letterMaxLength) return LetterRejection.tooLong;
  if (!letterUnlockChoices.contains(unlockDays)) {
    return LetterRejection.badDelay;
  }
  return null;
}

/// The moment a letter written at [writtenAt] opens: [unlockDays] calendar days
/// later, at [letterUnlockHour].
DateTime letterUnlockAt(DateTime writtenAt, int unlockDays) => DateTime(
  writtenAt.year,
  writtenAt.month,
  writtenAt.day + unlockDays,
  letterUnlockHour,
);

/// Seals [text] written at [now].
FutureLetter sealLetter({
  required String id,
  required String text,
  required int unlockDays,
  required DateTime now,
}) => FutureLetter(
  id: id,
  body: text.trim(),
  writtenAt: now,
  unlockAt: letterUnlockAt(now, unlockDays),
  unlockDays: unlockDays,
);

/// A new random id, like a Firestore auto id.
String newLetterId([Random? random]) {
  final rng = random ?? Random.secure();
  const alphabet =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes([
    for (var i = 0; i < 20; i++)
      alphabet.codeUnitAt(rng.nextInt(alphabet.length)),
  ]);
}

/// A stable notification id for [letterId] inside a block of 1,000 ids that
/// starts at [base]. Two letters can in theory share one; the later wins.
int letterNotificationId(String letterId, {required int base}) {
  var hash = 0x811c9dc5;
  for (final unit in letterId.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0x7fffffff;
  }
  return base + hash % 1000;
}
