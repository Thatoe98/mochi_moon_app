import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/premium/free_limits.dart';

/// Free users keep this many cards of their own; Premium has no limit
/// (PRD §6.17).
const int ownCardFreeLimit = FreeLimits.ownCards;

/// At most this many characters on a card (PRD §6.17, matched by the rules).
const ownCardMaxLength = 140;

/// The id prefix that tells a card she wrote from a bundled one.
const ownCardIdPrefix = 'own_';

/// An affirmation she wrote herself. It is private writing: it never goes to
/// the AI API, to analytics, or to the For You embeddings server.
@immutable
class OwnCard {
  const OwnCard({
    required this.id,
    required this.body,
    required this.illustrationId,
    required this.createdAt,
  });

  final String id;
  final String body;

  /// The id of one of the bundled illustrations (PRD §8.4).
  final String illustrationId;
  final DateTime createdAt;

  OwnCard copyWith({String? body, String? illustrationId}) => OwnCard(
    id: id,
    body: body ?? this.body,
    illustrationId: illustrationId ?? this.illustrationId,
    createdAt: createdAt,
  );

  /// The card as the deck sees it: category `self_love`, the same layout and
  /// timer gate as a bundled card. It carries no mood, sign or embedding.
  Quote toQuote() => Quote(
    id: '$ownCardIdPrefix$id',
    text: {'en': body},
    category: 'self_love',
    illustrationId: illustrationId,
  );

  @override
  bool operator ==(Object other) =>
      other is OwnCard &&
      other.id == id &&
      other.body == body &&
      other.illustrationId == illustrationId &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, body, illustrationId, createdAt);
}

/// Whether [quoteId] belongs to a card she wrote herself.
bool isOwnCardId(String quoteId) => quoteId.startsWith(ownCardIdPrefix);

/// Why a card was not saved.
enum OwnCardRejection { empty, tooLong, noIllustration, limitReached }

/// Checks a card against PRD §6.17. [countBefore] is how many cards she has
/// already, not counting the one being edited. Editing passes
/// `isNew: false`, so it never hits the free limit. Null means it can be
/// saved.
OwnCardRejection? checkOwnCard(
  String text,
  String illustrationId, {
  required int countBefore,
  required bool isPremium,
  bool isNew = true,
}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return OwnCardRejection.empty;
  if (trimmed.runes.length > ownCardMaxLength) return OwnCardRejection.tooLong;
  if (illustrationId.trim().isEmpty) return OwnCardRejection.noIllustration;
  if (isNew && !isPremium && countBefore >= ownCardFreeLimit) {
    return OwnCardRejection.limitReached;
  }
  return null;
}

/// A new random 20 character id, like a Firestore auto id.
String newOwnCardId([Random? random]) {
  final rng = random ?? Random.secure();
  const alphabet =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes([
    for (var i = 0; i < 20; i++)
      alphabet.codeUnitAt(rng.nextInt(alphabet.length)),
  ]);
}
