:: Wrapper Offline Updater
:: Author: xomdjl_#1337 (ytpmaker1000@gmail.com)
@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
set SUBSCRIPT=y
call utilities\config.bat
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
		cls
		echo Checking for Git installation...
		echo:
		if not exist "%PROGRAMFILES%\Git" (
			if not exist "%PROGRAMFILES(X86)%\Git" (
				echo Could not detect Git in Program Files folders.
				echo Checking via command-line testing...
				for /f "delims=" %%i in ('git --version 2^>nul') do set output=%%i
				echo:
				PING -n 4 127.0.0.1>nul
				IF "%output%" EQU "" (
					if "%DEVMODE%"=="y" (
						echo Git couldn't be found anywhere, but you do have developer mode on.
						echo:
						echo If either this is an actual dev using this from another machine who
						echo hasn't installed the actual Git yet, or this is someone who cloned
						echo the repository using something like GitHub Desktop, would you like
						echo to go ahead and install it?
						echo:
						echo Press 1 if you'd like to install actual Git
						echo Otherwise, press 2.
						echo:
						:gitresretry
						set /p GITRES= Response:
						if "%GITRES%"=="1" (
							cls
							echo Launching the Git installer...
							start utilities\git.exe
							PING -n 4 127.0.0.1>nul
							echo Git installer launched^^!
							echo:
							echo Once installation is finished, press any key to go to the
							echo next step of updating.
							echo:
							:gitrecheck
							pause
							for /f "delims=" %%i in ('git --version 2^>nul') do set output1=%%i
							IF "%output1%" EQU "" (
								echo Git not found. Please keep the installation going.
								echo When finished, press any key to continue.
								echo:
								goto gitrecheck
							) else (
								TASKKILL /F /IM git.exe>nul
								echo Git has been installed^! Proceeding to update...
								PING -n 4 127.0.0.1>nul
								cls
								set GIT=y
								goto update
							)
						)
						if "%GITRES%"=="2" ( goto nosignofgit )
						if "%GITRES%"=="" ( echo You must choose a valid response. && goto gitresretry )
					) else goto nosignofgit
				) else (
					set GIT=y
					echo The command-line worked, therefore Git is installed.
					echo:
					goto update
				)
			)
		) else (
			set GIT=y
			echo Git was detected in one of the Program Files folders, therefore it is installed.
			echo:
			goto update
		)
	)
	:update
	if "%GIT%"=="y" (
		echo Saving custom settings in temporary file...
		pushd utilities
		copy config.bat tmpcfg.bat>nul
		popd
		echo Saving imported assets to temporary files...
		call utilities\7za.exe a "utilities\misc\temp\importarchive.zip" .\server\store\3a981f5cb2739137\import\*>nul
		echo Pulling latest version of repository from GitHub through Git...
		PING -n 4 127.0.0.1>nul
		call git pull
		echo Deleting config.bat from repository and replacing it with user's copy...
		pushd utilities
		del config.bat
		ren tmpcfg.bat config.bat
		popd
		echo Deleting all the imported assets from the repository and replacing it with user's assets...
		pushd server\store\3a981f5cb2739137
		rd /q /s import
		md import
		popd
		call utilities\7za.exe e "utilities\misc\temp\importarchive.zip" -o"server\store\3a981f5cb2739137\import" -y>nul
		del utilities\misc\temp\importarchive.zip>nul
		del "wrapper\_THEMES\import.xml">nul
		copy "server\store\3a981f5cb2739137\import\theme.xml" "wrapper\_THEMES\import.xml">nul
		echo Latest version of repository pulled^^!
		echo:
		pause
		goto end
	)
) else (
	set GIT=n
	goto noupdate
)

:nosignofgit
echo Okay, there's no sign of FUNKING GIT ANYWHERE on this computer^^!
PING -n 4 127.0.0.1>nul
echo That means YOU MUST HAVE FUCKING INSTALLED THIS FUCKING INVALIDILY^^!
PING -n 4 127.0.0.1>nul
set GIT=n
goto noupdate

:noupdate
if "%GIT%"=="n" (
	echo NO FUCKING UPDATE FOR FUCKING YOU^^!^^!^^!^^!^^!
	PING -n 5 127.0.0.1>nul
	echo COME SHITY BACK, FOR FUCKING OVERFLOW^^!^^!^^!^^!^^!
	PING -n 4 127.0.0.1>nul
	echo GET LOST^^! SHIHEADS^^! YOU IDIOT FUCKING SHITTY HERE NOW 🖕^^!^^!^^!^^!^^!
	PING -n 4 127.0.0.1>nul
	echo:
	pause
)

:end
echo:
