import 'package:freezed_annotation/freezed_annotation.dart';

part 'natal_report.freezed.dart';

/// Where a report is in being written (PRD §6.11, §8.2).
enum ReportStatus { generating, ready, failed }

/// One part of the report, such as "Your Moon".
@freezed
abstract class ReportSection with _$ReportSection {
  const factory ReportSection({
    required String key,
    required String title,
    required String body,
  }) = _ReportSection;
}

/// The Premium natal report, possibly still being written: [sections] is an
/// unbroken run from the first part, and [total] is how many there will be.
@freezed
abstract class NatalReport with _$NatalReport {
  const factory NatalReport({
    required String reportId,
    required String lang,
    required int version,
    required ReportStatus status,
    required int total,
    required List<ReportSection> sections,
  }) = _NatalReport;

  const NatalReport._();

  bool get isReady => status == ReportStatus.ready;
  bool get isFailed => status == ReportStatus.failed;
  bool get isGenerating => status == ReportStatus.generating;

  /// A guess at the reading time: about 175 words a part, in any language.
  int get readMinutes => (total * 0.6).round().clamp(1, 60);
}
