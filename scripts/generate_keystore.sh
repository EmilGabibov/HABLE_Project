#!/bin/bash
# generate_keystore.sh
# Script to generate a secure RSA 2048 keystore for Android release builds

set -e

# Define directories
ANDROID_DIR="$(dirname "$0")/../android"
KEYSTORE_FILE="$ANDROID_DIR/upload-keystore.jks"
KEY_PROPERTIES_FILE="$ANDROID_DIR/key.properties"

echo "======================================"
echo "Android Play Store Keystore Generator"
echo "======================================"

if [ -f "$KEYSTORE_FILE" ] || [ -f "$KEY_PROPERTIES_FILE" ]; then
    echo "Warning: Keystore or key.properties already exists."
    echo "This script will overwrite them if you proceed."
    read -p "Are you sure you want to proceed? (y/N) " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Prompt for password
echo ""
echo "Please enter a strong password for your keystore."
echo "Keep this password safe, you will need it for all future updates!"
read -s -p "Password: " PASSWORD
echo ""
read -s -p "Confirm Password: " PASSWORD_CONFIRM
echo ""

if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
    echo "Passwords do not match. Aborting."
    exit 1
fi

if [ ${#PASSWORD} -lt 6 ]; then
    echo "Password must be at least 6 characters. Aborting."
    exit 1
fi

# Generate the keystore
echo ""
echo "Generating upload-keystore.jks..."
keytool -genkey -v -keystore "$KEYSTORE_FILE" -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass "$PASSWORD" -keypass "$PASSWORD"

# Create key.properties
echo "Creating key.properties..."
cat << EOF > "$KEY_PROPERTIES_FILE"
storePassword=$PASSWORD
keyPassword=$PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
EOF

# Ensure gitignore contains key.properties
GITIGNORE_FILE="$ANDROID_DIR/.gitignore"
if [ -f "$GITIGNORE_FILE" ]; then
    if ! grep -q "key.properties" "$GITIGNORE_FILE"; then
        echo "key.properties" >> "$GITIGNORE_FILE"
    fi
    if ! grep -q "*.jks" "$GITIGNORE_FILE"; then
        echo "*.jks" >> "$GITIGNORE_FILE"
    fi
    if ! grep -q "*.keystore" "$GITIGNORE_FILE"; then
        echo "*.keystore" >> "$GITIGNORE_FILE"
    fi
fi

echo "======================================"
echo "Success! Your keystore has been generated at: android/upload-keystore.jks"
echo "Properties file created at: android/key.properties"
echo "IMPORTANT: Backup upload-keystore.jks and its password in a secure place (like 1Password)."
echo "Losing this keystore means you will not be able to update your app on the Play Store!"
echo "======================================"
