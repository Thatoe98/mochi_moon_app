import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'for_you_providers.g.dart';

/// Whether the Deck tab is set to the For You deck (PRD §6.9). A choice for
/// this session; the plain deck is the default. Premium is checked where the
/// deck is dealt, so a stale "on" never gives a free user the ranked deck.
@Riverpod(keepAlive: true)
class ForYouSelected extends _$ForYouSelected {
  @override
  bool build() => false;

  // The setter reads better than assigning `state` from a widget.
  // ignore: use_setters_to_change_properties
  void select({required bool value}) => state = value;
}
