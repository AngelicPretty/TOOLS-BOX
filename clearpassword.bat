@echo off
echo.
echo 正在删除系统中当前使用的SAM文件及相关注册表文件……
echo.
del c:\windows\system32\config\sam /f /q >nul
del c:\windows\system32\config\system /f /q >nul
del c:\windows\system32\config\software /f /q >nul
del c:\windows\system32\config\security /f /q >nul
del c:\windows\system32\config\default /f /q >nul
echo 正在复制系统备份的SAM文件及相关注册表文件……
echo.
copy c:\windows\repair\sam c:\windows\system32\config\ >nul
copy c:\windows\repair\system c:\windows\system32\config\ >nul
copy c:\windows\repair\software c:\windows\system32\config\ >nul
copy c:\windows\repair\security c:\windows\system32\config\ >nul
copy c:\windows\repair\default c:\windows\system32\config\ >nul
echo 成功清除Windows所有账户及密码信息，现在重启机器即可直接进入Windows系统！
