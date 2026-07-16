#!/usr/bin/env bash
# Validate the identity and signing boundary of one iOS archive.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/verify_ios_archive.sh --archive PATH --flavor primary|friend

The archive must contain one app under Products/Applications. This validates
bundle/display identity, the flavor Keychain group, and deep code signing.
Provisioning profiles and certificates are injected by the archive operator.
EOF
}

ARCHIVE=""
FLAVOR=""
while (($#)); do
  case "$1" in
    --archive) ARCHIVE="${2:?missing value for --archive}"; shift 2 ;;
    --flavor) FLAVOR="${2:?missing value for --flavor}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$ARCHIVE" && -d "$ARCHIVE" ]] || { echo "Archive directory is required: $ARCHIVE" >&2; exit 2; }
case "$FLAVOR" in
  primary) EXPECTED_ID="com.hable.app.primary"; EXPECTED_NAME="Hable Primary" ;;
  friend) EXPECTED_ID="com.hable.app.friend"; EXPECTED_NAME="Hable Friend" ;;
  *) echo "--flavor must be primary or friend" >&2; exit 2 ;;
esac

for required in codesign plutil; do
  command -v "$required" >/dev/null || { echo "$required is required on macOS." >&2; exit 1; }
done

APP_PATH="$(find "$ARCHIVE/Products/Applications" -maxdepth 1 -type d -name '*.app' -print -quit 2>/dev/null || true)"
[[ -n "$APP_PATH" ]] || { echo "No .app found under $ARCHIVE/Products/Applications" >&2; exit 1; }
INFO_PLIST="$APP_PATH/Info.plist"
ACTUAL_ID="$(plutil -extract CFBundleIdentifier raw -o - "$INFO_PLIST")"
ACTUAL_NAME="$(plutil -extract CFBundleDisplayName raw -o - "$INFO_PLIST")"
[[ "$ACTUAL_ID" == "$EXPECTED_ID" ]] || { echo "Bundle ID mismatch: expected $EXPECTED_ID, got $ACTUAL_ID" >&2; exit 1; }
[[ "$ACTUAL_NAME" == "$EXPECTED_NAME" ]] || { echo "Display name mismatch: expected $EXPECTED_NAME, got $ACTUAL_NAME" >&2; exit 1; }

ENTITLEMENTS="$(codesign -d --entitlements :- "$APP_PATH" 2>&1 || true)"
printf '%s\n' "$ENTITLEMENTS" | grep -Fq "$EXPECTED_ID" || {
  echo "Keychain entitlement does not contain the final bundle ID $EXPECTED_ID." >&2
  exit 1
}
codesign --verify --deep --strict --verbose=2 "$APP_PATH"
echo "iOS archive identity/signing passed: $EXPECTED_ID ($EXPECTED_NAME)"
