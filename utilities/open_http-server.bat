:: opens http-server in a standalone batch so that i can use a tool that silently runs batch files
:: this is stupid
:: please help
@echo off
if exist %tmp%\importserver.bat ( del %tmp%\importserver.bat )
set SUBSCRIPT=y
call config.bat
set SUBSCRIPT=n
pushd "%~dp0"
title HTTP-SERVER HASN'T STARTED
goto importserver
:main
pushd ..\server
echo This is where all the required Flash files and stuff are hosted.
echo:
call http-server -p 4664 -c-1 -S -C the.crt -K the.key --trace-deprecation
echo:
:: I had it do it another time just in case ~xom
if exist %tmp%\importserver.bat ( del %tmp%\importserver.bat )
echo If you see an error saying "http-server is not recognized",
echo please type "npm install http-server -g" in this window,
echo press enter, and restart Wrapper: Offline.
pause & exit /B

:importserver
echo @echo off>> %tmp%\importserver.bat
echo pushd "%CD%">> %tmp%\importserver.bat
echo title Server for imported voice clips TTS voice>> %tmp%\importserver.bat
echo if not exist import_these ^( md import_these ^)>> %tmp%\importserver.bat
echo pushd import_these>> %tmp%\importserver.bat
echo if not exist voice ^( md voice ^)>> %tmp%\importserver.bat
echo pushd voice>> %tmp%\importserver.bat
echo echo This is where the imported voice clip service is hosted.>> %tmp%\importserver.bat
echo echo:>> %tmp%\importserver.bat
echo echo HOW TO USE: Simply type a single period in the text to speech box ^^(.^^) and hit Generate.>> %tmp%\importserver.bat
echo echo Your imported voice clip will then proceed to play. Whenever you import a new one, it will overwrite the old one.>> %tmp%\importserver.bat
echo echo:>> %tmp%\importserver.bat
echo call http-server -p 4334 -c-1 --trace-deprecation>> %tmp%\importserver.bat
echo echo:>> %tmp%\importserver.bat
echo pause ^& exit /B>> %tmp%\importserver.bat
if %VERBOSEWRAPPER%==y (
	start "%tmp%\importserver.bat" /MIN
) else (
	start SilentCMD %tmp%\importserver.bat
)
goto main