; ----------------------------------------------------
; Portable Littré
; ----------------------------------------------------
; Par sarkos modifié par Cyrille Largillier
; Utilisant comme base de travail le script de John T. Haller
; License : GPL
; Ce script permet de créer Portable Coolplayer.
; Ce script est à compiler avec NSIS de Nullsoft (http://www.nullsoft.com).
; Il nécessite le plugin "ipicsplash" (affichage splashscreen) pour être compilé.
; $id=PortableLittre.nsi $date=2006-02-18
; ----------------------------------------------------
; Général

; Définition variables entête
!define NAME "PortableLittre"
!define APP "Littre"
!define VER "0.2.0.0"
!define WEBSITE "http://www.framakey.org"
!define DEFAULTAPPDIR "littre"
!define DEFAULTEXE "Littre.exe"

; Nom de l'exécutable
  Name "${NAME}"
; Etiquette
  Caption "${NAME} - Portable and Proud"
; Icone
  Icon "${NAME}.ico"
  WindowIcon Off
; Nom du fichier à créer
  OutFile "${NAME}.exe"

; Runtime Switches
  SetDateSave on
  SetDatablockOptimize on
  CRCCheck On
  SilentInstall Silent
  AutoCloseWindow True

; ----------------------------------------------------
; Version Informations

  VIProductVersion "${VER}"
  VIAddVersionKey FileDescription "${NAME} for Windows"
  VIAddVersionKey LegalCopyright "GPL"
  VIAddVersionKey Comments "Allows ${APP} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
  VIAddVersionKey CompanyName "by Framasoft"
  VIAddVersionKey OriginalFilename "${NAME}.exe"
  VIAddVersionKey FileVersion "${VER}"

; ----------------------------------------------------
; Sections

Section "Main"

; Lancement
    InitPluginsDir
    File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
    ipicsplash::show 3000 600 400 0x04025C "$PLUGINSDIR\splash.jpg"
    SetOutPath "$EXEDIR\${DEFAULTAPPDIR}"
    Exec "${DEFAULTEXE}"

SectionEnd

Section .onInit
  Call Mutex
SectionEnd

; -------------------------------------------
; Prévenir plusieurs Instances
; Sources : http://www.veekee.net/wikinsis/docs/AppendiceC.html#C.11
; -------------------------------------------
  Function Mutex
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "myMutex") i .r1 ?e'
  Pop $R0

  StrCmp $R0 0 +3
   MessageBox MB_OK|MB_ICONEXCLAMATION "${NAME} est déjà lancé."
   Abort
  FunctionEnd

; -------------------------------------------
; Fin du script