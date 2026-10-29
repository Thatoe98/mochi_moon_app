import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entitlement_providers.g.dart';

/// Whether the user has Premium (PRD §6.12).
///
/// Always true until Google Play Billing and the server entitlement exist
/// (M4), so Premium features can be built and tried now. Switch this to the
/// real entitlement then; nothing else has to change.
// TODO(Thatoe98): read the real entitlement in M4.
@Riverpod(keepAlive: true)
bool hasPremium(Ref ref) => true;
