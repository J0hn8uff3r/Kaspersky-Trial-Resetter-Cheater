@echo off
NET SESSION >nul 2>&1 && goto noUAC
title.
set n=%0 %*
set n=%n:"=" ^& Chr(34) ^& "%
echo Set objShell = CreateObject("Shell.Application")>"%tmp%\cmdUAC.vbs"
echo objShell.ShellExecute "cmd.exe", "/c start " ^& Chr(34) ^& "." ^& Chr(34) ^& " /d " ^& Chr(34) ^& "%CD%" ^& Chr(34) ^& " cmd /c %n%", "", "runas", ^1>>"%tmp%\cmdUAC.vbs"
cscript "%tmp%\cmdUAC.vbs" //Nologo
del "%tmp%\cmdUAC.vbs"
exit /b
:noUAC

REG ADD "HKEY_CURRENT_USER\Software\KasperskyLab\AVP17.0.0" /v LastLicenseNotificationTime /T REG_SZ /d 1500000000 /F
REG ADD "HKEY_CURRENT_USER\Software\KasperskyLab\AVP17.0.0" /v HidePromo /T REG_SZ /d 1 /F

IF NOT EXIST "%ProgramFiles(x86)%\Kaspersky Lab\Kaspersky Internet Security 17.0.0" MKDIR "%ProgramFiles(x86)%\Kaspersky Lab\Kaspersky Internet Security 17.0.0"

FOR %%I IN ("%ProgramFiles(x86)%\Kaspersky Lab\Kaspersky Internet Security 17.0.0\avp.exe") DO SET avpsize=%%~zI
	
IF [%avpsize%] NEQ [] (
    msg * Please, uninstall Kaspersky Internet Security before running this script.
) ELSE (
    TYPE NUL > "%ProgramFiles(x86)%\Kaspersky Lab\Kaspersky Internet Security 17.0.0\avp.exe"

	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\KasperskyLab\AVP17.0.0\settings" /v EnableSelfProtection /T REG_DWORD /d 00000000 /F
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\KasperskyLab\AVP17.0.0\settings\def" /v EnableSelfProtection /T REG_DWORD /d 00000000 /F

	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\KasperskyLab\AVP17.0.0\environment" /v ProductRoot /T REG_SZ /d "C:\\Program Files (x86)\\Kaspersky Lab\\Kaspersky Internet Security 17.0.0" /F
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\KasperskyLab\AVP17.0.0\environment" /v ProductType /T REG_SZ /d kis /F
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\KasperskyLab\AVP17.0.0\environment" /v ProductVersion /T REG_SZ /d 17.0.0.611 /F
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\KasperskyLab\AVP17.0.0\environment" /v DataRoot /T REG_SZ /d "C:\\ProgramData\\Kaspersky Lab\\AVP17.0.0" /F
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\KasperskyLab\AVP17.0.0\environment" /v ProductStatus /T REG_SZ /d release /F

	msg * Done, now you can re-run your Kaspersky Trial Resetter 5.1.0.29 again and re-install KIS.
)
