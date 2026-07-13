; Inno Setup installer script for Hable release bundles.
; Build the Windows release first:
;   flutter build windows --release

#define MyAppName "Hable"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Hable"
#define MyAppExeName "Hable.exe"
#define MyBuildRoot "..\\build\\windows\\x64\\runner\\Release"

[Setup]
AppId={{8B9D0D41-0A44-4AC4-A19D-0E89C1B2B0F9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
Compression=lzma
SolidCompression=yes
WizardStyle=modern
OutputDir=dist\\windows
OutputBaseFilename=Hable-Setup
ArchitecturesInstallIn64BitMode=x64

[Files]
Source: "{#MyBuildRoot}\\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
Name: "{autoprograms}\\{#MyAppName}"; Filename: "{app}\\{#MyAppExeName}"
Name: "{autodesktop}\\{#MyAppName}"; Filename: "{app}\\{#MyAppExeName}"

[Run]
Filename: "{app}\\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent
