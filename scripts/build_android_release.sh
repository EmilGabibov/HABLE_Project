#!/bin/bash
# build_android_release.sh
# Script to build a Play Store ready Android App Bundle (.aab)

set -e

echo "======================================"
echo "Android Play Store Release Builder"
echo "======================================"

# Ensure keystore exists
ANDROID_DIR="$(dirname "$0")/../android"
KEY_PROPERTIES_FILE="$ANDROID_DIR/key.properties"

if [ ! -f "$KEY_PROPERTIES_FILE" ]; then
    echo "Error: key.properties not found!"
    echo "Please run scripts/generate_keystore.sh first."
    exit 1
fi

echo "Building Android App Bundle..."
# We use --obfuscate and --split-debug-info to further protect code and keep stack trace mapping
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols --flavor primary

echo "======================================"
echo "Build Successful!"
echo "Your App Bundle is located at:"
echo "build/app/outputs/bundle/primaryRelease/app-primary-release.aab"
echo ""
echo "Next Steps:"
echo "1. Go to the Google Play Console (https://play.google.com/console/)"
echo "2. Select your app -> Production -> Create new release"
echo "3. Upload the .aab file."
echo "4. IMPORTANT: Keep the contents of 'build/app/outputs/symbols' safe."
echo "   If you need to de-obfuscate a crash log from this release, you will need those symbols."
echo "======================================"
