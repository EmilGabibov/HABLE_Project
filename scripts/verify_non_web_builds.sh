#!/bin/bash
set -e

echo "=== Cleaning build cache ==="
flutter clean

echo "=== Fetching dependencies ==="
flutter pub get

echo "=== Building Android (Primary flavor) ==="
flutter build apk --flavor primary -t lib/main.dart

echo "=== Building Android (Friend flavor) ==="
flutter build apk --flavor friend -t lib/main.dart

echo "=== Building Web ==="
flutter build web --no-tree-shake-icons

echo "=== Building macOS ==="
# Release defaults to compile-only signing, so local verification never edits
# tracked entitlements or requires an Apple Developer team.
flutter build macos

echo "=== Checking Windows Build ==="
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" || "$OSTYPE" == "windows" ]]; then
  echo "Building Windows..."
  flutter build windows
else
  echo "Skipping Windows build (current OS: $OSTYPE is not Windows)"
fi

echo "=== Cleaning up build artifacts to save disk space ==="
flutter clean

echo "=== All builds passed successfully! ==="
