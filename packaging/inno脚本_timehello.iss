; efficientTim Windows installer (packaged binary source)
#define MyAppName "efficientTim"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "timehello"
#define MyAppExeName "timehello.exe"

[Setup]
AppId={{D974ED66-9570-4398-96B2-CD5DA2741AE9}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={commonpf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputDir=.\pack-output
OutputBaseFilename=efficientTim-setup
SetupIconFile=ic_launcherico.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "timerbell windows\timehello.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "timerbell windows\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
