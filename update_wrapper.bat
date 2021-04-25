@echo off
:: Wrapper Offline Updater
:: Author: xomdjl_#1337 (ytpmaker1000@gmail.com)

echo Welcome to the Wrapper: Offline updater.
echo:
echo This will update your copy of Wrapper: Offline to
echo the latest build using Git.
echo:
echo To continue, press 1.
echo Otherwise, press any key.
echo:
set /p GITPULL= Option:
if "%GITPULL%"=="1" (
	if not exist ".git" (
		echo No .git folder, eh?
		PING -n 4 127.0.0.1>nul
		echo You were supposed to download it using THE BULLSHIT INSTALLER^!
		PING -n 4 127.0.0.1>nul
		set GITPULL=
	) else (
		cls
		echo Pulling latest version of repository from GitHub through Git...
		PING -n 4 127.0.0.1>nul
		call git pull
		echo:
		echo Latest version of repository pulled^!
		echo:
		pause
	)
)
if "%GITPULL%"=="" (
	echo NO FUCKING UPDATE FOR FUCKING YOU^!!!
	PING -n 5 127.0.0.1>nul
	echo COME BACK 99 HETAMIGAROSAWATILLAMAKATILLION FUCKING SHITTY NIGGA ETERNITIES^!!!
	PING -n 4 127.0.0.1>nul
	echo: ALL WE HAD TO DO WAS FOLLOW THE INSTALLER CJ!
	PING -n 4 127.0.0.1>nul
	echo:	
	pause & exit
)
