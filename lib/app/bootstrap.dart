import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/app.dart';
import 'package:mochi_moon/app/flavors.dart';

final flavorConfigProvider = Provider<FlavorConfig>(
  (ref) => throw UnimplementedError('flavorConfigProvider must be overridden'),
);

void bootstrap(FlavorConfig config) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [flavorConfigProvider.overrideWithValue(config)],
      child: const MochiMoonApp(),
    ),
  );
}
