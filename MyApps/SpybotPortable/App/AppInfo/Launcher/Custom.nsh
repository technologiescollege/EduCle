!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_HKUDefaultLocalization
Var Exists_HKUDefaultSNL
Var Exists_Services_SDUpdateService

${SegmentPrePrimary}
    ${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SDUpdateService" $R0
    ${If} $R0 = 0
        StrCpy $Exists_Services_SDUpdateService true
    ${EndIf}

    ${registry::KeyExists} "HKU\.DEFAULT\Software\Safer Networking Limited\Localization" $R0
    ${If} $R0 = 0
        StrCpy $Exists_HKUDefaultLocalization true
    ${EndIf}

    ${registry::KeyExists} "HKU\.DEFAULT\Software\Safer Networking Limited" $R0
    ${If} $R0 = 0
        StrCpy $Exists_HKUDefaultSNL true
    ${EndIf}
!macroend

${SegmentPostPrimary}
    ${IfNot} $Exists_HKUDefaultSNL == true
        ${registry::DeleteKey} "HKU\.DEFAULT\Software\Safer Networking Limited" $R0
    ${Else}
        ${IfNot} $Exists_HKUDefaultLocalization == true
            ${registry::DeleteKey} "HKU\.DEFAULT\Software\Safer Networking Limited\Localization" $R0	
        ${EndIf}
    ${EndIf}
    ${IfNot} $Exists_Services_SDUpdateService == true
        ${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SDUpdateService" $R0
        ${If} $R0 = 0
            AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SDUpdateService" "(BU)" "FullAccess"
            Pop $R0
            ${If} $R0 == error
                Pop $R0
                ;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
            ${Else}
                ${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SDUpdateService" $R0
            ${EndIf}
        ${EndIf}
    ${EndIf}
!macroend
