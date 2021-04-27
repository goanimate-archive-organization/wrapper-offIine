:: W:O Video Exporting Script
:: Author: xomdjl_#1337 (ytpmaker1000@gmail.com)
:: License: MIT

@echo off
title Wrapper: Offline Exporting Script

:: To be quite honest I had to visit some old StackOverflow threads for help on this. ~xom

:restart
:: Sets all variables to default, also makes it so that it can properly load config.bat
set OUTRO=1
set TEMPPATH=%CD%\misc\temp\rewriteable.mp4
set TEMPPATH2=%CD%\misc\temp\rewriteable.ts
set TEMPPATH3=%CD%\misc\temp\rewriteable2.ts
set TEMPFILEPATH=%CD%\misc\temp
set FFMPEGINPUT=%CD%\misc\temp\rewriteable.avi
set OUTRO169=%CD%\misc\Outro16by9.ts
set OUTRO149=%CD%\misc\Outro14by9.ts
set VOLUME=1.5
set OUTPUT_PATH=%CD%\renders
set OUTPUT_FILENAME=Wrapper_Video_%date:~-4,4%-%date:~-7,2%-%date:~-10,2%T%time:~-11,2%-%time:~-8,2%-%time:~-5,2%Z
set OUTPUT_FILE=%OUTPUT_FILENAME%.mp4
SETLOCAL ENABLEDELAYEDEXPANSION
set SUBSCRIPT=y
call config.bat
if not exist "ffmpeg\ffmpeg.exe" ( goto error )
if not exist "avidemux\avidemux.exe" ( goto error )
if "%RESTARTVALUE%"=="1" (
	goto selectMovieId
) else (
	goto noerror
)

:error
echo ERROR: Could not find FFMPEG and/or Avidemux.
echo:
echo Chances are you probably have this script in the wrong
echo directory.
echo:
echo Make sure it's in the utilities folder of your copy of
echo Wrapper: Offline, and then try again.
echo:
pause
exit

:error2
set CONTFAILRENDER=0
echo There's a problem there, actually.
echo:
echo One or more of the rewriteables don't exist, and
echo it's required in order for continuing a failed render to work.
echo:
echo We'll just continue normally.
echo:
pause
echo:
goto findMovieId

:noerror
echo Before proceeding, we'll need to check to see if Wrapper: Offline is running.
PING -n 4 127.0.0.1>nul
echo:
tasklist /FI "IMAGENAME eq node.exe" 2>NUL | find /I /N "node.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo Processes for "node.exe" ^(Node.js^) have been detected, meaning Wrapper: Offline is running.
	PING -n 6 127.0.0.1>nul
	cls
) else (
	echo We could not detect any processes for "node.exe" ^(Node.js^), which means that Wrapper: Offline is NOT running.
	echo:
	echo To fix this, we'll be running "start_wrapper.bat".
	pause
	echo:
	echo Starting Wrapper: Offline...
	start ..\start_wrapper.bat
	PING -n 4 127.0.0.1>nul
	echo Wrapper: Offline successfully launched^!
	PING -n 6 127.0.0.1>nul
	cls
)
:selectMovieId
echo First, let's look for your movie ID.
echo:
echo Press 1 to find it in the _SAVED folder
echo Press 2 to find it in the video list on your default browser
echo Press 3 to find it in the video list on the included Chromium
echo Press 4 to find it in the video list on the included Basilisk
echo Press 5 if you already have your movie ID ready
echo:
set /p FINDMOVIEIDCHOICE= Choice:
goto findMovieId


:findMovieId
if %FINDMOVIEIDCHOICE%==1 (
	echo:
	echo Opening the _SAVED folder...
	start explorer.exe "..\wrapper\_SAVED\"
	echo:
	echo Please enter your movie ID when found.
	echo It should be in this format: m-%RANDOM%
	echo:
	echo IMPORTANT: DO NOT INCLUDE ".xml" OR THE ZEROS
	echo IN THE INPUT. MAKE SURE TO SHORTEN "movie" TO "m" TOO.
	echo:
	set /p MOVIEID= Movie ID: 
) else if %FINDMOVIEIDCHOICE%==2 (
	echo:
	echo Opening the video list in your default browser...
	start http://localhost:%PORT%
	echo:
	echo Please enter your movie ID when found.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
) else if %FINDMOVIEIDCHOICE%==3 (
	echo:
	echo Opening the video list in the included Chromium...
	start ungoogled-chromium\chrome.exe --allow-outdated-plugins --app="http://localhost:%PORT%"
	echo:
	echo Please enter your movie ID when found.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
) else if %FINDMOVIEIDCHOICE%==4 (
	echo:
	echo Opening the video list in the included Basilisk...
	start basilisk\Basilisk-Portable\Basilisk-Portable.exe http://localhost:%PORT%
	echo:
	echo Please enter your movie ID when found.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
) else if %FINDMOVIEIDCHOICE%==5 (
	echo:
	echo Please enter your movie ID.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
)
echo:
echo Are you continuing a failed render?
echo:
echo Press 1 if you are.
echo Otherwise, press 0.
echo:
set /p CONTFAILRENDER= Response:
echo:
cls

if %CONTFAILRENDER%==1 (
	if not exist "%FFMPEGINPUT%" (
		if not exist "%TEMPPATH%" (
			goto error2
		)
	) else (
	goto render_step_ask
	)
) else (
	goto screen_recorder_setup
)

:screen_recorder_setup
if not exist "%PROGRAMFILES%\Screen Capturer Recorder" (
	if not exist "%PROGRAMFILES(X86)%\Screen Capturer Recorder" (
		if not exist "%tmp%\srdriversinst.txt" (
			echo This step will only be required once.
			echo:
			echo It will have you install some needed drivers in order to get
			echo screen recording to work with FFMPEG, which is required for the
			echo exporting process.
			echo:
			pause
			echo Starting the installation for the required FFMPEG drivers...
			start installers\Setup.Screen.Capturer.Recorder.v0.12.11.exe
			echo:
			echo Once you're finished installing...
			pause
			taskkill /f /im "Setup.Screen.Capturer.Recorder.v0.12.11.exe" >nul 2>&1
			echo Drivers are already installed>%tmp%\srdriversinst.txt
			goto render_step1
		)
	)
) else (
	echo Screen recorder drivers for FFMPEG are already installed.
)

goto render_step1
:render_step_ask
echo:
echo Before we ask which step you left off at,
echo is your video widescreen or standard?
echo:
echo Press 1 if it's meant to be widescreen.
echo Press 2 if it's meant to be standard.
echo:
:iswidereask
set /p ISWIDEPROMPT= Is Wide?:
if %ISWIDEPROMPT%==1 (
	set WIDTH=1920
) else if %ISWIDEPROMPT%==2 (
	set WIDTH=1680
) else (
	echo You must choose a valid option.
	echo:
	goto iswidereask
)
echo:

echo Which step did you leave off at?
echo:
echo Press 1 if you left off at Step 2 (Avidemux)
echo Press 2 if you left off at Step 3 (Encoding)
echo:
:whichstepreask
set /p WHICHSTEP= Option: 
echo:
if %WHICHSTEP%==1 (
	taskkill /im avidemux.exe >nul 2>&1
	goto render_step2
) else if %WHICHSTEP%==2 (
	goto render_step3
) else (
	echo You must choose a valid option.
	echo:
	goto whichstepreask
)

:render_step1
echo Before we start the first step, please specify if your
echo video is meant to be widescreen (16:9), or standard (14:9).
echo:
echo Press 1 if your video is meant to be widescreen.
echo Otherwise, press 0 if your video is meant to be standard.
echo:
set /p ISWIDE= Is Wide?:
echo:
echo Which browser do you want to use for the process?
echo:
echo Press 1 for Basilisk
echo Press 2 for Chromium
echo Press 3 for your custom set browser
echo Press 4 for your default browser
echo:
set /p BROWSERCHOICE= Browser:
echo:
if %BROWSERCHOICE%==1 (
	echo Opening your movie in Basilisk...
	PING -n 3 127.0.0.1>nul
	start basilisk\Basilisk-Portable\Basilisk-Portable.exe "http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else if %BROWSERCHOICE%==2 (
	echo Opening your movie in Chromium...
	PING -n 3 127.0.0.1>nul
	start ungoogled-chromium\chrome.exe --allow-outdated-plugins --app="http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else if %BROWSERCHOICE%==3 (
	echo Opening your movie in your custom set browser...
	PING -n 3 127.0.0.1>nul
	start %CUSTOMBROWSER% "http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else if %BROWSERCHOICE%==4 (
	echo Opening your movie in your default browser...
	PING -n 3 127.0.0.1>nul
	start "" "http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else (
	echo You're supposed to pick which browser to use. Try again.
	echo:
	set /p BROWSERCHOICE= Browser:
)

echo:
taskkill /im avidemux.exe >nul 2>&1
cls
echo As you can see, the movie won't play right away. That's normal.
echo:
echo Press Enter in this box and hit play on the video player whenever
echo you're ready. It will open the FFMPEG screen recording CLI.
echo:
echo When you're done recording, press any key in this window to stop
echo recording your video. Alternatively, press Q in the FFMPEG
echo window to also stop recording.
echo:
pause
if not exist "misc\temp" ( mkdir misc\temp )
start ffmpeg\ffmpeg.exe -rtbufsize 150M -f dshow -framerate 25 -i video="screen-capture-recorder":audio="virtual-audio-capturer" -c:v libx264 -r 25 -preset fast -tune zerolatency -crf 17 -pix_fmt yuv420p -movflags +faststart -c:a aac -ac 2 -b:a 512k -y "%TEMPPATH%"
echo:
echo When you're finished recording,
pause
taskkill /im ffmpeg.exe >nul 2>&1
goto render_step2

:render_step2
cls
echo Opening MP4 in Avidemux...
start avidemux\avidemux.exe "misc\temp\rewriteable.mp4"
echo:
echo Make sure to set "Video Output" to "Mpeg4 ASP (xvid4)".
echo:
echo Make sure to also set "Output format" to "AVI Muxer".
echo:
echo Use the A and B buttons to highlight what you want gone.
echo Use the arrow buttons to navigate through the frames.
echo:
echo To crop, press Ctrl+Alt+F to open the Filters menu
echo and then use the red corner-tags and side-lines to
echo crop it to the proper video size. The "Auto Crop"
echo button may also be able to help.
echo:
echo For convenience, we'd recommend saving it to
echo the utilities\misc\temp folder with the name
echo "rewriteable.avi".
echo:
set /p GOTO_STEP3= Press Enter to go to the next step.
goto render_step3

:render_step3
cls
echo Press enter if the filename is 
echo "rewriteable.avi" and it's saved to
echo the utilities\misc\temp folder.
echo:
echo Otherwise, drag your AVI in here
echo and then press Enter.
echo:
set /p FFMPEGINPUT= AVI:
echo:
echo Is the video widescreen ^(16:9^) or standard ^(14:9^)?
echo:
echo Press 1 if it's widescreen. ^(1920x1080^)
echo Press 2 if it's standard. ^(1680x1080^)
echo:
set /p ISVIDEOWIDE= Which One?:
if %ISVIDEOWIDE%==1 (
	set WIDTH=1920
) else if %ISVIDEOWIDE%==2 (
	set WIDTH=1680
)
echo:
echo How much would you like to increase
echo or decrease the volume?
echo:
echo Please enter a range between 0.5 and 2.
echo:
echo By default, the volume will be increased
echo by 1.5.
echo:
set /p VOLUME= Volume:
echo:
echo Would you like the outro?
echo:
echo By default, the outro is on.
echo:
echo Press Enter if you want it.
echo Otherwise, press 0.
echo:
set /p OUTRO= Response:
echo:
echo Where would you like to output to?
echo Press Enter to output to the utilities\renders folder.
echo:
echo Example of a path: C:\Users\Someone\Videos
echo:
set /p OUTPUT_PATH= Path:
echo:
echo What would you like your video file to be named?
echo Press enter to make the filename %OUTPUT_FILE%.
echo ^(.mp4 will be added automatically.^)
echo:
set /p OUTPUT_FILENAME= Filename:
set OUTPUT_FILE=%OUTPUT_FILENAME%.mp4
echo:
if not exist "renders" ( mkdir "renders" )
goto render

:render_yesoutro
echo Because you chose to have an outro, this will
echo require 4 different FFMPEG processes.
echo:
echo For the first one, it'll be encoding the
echo input to a proper format.
echo:
pause
echo:
echo Starting ffmpeg...
echo:
call ffmpeg\ffmpeg.exe -i "%FFMPEGINPUT%" -vf scale=%WIDTH%:1080 -r 25 -filter:a loudnorm,volume=%VOLUME% -vcodec h264 -acodec aac -y "%TEMPPATH%"
echo:
echo Now, it's time for the next FFMPEG process,
echo which will encode it to TS, which is
echo required so concat will work properly.
echo:
pause
echo:
echo Starting ffmpeg...
echo:
call ffmpeg\ffmpeg.exe -i "%TEMPPATH%" -c copy -y "%TEMPPATH2%"
echo:
echo Now, it's time for the next FFMPEG process,
echo which will merge the outro video file and
echo the video file together using the concat
echo command.
echo:
echo Believe it or not, this isn't the final step.
echo After this we'll convert the .TS to a .MP4.
echo:
pause
:: This shit right here was where I began to have a really weird problem with the program working. ~xom
echo:
echo Starting ffmpeg...
echo:
if %ISVIDEOWIDE%==0 (
	call ffmpeg\ffmpeg.exe -i "concat:%TEMPPATH2%|%OUTRO149%" -c copy -y "%TEMPPATH3%"
) else (
	call ffmpeg\ffmpeg.exe -i "concat:%TEMPPATH2%|%OUTRO169%" -c copy -y "%TEMPPATH3%"
)
echo:
echo Now, it's time for the final step.
echo:
echo This will convert the resulting .TS file
echo into an H.264/AAC .MP4 file, which will make
echo it compatible with most common video editors,
echo especially VEGAS Pro.
echo:
pause
echo:
echo Starting ffmpeg...
echo:
call ffmpeg\ffmpeg.exe -i "%TEMPPATH3%" -vcodec h264 -acodec aac "%OUTPUT_PATH%\%OUTPUT_FILE%"
goto render_completed

:render_nooutro
call ffmpeg\ffmpeg.exe -i "%FFMPEGINPUT%" -vf scale=%WIDTH%:1080 -r 25 -filter:a loudnorm,volume=%VOLUME% -vcodec h264 -acodec aac "%OUTPUT_PATH%\%OUTPUT_FILE%"
goto render_completed

:render
if %OUTRO%==1 (
	goto render_yesoutro
) else (
	goto render_nooutro
)

:render_completed
echo:
echo The entire rendering process has been complete!
echo:
echo Press 1 to open the rendered file
echo Press 2 to go to the render output folder
echo Press 3 to exit out of this window right away
echo Press 4 to export another video
echo:
set /p WHATTODONEXT= Option:
if %WHATTODONEXT%==1 (
	start "%OUTPUT_PATH%\%OUTPUT_FILE%"
	goto last_step
) else if %WHATTODONEXT%==2 (
	start explorer.exe /select,"%OUTPUT_PATH%\%OUTPUT_FILE%"
	goto last_step
) else if %WHATTODONEXT%==3 (
	exit
) else if %WHATTODONEXT%==4 (
	set RESTARTVALUE=1
cls
goto restart
)


:last_step
echo:
echo Press 1 to export another video. Otherwise, press Enter to exit.
set /p LAST= Choice:

if %LAST%==1 (
	cls
	set RESTARTVALUE=1
	goto restart
) else exit