:: Automatically upgrades an existing W:O install to a new version
:: Author: xomdjl_#1337 (ytpmaker1000@gmail.com)
:: Original idea from 2Epik4u#1904
:: License: MIT

:: Initialize (stop command spam, clean screen, make variables work, set to UTF-8)
@echo off && cls
SETLOCAL ENABLEDELAYEDEXPANSION
chcp 65001 >nul

:: Move to base folder, and make sure it worked (otherwise things would go horribly wrong)
pushd "%~dp0"
if !errorlevel! NEQ 0 goto error_location
if not exist utilities ( goto error_location )
if not exist wrapper ( goto error_location )
if not exist server ( goto error_location )
goto noerror_location
:error_location
echo Doesn't seem like this script is in a Wrapper: Offline folder.
goto end
:noerror_location

:: Prevents CTRL+C cancelling and keeps window open when crashing
if "%~1" equ "point_insertion" goto point_insertion
start "" /wait /B "%~F0" point_insertion
exit
:point_insertion

:: patch detection
if exist "patch.jpg" echo no amount of upgrades can fix a patch && goto end

:: Get config.bat
set SUBSCRIPT=y
if not exist utilities\config.bat ( goto error_location )
call utilities\config.bat


echo Would you like to upgrade?
echo:
echo Press Y to install the update, press N to cancel.
echo:
:installaskretry
set /p INSTALLCHOICE= Response:
echo:
if not '!installchoice!'=='' set installchoice=%installchoice:~0,1%
if /i "!installchoice!"=="0" goto end
if /i "!installchoice!"=="y" goto checkforgit
if /i "!installchoice!"=="n" goto end
echo You must answer Yes or No. && goto installaskretry

:checkforgit
if !VERBOSEWRAPPER!==n ( cls )
echo Checking if you downloaded Wrapper: Offline correctly...
if exist .git (
	if !VERBOSEWRAPPER!==n ( cls )
	echo Git folder has been found!
	echo Beginning update...
	echo:
	goto startupdate
) else (
	goto nogit
)

:nogit
if !VERBOSEWRAPPER!==n ( cls )
echo Okay, there's no sign of Wrapper: Offline being
echo cloned through the installer.
PING -n 4 127.0.0.1>nul
echo That means YOU MUST HAVE INSTALLED THIS INCORRECTLY^^!
PING -n 4 127.0.0.1>nul
goto endseinfeld

:startupdate
if !VERBOSEWRAPPER!==n ( cls )
echo Please do not close this window^^!^^!
echo Doing so may ruin your copy of Wrapper: Offline.
echo It's almost certainly NOT frozen, just takes a while.
echo:
:: Save user data
if !VERBOSEWRAPPER!==y ( echo Saving custom settings in temporary file... )
pushd utilities
copy config.bat tmpcfg.bat>nul
popd
if !VERBOSEWRAPPER!==y ( echo Saving imported assets to temporary files... )
call utilities\7za.exe a "utilities\misc\temp\importarchive.zip" .\server\store\3a981f5cb2739137\import\*>nul
if !VERBOSEWRAPPER!==y ( echo Pulling latest version of repository from GitHub through Git... )
PING -n 4 127.0.0.1>nul
:: Perform the update
call git pull
:: Bring back user data
if !VERBOSEWRAPPER!==y ( echo Deleting config.bat from repository and replacing it with user's copy... )
pushd utilities
del config.bat
ren tmpcfg.bat config.bat
popd
if !VERBOSEWRAPPER!==y ( echo Deleting all the imported assets from the repository and replacing it with user's assets... )
pushd server\store\3a981f5cb2739137
rd /q /s import
md import
popd
call utilities\7za.exe e "utilities\misc\temp\importarchive.zip" -o"server\store\3a981f5cb2739137\import" -y>nul
del utilities\misc\temp\importarchive.zip>nul
del "wrapper\_THEMES\import.xml">nul
copy "server\store\3a981f5cb2739137\import\theme.xml" "wrapper\_THEMES\import.xml">nul

:: congratulations new version
if !VERBOSEWRAPPER!==n ( cls )
color 20
echo:
echo:
echo Update installed^^!
echo:
goto end

:: seinfeld reference
:endseinfeld
echo NO UPDATE FOR YOU^^!
PING -n 5 127.0.0.1>nul
echo COME BACK, ONE YEAR^^!
PING -n 4 127.0.0.1>nul

:: normal end
:end
echo Closing...
pause & exit
