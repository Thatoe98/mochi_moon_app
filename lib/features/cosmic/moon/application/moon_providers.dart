import 'package:mochi_moon/features/cosmic/astro/moon_phase.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'moon_providers.g.dart';

/// What the Moon looks like right now. The engine needs no network and only a
/// few milliseconds, so it runs on the main isolate.
@riverpod
MoonPhase moonNow(Ref ref) =>
    moonPhase(ref.watch(clockProvider)().toUtc());
