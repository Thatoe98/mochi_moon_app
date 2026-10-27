$ErrorActionPreference = 'Stop'

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

dart run build_runner build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter gen-l10n
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter test
exit $LASTEXITCODE
