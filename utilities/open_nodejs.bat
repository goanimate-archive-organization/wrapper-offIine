:: opens node.js in a standalone batch so that i can use a tool that silently runs batch files
:: this is stupid
:: please help
@echo off
pushd "%~dp0"
title NODE.JS HASN'T STARTED YET
pushd ..\wrapper
:start
call npm start
echo:
echo Uh oh!
echo Either Node.js has crashed or you dont have it installed.
echo If Node.js crashed, please send the error in the github issues page.
echo If you dont have Node.js, Install it in utilities folder.
echo:
echo If you saw an error that says "MODULE_NOT_FOUND",
echo go in utilities folder and run module_installer.bat
pause
goto start