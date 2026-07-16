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

`flutter pub outdated --transitive` reports no newer compatible release for the two warning-producing direct/transitive plugin surfaces. Keep `android.builtInKotlin=false` until the plugin authors publish Built-in Kotlin-compatible releases, then rerun both flavor builds and review the official [Flutter migration guidance](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin).
