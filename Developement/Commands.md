# Hable Project Commands

Quick reference for all build, install, and deploy shell commands across platforms.

## Web Deployment
Deploy the web version of the Flutter app to Cloudflare Pages:
```bash
flutter build web --release --base-href / \
  --dart-define=HABLE_APP_ENV=production && \
cd backend && npx wrangler pages deploy ../build/web --project-name=hable
```

## Build Android APKs
Build the **primary** Android APK:
```bash
flutter build apk --flavor primary -t lib/main.dart
```

Build the **partner/friend** Android APK:
```bash
flutter build apk --flavor friend -t lib/main.dart
```

For local backend testing, debug builds now default to `http://127.0.0.1:8787`.
The backend target is resolved in this order:
1. `HABLE_API_BASE_URL` manual override
2. `HABLE_APP_ENV` preset: `local`, `staging`, or `production`
3. Fallback when no define is passed: debug/profile -> `local`, release -> `production`

`staging` currently resolves to `production` unless `HABLE_STAGING_API_BASE_URL` is also provided.

Use `adb reverse tcp:8787 tcp:8787` on a physical Android device.
If you need to target a different backend host, pass:
```bash
flutter build apk --debug --flavor primary -t lib/main.dart \
  --dart-define=HABLE_APP_ENV=local \
  --dart-define=HABLE_API_BASE_URL=http://10.0.2.2:8787
```
The override above is the usual emulator case; replace the URL as needed.

To make a debug or profile build talk to production explicitly:
```bash
flutter run -d chrome \
  --dart-define=HABLE_APP_ENV=production
```

To target a dedicated staging backend alias:
```bash
flutter run -d chrome \
  --dart-define=HABLE_APP_ENV=staging \
  --dart-define=HABLE_STAGING_API_BASE_URL=https://staging-hable.pages.dev
```

## Install APKs via ADB
Install the **primary** APK on a connected USB device:
```bash
~/Library/Android/sdk/platform-tools/adb install build/app/outputs/flutter-apk/app-primary-release.apk
```

Install the **partner/friend** APK on a connected USB device:
```bash
~/Library/Android/sdk/platform-tools/adb install build/app/outputs/flutter-apk/app-friend-release.apk
```

## Build & Install on iOS via USB
To build and install the **primary** flavor directly to a connected iOS device:
```bash
flutter run --release --flavor primary -t lib/main.dart
```
```bash
flutter build ios --no-codesign --flavor primary -t lib/main.dart
```
To build for iOS simulator:
```bash
flutter build ios --simulator --flavor primary -t lib/main.dart
```


To build and install the **partner/friend** flavor to a connected iOS device:
```bash
flutter run --release --flavor friend -t lib/main.dart
```

*(Note: For iOS, `flutter run --release` is the most reliable way to compile and transfer the app to your device over USB in one step. If you only want to install an already-built iOS app without running it, you can simply use `flutter install`.)*

## Clean Build Cache
Empty/clean Flutter build outputs and caches (deletes the `build/` directory):
```bash
flutter clean
```
