import 'package:flutter/foundation.dart';

/// Adds the data we bundle (not packages) to Flutter's licenses page, where
/// attribution is required (PRD §8.5).
void registerContentLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['Cities list'],
      'The list of cities used for birthplace search is derived from '
      'GeoNames (https://www.geonames.org), licensed under Creative Commons '
      'Attribution 4.0 (https://creativecommons.org/licenses/by/4.0/). '
      'It was reduced to cities with at least 15,000 people.',
    );
  });
}
