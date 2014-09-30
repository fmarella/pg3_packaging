Name "PromoGest Gestionale open source"
SetCompressor /SOLID lzma

!include "EnvVarUpdate.nsh"
# Defines
!define REGKEY "SOFTWARE\$(^Name)"

# MUI defines
!define MUI_ICON mask_32.ico
!define MUI_FINISHPAGE_NOAUTOCLOSE

#!define MUI_CUSTOMFUNCTION_GUIINIT CustomGUIInit
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-colorful.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_LANGDLL_REGISTRY_ROOT HKCU
!define MUI_LANGDLL_REGISTRY_KEY ${REGKEY}
!define MUI_LANGDLL_REGISTRY_VALUENAME InstallerLanguage

# Included files
!include Sections.nsh
!include MUI2.nsh

;Request application privileges for Windows Vista
RequestExecutionLevel user

# Variables
Var StartMenuFolder

;--------------------------------
;Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE gpl-2.0.txt
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_FINISH


;Start Menu Folder Page Configuration
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" ;HKCU
;!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
!define MUI_STARTMENUPAGE_DEFAULTFOLDER PromoGest3

!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder

!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages
;!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE Italian

# Installer attributes
OutFile PromoGest-3.0_setup.exe
InstallDir "$APPDATA\pg3"
CRCCheck on
XPStyle on
ShowInstDetails show
InstallDirRegKey HKCU "${REGKEY}" ""
ShowUninstDetails show

# Reserved Files
ReserveFile "${NSISDIR}\Plugins\AdvSplash.dll"
ReserveFile "${NSISDIR}\Plugins\AccessControl.dll"

Function .onInit
    ;InitPluginsDir
    SetOutPath $TEMP
    ;Push $R1
    File /oname=spltmp.bmp "promo_splash.bmp"
    advsplash::show 1000 600 400 -1 $TEMP\spltmp
    AccessControl::GrantOnFile "$DOCUMENTS\promogest2" "(BU)" "FullAccess"
    AccessControl::GrantOnFile "$INSTDIR\pg3" "(BU)" "FullAccess"
    AccessControl::GrantOnFile "$APPDATA\pg3" "(BU)" "FullAccess"
    Pop $R1
    Pop $R1
    !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

# Installer sections

Section Python SEC0001
    SetOutPath $INSTDIR\inst
    SetOverwrite on
    File "python-2.7.6.msi"
    ExecWait '"msiexec" /i "$INSTDIR\inst\python-2.7.6.msi" /qn'
    WriteRegStr HKCU "${REGKEY}\Components" "Python" 1
    ;
    Push $R0
    ReadRegStr $R0 HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    Push $R0
    Call AddToPath
    Pop $R0
    ;
    Push $R0
    ReadRegStr $R0 HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    Push $R0Scripts
    Call AddToPath
    Pop $R0
SectionEnd

Section PyGI SEC0000
    SetOutPath C:\Python27\Lib\site-packages
    SetOverwrite on
    File /r D:\windows\py2.7-gtk3\*
SectionEnd

Section Tools SEC0006
    Push $R0
    ReadRegStr $R0 HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    Push $R0Scripts
    SetOutPath $R0Scripts
    Pop $R0
    SetOverwrite on
	
	SetOutPath $INSTDIR\inst
	
    File distribute_setup.py
    ExecWait 'C:\Python27\python.exe "$INSTDIR\inst\distribute_setup.py"'
    File get-pip.py
    ExecWait 'C:\Python27\python.exe "$INSTDIR\inst\get-pip.py"'
    File ez_setup.py
    ExecWait 'C:\Python27\python.exe "$INSTDIR\inst\ez_setup.py"'
    ;File requirements.txt
;    ExecWait 'C:\Python27\Scripts\pip.exe install -r "$INSTDIR\inst\requirements.txt"'
    ExecWait "c:\Python27\Scripts\pip.exe install pillow"
    ExecWait "c:\Python27\Scripts\pip.exe install Jinja2"
    ExecWait "c:\Python27\Scripts\pip.exe install sqlalchemy"
    ExecWait "c:\Python27\Scripts\pip.exe install reportlab"
    ExecWait "c:\Python27\Scripts\pip.exe install xhtml2pdf"
    ExecWait "c:\Python27\Scripts\pip.exe install html5lib"
    ExecWait "c:\Python27\Scripts\pip.exe install six"
    WriteRegStr HKCU "${REGKEY}\Components" Tools 1
SectionEnd


Section PySVN SEC0007
    SetOutPath $INSTDIR\inst
    SetOverwrite on
    File py27-pysvn-svn185-1.7.9-1572.exe
    ExecWait "$INSTDIR\inst\py27-pysvn-svn185-1.7.9-1572.exe"
    WriteRegStr HKCU "${REGKEY}\Components" PySVN 1
    File svn_co.py
    ExecWait 'C:\Python27\python.exe "$INSTDIR\inst\svn_co.py"'
SectionEnd


Section PYWIN SEC0009
    SetOutPath $INSTDIR\inst
    SetOverwrite on
    File pywin32-218.win32-py2.7.exe
    ExecWait "$INSTDIR\inst\pywin32-218.win32-py2.7.exe"
    WriteRegStr HKCU "${REGKEY}\Components" Pywin32 1
SectionEnd

Section psycopg2 SEC0003
    SetOutPath $INSTDIR\inst
    SetOverwrite on
    File psycopg2-2.5.4.win32-py2.7-pg9.3.5-release.exe
    ExecWait "$INSTDIR\inst\psycopg2-2.5.4.win32-py2.7-pg9.3.5-release.exe"
    WriteRegStr HKCU "${REGKEY}\Components" psycopg2 1
SectionEnd

Section TortoiseSVN SEC0015
    SetOutPath $INSTDIR\inst
    SetOverwrite on
    File TortoiseSVN-1.8.8.25755-win32-svn-1.8.10.msi
    ExecWait "$INSTDIR\inst\TortoiseSVN-1.8.8.25755-win32-svn-1.8.10.msi"
    WriteRegStr HKCU "${REGKEY}\Components" TortoiseSVN 1
SectionEnd

Section PromoGest SEC00010
    SetOutPath $INSTDIR
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    SetOverwrite on
    File "promoG2WIN.pyw"
    File "mask_32.ico"
    SetOutPath $INSTDIR\core
    CreateShortcut $SMPROGRAMS\$StartMenuFolder\PromoGest3.lnk $INSTDIR\core\promoG2WIN.pyw "" "$INSTDIR\mask_32.ico" "0"
    CreateShortcut $DESKTOP\PromoGest3.lnk $INSTDIR\core\promoG2WIN.pyw "" "$INSTDIR\mask_32.ico" "0"
    CreateShortcut $SMPROGRAMS\$StartMenuFolder\Aggiornamento_Emergenza.lnk $INSTDIR\core\aggiornamento_emergenza_windows.pyw "" "$INSTDIR\mask_32.ico" "0"
    CreateShortcut $SMPROGRAMS\$StartMenuFolder\PromoGest3_Debug.lnk $INSTDIR\core\promogest.py "" "$INSTDIR\mask_32.ico" "0"
    WriteRegStr HKCU "${REGKEY}\Components" PromoGest 1
    SetOutPath $INSTDIR
    Push $INSTDIR\pg3\core
    Call AddToPath
    Pop $R0
SectionEnd


Section -post SEC0011
	SetOutPath $INSTDIR
	;Store installation folder
    WriteRegStr HKCU "${REGKEY}" "" $INSTDIR
    ;Create uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
		;Create shortcuts
		CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
		;SetOutPath $SMPROGRAMS\$StartMenuFolder
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" $INSTDIR\uninstall.exe
	!insertmacro MUI_STARTMENU_WRITE_END
	
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd





# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKCU "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections

Section /o -un.Tools UNSEC0009
    Delete /REBOOTOK $INSTDIR\inst\get-pip.py
    Delete /REBOOTOK $INSTDIR\inst\distribute_setup.py
    Delete /REBOOTOK $INSTDIR\inst\ez_setup.py
    ExecWait "c:\Python27\Scripts\pip.exe uninstall -y Jinja2"
    ExecWait "c:\Python27\Scripts\pip.exe uninstall -y pillow"
    ExecWait "c:\Python27\Scripts\pip.exe uninstall -y sqlalchemy"
    ExecWait "c:\Python27\Scripts\pip.exe uninstall -y reportlab"
    ExecWait "c:\Python27\Scripts\pip.exe uninstall -y xhtml2pdf"
    ExecWait "c:\Python27\Scripts\pip.exe uninstall -y six"
    ExecWait "c:\Python27\Scripts\pip.exe uninstall -y html5lib"
SectionEnd

Section /o -un.PromoGest UNSEC0008
    Delete /REBOOTOK $SMPROGRAMS\$StartMenuFolder\Aggiornamento_Emergenza.lnk
    Delete /REBOOTOK $SMPROGRAMS\$StartMenuFolder\PromoGest3_Debug.lnk
    Delete /REBOOTOK $SMPROGRAMS\$StartMenuFolder\PromoGest3.lnk
    Delete /REBOOTOK $DESKTOP\PromoGest3.lnk
    Push $INSTDIR
    Call un.RemoveFromPath
SectionEnd

Section /o -un.psycopg2 UNSEC00013
    Delete /REBOOTOK $INSTDIR\inst\psycopg2-2.5.4.win32-py2.7-pg9.3.5-release.exe
    DeleteRegValue HKCU "${REGKEY}\Components" psycopg2
    Push $R0
    ReadRegStr $R0 HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    ExecWait '"$R0Removepsycopg2.exe" -u "$R0psycopg2-wininst.log"'
    Pop $R0
SectionEnd

Section /o -un.Pywin32 UNSEC00012
    Delete /REBOOTOK $INSTDIR\inst\pywin32-218.win32-py2.7.exe
    DeleteRegValue HKCU "${REGKEY}\Components" Pywin32
    Push $R0
    ReadRegStr $R0 HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    ExecWait '"$R0Removepywin32.exe" -u "$R0pywin32-wininst.log"'
    Pop $R0
SectionEnd

Section /o -un.PySVN UNSEC0006
    Delete /REBOOTOK $INSTDIR\inst\py27-pysvn-svn185-1.7.9-1572.exe
    DeleteRegValue HKCU "${REGKEY}\Components" PySVN
    Push $R0
    ReadRegStr $R0 HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    ExecWait '"$R0lib\site-packages\pysvn\unins000.exe"'
    Pop $R0
SectionEnd

Section /o -un.SetupTools UNSEC0005
    Delete /REBOOTOK $INSTDIR\inst\svn_co.py
SectionEnd

Section /o -un.Python UNSEC0001
    Delete /REBOOTOK $INSTDIR\python-2.7.6.msi
    DeleteRegValue HKCU "${REGKEY}\Components" Python
    Push $R0
    ReadRegStr $R0 HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    Push $R0
    Call un.RemoveFromPath
    Push $R0Scripts
    Call un.RemoveFromPath
    Pop $R0
    ExecWait '"msiexec" /passive /uninstall "$INSTDIR\inst\python-2.7.6.msi"'
SectionEnd

Section /o -un.TortoiseSVN UNSEC0015
	Delete /REBOOTOK $INSTDIR\python-2.7.6.msi
    DeleteRegValue HKCU "${REGKEY}\Components" TortoiseSVN
    ExecWait '"msiexec" /passive /uninstall "$INSTDIR\inst\TortoiseSVN-1.8.8.25755-win32-svn-1.8.10.msi"'
SectionEnd

Section /o -un.Gtk+ UNSEC0000
SectionEnd

Section -un.post UNSEC0010
    DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKCU "${REGKEY}" StartMenuFolder
    DeleteRegValue HKCU "${REGKEY}" ""
    DeleteRegKey /IfEmpty HKCU "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKCU "${REGKEY}"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder"
    RmDir   /REBOOTOK $SMPROGRAMS\$StartMenuFolder"
    RmDir /r /REBOOTOK $INSTDIR
SectionEnd


# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKCU "${REGKEY}" ""
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
    !insertmacro SELECT_UNSECTION "PyGI" ${UNSEC0000}
    !insertmacro SELECT_UNSECTION Python         ${UNSEC0001}
    !insertmacro SELECT_UNSECTION TortoiseSVN    ${UNSEC0015}
    !insertmacro SELECT_UNSECTION PySVN          ${UNSEC0006}
    !insertmacro SELECT_UNSECTION Promogest      ${UNSEC0008}
    !insertmacro SELECT_UNSECTION Tools          ${UNSEC0009}
    !insertmacro SELECT_UNSECTION Pywin32        ${UNSEC00012}
    !insertmacro SELECT_UNSECTION Pywin32        ${UNSEC00013}
FunctionEnd

# Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0001} $(SEC0000_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0000} $(SEC0001_DESC)
;!insertmacro MUI_DESCRIPTION_TEXT ${SEC0002} $(SEC0002_DESC)
;!insertmacro MUI_DESCRIPTION_TEXT ${SEC0003} $(SEC0003_DESC)
;!insertmacro MUI_DESCRIPTION_TEXT ${SEC0004} $(SEC0004_DESC)
;!insertmacro MUI_DESCRIPTION_TEXT ${SEC0005} $(SEC0005_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0006} $(SEC0006_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0007} $(SEC0007_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0015} $(SEC0015_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC0008} $(SEC0009_DESC)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
