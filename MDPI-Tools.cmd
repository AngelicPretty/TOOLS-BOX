@setlocal DisableDelayedExpansion
@echo off

::============================================================================
::
::   This script is a part of 'MDPI IT TOOLS' project.
::
::      Homepage: mdpi.com
::      Email: ziang.yu@mdpi.com
::
::============================================================================




::========================================================================================================================================

:: Re-launch the script with x64 process if it was initiated by x86 process on x64 bit Windows
:: or with ARM64 process if it was initiated by x86/ARM32 process on ARM64 Windows

if exist %SystemRoot%\Sysnative\cmd.exe (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

:: Re-launch the script with ARM32 process if it was initiated by x64 process on ARM64 Windows

if exist %SystemRoot%\SysArm32\cmd.exe if %PROCESSOR_ARCHITECTURE%==AMD64 (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

::  Set Path variable, it helps if it is misconfigured in the system

set "SysPath=%SystemRoot%\System32"
if exist "%SystemRoot%\Sysnative\reg.exe" (set "SysPath=%SystemRoot%\Sysnative")
set "Path=%SysPath%;%SystemRoot%;%SysPath%\Wbem;%SysPath%\WindowsPowerShell\v1.0\"

::========================================================================================================================================

cls

title  Little Fish Microsoft MDPI Backup Scripts v5.5

set _elev=
if /i "%~1"=="-el" set _elev=1

set winbuild=1
set "nul=>nul 2>&1"
set "_psc=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G

set _NCS=1
if %winbuild% LSS 10586 set _NCS=0
if %winbuild% GEQ 10586 reg query "HKCU\Console" /v ForceV2 2>nul | find /i "0x0" 1>nul && (set _NCS=0)

call :_colorprep

set "nceline=echo: &echo ==== ERROR ==== &echo:"
set "eline=echo: &call :_color %Red% "==== ERROR ====" &echo:"

::========================================================================================================================================

if %winbuild% LSS 7600 (
%nceline%
echo Unsupported OS version detected.
echo Project is supported only for Windows 7/8/8.1/10/11 and their Server equivalent.
goto MASend
)

if not exist %_psc% (
%nceline%
echo Powershell is not installed in the system.
echo Aborting...
goto MASend
)

::========================================================================================================================================

::  Fix for the special characters limitation in path name

set "_batf=%~f0"
set "_batp=%_batf:'=''%"

set "_PSarg="""%~f0""" -el %_args%"

set "_ttemp=%temp%"

setlocal EnableDelayedExpansion

::========================================================================================================================================

echo "!_batf!" | find /i "!_ttemp!" 1>nul && (
%nceline%
echo Script is launched from the temp folder,
echo Most likely you are running the script directly from the archive file.
echo:
echo Extract the archive file and launch the script from the extracted folder.
goto MASend
)

::========================================================================================================================================

::  Elevate script as admin and pass arguments and preventing loop

%nul% reg query HKU\S-1-5-19 || (
if not defined _elev %nul% %_psc% "start cmd.exe -arg '/c \"!_PSarg:'=''!\"' -verb runas" && exit /b
%nceline%
echo This script require administrator privileges.
echo To do so, right click on this script and select 'Run as administrator'.
goto MASend
)

::========================================================================================================================================

setlocal DisableDelayedExpansion

::  Check desktop location

set _desktop_=
for /f "skip=2 tokens=2*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop') do call set "_desktop_=%%b"
if not defined _desktop_ for /f "delims=" %%a in ('%_psc% "& {write-host $([Environment]::GetFolderPath('Desktop'))}"') do call set "_desktop_=%%a"

set "_pdesk=%_desktop_:'=''%"
setlocal EnableDelayedExpansion
set "mastemp=%SystemRoot%\Temp\__MAS"

::========================================================================================================================================
:MainMenu
cls
color 07
title Little Fish MDPI Tool Scripts v5.5
mode 80, 40
if exist "%mastemp%\.*" rmdir /s /q "%mastemp%\" %nul%

echo:       
echo:	       ¨u ¨v
echo:	     ^¨u¨u    ¨v
echo:	   ^¨u¨u        
echo:	  ^|   ¨€¨€¨€¨[   ¨€¨€¨€¨[¨€¨€¨€¨€¨€¨€¨[ ¨€¨€¨€¨€¨€¨€¨[ ¨€¨€¨[
echo:	  ^|   ¨€¨€¨€¨€¨[ ¨€¨€¨€¨€¨U¨€¨€¨X¨T¨T¨€¨€¨[¨€¨€¨X¨T¨T¨€¨€¨[¨€¨€¨U
echo:	  ^|   ¨€¨€¨X¨€¨€¨€¨€¨X¨€¨€¨U¨€¨€¨U  ¨€¨€¨U¨€¨€¨€¨€¨€¨€¨X¨a¨€¨€¨U
echo:	  ^|   ¨€¨€¨U¨^¨€¨€¨X¨a¨€¨€¨U¨€¨€¨U  ¨€¨€¨U¨€¨€¨X¨T¨T¨T¨a ¨€¨€¨U   ^|
echo:	      ¨€¨€¨U ¨^¨T¨a ¨€¨€¨U¨€¨€¨€¨€¨€¨€¨X¨a¨€¨€¨U     ¨€¨€¨U   ^|
echo:	      ¨^¨T¨a     ¨^¨T¨a¨^¨T¨T¨T¨T¨T¨a ¨^¨T¨a     ¨^¨T¨a   ^|
echo:	                                    ¨u¨u
echo:	                             ¨v    ¨u¨u
echo:	                               ¨v ¨u
echo:							
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
echo:                 MDPI Methods:
echo:
echo:             [1] Backup      ^| Permanent   ^|  U Disk
echo:             [2] Adobe       ^| Acrobat     ^|  Install/uninstall
echo:             [3] LayoutDeck  ^| Office Tool ^|  Install/Repair
echo:             [4] Snippets    ^| XML Tool    ^|  Install
echo:             __________________________________________________      
echo:                                                                      
echo:             [5] Network Setting
echo:             [6] Create New Profile
echo:             __________________________________________________      
echo:                                                                     
echo:             [7] Read Me
echo:             [8] Exit                                
echo:       ______________________________________________________________
echo:

call :_color2 %_White% "         " %_Green% "Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8] :"
choice /C:12345678 /N
set _erl=%errorlevel%

if %_erl%==8 exit /b
if %_erl%==7 exit /b
if %_erl%==6 setlocal & call :n_profile & cls & endlocal & goto :MainMenu
if %_erl%==5 setlocal & call :r_network & cls & endlocal & goto :MainMenu
if %_erl%==4 setlocal & call :Snippets & cls & endlocal & goto :MainMenu
if %_erl%==3 setlocal & call :Layout_Deck & cls & endlocal & goto :MainMenu
if %_erl%==2 setlocal & call :Adobe & cls & endlocal & goto :MainMenu
if %_erl%==1 setlocal & call :Backup & cls & endlocal & goto :MainMenu
goto :MainMenu
::========================================================================================================================================
:n_profile
setlocal enabledelayedexpansion
cls
mode 85, 30
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:

set /p user=[+] Please enter user name:
set mail_add=%user%@mdpi.com
echo [+] Mail address set %user%@mdpi.com [Done]
echo [+] Start create new mail folders
md "D:/Mail/%mail_add%"
echo [+] D:/Mail/%mail_add% [DONE]
md "D:/Mail/Local Folders"
echo [+] D:/Mail/Local Floders [DONE]
call :_color2 %_Green% "[+] Create new mail folders complete!"
goto :casVend
::========================================================================================================================================
:Adobe
setlocal enabledelayedexpansion
cls
mode 76, 30
echo:
echo:
echo:           /\      ^|^|     ^| ^|         
echo:          /  \   _ ^|^| ___ ^| ^|__   __     ^|\_/^|
echo:         / /\ \ / _`^|/ _ \^| '_ \ / _ \   ^|o o^|__
echo:        / ____ \ ( ^|^| (_) ^| ^|_) ^|  __/   --^*--__\
echo:       /_/    \_\___^|\___/^|_.__/ \__^|    C_C_(___) 
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
echo:                 Adobe Arcobat DC Application Maintenance
echo:                 Program Maintenance:   
echo:     
echo:             [1] Adobe Arcobat DC [Install] 
echo:             [2] Adobe Arcobat DC [Remove]
echo:             [3] Adobe Arcobat DC Print Setting
echo:           __________________________________________________      
echo:                                                                     
echo:             [4] Read Me
echo:             [5] Back to Menu          
echo:       ______________________________________________________________
echo:

call :_color2 %_White% "         " %_Green% "Enter a menu option in the Keyboard [1,2,3,4,5] :"
choice /C:12345 /N
set _erl=%errorlevel%

if %_erl%==5 setlocal & goto :MainMenu
if %_erl%==4 setlocal & goto :MainMenu
if %_erl%==3 setlocal & call :Adobe_P & cls & endlocal & goto :Adobe
if %_erl%==2 setlocal & call :Adobe_R & cls & endlocal & goto :Adobe
if %_erl%==1 setlocal & call :Adobe_S & cls & endlocal & goto :Adobe
goto :Adobe
::========================================================================================================================================
:Adobe_R
setlocal enabledelayedexpansion
cls
mode 85, 30
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:	
call :_color2 %_Green% "[+] Starting remove Adobe Arcobat DC"
::REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Acrobat Distiller" | findstr 2017 && set adobe=2017
::REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Acrobat Distiller\DC\Installer" /v "CHS_GUID"
::REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Acrobat Distiller\DC\Installer >nul 2>nul && goto A || goto B
for /f "skip=1 tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Acrobat Distiller\DC\Installer" /v "ENU_GUID"') do ( 
   set key=%%i 
   )
) 
::REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Acrobat Distiller" | findstr DC && set adobe=DC
MsiExec.exe /I%key%
call :_color2 %_Yellow% "[+] Remove Adobe Arcobat DC complete!"
goto :casVend
:Adobe_S
setlocal enabledelayedexpansion
cls
mode 85, 30
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:

call :_color2 %_Green% "[+] Checking U disk exists..."
for %%i in (d e f g h i j k) do (
fsutil fsinfo drivetype %%i: | findstr "Removable" >nul 2>nul && set u_disk=%%i:
)
echo [+] Find %u_disk% - Removable Drive
if "%u_disk%"=="" (
call :_color2 %_Red% "[-] U disk not detected"
echo [+] Please insert a USB Disk!
set /p input=[+] Recheck USB Disk?[Y/N]N=Exit:
IF "!input!"=="N" (
goto :MainMenu
) ELSE (
ping -n 1 127.0.0.1>nul
goto :check_U
)
)
set /p u_disk=[+] Please select the location of the installation disk:
set /p input=[+] Use the %u_disk% to install Adobe Arcobat DC? [Y/N]N=Exit:
IF "!input!"=="N" (
	goto :Aobe
)
call :_color2 %_Green% "[+] Checking install file exists..."

IF EXIST "%u_disk%\Adobe Acrobat\Setup.exe" (
	call :_color2 %_Green% "[+] %u_disk%\Adobe Acrobat\Setup.exe [OK]"
	call :_color2 %_Green% "[+] Starting install Adobe Arcobat DC"
	start "" "%u_disk%\Adobe Acrobat\Setup.exe"
) ELSE (
	call :_color2 %_Red% "[+] %u_disk%\Adobe Acrobat\Setup.exe [ERROR]"
	call :_color2 %_Red% "[+] Adobe Arcobat DC install file is not exists!"
	call :_color2 %_Yellow% "[+] Interrupt Adobe Arcobat DC installation"
	goto :casVend
)

call :_color2 %_Yellow% "[+] install Adobe Arcobat DC complete!"
goto :casVend
:Adobe_P
setlocal enabledelayedexpansion
cls
mode 85, 30
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
set Setting_file="%~dp0PDF\1200DPI.joboptions" "%~dp0PDF\MDPI-General-Press-Quality.joboptions"
call :_color2 %_Green% "[+] Start Setting Adobe PDF print file"
IF not exist "%AppData%\Roaming\Adobe\Adobe PDF\Settings" (
	echo "[+] Create Adobe PDF Setting folder"
	md "%AppData%\Roaming\Adobe\Adobe PDF\Settings
)
call :_color2 %_Green% "[+] Checking Setting file exists..."
ping -n 2 0.0.0.0>nul
for %%a in (%Setting_file%) do (
	IF EXIST %%a (
	echo [+] %%a [OK]
	) ELSE (
	echo [+] The specified setting path does not Found!
	call :_color2 %_Red% "[-] %%a [ERROR]"
	echo [+] Please recheck adobe print file...
	set /p input=[+] Recheck Hosts file? [Y/N]N=Exit:
	IF "!input!"=="N" (
	goto :MainMenu
	) ELSE (
	goto :Adobe
	)
	)
)
xcopy "%~dp0PDF\1200DPI.joboptions" "%AppData%\Adobe\Adobe PDF\Settings" /d /c /y 
xcopy "%~dp0PDF\MDPI-General-Press-Quality.joboptions" "%AppData%\Adobe\Adobe PDF\Settings" /d /c /y
call :_color2 %_Green% "[+] Adobe PDF print file DONE!"
goto :casVend
::========================================================================================================================================
:Snippets
setlocal enabledelayedexpansion
cls
mode 85, 30
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
call :_color2 %_Yellow% "[+] Start install Snippets for Notepad++ XML Tools"
call :_color2 %_Green% "[+] Check Layout Deck intstall file exists..."
	IF exist "%~dp0\Snippets\resources" (
	echo [+] Layout Deck resources install files [OK]
	) ELSE (
	echo [+] The install flies does not Found!
	call :_color2 %_Red% "[-] %%i [ERROR]"
	set /p input=[+] Recheck install files? [Y/N]N=Exit:
		IF "!input!"=="N" (
		goto :MainMenu
		) ELSE (
		goto :Layout_Deck
		)
	)
echo [+] Close program Notepad++...
taskkill /f /im Notepad++.exe >nul 2>nul
call :_color2 %_Green% "[+] Notepadd++ program: [CLOSE]"
set NAMESEED=%date:~5,2%.%date:~8,2%
ren %APPDATA%\Notepad++\plugins\config\NppSnippets.sqlite NppSnippets-%NAMESEED%.sqlite
xcopy  "%~dp0Snippets\resources\NppSnippets.sqlite" "%APPDATA%\Notepad++\plugins\config" /d /c /y 
if exist "C:\Program Files (x86)\Notepad++\notepad++.exe" (
	if not exist "C:\Program Files (x86)\Notepad++\plugins\NppSnippets" (
		md "C:\Program Files (x86)\Notepad++\plugins\NppSnippets"
	)
	xcopy  "%~dp0Snippets\resources\32\NppSnippets.dll"  "C:\Program Files (x86)\Notepad++\plugins" /d /c /y 
	xcopy  "%~dp0Snippets\resources\32\NppSnippets.dll"  "C:\Program Files (x86)\Notepad++\plugins\NppSnippets" /d /c /y 
) else (
	if not exist "C:\Program Files\Notepad++\plugins\NppSnippets" (
		md "C:\Program Files\Notepad++\plugins\NppSnippets"
	)
	xcopy  "%~dp0Snippets\resources\64\NppSnippets.dll"  "C:\Program Files\Notepad++\plugins" /d /c /y 
	xcopy  "%~dp0Snippets\resources\64\NppSnippets.dll"  "C:\Program Files\Notepad++\plugins\NppSnippets" /d /c /y 
)
echo [+] Installation Complete.
goto :casVend

:Layout_Deck
setlocal enabledelayedexpansion
cls
mode 85, 30
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
call :_color2 %_Yellow% "[+] Start install Layout Deck for office Tools"
call :_color2 %_Green% "[+] Check Layout Deck intstall file exists..."
	IF exist "%~dp0\LayoutDeck\resources" (
	echo [+] Layout Deck resources install files [OK]
	) ELSE (
	echo [+] The install flies does not Found!
	call :_color2 %_Red% "[-] %%i [ERROR]"
	set /p input=[+] Recheck install files? [Y/N]N=Exit:
		IF "!input!"=="N" (
		goto :MainMenu
		) ELSE (
		goto :Layout_Deck
		)
	)

IF exist "%APPDATA%\Microsoft\Word\STARTUP\Normal.dotm" (
ren "%APPDATA%\Microsoft\Word\STARTUP\Normal.dotm Normal1.dotm"
) else (
GOTO N_Version
)
if %errorlevel% EQU 0 GOTO P_Version
if %errorlevel% NEQ 0 GOTO E_CLOSE
GOTO END

:P_Version
if exist "%APPDATA%\Microsoft\Word\STARTUP\Normal1.dotm" del "%APPDATA%\Microsoft\Word\STARTUP\Normal1.dotm"
if exist "%APPDATA%\Microsoft\Word\STARTUP\Normal.dotm" del "%APPDATA%\Microsoft\Word\STARTUP\Normal.dotm"
GOTO N_Version

:E_CLOSE
call :_color2 %_Red% "[+] Please Close MS Word to complete the installation!"
set /p user=[+] Do you want to try again?[Y/N]N=Exit:
IF "!input!"=="N" (
GOTO :MainMenu
) ELSE (
GOTO :Layout_Deck
)
:N_Version
echo [+] Clean old files...
IF exist "%APPDATA%\Microsoft\Templates" (
DEL /f /s /q "%APPDATA%\Microsoft\Templates\*.*"
)

if exist "%APPDATA%\Microsoft\Templates\Normal.dotm" (
ren "%APPDATA%\Microsoft\Templates\Normal.dotm" Normal2.dotm
)
if %errorlevel% NEQ 0 GOTO E_CLOSE
if exist "%APPDATA%\Microsoft\Templates\Normal2.dotm" del "%APPDATA%\Microsoft\Templates\Normal2.dotm"
echo [+] Copy new files...
copy /y "%~dp0LayoutDeck\resources\Normal.dotm" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\Normal1.dotm" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\The MDPI Layout Style Guide v7-2021.12.pdf" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\abbreviation.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\How to Reorder References.pdf" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\chicagoNoteDate.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\ISSN.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\ccby-nc-nd.png" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\countryList.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\ShortFull.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\doiAbbr.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\journalNameFull.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\jourWebName.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\journalNameAbbr.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\universitylist.json" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\Common Shortcut.docx" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\copyRight.png" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\MDPI.png" "%APPDATA%\Microsoft\Templates"
copy /y "%~dp0LayoutDeck\resources\WCopyfind.4.1.1.exe" "%APPDATA%\Microsoft\Templates"

if exist "%SystemRoot%\System32\WindowsPowerShell\vv5.5\powershell.exe" (
echo [+] Add items that we escap Microsoft Defender Antivirus scans.
powershell -noprofile -command "&{ start-process powershell -ArgumentList '-noprofile -c Add-MpPreference -ExclusionPath "%APPDATA%\Microsoft\Templates\Normal.dotm"; Add-MpPreference -ExclusionPath "%APPDATA%\Microsoft\Templates"; Add-MpPreference -ExclusionPath "%APPDATA%\Microsoft\Templates"' -verb RunAs}")

echo [+] Installation Complete.
goto :casVend
::========================================================================================================================================
:info
cls
wmic logicaldisk list brief
goto :casVend

::========================================================================================================================================
:Backup
setlocal enabledelayedexpansion
cls
mode 85, 30
echo:
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
echo:                 Disk Backup Methods
echo:                 Select the disk to backup:   
echo:                
echo:             [1] All Disk    
echo:             [2] C Disk      
echo:             [3] D Disk      
echo:             [4] E Disk  
echo:             [5] F Disk                         
echo:                                                        
echo:       
echo:             __________________________________________________      
echo:                                                                     
echo:             [6] Read Me
echo:             [7] Back to Menu          
echo:       ______________________________________________________________
echo:
call :_color2 %_White% "         " %_Green% "Enter a menu option in the Keyboard [1,2,3,4,5,6,7] :"
choice /C:1234567 /N
set _erl=%errorlevel%

if %_erl%==7 setlocal & goto :MainMenu
if %_erl%==6 setlocal & goto :MainMenu
if %_erl%==5 setlocal & call :F_Backup & cls & endlocal & goto :Backup
if %_erl%==4 setlocal & call :E_Backup & cls & endlocal & goto :Backup
if %_erl%==3 setlocal & call :D_Backup & cls & endlocal & goto :Backup
if %_erl%==2 setlocal & call :C_Backup & cls & endlocal & goto :Backup
if %_erl%==1 setlocal & call :C_Backup & call :D_Start_Backup & call :E_Start_Backup & call :F_Start_Backup & cls & endlocal & goto :Backup
goto :Backup
::========================================================================================================================================
:F_Backup
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
call :_color2 %_Green% "[+] Checking F: disk status..."
wmic logicaldisk list brief | findstr F: && set backup_disk=F
if "%backup_disk%"=="" (
call :_color2 %_Red% "[-] F disk does not exist [ERROR]"

goto :Backup
)
goto :check_U

:F_Start_Backup

set /p user=[+] Please enter user name(default name backup):
IF "%user%"=="" (
	set user=backup
)
echo [+] Backup files path set %u_disk%\%user%

IF not exist "%u_disk%\%user%\%backup_disk%\" (
	 md "%u_disk%\%user%\%backup_disk%\"
	 call :_color2 %_Green% "[+] Create backup files in %u_disk%\%user%\%backup_disk% [DONE]"
)
call :_color2 %_Yellow% "[+] Starting Backup F Disk Files in %u_disk%\%user%"
RoboCopy F:\ %u_disk%\%user%\F\ /E
attrib -s -h "%u_disk%\%user%\%backup_disk%"
call :_color2 %_Green% "[+] F: Disk Backup Done!"
call :_color2 %_Yellow% "[+] Press any key to continue..."
pause >nul
goto :casVend
:E_Backup
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
call :_color2 %_Green% "[+] Checking E: disk status..."
wmic logicaldisk list brief | findstr E: && set backup_disk=E
if "%backup_disk%"=="" (
call :_color2 %_Red% "[-] E disk does not exist [ERROR]"

goto :Backup
)
goto :check_U

:E_Start_Backup

set /p user=[+] Please enter user name(default name backup):
IF "%user%"=="" (
	set user=backup
)
echo [+] Backup files path set %u_disk%\%user%

IF not exist "%u_disk%\%user%\%backup_disk%\" (
	 md "%u_disk%\%user%\%backup_disk%\"
	 call :_color2 %_Green% "[+] Create backup files in %u_disk%\%user%\%backup_disk% [DONE]"
)
call :_color2 %_Yellow% "[+] Starting Backup E Disk Files in %u_disk%\%user%"
RoboCopy E:\ %u_disk%\%user%\E\ /E
attrib -s -h "%u_disk%\%user%\%backup_disk%"
call :_color2 %_Green% "[+] E: Disk Backup Done!"
call :_color2 %_Yellow% "[+] Press any key to continue..."
pause >nul
goto :casVend
:D_Backup
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
call :_color2 %_Green% "[+] Checking D: disk status..."
wmic logicaldisk list brief | findstr D: && set backup_disk=D
if "%backup_disk%"=="" (
call :_color2 %_Red% "[-] D disk does not exist [ERROR]"

goto :Backup
)
goto :check_U

:D_Start_Backup

set /p user=[+] Please enter user name(default name backup):
IF "%user%"=="" (
	set user=backup
)
echo [+] Backup files path set %u_disk%\%user%\%backup_disk%

IF not exist "%u_disk%\%user%\%backup_disk%\" (
	 md "%u_disk%\%user%\%backup_disk%\"
	 call :_color2 %_Green% "[+] Create backup files in %u_disk%\%user%\%backup_disk% [DONE]"
	 pause
)
call :_color2 %_Yellow% "[+] Starting Backup D Disk Files in %u_disk%\%user%"
RoboCopy D:\ %u_disk%\%user%\D\ /E
attrib -s -h "%u_disk%\%user%\%backup_disk%"
call :_color2 %_Green% "[+] D: Disk Backup Done!"
call :_color2 %_Yellow% "[+] Press any key to continue..."
pause >nul
goto :casVend
:C_Backup
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
set Setting_file=%~dp0resourse\path.txt %~dp0resourse\localpath.txt %~dp0resourse\roamingpath.txt
set Desktop_Path_Check=1
set input=Y
call :_color2 %_Green% "[+] Checking C: disk status..."
wmic logicaldisk list brief | findstr C: && set backup_disk=C
:check_path
call :_color2 %_Green% "[+] Checking Setting file exists..."
ping -n 2 0.0.0.0>nul
for %%a in (%Setting_file%) do (
	IF EXIST %%a (
	echo [+] %%a [OK]
	set Desktop_Path_Check=1
	) ELSE (
	echo [+] The specified setting path does not Found!
	call :_color2 %_Red% "[-] %%a [ERROR]"
	set Desktop_Path_Check=0
	goto :recheck_setfile
	)
)

call :_color2 %_Green% "[+] Checking file exists..."
ping -n 2 0.0.0.0>nul
for /f %%a in (%~dp0resourse/path.txt) do (
	IF EXIST %%a (
	echo [+] %%a [OK]
	set Desktop_Path_Check=1
	) ELSE (
	echo [+] The specified path does not Found!
	call :_color2 %_Red% "[-] %%a [ERROR]"
	set Desktop_Path_Check=0
	goto :recheck_setfile
	)
)
:recheck_setfile
IF "%Desktop_Path_Check%"=="0" (
echo [+] Please Check file Exists!
set /p input=[+] Recheck Path? [Y/N]N=Exit:
IF "!input!"=="N" (
goto :MainMenu
) ELSE (
ping -n 2 0.0.0.0>nul
goto :check_path
)
) ELSE (
goto :check_U
)
:check_U
call :_color2 %_Green% "[+] Checking U disk exists..."
for %%i in (d e f g h i j k) do (
fsutil fsinfo drivetype %%i: | findstr ":"
)
set /p u_disk=[+] Please select the location of the installation disk:
set /p input=[+] Use the %u_disk% to backup files [Y/N]N=Exit:
IF "!input!"=="N" (
	goto :Backup
)

if "%backup_disk%"=="C" goto :C_Start_Backup
if "%backup_disk%"=="D" goto :D_Start_Backup
if "%backup_disk%"=="E" goto :E_Start_Backup
if "%backup_disk%"=="F" goto :F_Start_Backup

:C_Start_Backup
set /p user=[+] Please enter user name(default name backup):
IF "%user%"=="" (
	set user=backup
)
echo [+] Backup files path set %u_disk%\%user%
IF not exist "%u_disk%\%user%\%backup_disk%\" (
	 md "%u_disk%\%user%\%backup_disk%\.texlive2020"
	 md "%u_disk%\%user%\%backup_disk%\Local"
	 md "%u_disk%\%user%\%backup_disk%\Roaming"
	 md "%u_disk%\%user%\%backup_disk%\Documents"
	 md "%u_disk%\%user%\%backup_disk%\Downloads"
	 md "%u_disk%\%user%\%backup_disk%\Desktop"
	 call :_color2 %_Green% "[+] Create backup files in %u_disk%\%user% [DONE]"
)
IF exist "C:\Users\MDPI\Documents\WeChat Files" (
	call :_color2 %_Green% "[+] Find Wechat Document files"
	set /p input=[+] Do you want to keep Wechat Document files?[Y/N]:
	IF "!input!"=="N" (
	rd /s /q "C:\Users\MDPI\Documents\WeChat Files\"
	call :_color2 %_Green% "[+] Delete complete!"
	)
)
call :_color2 %_Yellow% "[+] Starting Backup C Disk Files in %u_disk%\%user%"
call :_color2 %_Yellow% "[+] Press any key to continue..."
PAUSE >nul
xcopy "C:\Users\MDPI\.texlive2020\*.*" "%u_disk%\%user%\C\.texlive2020" /s /h /d /c /y
xcopy "C:\Users\MDPI\Documents\*.*" "%u_disk%\%user%\C\Documents" /s /h /d /c /y
xcopy "C:\Users\MDPI\Downloads\*.*" "%u_disk%\%user%\C\Downloads" /s /h /d /c /y
xcopy "C:\Users\MDPI\Desktop\*.*" "%u_disk%\%user%\C\Desktop" /s /h /d /c /y
for /f %%i in (%~dp0resourse\localpath.txt) do set "pt=%%i"&echo %%i&call :getname %%i&xcopy "!pt!\*.*" "%u_disk%\%user%\C\Local\!fn!\" /s /h /d /c /y
for /f %%i in (%~dp0resourse\roamingpath.txt) do set "pt=%%i"&echo %%i&call :getname %%i&xcopy "!pt!\*.*" "%u_disk%\%user%\C\Roaming\!fn!\" /s /h /d /c /y
call :_color2 %_Green% "[+] C: Diks Backup Done!"
goto :casVend

::========================================================================================================================================
:r_network
setlocal enabledelayedexpansion
cls
mode 76, 25
echo:
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
echo:                 Solve Network Error
echo:                 Select the methods to Repair:   
echo:                
echo:             [1] Hosts File Repair [Manual]    
echo:             [2] Hosts File Repair [Auto]     
echo:             __________________________________________________      
echo:
echo:             [3] Network Restet [DNS]                    
echo:             [4] VPN install [WH/GG]
echo:             __________________________________________________      
echo:                                                                     
echo:             [7] Read Me
echo:             [8] Back to Menu          
echo:       ______________________________________________________________
echo:
call :_color2 %_White% "         " %_Green% "Enter a menu option in the Keyboard [1,2,3,4,5,6,7] :"
choice /C:12345678 /N
set _erl=%errorlevel%

if %_erl%==8 setlocal & goto :MainMenu
if %_erl%==7 exit /b
if %_erl%==6 exit /b
if %_erl%==5 exit /b
if %_erl%==4 setlocal & call :update_vpn & cls & endlocal & goto :r_network
if %_erl%==3 setlocal & call :DNS_r & cls & endlocal & goto :r_network
if %_erl%==2 setlocal & call :Hosts_a & cls & endlocal & goto :r_network
if %_erl%==1 setlocal & call :Hosts_m & cls & endlocal & goto :r_network
goto :r_network
::========================================================================================================================================
:Hosts_m
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
set hosts_path=C:\Windows\System32\drivers\etc\hosts
call :_color2 %_Green% "[+] Checking Hosts file exists..."
IF EXIST %hosts_path% (
 echo [+] C:\Windows\System32\drivers\etc\hosts [OK]
) ELSE (
 call :_color2 %_Red% "[-] %hosts_path% [ERROR]"
 echo [+] Regenerate the hosts file
 echo=>C:\Windows\System32\drivers\etc\hosts
)
echo [+] Start manual repairing the hosts file...
start notepad "C:\Windows\System32\drivers\etc\hosts"
echo [+] Hosts repaired successfully!
call :_color2 %_Yellow% "[+] Press any key to continue..."
pause >nul
echo [+] Start DNS flush
ipconfig /flushdns >nul
echo [+] Windows IP Configuration
call :_color2 %_Green% "[+] Successfully flushed the DNS Resolver Cache."
goto :casVend

:Hosts_a
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
set Setting_file=%~dp0resourse\hosts
call :_color2 %_Green% "[+] Checking Hosts Setting file exists..."
IF EXIST %Setting_file% (
	echo [+] %Setting_file% [OK]
	echo [+] Start auto repairing the hosts file
	xcopy "%Setting_file%" "C:\Windows\System32\drivers\etc" /d /c /y 
) ELSE (
	call :_color2 %_Red% "[-] Hosts Setting file is not exist [ERROR]"
	echo [+] Please check Hosts setting file Exists!
	set /p input=[+] Recheck Hosts file? [Y/N]N=Exit:
	IF "!input!"=="N" (
	goto :r_network
	) ELSE (
    goto :Hosts_a
	)
)
echo [+] Start DNS flush
ipconfig /flushdns >nul
echo [+] Windows IP Configuration
call :_color2 %_Green% "[+] Successfully flushed the DNS Resolver Cache."
echo [+] Hosts repaired successfully!
goto :casVend

:DNS_r
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
echo [+] Start DNS flush
ipconfig /flushdns >nul
echo [+] Windows IP Configuration
call :_color2 %_Green% "[+] Successfully flushed the DNS Resolver Cache."
echo [+] Start Netword reset...
netsh winsock reset >nul
echo [+] You must restart the computer in order to complete the reset.
call :_color2 %_Green% "[+] Sucessfully reset the Winsock Catalog."
goto :casVend

:update_vpn
setlocal enabledelayedexpansion
cls
echo:
echo:		Little Fish MDPI Tool Scripts v5.5
echo:		Copyright (C) Little Fish. All rights reserved.
echo:       ______________________________________________________________
echo:
set update_file=%~dp0resourse\OVPNCA-GG.exe %~dp0resourse\OVPNCA-WH01.exe %~dp0resourse\OVPNCA-WH02.exe
echo [+] Start update openvpn...
call :_color2 %_Green% "[+] Checking openvpn update file exists..."
for %%a in (%update_file%) do (
	IF EXIST %%a (
	echo [+] %%a [OK]
	) ELSE (
	echo [+] The specified openvpn update file does not Found!
	call :_color2 %_Red% "[-] %%a [ERROR]"
	echo [+] Please recheck openvpn update file...
	set /p input=[+] Recheck Hosts file? [Y/N]N=Exit:
	IF "!input!"=="N" (
	call :_color2 %_Yellow% "[+] Press any key to continue..."
	pause >nul
	goto :r_network
	) ELSE (
	call :_color2 %_Yellow% "[+] Press any key to continue..."
	pause >nul
	goto :update_vpn
	)
	)
)
echo [+] Shuting down OpenVPN services
taskkill /f /im openvpn-gui.exe >nul 2>nul
call :_color2 %_Green% "[+] OpenVPN services status: [CLOSE]"
set /p region=[+] Please select region to update[WH=1/GG=2]:
IF "%region%"=="2" (
	start "" "%~dp0OVPNCA-GG.exe"
) ELSE (
set /p floor=[+] Please select your floor to update[11F-15F=1/18F-26F=2]:
IF "!floor"=="2" (
	start "" "%~dp0OVPNCA-WH02.exe"
	echo [+] OVPNCA-WH02 update complete!
) ELSE (
	start "" "%~dp0OVPNCA-WH01.exe"
	echo [+] OVPNCA-WH01 update complete!
)
)
echo [+] OpenVPN install1 complete!
goto :casVend

::========================================================================================================================================

:casVend
echo.
call :_color %_Yellow% "[+] Press any key to go back..."
pause >nul
exit /b

:break
goto :eof

:getname
set "fn=%~nx1"

:_colorprep

if %_NCS% EQU 1 (
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

set     "Red="41;97m""
set    "Gray="100;97m""
set   "Black="30m""
set   "Green="42;97m""
set    "Blue="44;97m""
set  "Yellow="43;97m""
set "Magenta="45;97m""

set    "_Red="40;91m""
set  "_Green="40;92m""
set   "_Blue="40;94m""
set  "_White="40;37m""
set "_Yellow="40;93m""

exit /b
)

for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "_BS=%%A %%A"
set "_coltemp=%SystemRoot%\Temp"

set     "Red="CF""
set    "Gray="8F""
set   "Black="00""
set   "Green="2F""
set    "Blue="1F""
set  "Yellow="6F""
set "Magenta="5F""

set    "_Red="0C""
set  "_Green="0A""
set   "_Blue="09""
set  "_White="07""
set "_Yellow="0E""

exit /b

:_color

if %_NCS% EQU 1 (
if defined _unattended (echo %~2) else (echo %esc%[%~1%~2%esc%[0m)
) else (
if defined _unattended (echo %~2) else (call :batcol %~1 "%~2")
)
exit /b

:_color2

if %_NCS% EQU 1 (
echo %esc%[%~1%~2%esc%[%~3%~4%esc%[0m
) else (
call :batcol %~1 "%~2" %~3 "%~4"
)
exit /b

::=======================================

:: Colored text with pure batch method
:: Thanks to @dbenham and @jeb
:: stackoverflow.com/a/10407642