#!/usr/bin/env bash
set -euo pipefail

# Runs the Firestore security rules tests against the local emulator.
# Needs Node, Java and the Firebase CLI (npm i -g firebase-tools).
cd "$(dirname "$0")/.."

npm --prefix test/firestore_rules install --no-audit --no-fund
firebase emulators:exec --only firestore --project demo-mochi-moon "npm --prefix test/firestore_rules test"
