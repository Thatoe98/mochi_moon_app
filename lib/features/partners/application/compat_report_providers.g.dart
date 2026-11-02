// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compat_report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Readings API with the device cache in front, or a stand-in that says
/// the report is unavailable when the build has no server.

@ProviderFor(compatReportRepository)
final compatReportRepositoryProvider = CompatReportRepositoryProvider._();

/// The Readings API with the device cache in front, or a stand-in that says
/// the report is unavailable when the build has no server.

final class CompatReportRepositoryProvider
    extends
        $FunctionalProvider<
          CompatReportRepository,
          CompatReportRepository,
          CompatReportRepository
        >
    with $Provider<CompatReportRepository> {
  /// The Readings API with the device cache in front, or a stand-in that says
  /// the report is unavailable when the build has no server.
  CompatReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compatReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compatReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<CompatReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompatReportRepository create(Ref ref) {
    return compatReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompatReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompatReportRepository>(value),
    );
  }
}

String _$compatReportRepositoryHash() =>
    r'f0771f89c1c584ca0f736861ebbb40edbfb9adb6';

/// The Premium compatibility report for [partnerId] in [lang] as it is
/// written: each value has more parts than the one before. Null while the user
/// has no birth date. Only asked for when she opens the report.

@ProviderFor(compatReport)
final compatReportProvider = CompatReportFamily._();

/// The Premium compatibility report for [partnerId] in [lang] as it is
/// written: each value has more parts than the one before. Null while the user
/// has no birth date. Only asked for when she opens the report.

final class CompatReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<NatalReport?>,
          NatalReport?,
          Stream<NatalReport?>
        >
    with $FutureModifier<NatalReport?>, $StreamProvider<NatalReport?> {
  /// The Premium compatibility report for [partnerId] in [lang] as it is
  /// written: each value has more parts than the one before. Null while the user
  /// has no birth date. Only asked for when she opens the report.
  CompatReportProvider._({
    required CompatReportFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'compatReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$compatReportHash();

  @override
  String toString() {
    return r'compatReportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<NatalReport?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<NatalReport?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return compatReport(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CompatReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$compatReportHash() => r'a830b6e85d0dae554f240cab9e53c5a1fdb986b6';

/// The Premium compatibility report for [partnerId] in [lang] as it is
/// written: each value has more parts than the one before. Null while the user
/// has no birth date. Only asked for when she opens the report.

final class CompatReportFamily extends $Family
    with $FunctionalFamilyOverride<Stream<NatalReport?>, (String, String)> {
  CompatReportFamily._()
    : super(
        retry: null,
        name: r'compatReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The Premium compatibility report for [partnerId] in [lang] as it is
  /// written: each value has more parts than the one before. Null while the user
  /// has no birth date. Only asked for when she opens the report.

  CompatReportProvider call(String partnerId, String lang) =>
      CompatReportProvider._(argument: (partnerId, lang), from: this);

  @override
  String toString() => r'compatReportProvider';
}
