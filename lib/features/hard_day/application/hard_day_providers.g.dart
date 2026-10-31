// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hard_day_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Today's comforting cards for the hard-day kit: bundled cards only, so the
/// kit works offline and signed out.

@ProviderFor(comfortCardsToday)
final comfortCardsTodayProvider = ComfortCardsTodayProvider._();

/// Today's comforting cards for the hard-day kit: bundled cards only, so the
/// kit works offline and signed out.

final class ComfortCardsTodayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quote>>,
          List<Quote>,
          FutureOr<List<Quote>>
        >
    with $FutureModifier<List<Quote>>, $FutureProvider<List<Quote>> {
  /// Today's comforting cards for the hard-day kit: bundled cards only, so the
  /// kit works offline and signed out.
  ComfortCardsTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'comfortCardsTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$comfortCardsTodayHash();

  @$internal
  @override
  $FutureProviderElement<List<Quote>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Quote>> create(Ref ref) {
    return comfortCardsToday(ref);
  }
}

String _$comfortCardsTodayHash() => r'1cde2d35468287b391ecd555f03117911ba8f51d';
