/// Where allowed events end up. The real service (Firebase Analytics) plugs in
/// here once it is approved; until then nothing leaves the device.
abstract interface class AnalyticsSink {
  Future<void> record(String name, Map<String, String> params);
}

/// Drops every event.
class NoopAnalyticsSink implements AnalyticsSink {
  const NoopAnalyticsSink();

  @override
  Future<void> record(String name, Map<String, String> params) async {}
}
