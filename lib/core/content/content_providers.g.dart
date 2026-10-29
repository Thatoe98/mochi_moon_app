// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contentRepository)
final contentRepositoryProvider = ContentRepositoryProvider._();

final class ContentRepositoryProvider
    extends
        $FunctionalProvider<
          ContentRepository,
          ContentRepository,
          ContentRepository
        >
    with $Provider<ContentRepository> {
  ContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentRepository create(Ref ref) {
    return contentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentRepository>(value),
    );
  }
}

String _$contentRepositoryHash() => r'12b620d98c34ed2215dd9ca081dc670315f7afb2';

@ProviderFor(quotes)
final quotesProvider = QuotesProvider._();

final class QuotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quote>>,
          List<Quote>,
          FutureOr<List<Quote>>
        >
    with $FutureModifier<List<Quote>>, $FutureProvider<List<Quote>> {
  QuotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quotesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quotesHash();

  @$internal
  @override
  $FutureProviderElement<List<Quote>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Quote>> create(Ref ref) {
    return quotes(ref);
  }
}

String _$quotesHash() => r'781638bd6366711c350c886879f2ca9b2f8d0550';

@ProviderFor(signs)
final signsProvider = SignsProvider._();

final class SignsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SignInfo>>,
          List<SignInfo>,
          FutureOr<List<SignInfo>>
        >
    with $FutureModifier<List<SignInfo>>, $FutureProvider<List<SignInfo>> {
  SignsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signsHash();

  @$internal
  @override
  $FutureProviderElement<List<SignInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SignInfo>> create(Ref ref) {
    return signs(ref);
  }
}

String _$signsHash() => r'5231c159b27af0a616fae8de4902f786c4c08246';

@ProviderFor(dayColors)
final dayColorsProvider = DayColorsProvider._();

final class DayColorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DayColors>,
          DayColors,
          FutureOr<DayColors>
        >
    with $FutureModifier<DayColors>, $FutureProvider<DayColors> {
  DayColorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dayColorsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dayColorsHash();

  @$internal
  @override
  $FutureProviderElement<DayColors> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DayColors> create(Ref ref) {
    return dayColors(ref);
  }
}

String _$dayColorsHash() => r'ade792ca4b6fcf96a6c79077a00f7df7d5cf0df7';
