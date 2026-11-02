/// The public pages the server hosts (privacy policy and terms).
enum LegalPage {
  privacy('privacy'),
  terms('terms');

  LegalPage(this.path);

  final String path;
}

/// The address of [page] on the same host as the Readings API at [baseUrl]
/// (for example `https://host/v1/` gives `https://host/privacy`). Null when the
/// build has no usable base URL.
Uri? legalUrl(String baseUrl, LegalPage page) {
  final base = Uri.tryParse(baseUrl);
  if (base == null || !base.hasAuthority || base.host.isEmpty) return null;
  return Uri(
    scheme: base.scheme,
    host: base.host,
    port: base.hasPort ? base.port : null,
    path: '/${page.path}',
  );
}
