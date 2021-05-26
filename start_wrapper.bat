:: Wrapper: Offline Launcher
:: Author: benson#0411
:: License: MIT
set SUBSCRIPT=y
if not exist utilities\metadata.bat ( goto metamissing )
call utilities\metadata.bat
cls
title Wrapper: Offline v!WRAPPER_VER! ^(build !WRAPPER_BLD!^) [Initializing...]

::::::::::::::::::::
:: Initialization ::
::::::::::::::::::::

:: Stop commands from spamming stuff, cleans up the screen
@echo off && cls

:: Lets variables work or something idk im not a nerd
SETLOCAL ENABLEDELAYEDEXPANSION

:: Make sure we're starting in the correct folder, and that it worked (otherwise things would go horribly wrong)
pushd "%~dp0"
if !errorlevel! NEQ 0 goto error_location
if not exist utilities ( goto error_location )
if not exist wrapper ( goto error_location )
if not exist server ( goto error_location )
goto noerror_location
:error_location
echo Doesn't seem like this script is in a Wrapper: Offline folder.
pause & exit
:metamissing
title Wrapper: Offline [Metadata Missing]
echo The metadata's missing for some reason?
echo Restoring...
goto metacopy
:returnfrommetacopy
if not exist utilities\metadata.bat ( echo Something is horribly wrong. You may be in a read-only system/admin folder. & pause & exit )
call utilities\metadata.bat
:devmodeerror
echo Ooh, sorry. You have to have developer mode on
echo in order to access these features.
echo:
echo Please turn developer mode on in the settings, then try again.
goto wrapperidle
:noerror_location

:: patch detection
if exist "patch.jpg" goto patched

:: Prevents CTRL+C cancelling (please close with 0) and keeps window open when crashing
if "%~1" equ