#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <primary-apk> <friend-apk>" >&2
  exit 2
fi

ANDROID_BUILD_TOOLS="${ANDROID_BUILD_TOOLS:-${ANDROID_SDK_ROOT:-}/build-tools/36.1.0}"
APKSIGNER="${APKSIGNER:-$ANDROID_BUILD_TOOLS/apksigner}"
APKANALYZER="${APKANALYZER:-$(command -v apkanalyzer || true)}"

if [[ ! -x "$APKSIGNER" ]]; then
  echo "apksigner not found; set APKSIGNER or ANDROID_BUILD_TOOLS." >&2
  exit 1
fi
if [[ -z "$APKANALYZER" || ! -x "$APKANALYZER" ]]; then
  echo "apkanalyzer not found; set APKANALYZER to the Android SDK tool." >&2
  exit 1
fi

verify_artifact() {
  local artifact="$1"
  local expected_application_id="$2"
  local certificate application_id

  certificate="$($APKSIGNER verify --print-certs "$artifact")"
  if grep -q "CN=Android Debug" <<<"$certificate"; then
    echo "Debug certificate found in production artifact: $artifact" >&2
    exit 1
  fi

  application_id="$($APKANALYZER manifest application-id "$artifact")"
  if [[ "$application_id" != "$expected_application_id" ]]; then
    echo "Unexpected application id for $artifact: $application_id" >&2
    exit 1
  fi

  echo "$artifact: certificate is non-debug; application id is $application_id"
}

verify_artifact "$1" com.hable.app.primary
verify_artifact "$2" com.hable.app.friend
