// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cosmic_today_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyReadingRepository)
final dailyReadingRepositoryProvider = DailyReadingRepositoryProvider._();

final class DailyReadingRepositoryProvider
    extends
        $FunctionalProvider<
          DailyReadingRepository,
          DailyReadingRepository,
          DailyReadingRepository
        >
    with $Provider<DailyReadingRepository> {
  DailyReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReadingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReadingRepositoryHash();

  @$internal
  @override
  $ProviderElement<DailyReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyReadingRepository create(Ref ref) {
    return dailyReadingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyReadingRepository>(value),
    );
  }
}

String _$dailyReadingRepositoryHash() =>
    r'3a66dd239a60d79f79291db0fbc893a75dbaa236';

@ProviderFor(thaiColorsSettingRepository)
final thaiColorsSettingRepositoryProvider =
    ThaiColorsSettingRepositoryProvider._();

final class ThaiColorsSettingRepositoryProvider
    extends
        $FunctionalProvider<
          ThaiColorsSettingRepository,
          ThaiColorsSettingRepository,
          ThaiColorsSettingRepository
        >
    with $Provider<ThaiColorsSettingRepository> {
  ThaiColorsSettingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'thaiColorsSettingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$thaiColorsSettingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ThaiColorsSettingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ThaiColorsSettingRepository create(Ref ref) {
    return thaiColorsSettingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThaiColorsSettingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThaiColorsSettingRepository>(value),
    );
  }
}

String _$thaiColorsSettingRepositoryHash() =>
    r'ce13f7156a26f7c6d625d1ae0634dc63532ce233';

/// The user's choice on the Thai colors switch for [lang], falling back to
/// the default for that language.

@ProviderFor(ShowThaiColors)
final showThaiColorsProvider = ShowThaiColorsFamily._();

/// The user's choice on the Thai colors switch for [lang], falling back to
/// the default for that language.
final class ShowThaiColorsProvider
    extends $AsyncNotifierProvider<ShowThaiColors, bool> {
  /// The user's choice on the Thai colors switch for [lang], falling back to
  /// the default for that language.
  ShowThaiColorsProvider._({
    required ShowThaiColorsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'showThaiColorsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$showThaiColorsHash();

  @override
  String toString() {
    return r'showThaiColorsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ShowThaiColors create() => ShowThaiColors();

  @override
  bool operator ==(Object other) {
    return other is ShowThaiColorsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$showThaiColorsHash() => r'043f564446fcb817e1bc5ddf504a0d6ba9b942b7';

/// The user's choice on the Thai colors switch for [lang], falling back to
/// the default for that language.

final class ShowThaiColorsFamily extends $Family
    with
        $ClassFamilyOverride<
          ShowThaiColors,
          AsyncValue<bool>,
          bool,
          FutureOr<bool>,
          String
        > {
  ShowThaiColorsFamily._()
    : super(
        retry: null,
        name: r'showThaiColorsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The user's choice on the Thai colors switch for [lang], falling back to
  /// the default for that language.

  ShowThaiColorsProvider call(String lang) =>
      ShowThaiColorsProvider._(argument: lang, from: this);

  @override
  String toString() => r'showThaiColorsProvider';
}

/// The user's choice on the Thai colors switch for [lang], falling back to
/// the default for that language.

abstract class _$ShowThaiColors extends $AsyncNotifier<bool> {
  late final _$args = ref.$arg as String;
  String get lang => _$args;

  FutureOr<bool> build(String lang);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// The user's Sun sign, or null while there is no birth date.

@ProviderFor(userSunSign)
final userSunSignProvider = UserSunSignProvider._();

/// The user's Sun sign, or null while there is no birth date.

final class UserSunSignProvider
    extends
        $FunctionalProvider<
          AsyncValue<ZodiacSign?>,
          ZodiacSign?,
          FutureOr<ZodiacSign?>
        >
    with $FutureModifier<ZodiacSign?>, $FutureProvider<ZodiacSign?> {
  /// The user's Sun sign, or null while there is no birth date.
  UserSunSignProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSunSignProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSunSignHash();

  @$internal
  @override
  $FutureProviderElement<ZodiacSign?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ZodiacSign?> create(Ref ref) {
    return userSunSign(ref);
  }
}

String _$userSunSignHash() => r'b7ffa05dc11727cec3df6a526f20a862324b63d7';

/// The sign whose page the Cosmic tab shows instead of the user's own, or
/// null for their own. Premium; ignored without it. Starts over each time the
/// Cosmic tab is left.

@ProviderFor(ViewedSign)
final viewedSignProvider = ViewedSignProvider._();

/// The sign whose page the Cosmic tab shows instead of the user's own, or
/// null for their own. Premium; ignored without it. Starts over each time the
/// Cosmic tab is left.
final class ViewedSignProvider
    extends $NotifierProvider<ViewedSign, ZodiacSign?> {
  /// The sign whose page the Cosmic tab shows instead of the user's own, or
  /// null for their own. Premium; ignored without it. Starts over each time the
  /// Cosmic tab is left.
  ViewedSignProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'viewedSignProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$viewedSignHash();

  @$internal
  @override
  ViewedSign create() => ViewedSign();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZodiacSign? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZodiacSign?>(value),
    );
  }
}

String _$viewedSignHash() => r'25cbb21ce36040a0ca3ea7dd75e7dfdf7447fd4c';

/// The sign whose page the Cosmic tab shows instead of the user's own, or
/// null for their own. Premium; ignored without it. Starts over each time the
/// Cosmic tab is left.

abstract class _$ViewedSign extends $Notifier<ZodiacSign?> {
  ZodiacSign? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ZodiacSign?, ZodiacSign?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ZodiacSign?, ZodiacSign?>,
              ZodiacSign?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Today's page in [lang] for the sign being viewed, the user's own unless
/// they chose another, or null until there is a sign (the profile has a birth
/// date). Rebuilds when the language, the profile or the chosen sign changes.

@ProviderFor(cosmicToday)
final cosmicTodayProvider = CosmicTodayFamily._();

/// Today's page in [lang] for the sign being viewed, the user's own unless
/// they chose another, or null until there is a sign (the profile has a birth
/// date). Rebuilds when the language, the profile or the chosen sign changes.

final class CosmicTodayProvider
    extends
        $FunctionalProvider<
          AsyncValue<CosmicToday?>,
          CosmicToday?,
          FutureOr<CosmicToday?>
        >
    with $FutureModifier<CosmicToday?>, $FutureProvider<CosmicToday?> {
  /// Today's page in [lang] for the sign being viewed, the user's own unless
  /// they chose another, or null until there is a sign (the profile has a birth
  /// date). Rebuilds when the language, the profile or the chosen sign changes.
  CosmicTodayProvider._({
    required CosmicTodayFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cosmicTodayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cosmicTodayHash();

  @override
  String toString() {
    return r'cosmicTodayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CosmicToday?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CosmicToday?> create(Ref ref) {
    final argument = this.argument as String;
    return cosmicToday(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CosmicTodayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cosmicTodayHash() => r'69f58db3a39b58cd676acdccb0024ffe3ed74a61';

/// Today's page in [lang] for the sign being viewed, the user's own unless
/// they chose another, or null until there is a sign (the profile has a birth
/// date). Rebuilds when the language, the profile or the chosen sign changes.

final class CosmicTodayFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CosmicToday?>, String> {
  CosmicTodayFamily._()
    : super(
        retry: null,
        name: r'cosmicTodayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Today's page in [lang] for the sign being viewed, the user's own unless
  /// they chose another, or null until there is a sign (the profile has a birth
  /// date). Rebuilds when the language, the profile or the chosen sign changes.

  CosmicTodayProvider call(String lang) =>
      CosmicTodayProvider._(argument: lang, from: this);

  @override
  String toString() => r'cosmicTodayProvider';
}
