import 'package:mochi_moon/core/content/asset_content_repository.dart';
import 'package:mochi_moon/core/content/content_repository.dart';
import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_providers.g.dart';

@Riverpod(keepAlive: true)
ContentRepository contentRepository(Ref ref) => AssetContentRepository();

@Riverpod(keepAlive: true)
Future<List<Quote>> quotes(Ref ref) =>
    ref.watch(contentRepositoryProvider).loadQuotes();

@Riverpod(keepAlive: true)
Future<List<Quest>> quests(Ref ref) =>
    ref.watch(contentRepositoryProvider).loadQuests();

@Riverpod(keepAlive: true)
Future<List<Journey>> journeys(Ref ref) =>
    ref.watch(contentRepositoryProvider).loadJourneys();

@Riverpod(keepAlive: true)
Future<List<SignInfo>> signs(Ref ref) =>
    ref.watch(contentRepositoryProvider).loadSigns();

@Riverpod(keepAlive: true)
Future<DayColors> dayColors(Ref ref) =>
    ref.watch(contentRepositoryProvider).loadDayColors();
