/// Shortest time a card stays locked (PRD §6.2).
const Duration minReadAloudLock = Duration(seconds: 3);

/// Longest time a card stays locked.
const Duration maxReadAloudLock = Duration(seconds: 8);

const double _wordsPerSecond = 2.5;

/// How long a card with [text] stays locked while it is read aloud:
/// `max(3.0, wordCount / 2.5)` seconds, capped at 8 s.
///
/// Words are split on whitespace. Burmese is written without spaces, so it
/// counts as one word and gets the minimum lock.
Duration readAloudLockDuration(String text) {
  final words = text
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .length;
  final millis = (words / _wordsPerSecond * 1000).round();
  return Duration(
    milliseconds: millis.clamp(
      minReadAloudLock.inMilliseconds,
      maxReadAloudLock.inMilliseconds,
    ),
  );
}
