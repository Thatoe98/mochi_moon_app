import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_chart.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compatibility_providers.g.dart';

/// Most supportive aspects the result lists (PRD §6.12).
const topSupportiveCount = 3;

/// Most growth aspects the result lists (PRD §6.12).
const topGrowthCount = 2;

/// The partner is no longer saved (deleted, or a stale link).
class PartnerNotFound implements Exception {
  const PartnerNotFound(this.id);

  final String id;

  @override
  String toString() => 'PartnerNotFound($id)';
}

/// The user's chart set beside a partner's, with the §9.6 reading of the two.
class Compatibility {
  const Compatibility({
    required this.partner,
    required this.you,
    required this.them,
    required this.synastry,
  });

  final Partner partner;
  final NatalChart you;
  final NatalChart them;
  final Synastry synastry;

  List<SynastryAspect> get topSupportive =>
      synastry.supportive.take(topSupportiveCount).toList();

  List<SynastryAspect> get topGrowth =>
      synastry.growth.take(topGrowthCount).toList();
}

/// A missing partner stays missing, so only other failures are retried.
Duration? _retry(int retryCount, Object error) => error is PartnerNotFound
    ? null
    : ProviderContainer.defaultRetry(retryCount, error);

/// The compatibility reading of the user and the partner with [partnerId].
/// Null while the user has no birth date of their own. Throws
/// [PartnerNotFound] when the partner is not saved. Computed on the device;
/// no birth data leaves it.
@Riverpod(retry: _retry)
Future<Compatibility?> compatibility(Ref ref, String partnerId) async {
  final partners = await ref.watch(partnersProvider.future);
  final partner = partners.where((p) => p.id == partnerId).firstOrNull;
  if (partner == null) throw PartnerNotFound(partnerId);
  final you = await ref.watch(natalChartProvider.future);
  if (you == null) return null;
  final them = chartOfPartner(partner);
  return Compatibility(
    partner: partner,
    you: you,
    them: them,
    synastry: synastry(you, them),
  );
}
