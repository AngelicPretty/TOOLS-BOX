@echo off
echo ���������ڽ��У����Եȡ���
echo.
del /f /q %windir%\temp\*.* >nul
echo �ɹ����ϵͳ��ʱ�ļ����е������ļ���
echo.
del /f /q "%userprofile%\cookies\*.*" >nul
echo �ɹ������ǰ�û����е�cookies��¼��
echo.
del /f /q "%userprofile%\recent\*.*" >nul
echo �ɹ������ǰ�û����ʹ�õ��ļ���¼��
echo.
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*" >nul
echo �ɹ������ǰ�û�Internet��ʱ�ļ����е������ļ���
echo.
del /f /s /q "%userprofile%\Local Settings\Temp\*.*" nul
echo �ɹ������ǰ�û���ʱ�ļ����е������ļ���
echo.
echo �����ļ��Ѿ�������ϣ�
pause