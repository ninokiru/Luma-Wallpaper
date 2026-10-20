; Inno Setup
; https://jrsoftware.org/isinfo.php

#define MyAppName "Luma Wallpaper"
; CI passes /DMyAppVersion=<tag> so the asset name tracks the release; local builds fall back here.
#ifndef MyAppVersion
#define MyAppVersion "0.0.1"
#endif
#define MyAppPublisher "ninokiru"
#define MyAppURL "https://github.com/ninokiru/Luma-Wallpaper"
#define MyAppExeName "Lively.exe"

[CustomMessages]
; No prefix = the fallback used by every language that has no entry of its own.
; The two folder paths are appended by the code, so these strings must not name a folder.
DeleteEverythigMsgBox=Delete these folders and everything inside them?
english.DeleteEverythigMsgBox=Delete these folders and everything inside them?
vietnamese.DeleteEverythigMsgBox=Xóa những thư mục này và toàn bộ bên trong?
russian.DeleteEverythigMsgBox=Удалить эти папки и всё их содержимое?
spanish.DeleteEverythigMsgBox=¿Desea eliminar estas carpetas y todo su contenido?
chinese.DeleteEverythigMsgBox=是否删除这些文件夹及其全部内容？
korean.DeleteEverythigMsgBox=이 폴더들과 내용을 삭제하시겠습니까?
CloseAppMsgBox=Luma Wallpaper is still running. Close it so the uninstall can finish?
vietnamese.CloseAppMsgBox=Luma Wallpaper vẫn đang chạy. Đóng ứng dụng để gỡ cài đặt xong?

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{E3E43E1B-DEC8-44BF-84A6-243DBA3F2CB1}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=yes
; Remove the following line to run in administrative install mode (install for all users.)
; lowest - AppData folder, admin - Program Files (x86) 
PrivilegesRequired=lowest
; Ask user which PrivilegesRequired on startup. commandline is also required: the in-app
; updater passes /ALLUSERS when it runs from a Program Files install, and a setup that only
; allows the dialog would refuse the switch and install a second copy under AppData.
PrivilegesRequiredOverridesAllowed=dialog commandline
; Name matches the asset prefix the in-app updater looks for: luma_setup_x64_full_*
OutputBaseFilename=luma_setup_x64_full_v{#MyAppVersion}
SetupIconFile=Icons\appicon_96.ico
; Solid lzma2 over the whole tree: the publish folder is mostly runtime dll files that
; compress well together. lzma (LZMA1) is single threaded and weaker; the ultra levels
; need Inno Setup 6.3+ and add minutes of build time for a few percent more.
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
;Installer/Uninstaller will stop if application is running by checking mutex.
AppMutex=LIVELY:DESKTOPWALLPAPERSYSTEM
;https://jrsoftware.org/ishelp/index.php?topic=winvernotes
;Win10 1903 or above
MinVersion=10.0.18362
WizardSmallImageFile=Theme\wizard_small.bmp
WizardImageFile=Theme\wizard_large.bmp
;Default is hide the welcome page, ms guidelines
DisableWelcomePage=no
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "License\License.txt";
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl";
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl";
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl";
Name: "bulgarian"; MessagesFile: "compiler:Languages\Bulgarian.isl";
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl";
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl";
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl";
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl";
Name: "french"; MessagesFile: "compiler:Languages\French.isl";
Name: "german"; MessagesFile: "compiler:Languages\German.isl";
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl";
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl";
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl";
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl";
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl";
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl";
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl";
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl";
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl";
Name: "chinese"; MessagesFile: "Languages\ChineseSimplified.isl";
Name: "traditionalchinese"; MessagesFile: "Languages\ChineseTraditional.isl";
Name: "arabic"; MessagesFile: "Languages\Arabic.isl";
Name: "vietnamese"; MessagesFile: "Languages\Vietnamese.isl";
Name: "greek"; MessagesFile: "Languages\Greek.isl";
Name: "indonesian"; MessagesFile: "Languages\Indonesian.isl";
Name: "korean"; MessagesFile: "Languages\Korean.isl";
Name: "swedish"; MessagesFile: "Languages\Swedish.isl";
Name: "serbiancyrillic"; MessagesFile: "Languages\SerbianCyrillic.isl";
Name: "serbianlatin"; MessagesFile: "Languages\SerbianLatin.isl";

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}";

[Registry]
;current user only
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Lively"; ValueData: """{app}\Lively.exe"""; Flags: uninsdeletevalue;

; Inno only removes the files it wrote itself. Anything else that ended up in the folder
; stayed forever: crash dumps, the plugins tree from builds before the engines were merged,
; and every file of a previous version whose name changed. The app never writes next to its
; own executables - settings, the wallpaper library and the screenshots all live under the
; data folder - so the whole directory is program data and can go with the uninstall.
[UninstallDelete]
Type: filesandordirs; Name: "{app}"

; Core, UI and player are published into one shared folder now instead of plugins\UI and
; plugins\webview2. Inno only overwrites files, it never removes ones that disappeared, so
; an upgrade from an earlier build would keep three orphaned runtime copies (~250 MB) and
; could even launch the stale executable. Cleared before every install.
[InstallDelete]
Type: filesandordirs; Name: "{app}\plugins"

[Files]
Source: "VC\VC_redist.x64.exe"; DestDir: {tmp}; Flags: deleteafterinstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
; Published self-contained, so no .NET / Windows App runtime redistributable is needed.
Source: "Release\Lively.exe"; DestDir: "{app}"; Flags: ignoreversion;
Source: "Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs;

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall; Check: AutoLaunch 
;skipifsilent
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: /install /quiet /norestart; Check: VCRedistNeedsInstall; StatusMsg: Installing Visual C++ Redistributable...

[Code]
var
  isAlreadyInstalled: Boolean;

// Visual C++ 2015-2022 redistributable.
// The installer only carries the x64 package, so the check has to look at the x64 runtime.
// The old code asked Windows Installer for the x86 product code, which almost never matches
// an x64 machine and made every install run the redist setup again, adding a reboot prompt
// and a minute to the setup.
// Detection as documented by Microsoft: HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64
// holds a REG_DWORD "Major" once a runtime is present.
// ref: https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist
function VCRedistNeedsInstall: Boolean;
var
  MajorVersion: DWord;
begin
  Result := not (RegQueryDWordValue(HKLM64,
    'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64', 'Major', MajorVersion)
    and (MajorVersion >= 14));
end;


// event fired when the uninstall step is changed: https://stackoverflow.com/revisions/12645836/1
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  DeleteUserData: Boolean;
begin
  if CurUninstallStep <> usPostUninstall then
    Exit;

  // Settings, downloaded wallpapers, screenshots and the depth models are user data, so the
  // user is asked and the default keeps them; the folder left by the old brand name goes with
  // the current one.
  DeleteUserData := SuppressibleMsgBox(
      ExpandConstant('{cm:DeleteEverythigMsgBox}') + #13#10 + #13#10 +
      ExpandConstant('{localappdata}\Luma Wallpaper') + #13#10 +
      ExpandConstant('{localappdata}\Lively Wallpaper'),
      mbConfirmation, MB_YESNO, IDNO) = IDYES;
  if DeleteUserData then
  begin
    DelTree(ExpandConstant('{localappdata}\Luma Wallpaper'), True, True, True);
    DelTree(ExpandConstant('{localappdata}\Lively Wallpaper'), True, True, True);
  end;

  // Browser cache and theme copies are rebuilt by the next install and hold nothing a user
  // would want back, so they are cleared without asking.
  DelTree(ExpandConstant('{%TEMP}\Luma Wallpaper'), True, True, True);
  DelTree(ExpandConstant('{%TEMP}\Lively Wallpaper'), True, True, True);
end;

//Uninstall previous install: https://stackoverflow.com/questions/2000296/inno-setup-how-to-automatically-uninstall-previous-installed-version
//note: Inno does not delete files, it just overwrites & keeps the old ones if they have different name..it can get accumulated when program structure change!
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  // Check the 64-bit registry location first
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);

  // If not found, check the 32-bit registry location
  if sUnInstallString = '' then
  begin
    sUnInstPath := ExpandConstant('Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
    if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
      RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  end;

  Result := sUnInstallString;
end;


/////////////////////////////////////////////////////////////////////
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;


/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;
  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/VERYSILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      begin
        isAlreadyInstalled := True;
        Result := 3;
      end
    else
      begin
      isAlreadyInstalled := True;
      Result := 2;
      end
  end else
    isAlreadyInstalled := False;
    Result := 1;
end;

/////////////////////////////////////////////////////////////////////
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;
end;

function ShouldInstallWallpapers: Boolean;
begin
    Result := not isAlreadyInstalled;
end;

//////////////////////////////////////////////////////////////////////
// Uninstaller promts user whether to close lively if running before proceeding.
function InitializeUninstall(): Boolean;
var
  ErrorCode: Integer;
begin
  Result := True;
  if not CheckForMutexes('LIVELY:DESKTOPWALLPAPERSYSTEM') then
    Exit;

  if SuppressibleMsgBox(ExpandConstant('{cm:CloseAppMsgBox}'),
      mbConfirmation, MB_OKCANCEL, IDOK) <> IDOK then
  begin
    // This used to return True anyway and start an uninstall that could not remove a single
    // file: the executables were still running, so Inno skipped them and left the folder.
    Result := False;
    Exit;
  end;

  // A second instance forwards the switch over the named pipe instead of starting a new app,
  // and the core then closes every wallpaper and restores the desktop picture. Forcing the
  // processes down instead leaves the last wallpaper window painted on the desktop until the
  // user reboots.
  ShellExec('open', ExpandConstant('{app}\{#MyAppExeName}'), '--shutdown', '',
    SW_HIDE, ewWaitUntilTerminated, ErrorCode);

  // The UI and one player per screen are separate processes in the same folder, and they all
  // hold files locked; taskkill also waits for the tree to go down before Inno starts.
  ShellExec('open', 'taskkill.exe', '/f /t /im {#MyAppExeName}', '',
    SW_HIDE, ewWaitUntilTerminated, ErrorCode);
  ShellExec('open', 'taskkill.exe', '/f /t /im Lively.UI.WinUI.exe', '',
    SW_HIDE, ewWaitUntilTerminated, ErrorCode);
  ShellExec('open', 'taskkill.exe', '/f /t /im Lively.Player.WebView2.exe', '',
    SW_HIDE, ewWaitUntilTerminated, ErrorCode);
end;
//////////////////////////////////////////////////////////////////////
function CmdLineParamNotExists(const Value: string): Boolean;
var
  I: Integer;  
begin
  Result := True;
  for I := 1 to ParamCount do
    if CompareText(ParamStr(I), Value) = 0 then
    begin
      Result := False;
      Exit;
    end;
end;

function AutoLaunch(): Boolean;
begin
 Result := CmdLineParamNotExists('/NOAUTOLAUNCH');
end;
