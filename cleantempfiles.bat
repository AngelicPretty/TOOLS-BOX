@echo off
echo 清理工作正在进行，请稍等……
echo.
del /f /q %windir%\temp\*.* >nul
echo 成功清除系统临时文件夹中的垃圾文件！
echo.
del /f /q "%userprofile%\cookies\*.*" >nul
echo 成功清除当前用户所有的cookies记录！
echo.
del /f /q "%userprofile%\recent\*.*" >nul
echo 成功清除当前用户最近使用的文件记录！
echo.
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*" >nul
echo 成功清除当前用户Internet临时文件夹中的垃圾文件！
echo.
del /f /s /q "%userprofile%\Local Settings\Temp\*.*" nul
echo 成功清除当前用户临时文件夹中的垃圾文件！
echo.
echo 垃圾文件已经清理完毕！
pause