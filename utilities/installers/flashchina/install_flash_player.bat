:: Chinese Flash Player installer
:: Original Author: darktohka
:: Modified by: xomdjl_#1337 (ytpmaker1000@gmail.com)
:: License: MIT

@echo off
title Installing Flash Player version 34.0.0.155...

:: Check for admin rights
if "%PROCESSOR_ARCHITECTURE%"=="amd64" (
	>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
	>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"  
)

:: Ask for admin through temporary VBS file if not detected
if not "%ERRORLEVEL%"=="0" (
	echo Requesting administrative privileges...
	goto uacPrompt
) else (
	goto main
)

:uacPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > %tmp%\requestAdmin.vbs
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> %tmp%\requestAdmin.vbs
start "" %tmp%\requestAdmin.vbs
exit /B

:main
del %tmp%\requestAdmin.vbs>nul
echo Installing 32-bit Adobe Flash Player plugins...
robocopy %~dp0\flash32 %SYSTEMROOT%\SysWOW64\Macromed\Flash /e /xx /njh /njs /ndl /nc /ns
echo Installing 64-bit Adobe Flash Player plugins...
robocopy %~dp0\flash64 %SYSTEMROOT%\System32\Macromed\Flash /e /xx /njh /njs /ndl /nc /ns
title Adobe Flash Player installed!
echo Adobe Flash Player installed!
echo:
echo Press any key to launch FlashPatch.exe.
echo ^(Required to patch any adware hiding in the Chinese Flash Player.^)
pause
start "" "%~dp0\FlashPatch.exe"
exit
