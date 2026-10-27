import 'package:mochi_moon/app/bootstrap.dart';
import 'package:mochi_moon/app/flavors.dart';

void main() => bootstrap(
  const FlavorConfig(
    flavor: Flavor.dev,
    readingsApiBaseUrl: String.fromEnvironment('READINGS_API_URL'),
  ),
);
