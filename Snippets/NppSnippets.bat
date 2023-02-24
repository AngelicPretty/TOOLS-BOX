@echo off
set NAMESEED=%date:~5,2%.%date:~8,2%
ren %APPDATA%\Notepad++\plugins\config\NppSnippets.sqlite NppSnippets-%NAMESEED%.sqlite
copy /y "%~dp0resources\NppSnippets.sqlite" "%APPDATA%\Notepad++\plugins\config"
if exist "C:\Program Files (x86)\Notepad++\notepad++.exe" (
	if not exist "C:\Program Files (x86)\Notepad++\plugins\NppSnippets" (
		md "C:\Program Files (x86)\Notepad++\plugins\NppSnippets"
	)
	copy /y "%~dp0resources\32\NppSnippets.dll"  "C:\Program Files (x86)\Notepad++\plugins"
	copy /y "%~dp0resources\32\NppSnippets.dll"  "C:\Program Files (x86)\Notepad++\plugins\NppSnippets"
) else (
	if not exist "C:\Program Files\Notepad++\plugins\NppSnippets" (
		md "C:\Program Files\Notepad++\plugins\NppSnippets"
	)
	copy /y "%~dp0resources\64\NppSnippets.dll"  "C:\Program Files\Notepad++\plugins"
	copy /y "%~dp0resources\64\NppSnippets.dll"  "C:\Program Files\Notepad++\plugins\NppSnippets"
)
cls
echo *****************************************************
echo Update Complete. Pleae reopen Notepad++ to enjoy it.
echo *****************************************************
pause
exit