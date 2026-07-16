#!/usr/bin/env bash
# Validate one macOS distribution app without exposing signing secrets.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/verify_macos_distribution.sh --app PATH
       [--channel developer-id|app-store] [--require-staple]

Checks bundle identity, team-backed signing, nested code, hardened runtime,
release entitlements, Gatekeeper, and optional notarization staple state.
Certificates, team IDs, and notarization credentials are operator inputs.
EOF
}

APP=""
CHANNEL="developer-id"
REQUIRE_STAPLE=0
while (($#)); do
  case "$1" in
    --app) APP="${2:?missing value for --app}"; shift 2 ;;
    --channel) CHANNEL="${2:?missing value for --channel}"; shift 2 ;;
    --require-staple) REQUIRE_STAPLE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$APP" && -d "$APP" ]] || { echo "macOS .app directory is required: $APP" >&2; exit 2; }
case "$CHANNEL" in developer-id|app-store) ;; *) echo "--channel must be developer-id or app-store" >&2; exit 2 ;; esac
for required in codesign plutil spctl xcrun; do
  command -v "$required" >/dev/null || { echo "$required is required on macOS." >&2; exit 1; }
done

EXPECTED_ID="com.hable.app.macos"
EXPECTED_NAME="Hable"
ACTUAL_ID="$(plutil -extract CFBundleIdentifier raw -o - "$APP/Contents/Info.plist")"
ACTUAL_NAME="$(plutil -extract CFBundleName raw -o - "$APP/Contents/Info.plist")"
[[ "$ACTUAL_ID" == "$EXPECTED_ID" ]] || { echo "Bundle ID mismatch: expected $EXPECTED_ID, got $ACTUAL_ID" >&2; exit 1; }
[[ "$ACTUAL_NAME" == "$EXPECTED_NAME" ]] || { echo "Bundle name mismatch: expected $EXPECTED_NAME, got $ACTUAL_NAME" >&2; exit 1; }

SIGNING_DETAILS="$(codesign -dvvv "$APP" 2>&1 || true)"
printf '%s\n' "$SIGNING_DETAILS" | grep -Eq '^TeamIdentifier=[^[:space:]]+$' || {
  echo "A protected signing team is required; ad-hoc or unsigned output is not distributable." >&2
  exit 1
}
printf '%s\n' "$SIGNING_DETAILS" | grep -Fq 'Signature=adhoc' && {
  echo "Ad-hoc signing is not accepted for macOS distribution." >&2
  exit 1
}
printf '%s\n' "$SIGNING_DETAILS" | grep -Eq 'flags=.*\(runtime\)' || {
  echo "Hardened runtime is not present in the code signature." >&2
  exit 1
}

codesign --verify --deep --strict --verbose=4 "$APP"
ENTITLEMENTS="$(codesign -d --entitlements :- "$APP" 2>&1 || true)"
if printf '%s\n' "$ENTITLEMENTS" | grep -A1 -Fq '<key>get-task-allow</key>'; then
  echo "Release distribution entitlements contain get-task-allow." >&2
  exit 1
fi

spctl --assess --type execute --verbose=2 "$APP"
if [[ "$REQUIRE_STAPLE" == 1 ]]; then
  xcrun stapler validate "$APP"
fi

echo "macOS ${CHANNEL} distribution checks passed: ${ACTUAL_ID} (${ACTUAL_NAME})"
echo "sha256=$(shasum -a 256 "$APP/Contents/MacOS/Hable" | awk '{print $1}')"
