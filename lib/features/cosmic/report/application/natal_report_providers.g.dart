// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'natal_report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Readings API with the device cache in front, or a stand-in that says
/// the report is unavailable when the build has no server.

@ProviderFor(natalReportRepository)
final natalReportRepositoryProvider = NatalReportRepositoryProvider._();

/// The Readings API with the device cache in front, or a stand-in that says
/// the report is unavailable when the build has no server.

final class NatalReportRepositoryProvider
    extends
        $FunctionalProvider<
          NatalReportRepository,
          NatalReportRepository,
          NatalReportRepository
        >
    with $Provider<NatalReportRepository> {
  /// The Readings API with the device cache in front, or a stand-in that says
  /// the report is unavailable when the build has no server.
  NatalReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'natalReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$natalReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<NatalReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NatalReportRepository create(Ref ref) {
    return natalReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NatalReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NatalReportRepository>(value),
    );
  }
}

String _$natalReportRepositoryHash() =>
    r'be55b78d283a80ddfb5d9a0eaed46fc39ca24f23';

/// The Premium natal report in [lang] as it is written: each value has more
/// parts than the one before. Null while there is no birth date. The server
/// keeps writing if the screen is left, and opening it again picks it up.

@ProviderFor(natalReport)
final natalReportProvider = NatalReportFamily._();

/// The Premium natal report in [lang] as it is written: each value has more
/// parts than the one before. Null while there is no birth date. The server
/// keeps writing if the screen is left, and opening it again picks it up.

final class NatalReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<NatalReport?>,
          NatalReport?,
          Stream<NatalReport?>
        >
    with $FutureModifier<NatalReport?>, $StreamProvider<NatalReport?> {
  /// The Premium natal report in [lang] as it is written: each value has more
  /// parts than the one before. Null while there is no birth date. The server
  /// keeps writing if the screen is left, and opening it again picks it up.
  NatalReportProvider._({
    required NatalReportFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'natalReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$natalReportHash();

  @override
  String toString() {
    return r'natalReportProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<NatalReport?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<NatalReport?> create(Ref ref) {
    final argument = this.argument as String;
    return natalReport(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NatalReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$natalReportHash() => r'2fc6d042b09d19460b6a06b05e4cbff0b4c32711';

/// The Premium natal report in [lang] as it is written: each value has more
/// parts than the one before. Null while there is no birth date. The server
/// keeps writing if the screen is left, and opening it again picks it up.

final class NatalReportFamily extends $Family
    with $FunctionalFamilyOverride<Stream<NatalReport?>, String> {
  NatalReportFamily._()
    : super(
        retry: null,
        name: r'natalReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The Premium natal report in [lang] as it is written: each value has more
  /// parts than the one before. Null while there is no birth date. The server
  /// keeps writing if the screen is left, and opening it again picks it up.

  NatalReportProvider call(String lang) =>
      NatalReportProvider._(argument: lang, from: this);

  @override
  String toString() => r'natalReportProvider';
}
