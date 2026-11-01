import 'dart:async';

import 'package:mochi_moon/features/mascot/domain/mascot_repository.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';

/// An in-memory [MascotRepository] for widget tests.
class FakeMascotRepository implements MascotRepository {
  FakeMascotRepository([this._state = const MascotState()]);

  MascotState _state;
  final _controller = StreamController<MascotState>.broadcast();

  MascotState get state => _state;

  void _set(MascotState next) {
    _state = next;
    _controller.add(next);
  }

  @override
  Stream<MascotState> watch() async* {
    yield _state;
    yield* _controller.stream;
  }

  @override
  Future<void> grant(Iterable<String> itemIds, DateTime at) async => _set(
    MascotState(
      owned: [
        ..._state.owned,
        for (final id in itemIds)
          if (!_state.owns(id)) id,
      ],
      equipped: _state.equipped,
    ),
  );

  @override
  Future<void> equip(String slot, String itemId) async => _set(
    MascotState(
      owned: _state.owned,
      equipped: {..._state.equipped, slot: itemId},
    ),
  );

  @override
  Future<void> unequip(String slot) async => _set(
    MascotState(
      owned: _state.owned,
      equipped: {..._state.equipped}..remove(slot),
    ),
  );

  @override
  Future<void> restore(MascotState remote, DateTime now) =>
      grant(remote.owned, now);
}
