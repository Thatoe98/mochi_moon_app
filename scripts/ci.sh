#!/usr/bin/env sh
set -eu

flutter pub get
dart run build_runner build
flutter gen-l10n
flutter analyze
flutter test
