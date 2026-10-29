import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Starts the whole app over, as if freshly opened: the provider tree is
/// thrown away and rebuilt. Used after the account and local data are deleted,
/// so no screen keeps showing what was erased. `bootstrap` overrides it.
final appRestartProvider = Provider<VoidCallback>(
  (ref) => throw UnimplementedError('appRestartProvider must be overridden'),
);

/// Rebuilds its child with a new `generation` each time `restart` is called.
/// The first generation is 0.
class AppRestart extends StatefulWidget {
  const AppRestart({required this.builder, super.key});

  final Widget Function(
    BuildContext context,
    int generation,
    VoidCallback restart,
  )
  builder;

  @override
  State<AppRestart> createState() => _AppRestartState();
}

class _AppRestartState extends State<AppRestart> {
  int _generation = 0;

  void _restart() => setState(() => _generation++);

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _generation, _restart);
}
