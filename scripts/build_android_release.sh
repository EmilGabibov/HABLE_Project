#!/usr/bin/env bash
# Build one explicitly selected Android release flavor.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/build_android_release.sh --flavor primary|friend [--env production|staging]

The Android Gradle signing gate requires android/key.properties and a real
keystore. Flutter/Gradle discover the SDK through their normal local setup.
EOF
}

FLAVOR=""
ENVIRONMENT="production"
while (($#)); do
  case "$1" in
    --flavor) FLAVOR="${2:?missing value for --flavor}"; shift 2 ;;
    --env) ENVIRONMENT="${2:?missing value for --env}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$FLAVOR" in
  primary|friend) ;;
  *) echo "--flavor is required and must be primary or friend" >&2; exit 2 ;;
esac
case "$ENVIRONMENT" in
  production|staging) ;;
  *) echo "--env must be production or staging" >&2; exit 2 ;;
esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
command -v flutter >/dev/null || { echo "Flutter is not on PATH; install it or add it to PATH." >&2; exit 1; }

echo "Building Android ${FLAVOR} App Bundle (${ENVIRONMENT})..."
flutter build appbundle --release --obfuscate \
  --split-debug-info="build/app/outputs/symbols/${FLAVOR}" \
  --flavor "$FLAVOR" -t lib/main.dart \
  --dart-define="HABLE_APP_ENV=${ENVIRONMENT}"

ARTIFACT="build/app/outputs/bundle/${FLAVOR}Release/app-${FLAVOR}-release.aab"
echo "Build successful: ${ARTIFACT}"
echo "Keep build/app/outputs/symbols/${FLAVOR} with the release artifact for crash de-obfuscation."
