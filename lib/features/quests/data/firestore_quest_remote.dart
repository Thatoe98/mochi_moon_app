import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/quests/domain/quest_day.dart';
import 'package:mochi_moon/features/quests/domain/quest_repository.dart';

class FirestoreQuestRemote implements QuestRemote {
  FirestoreQuestRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid).collection('state').doc('quest');

  @override
  Future<QuestDay?> fetch(String uid) => _guard(() async {
    final data = (await _doc(uid).get()).data();
    return data == null ? null : questDayFromMap(data);
  });

  @override
  Future<void> put(String uid, QuestDay day) =>
      _guard(() => _doc(uid).set(questDayToMap(day)));

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on FirebaseException catch (error) {
      throw error.code == 'unavailable'
          ? const NetworkFailure()
          : UnknownFailure(error);
    }
  }
}

/// The fields the rules allow (PRD §8.1): no more, no fewer.
Map<String, Object> questDayToMap(QuestDay day) => {
  'date': day.date,
  'questId': day.questId,
  'done': day.done,
  'swapped': day.swapped,
};

/// Null when a field is missing or the wrong type.
QuestDay? questDayFromMap(Map<String, dynamic> data) {
  final date = data['date'];
  final questId = data['questId'];
  final done = data['done'];
  final swapped = data['swapped'];
  if (date is! String || questId is! String) return null;
  if (done is! bool || swapped is! bool) return null;
  return QuestDay(date: date, questId: questId, done: done, swapped: swapped);
}
