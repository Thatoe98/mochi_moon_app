import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/letters/data/drift_weekly_letter_cache.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter_repository.dart';

/// The weekly letter from the Readings API (PRD §6.24, §8.2). Only the week's
/// counts go out ([WeekAggregates.toRequest]); a letter that arrived is saved
/// on the device, so the server is asked once per week and language.
class ApiWeeklyLetterRepository implements WeeklyLetterRepository {
  ApiWeeklyLetterRepository({required this.api, required this.cache});

  final ReadingsApi api;
  final DriftWeeklyLetterCache cache;

  @override
  Future<WeeklyLetter?> cached({
    required String lang,
    required String weekStart,
  }) => cache.find(lang: lang, weekStart: weekStart);

  @override
  Future<WeeklyLetter> letter({
    required WeekAggregates week,
    required String lang,
  }) async {
    final key = weekDateKey(week.weekStart);
    final saved = await cache.find(lang: lang, weekStart: key);
    if (saved != null) return saved;
    final data = await api.postJson('letters/weekly', week.toRequest(lang));
    final title = data['title'];
    final body = data['body'];
    final version = data['version'];
    if (title is! String || body is! String || version is! int) {
      throw const FormatException('The weekly letter has the wrong shape.');
    }
    final letter = WeeklyLetter(
      weekStart: key,
      lang: lang,
      version: version,
      title: title,
      body: body,
    );
    await cache.put(letter);
    return letter;
  }
}

/// Used while the build has no Readings API: only a saved letter can be shown.
class UnavailableWeeklyLetterRepository implements WeeklyLetterRepository {
  const UnavailableWeeklyLetterRepository(this.cache);

  final DriftWeeklyLetterCache cache;

  @override
  Future<WeeklyLetter?> cached({
    required String lang,
    required String weekStart,
  }) => cache.find(lang: lang, weekStart: weekStart);

  @override
  Future<WeeklyLetter> letter({
    required WeekAggregates week,
    required String lang,
  }) => Future.error(const UnavailableFailure());
}
