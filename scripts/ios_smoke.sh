#!/usr/bin/env bash
# Fail-closed iOS simulator preflight and bounded flavor smoke.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/ios_smoke.sh --flavor primary|friend --env local|staging|production
       [--device SIMULATOR_UDID] [--runtime 'iOS 26.5']
       [--mode debug|release] [--preflight-only] [--skip-build]

The default supported runtime is iOS 26.5 under Xcode 26.x. Set
IOS_SIMULATOR_UDID to reuse one deterministic simulator fixture. The runner
never creates accounts or claims the manual retry/logout checks as automated.
EOF
}

FLAVOR=""
ENVIRONMENT=""
DEVICE_ID="${IOS_SIMULATOR_UDID:-}"
RUNTIME_LABEL="${IOS_RUNTIME_LABEL:-iOS 26.5}"
MODE="debug"
PREFLIGHT_ONLY=0
SKIP_BUILD=0

while (($#)); do
  case "$1" in
    --flavor) FLAVOR="${2:?missing value for --flavor}"; shift 2 ;;
    --env) ENVIRONMENT="${2:?missing value for --env}"; shift 2 ;;
    --device) DEVICE_ID="${2:?missing value for --device}"; shift 2 ;;
    --runtime) RUNTIME_LABEL="${2:?missing value for --runtime}"; shift 2 ;;
    --mode) MODE="${2:?missing value for --mode}"; shift 2 ;;
    --preflight-only) PREFLIGHT_ONLY=1; shift ;;
    --skip-build) SKIP_BUILD=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ "$PREFLIGHT_ONLY" == 0 ]]; then
  case "$FLAVOR" in primary|friend) ;; *) echo "--flavor is required: primary or friend" >&2; exit 2 ;; esac
  case "$ENVIRONMENT" in local|staging|production) ;; *) echo "--env is required: local, staging, or production" >&2; exit 2 ;; esac
fi
case "$MODE" in debug|release) ;; *) echo "--mode must be debug or release" >&2; exit 2 ;; esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
for required in flutter xcodebuild xcrun; do
  command -v "$required" >/dev/null || { echo "$required is unavailable on this host." >&2; exit 1; }
done

XCODE_VERSION="$(xcodebuild -version)"
if ! printf '%s\n' "$XCODE_VERSION" | grep -Eq '^Xcode 26\.'; then
  echo "Unsupported Xcode version; this gate is pinned to Xcode 26.x." >&2
  printf '%s\n' "$XCODE_VERSION" >&2
  exit 1
fi
RUNTIMES="$(xcrun simctl list runtimes available)"
if ! printf '%s\n' "$RUNTIMES" | grep -Fq "$RUNTIME_LABEL"; then
  echo "No available simulator runtime matches '${RUNTIME_LABEL}'." >&2
  echo "Install the pinned platform with: xcodebuild -downloadPlatform iOS" >&2
  echo "Available runtimes:" >&2
  printf '%s\n' "$RUNTIMES" >&2
  exit 1
fi

DEVICES="$(xcrun simctl list devices available)"
if [[ -z "$DEVICE_ID" ]]; then
  DEVICE_ID="$(printf '%s\n' "$DEVICES" | sed -n "/-- ${RUNTIME_LABEL} --/,/^-- /p" | grep -Eo '\([0-9A-F-]{36}\)' | head -1 | tr -d '()' || true)"
fi
if [[ -z "$DEVICE_ID" ]] || ! printf '%s\n' "$DEVICES" | grep -Fq "($DEVICE_ID)"; then
  echo "No eligible simulator UDID was found for '${RUNTIME_LABEL}'. Pass --device with a listed UDID." >&2
  printf '%s\n' "$DEVICES" >&2
  exit 1
fi

DEVICE_STATE="$(printf '%s\n' "$DEVICES" | grep -F "($DEVICE_ID)" | sed -E 's/.* \((Booted|Shutdown)\).*/\1/' | head -1)"
if [[ "$DEVICE_STATE" == "Shutdown" ]]; then
  xcrun simctl boot "$DEVICE_ID"
  xcrun simctl bootstatus "$DEVICE_ID" -b
fi

if [[ "$PREFLIGHT_ONLY" == 1 ]]; then
  echo "iOS preflight passed: ${RUNTIME_LABEL}, ${DEVICE_ID}, ${DEVICE_STATE:-Booted}"
  exit 0
fi

command -v flutter >/dev/null || { echo "Flutter is not on PATH." >&2; exit 1; }
if [[ "$SKIP_BUILD" == 0 ]]; then
  flutter build ios --simulator --"$MODE" --no-codesign --flavor "$FLAVOR" -t lib/main.dart \
    --dart-define="HABLE_APP_ENV=${ENVIRONMENT}"
fi

APP_PATH="$(find build/ios/iphonesimulator -maxdepth 1 -type d -name '*.app' -print -quit 2>/dev/null || true)"
[[ -n "$APP_PATH" ]] || { echo "No simulator .app found under build/ios/iphonesimulator." >&2; exit 1; }
BUNDLE_ID="$(plutil -extract CFBundleIdentifier raw -o - "$APP_PATH/Info.plist")"
xcrun simctl install "$DEVICE_ID" "$APP_PATH"
xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID" >/dev/null

EVIDENCE_DIR="build/ios-smoke"
mkdir -p "$EVIDENCE_DIR"
EVIDENCE_FILE="${EVIDENCE_DIR}/${FLAVOR}-${MODE}-${DEVICE_ID}.txt"
xcrun simctl io "$DEVICE_ID" screenshot "${EVIDENCE_FILE%.txt}.png" >/dev/null
{
  printf '%s\n' "$XCODE_VERSION"
  echo "runtime=${RUNTIME_LABEL}"
  echo "device=${DEVICE_ID}"
  echo "flavor=${FLAVOR}"
  echo "environment=${ENVIRONMENT}"
  echo "bundle_id=${BUNDLE_ID}"
  echo "mode=${MODE}"
  echo "scenario=launch,loading-error,retry-reconnect,logout,relaunch"
  echo "scenario_status=launch automated; remaining checkpoints require fixture-safe UI interaction"
} > "$EVIDENCE_FILE"
echo "iOS ${FLAVOR} launch passed on ${DEVICE_ID}. Evidence: ${EVIDENCE_FILE} and ${EVIDENCE_FILE%.txt}.png"
