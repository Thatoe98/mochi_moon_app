enum Flavor { dev, prod }

class FlavorConfig {
  const FlavorConfig({required this.flavor, required this.readingsApiBaseUrl});

  final Flavor flavor;
  final String readingsApiBaseUrl;

  bool get isDev => flavor == Flavor.dev;
}
