@echo off
echo.
echo ����ɾ��ϵͳ�е�ǰʹ�õ�SAM�ļ������ע����ļ�����
echo.
del c:\windows\system32\config\sam /f /q >nul
del c:\windows\system32\config\system /f /q >nul
del c:\windows\system32\config\software /f /q >nul
del c:\windows\system32\config\security /f /q >nul
del c:\windows\system32\config\default /f /q >nul
echo ���ڸ���ϵͳ���ݵ�SAM�ļ������ע����ļ�����
echo.
copy c:\windows\repair\sam c:\windows\system32\config\ >nul
copy c:\windows\repair\system c:\windows\system32\config\ >nul
copy c:\windows\repair\software c:\windows\system32\config\ >nul
copy c:\windows\repair\security c:\windows\system32\config\ >nul
copy c:\windows\repair\default c:\windows\system32\config\ >nul
echo �ɹ����Windows�����˻���������Ϣ������������������ֱ�ӽ���Windowsϵͳ��
