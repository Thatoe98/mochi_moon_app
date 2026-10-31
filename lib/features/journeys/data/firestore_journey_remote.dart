import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/journeys/domain/journey_repository.dart';

class FirestoreJourneyRemote implements JourneyRemote {
  FirestoreJourneyRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('users').doc(uid).collection('journeyProgress');

  @override
  Future<List<JourneyProgress>> fetchAll(String uid) => _guard(() async {
    final snapshot = await _collection(uid).get();
    return [
      for (final doc in snapshot.docs)
        ?journeyProgressFromMap(doc.id, doc.data()),
    ];
  });

  @override
  Future<void> put(String uid, JourneyProgress progress) => _guard(
    () =>
        _collection(uid)
            .doc(progress.journeyId)
            .set(journeyProgressToMap(progress)),
  );

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

/// The fields the rules allow (PRD §8.1): no more, no fewer. Her private
/// reflections are included: they live only in her own document.
Map<String, Object?> journeyProgressToMap(JourneyProgress progress) => {
  'startedAt': Timestamp.fromDate(progress.startedAt),
  'currentDay': progress.currentDay,
  'completedDays': progress.completedDays,
  'reflections': {
    for (final entry in progress.reflections.entries)
      '${entry.key}': entry.value,
  },
  'completedAt': progress.completedAt == null
      ? null
      : Timestamp.fromDate(progress.completedAt!),
};

/// Null when a required field is missing or the wrong type.
JourneyProgress? journeyProgressFromMap(
  String journeyId,
  Map<String, dynamic> data,
) {
  final startedAt = data['startedAt'];
  final currentDay = data['currentDay'];
  final completedDays = data['completedDays'];
  final completedAt = data['completedAt'];
  final reflections = data['reflections'];
  if (startedAt is! Timestamp || currentDay is! int) return null;
  if (completedDays is! List || completedDays.any((day) => day is! int)) {
    return null;
  }
  if (completedAt != null && completedAt is! Timestamp) return null;
  if (reflections != null && reflections is! Map) return null;
  return JourneyProgress(
    journeyId: journeyId,
    startedAt: startedAt.toDate(),
    currentDay: currentDay,
    completedDays: completedDays.cast<int>(),
    reflections: {
      if (reflections is Map)
        for (final entry in reflections.entries)
          if (int.tryParse('${entry.key}') case final day?)
            if (entry.value is String) day: entry.value as String,
    },
    completedAt: (completedAt as Timestamp?)?.toDate(),
  );
}
