#!/usr/bin/env bash
# Build/install/launch one Android flavor on one explicitly selected device.
# This is intentionally stateless: it never creates accounts or mutates backend data.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/android_smoke.sh --flavor primary|friend --env local|staging|production
       [--device DEVICE_ID] [--mode debug|release] [--reset]
       [--api-base-url URL] [--seed-user-id ID --seed-username NAME]
       [--skip-build] [--apk PATH]

Without fixture defines the app starts at its normal onboarding/auth flow.
Seed defines are operator-supplied only for the local twin harness. The script
does not create users, choose an emulator, configure adb reverse, or print logs.
EOF
}

FLAVOR=""
ENVIRONMENT=""
DEVICE_ID="${ANDROID_DEVICE_ID:-}"
MODE="debug"
RESET=0
API_BASE_URL=""
SEED_USER_ID=""
SEED_USERNAME=""
SKIP_BUILD=0
APK=""

while (($#)); do
  case "$1" in
    --flavor) FLAVOR="${2:?missing value for --flavor}"; shift 2 ;;
    --env) ENVIRONMENT="${2:?missing value for --env}"; shift 2 ;;
    --device) DEVICE_ID="${2:?missing value for --device}"; shift 2 ;;
    --mode) MODE="${2:?missing value for --mode}"; shift 2 ;;
    --reset) RESET=1; shift ;;
    --api-base-url) API_BASE_URL="${2:?missing value for --api-base-url}"; shift 2 ;;
    --seed-user-id) SEED_USER_ID="${2:?missing value for --seed-user-id}"; shift 2 ;;
    --seed-username) SEED_USERNAME="${2:?missing value for --seed-username}"; shift 2 ;;
    --skip-build) SKIP_BUILD=1; shift ;;
    --apk) APK="${2:?missing value for --apk}"; SKIP_BUILD=1; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$FLAVOR" in primary|friend) ;; *) echo "--flavor is required: primary or friend" >&2; exit 2 ;; esac
case "$ENVIRONMENT" in local|staging|production) ;; *) echo "--env is required: local, staging, or production" >&2; exit 2 ;; esac
case "$MODE" in debug|release) ;; *) echo "--mode must be debug or release" >&2; exit 2 ;; esac
if [[ -n "$SEED_USER_ID" && -z "$SEED_USERNAME" || -z "$SEED_USER_ID" && -n "$SEED_USERNAME" ]]; then
  echo "--seed-user-id and --seed-username must be supplied together" >&2
  exit 2
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
command -v flutter >/dev/null || { echo "Flutter is not on PATH; install it or add it to PATH." >&2; exit 1; }

resolve_adb() {
  if [[ -n "${ADB:-}" && -x "${ADB}" ]]; then printf '%s\n' "$ADB"; return; fi
  if command -v adb >/dev/null; then command -v adb; return; fi
  for sdk_root in "${ANDROID_HOME:-}" "${ANDROID_SDK_ROOT:-}"; do
    if [[ -n "$sdk_root" && -x "$sdk_root/platform-tools/adb" ]]; then
      printf '%s\n' "$sdk_root/platform-tools/adb"
      return
    fi
  done
  echo "adb is unavailable. Put platform-tools on PATH or set ANDROID_HOME/ANDROID_SDK_ROOT." >&2
  exit 1
}

ADB_BIN="$(resolve_adb)"
if [[ -z "$DEVICE_ID" ]]; then
  devices="$($ADB_BIN devices | awk 'NR > 1 && $2 == "device" {print $1}')"
  count="$(printf '%s\n' "$devices" | awk 'NF {count++} END {print count + 0}')"
  if [[ "$count" != 1 ]]; then
    echo "Expected exactly one connected Android device; pass --device DEVICE_ID." >&2
    "$ADB_BIN" devices >&2
    exit 1
  fi
  DEVICE_ID="$devices"
fi

PACKAGE="com.hable.app.${FLAVOR}"
if [[ "$SKIP_BUILD" == 0 ]]; then
  defines=("--dart-define=HABLE_APP_ENV=${ENVIRONMENT}")
  [[ -n "$API_BASE_URL" ]] && defines+=("--dart-define=HABLE_API_BASE_URL=${API_BASE_URL}")
  [[ -n "$SEED_USER_ID" ]] && defines+=("--dart-define=SEED_USER_ID=${SEED_USER_ID}" "--dart-define=SEED_USERNAME=${SEED_USERNAME}")
  flutter build apk --"$MODE" --flavor "$FLAVOR" -t lib/main.dart "${defines[@]}"
fi

if [[ -z "$APK" ]]; then APK="build/app/outputs/flutter-apk/app-${FLAVOR}-${MODE}.apk"; fi
[[ -f "$APK" ]] || { echo "APK not found: $APK. Build it first or pass --apk PATH." >&2; exit 1; }

if [[ "$RESET" == 1 ]]; then "$ADB_BIN" -s "$DEVICE_ID" shell pm clear "$PACKAGE" >/dev/null; fi
"$ADB_BIN" -s "$DEVICE_ID" install -r "$APK" >/dev/null
"$ADB_BIN" -s "$DEVICE_ID" shell am force-stop "$PACKAGE"
"$ADB_BIN" -s "$DEVICE_ID" shell monkey -p "$PACKAGE" 1 >/dev/null

EVIDENCE_DIR="build/android-smoke"
mkdir -p "$EVIDENCE_DIR"
EVIDENCE_FILE="${EVIDENCE_DIR}/${FLAVOR}-${MODE}-${DEVICE_ID}.txt"
if command -v sha256sum >/dev/null; then
  APK_SHA256="$(sha256sum "$APK" | awk '{print $1}')"
else
  APK_SHA256="$(shasum -a 256 "$APK" | awk '{print $1}')"
fi
{
  echo "flavor=${FLAVOR}"
  echo "environment=${ENVIRONMENT}"
  echo "device=${DEVICE_ID}"
  echo "package=${PACKAGE}"
  echo "mode=${MODE}"
  echo "apk_sha256=${APK_SHA256}"
  if [[ -n "$SEED_USER_ID" ]]; then echo "onboarding_mode=fixture"; else echo "onboarding_mode=normal"; fi
} > "$EVIDENCE_FILE"
echo "Smoke launch passed for ${PACKAGE} on ${DEVICE_ID}. Sanitized evidence: ${EVIDENCE_FILE}"
