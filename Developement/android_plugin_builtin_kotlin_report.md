# Built-in Kotlin Plugin Report

Captured 2026-07-16 from Flutter release builds in this checkout.

## Reproduction

```text
flutter build apk --flavor primary --release --dart-define=HABLE_APP_ENV=production
flutter build apk --flavor friend --release --dart-define=HABLE_APP_ENV=production
```

Both flavors complete successfully, but Flutter reports:

```text
WARNING: Your app uses the following plugins that apply Kotlin Gradle Plugin (KGP): flutter_timezone, workmanager_android
Future versions of Flutter will fail to build if the app uses plugins that apply KGP.
```

## Resolved Versions

- `flutter_timezone`: `5.1.0`
- `workmanager`: `0.9.0+3`
- `workmanager_android`: `0.9.0+2`
- AGP: `9.2.1`
- Kotlin: `2.3.20`
- Gradle: `9.6.1`

`flutter pub outdated --transitive` reports no newer compatible release for the
two warning-producing direct/transitive plugin surfaces. The upstream blockers
remain open in
[`fluttercommunity/flutter_workmanager#667`](https://github.com/fluttercommunity/flutter_workmanager/issues/667)
and
[`tjarvstrand/flutter_timezone#63`](https://github.com/tjarvstrand/flutter_timezone/issues/63).
Keep `android.builtInKotlin=false` until the plugin authors publish Built-in
Kotlin-compatible releases, then rerun both flavor builds and review the
official [Flutter migration guidance](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin).

This is an upstream dependency boundary, not a reason to vendor modified plugin
copies. A local fork would make Hable responsible for native background-work
and timezone plugin maintenance while still requiring migration checks for the
rest of the Flutter plugin graph. The supported repository state therefore
keeps runtime behavior on the published packages, records the warning
explicitly, and treats a future compatible package release as the migration
trigger.

The separate Java restricted-native-access warning is repository-owned.
`android/gradle.properties` configures the daemon, while the tracked Android
build/smoke scripts and Android CI jobs export
`GRADLE_OPTS=--enable-native-access=ALL-UNNAMED` for the wrapper JVM. Generated
`android/gradlew*` launchers remain ignored. The release-signing verifier passes
the same option to `apksigner` and prefers `aapt` from the selected Android
Build Tools version, avoiding a mismatched global SDK lookup.

On 2026-07-17, primary and friend release APK and App Bundle builds completed,
Flutter resolved all four flavor-specific artifacts, and the repository-owned
restricted-access warning was absent. Both APKs passed the non-debug certificate
gate with application IDs `com.hable.app.primary` and `com.hable.app.friend`.
The remaining KGP warning is limited to the two upstream blockers documented
above.
