import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/domain/legal_links.dart';

void main() {
  test('uses the host of the API base URL', () {
    expect(
      legalUrl('https://api.example.com/v1/', LegalPage.privacy),
      Uri.parse('https://api.example.com/privacy'),
    );
    expect(
      legalUrl('http://10.0.2.2:8081', LegalPage.terms),
      Uri.parse('http://10.0.2.2:8081/terms'),
    );
  });

  test('is null without a usable base URL', () {
    expect(legalUrl('', LegalPage.privacy), isNull);
    expect(legalUrl('not a url', LegalPage.terms), isNull);
  });
}
