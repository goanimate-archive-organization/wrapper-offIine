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
if %autonode%==y (
cls
goto start
) else (
echo Uh-oh!
echo You Have Been Crashed!!!
echo How to fix wrapper offline
echo 1. go to wrapper
echo 2. select _CACHE and _SAVED folder and move to desktop.
echo 3. Reinstall or Repair Wrapper Offline
echo 4. go to settings.bat and switch on verbose mode
echo And done! you will no longer crash forever! U CAN USE IT!
echo issues? Contact on discord.
echo zoccorus#9939
echo NOTE: Either Node.js has crashed or you don't have it installed.
echo If Node.js crashed, please send the error in the GitHub issues page.
echo If you don't have Node.js, install it in the utilities/installers or [Node.js LTS](https://nodejs.org/en/download/) or [Node.js Current](https://nodejs.org/en/download/current/).
echo:
echo If you saw an error that says "MODULE_NOT_FOUND",
echo go in the utilities folder and run module_installer.bat.
pause
cls
goto start
)
