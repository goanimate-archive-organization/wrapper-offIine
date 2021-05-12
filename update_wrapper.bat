@echo off
:: Wrapper Offline Updater
:: Author: xomdjl_#1337 (ytpmaker1000@gmail.com)

echo Welcome to the Wrapper: Offline updater.
popd
echo:
echo This will update your copy of Wrapper: Offline to
echo the latest build using Git.
echo:
echo To continue, press 1.
echo Otherwise, press any key.
echo:
set /p GITPULL= Option:
if "%GITPULL%"=="1" (
		cls
		echo Checking for Git installation...
		echo:
		if not exist "%PROGRAMFILES%\Git" (
			if not exist "%PROGRAMFILES(X86)%\Git" (
				echo Could not detect Git in Program Files folders.
				echo:
				echo Checking via command-line testing...
				for /f "delims=" %%i in ('git^>nul') do set output=%%i
				echo:
				IF "%output%" EQU "" (
					echo Okay, there's no sign of Git ANYWHERE on this computer.
					PING -n 4 127.0.0.1>nul
					echo That means YOU MUST HAVE INSTALLED THIS INCORRECTLY!
					PING -n 4 127.0.0.1>nul
					set GITPULL=""
				) else (
					echo The command-line worked, therefore Git is installed.
					echo:
				)
			)
		) else (
			echo Git was detected in one of the Program Files folders, therefore it is installed.
			echo:
		)
		echo Saving custom settings in temporary file...
		pushd utilities
		copy config.bat tmpcfg.bat>nul
		popd
		echo:
		echo Pulling latest version of repository from GitHub through Git...
		PING -n 4 127.0.0.1>nul
		echo:
		call git pull
		echo:
		echo Deleting config.bat from repository and replacing it with user's copy...
		pushd utilities
		del config.bat
		ren tmpcfg.bat config.bat
		popd
		echo:
		echo Latest version of repository pulled^!
		echo:
		pause
	)
)
if "%GITPULL%"=="" (
	echo NO UPDATE FOR YOU^!
	PING -n 5 127.0.0.1>nul
	echo COME BACK, ONE YEAR^!
	PING -n 4 127.0.0.1>nul
	echo:
	pause
)
