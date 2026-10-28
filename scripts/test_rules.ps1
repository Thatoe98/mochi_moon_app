$ErrorActionPreference = 'Stop'

# Runs the Firestore security rules tests against the local emulator.
# Needs Node, Java and the Firebase CLI (npm i -g firebase-tools).
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    npm --prefix test/firestore_rules install --no-audit --no-fund
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    firebase emulators:exec --only firestore --project demo-mochi-moon "npm --prefix test/firestore_rules test"
    exit $LASTEXITCODE
} finally {
    Pop-Location
}
