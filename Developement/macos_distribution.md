# macOS Distribution Path

## Goal

Ship Hable on macOS through two channels:

1. Mac App Store build
2. Standalone notarized `.app` / `.dmg`

The desktop app already uses sandboxed release entitlements in `macos/Runner/Release.entitlements`, so the remaining work is operator-controlled signing, archiving, export, and notarization.

## Repo State

- Product name: `Hable`
- Bundle identifier: `com.hable.app.macos`
- Release entitlements:
  - `com.apple.security.app-sandbox = true`
  - `com.apple.security.network.client = true`
- Smoke-validated locally on 2026-07-13:
  - `flutter build macos --debug`
  - `flutter build macos --release`
  - `codesign -dvvv --entitlements :- build/macos/Build/Products/Release/Hable.app`
  - `spctl -a -vv build/macos/Build/Products/Release/Hable.app`

Local signing state during validation:

- `security find-identity -p codesigning -v` returned `0 valid identities found`
- Result: buildable locally, but the release app is ad-hoc signed (`Signature=adhoc`, `TeamIdentifier=not set`) and `spctl` rejects it. App Store export, Developer ID signing, and notarization were not executable on this machine because no signing identities are installed.

## App Store Path

1. Install the Apple distribution assets in Xcode:
   - App Store Connect-ready bundle id for `com.hable.app.macos`
   - Mac App Store provisioning profile
   - Apple Distribution signing identity
2. Open `macos/Runner.xcworkspace` in Xcode.
3. Set the `Runner` target signing team and archive in `Release`.
4. Use Xcode Organizer:
   - `Product > Archive`
   - `Distribute App`
   - `App Store Connect`
5. Validate and upload from Organizer.

Recommended validation commands after archive/export:

```bash
codesign -dvvv --entitlements :- "Hable.app"
spctl -a -vv "Hable.app"
```

## Standalone Path

1. Install a Developer ID Application certificate in the login keychain.
2. Build the release app:

```bash
flutter build macos --release
```

3. Verify nested signatures in the exported app bundle.
4. Sign the final bundle with Developer ID if Xcode/Flutter did not already do so under the selected signing setup.
5. Package either:
   - a zipped `.app` for direct download, or
   - a `.dmg` wrapper for friendlier distribution
6. Submit the artifact for notarization, then staple the result before publishing.

Recommended post-export checks:

```bash
codesign -dvvv --entitlements :- "build/macos/Build/Products/Release/Hable.app"
spctl -a -vv "build/macos/Build/Products/Release/Hable.app"
```

## Operator Checklist

- Confirm the build machine has at least 10-15 GiB free before archive/export.
- Verify `PRODUCT_BUNDLE_IDENTIFIER` still matches the registered Apple identifier.
- Keep App Store and standalone signing identities separate.
- Recheck sandbox entitlements whenever a new plugin adds file system, camera, notification, or login-item requirements.
- Treat the current code-asset framework-name warnings during release build as package-level follow-up items if notarization starts rejecting nested assets.

## Current Gaps

- No local code-signing identities are installed on the current machine.
- No notarized standalone artifact was produced in this session.
- No App Store archive/upload was possible from this environment.
