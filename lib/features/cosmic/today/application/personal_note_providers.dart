import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/cosmic/today/data/api_personal_note_repository.dart';
import 'package:mochi_moon/features/cosmic/today/domain/personal_note.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'personal_note_providers.g.dart';

/// The Readings API with the device cache in front; without a server only a
/// saved note can be shown.
@Riverpod(keepAlive: true)
PersonalNoteRepository personalNoteRepository(Ref ref) {
  final cache = DriftPersonalNoteCache(ref.watch(appDatabaseProvider));
  final api = ref.watch(readingsApiProvider);
  if (api == null) return UnavailablePersonalNoteRepository(cache);
  return ApiPersonalNoteRepository(api: api, cache: cache);
}

/// Today's personal note in [lang], or null: for a free user (she sees the
/// locked preview), without a birth date, or when it cannot be written. The
/// page simply leaves the block out then; no made-up text stands in.
@riverpod
Future<PersonalNote?> personalNote(Ref ref, String lang) async {
  if (!ref.watch(hasPremiumProvider)) return null;
  final chart = await ref.watch(natalChartProvider.future);
  if (chart == null) return null;
  final now = ref.watch(clockProvider)();
  final date = DateTime(now.year, now.month, now.day);
  final repository = ref.watch(personalNoteRepositoryProvider);
  try {
    return await repository.cached(date: date, lang: lang) ??
        await repository.note(chart: chart, date: date, lang: lang);
  } on Object catch (error) {
    debugPrint('Could not get the personal note: $error');
    return null;
  }
}
