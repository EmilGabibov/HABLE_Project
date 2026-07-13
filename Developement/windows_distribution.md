# Windows Distribution Path

## Goal

Ship Hable on Windows through two channels:

1. Installer build
2. Standalone portable bundle

The repo now carries Hable-specific Windows metadata plus an Inno Setup installer template at `windows/installer/Hable.iss`.

## Repo State

- CMake project name: `Hable`
- Binary name: `Hable.exe`
- Window title: `Hable`
- Windows version resource strings updated from the Flutter defaults to Hable values
- Installer template: `windows/installer/Hable.iss`

## Release Build Path

Run these commands on a Windows build machine with Visual Studio Build Tools installed:

```bash
flutter build windows --release
```

Primary artifact directory:

```text
build/windows/x64/runner/Release/
```

That folder is the standalone portable bundle. Zip it as-is for direct download distribution.

## Installer Path

1. Build the release bundle with `flutter build windows --release`.
2. Install Inno Setup on the Windows packaging machine.
3. Open `windows/installer/Hable.iss`.
4. Update `MyAppVersion` if needed.
5. Compile the installer from Inno Setup.

Expected output:

```text
dist/windows/Hable-Setup.exe
```

## Signing Path

1. Install the code-signing certificate on the Windows build host.
2. Sign `Hable.exe` inside the release folder.
3. Sign the final `Hable-Setup.exe` installer.
4. Prefer timestamped signatures so the installer remains trusted after certificate expiry.

## Operator Checklist

- Build on Windows; Flutter desktop does not produce Windows artifacts from this macOS host.
- Keep the standalone ZIP and installer sourced from the same `Release/` bundle.
- Verify the signed installer launches cleanly on a fresh Windows machine.
- Re-sign after any post-build file mutation.

## Current Gaps

- No Windows build or installer smoke run was possible in this session because the current host is macOS.
- No Windows signing certificate was available here.
- The installer template is ready, but the final signed installer still requires a Windows packaging pass.
