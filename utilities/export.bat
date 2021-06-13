:: Wrapper: Offline Video Exporting Script
:: Original Author: xomdjl_#1337 (ytpmaker1000@gmail.com)
:: License: MIT

@echo off
title Wrapper: Offline Exporting Script

:: patch detection
if exist "..\patch.jpg" echo there's no videos to export if whoppers patched && pause & exit

:: To be quite honest I had to visit some old StackOverflow threads for help on this. ~xom

:restart
:: Sets all variables to default, also makes it so that it can properly load config.bat
set ERROR=n
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
set FILESUFFIX=mp4
set VCODEC=h264
set ACODEC=aac
set CRF=17
set RESOLUTIONOPTION=5
set FORMATTYPE=1
set ADDITIONAL="-crf %CRF%"
set OUTPUT_FILE=%OUTPUT_FILENAME%.%FILESUFFIX%
SETLOCAL ENABLEDELAYEDEXPANSION
set SUBSCRIPT=y
call config.bat
set FINDMOVIEIDCHOICE=""
set CONTFAILRENDER=""
set BROWSERCHOICE=""
set VF=""
set ISVIDEOWIDE=0
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
PING -n 3 127.0.0.1>nul
echo:
tasklist /FI "IMAGENAME eq node.exe" 2>NUL | find /I /N "node.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo Processes for "node.exe" ^(Node.js^) have been detected, meaning Wrapper: Offline is running.
	PING -n 4 127.0.0.1>nul
	cls
) else (
	echo We could not detect any processes for "node.exe" ^(Node.js^), which means that Wrapper: Offline is NOT running.
	echo:
	echo To fix this, we'll be running "start_wrapper.bat".
	pause
	echo:
	echo Starting Wrapper: Offline...
	set SUBSCRIPT=n
	pushd %~dp0..
	:: Pushd twice just to be safe
	pushd %~dp0..
	start "" "start_wrapper.bat"
	popd
	PING -n 3 127.0.0.1>nul
	echo Wrapper: Offline successfully launched^!
	PING -n 4 127.0.0.1>nul
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
:MovieChoice
set /p FINDMOVIEIDCHOICE= Choice:
goto findMovieId


:findMovieId
if "%FINDMOVIEIDCHOICE%"=="1" (
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
) else if "%FINDMOVIEIDCHOICE%"=="2" (
	echo:
	echo Opening the video list in your default browser...
	start http://localhost:%PORT%
	echo:
	echo Please enter your movie ID when found.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
) else if "%FINDMOVIEIDCHOICE%"=="3" (
	echo:
	echo Opening the video list in the included Chromium...
	start ungoogled-chromium\chromium.exe --allow-outdated-plugins --app="http://localhost:%PORT%"
	echo:
	echo Please enter your movie ID when found.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
) else if "%FINDMOVIEIDCHOICE%"=="4" (
	echo:
	echo Opening the video list in the included Basilisk...
	start basilisk\Basilisk-Portable\Basilisk-Portable.exe http://localhost:%PORT%
	echo:
	echo Please enter your movie ID when found.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
) else if "%FINDMOVIEIDCHOICE%"=="5" (
	echo:
	echo Please enter your movie ID.
	echo It should be in this format: m-%RANDOM%
	echo:
	set /p MOVIEID= Movie ID: 
) else (
	echo You must choose a valid option.
	echo:
	goto MovieChoice
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

if "%CONTFAILRENDER%"=="1" (
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
set ISWIDEPROMPT=0
set /p ISWIDEPROMPT= Is Wide?:
if "%ISWIDEPROMPT%"=="1" (
	set WIDTH=1920
	set HEIGHT=1080
) else if "%ISWIDEPROMPT%"=="2" (
	set WIDTH=1680
	set HEIGHT=1080
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
set WHICHSTEP=""
set /p WHICHSTEP= Option: 
echo:
if "%WHICHSTEP%"=="1" (
	taskkill /f /im avidemux.exe >nul 2>&1
	goto render_step2
) else if "%WHICHSTEP%"=="2" (
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
echo Press 3 for your custom set browser ^(Must be specified in settings.bat^)
echo Press 4 for your default browser
:BrowserSelect
set /p BROWSERCHOICE= Browser:
echo:
if "%BROWSERCHOICE%"=="1" (
	echo Opening your movie in Basilisk...
	PING -n 2.5 127.0.0.1>nul
	start basilisk\Basilisk-Portable\Basilisk-Portable.exe "http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else if "%BROWSERCHOICE%"=="2" (
	echo Opening your movie in Chromium...
	PING -n 2.5 127.0.0.1>nul
	start ungoogled-chromium\chromium.exe --allow-outdated-plugins --app="http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else if "%BROWSERCHOICE%"=="3" (
	echo Opening your movie in your custom set browser...
	PING -n 2.5 127.0.0.1>nul
	start %CUSTOMBROWSER% "http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else if "%BROWSERCHOICE%"=="4" (
	echo Opening your movie in your default browser...
	PING -n 2.5 127.0.0.1>nul
	start "" "http://localhost:%PORT%/recordWindow?movieId=%MOVIEID%&isWide=%ISWIDE%"
) else (
	echo You're supposed to pick which browser to use. Try again.
	echo:
	goto BrowserSelect
)

echo:
taskkill /f /im avidemux.exe >nul 2>&1
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
echo When finished with this step, press any key to continue
echo to the next step.
echo:
pause
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
cls
echo Is the video widescreen ^(16:9^) or standard ^(14:9^)?
echo:
echo Press 1 if it's widescreen.
echo Press 2 if it's standard.
echo:
:VideoWideSelect
set /p ISVIDEOWIDE= Which One?:
if "%ISVIDEOWIDE%"=="1" (
	set WIDTH=1920
	set HEIGHT=1080
) else if "%ISVIDEOWIDE%"=="2" (
	set WIDTH=1680
	set HEIGHT=1080
) else (
	echo You must choose either widescreen or standard.
	echo:
	goto VideoWideSelect
)

echo:
cls
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
cls
echo Would you like the outro?
echo:
echo By default, the outro is on.
echo:
echo Press Enter if you want it.
echo Otherwise, press 0.
echo:
set /p OUTRO= Response:
echo:
cls

if "%OUTRO%"=="0" (
goto resolution
) else (
goto outrocheck


:outrocheck
if exist "misc\OriginalOutro16by9.ts" (
	goto resetoutrocheck
) else goto customoutro (
)

:resetoutrocheck
if %DEVMODE%==n (
goto customoutro
) else (
goto resetcustomoutro
)
	:resetcustomoutro
	echo ^(Developer mode-exclusive option^)
		set RESETOUTRO=0
		echo It looks like you still have a custom outro
		echo being used.
		echo:
		echo Would you like to reset the outro back to the
		echo default one?
		echo:
		echo Press 1 if you'd like to reset it.
		echo Otherwise, press Enter.
		echo:
		set /p RESETOUTRO= Response: 
		echo:
		if %RESETOUTRO%==1 (
			pushd misc
			if not exist "outros" ( mkdir outros )
			ren Outro16by9.ts PreviouslyUsedOutro.ts 
			set "last=0"
			set "filename=outros\PreviouslyUsedOutro.ts" 
			if exist "outros\PreviouslyUsedOutro.ts" (
				for /R %%i in ("outros\PreviouslyUsedOutro(*).ts") do (
					for /F "tokens=2 delims=(^)" %%a in ("%%i") do if %%a GTR !last! set "last=%%a"
				)
				set/a last+=1
				set "filename=outros\PreviouslyUsedOutro(!last!).ts"   
			)
			move "PreviouslyUsedOutro.ts" "%filename%" 
			ren OriginalOutro16by9.ts Outro16by9.ts 
			echo The outro has been resetted back to default.
			echo:
			pause
		)
		cls
	
	:customoutro
	if exist "misc\outros" (
		echo Would you like to use a new custom outro
	) else (
		echo Would you like to use a custom outro
	)
	echo or the default outro?
	echo:
	set CUSTOMOUTROCHOICE=0
	echo Press 1 if you'd like to use a custom outro.
	echo Otherwise, press Enter.
	echo:
	echo ^(Please note this will only affect the TS copy of the
	echo 16:9 outro. For the 14:9 outro and the MP4 copies, you 
	echo will have to take care of that manually.^)
	echo:
	set /p CUSTOMOUTROCHOICE= Response: 
	echo:
	cls
	if "%CUSTOMOUTROCHOICE%"=="1" (
		echo Drag the path to your custom outro in here.
		echo:
		set /p CUSTOMOUTRO= Path: 
		echo:
		cls
		pushd misc
		ren Outro16by9.ts OriginalOutro16by9.ts
		echo Encoding outro to compatible H.264/AAC .TS file with FFMPEG...
		PING -n 1.5 127.0.0.1>nul
		if "%VERBOSEWRAPPER%"=="y" (
			start ffmpeg\ffmpeg.exe -i "file:%CUSTOMOUTRO%" -vcodec h264 -acodec aac -crf 17 -y "%OUTRO169%">nul
		) else (
			start ffmpeg\ffmpeg.exe -i "file:%CUSTOMOUTRO%" -vcodec h264 -acodec aac -crf 17 -y "%OUTRO169%"
		)
		echo Custom outro successfully encoded and added^!
		echo:
		pause
		cls
		) else (
		goto videofilter
		)
		
	:videofilter
	if %DEVMODE%==n (
	goto resolution
	) else (
	goto vf
	)
	:vf
	echo ^(Developer mode-exclusive option^)
	set VFRESPONSE=0
	echo Would you like to use any additional
	echo FFMPEG video filters?
	echo:
	echo Press 1 if you would like to.
	echo Otherwise, press Enter.
	echo:
	set /p VFRESPONSE= Response: 
	echo:
	if "%VFRESPONSE%"=="1" (
		goto avfilters
		) else goto resolution (
		)
		
		:avfilters
		echo Press 1 to retrieve a list of available A/V filters.
		echo Otherwise, press Enter if you already have one pulled up.
		echo:
		set /p AVFILTERLIST= Response:
		echo:
		cls
		if "%AVFILTERLIST%"=="1" (
		goto filterlist
		) else goto filterargs (
		)
		
		:filterlist
		echo Opening FFMPEG filter list in your default browser...
		PING -n 2.5 127.0.0.1>nul
		start https://ffmpeg.org/ffmpeg-filters.html
		echo Opened.
		PING -n 2 127.0.0.1>nul
		echo:
		cls
		)
		:filterargs
		echo Please place your filter args in here.
		echo:
		set /p FILTERARGS= Filter args: 
		set VF=, %FILTERARGS%
		echo:
		cls
	)
	
:resolution
cls
echo What resolution would you like your video to be in?
echo:
if "%ISVIDEOWIDE%"=="1" (
	echo ^(1^) 240p ^(426x240^)
	echo ^(2^) 360p ^(640x360^)
	echo ^(3^) 480p ^(854x480^)
	echo ^(4^) 720p ^(1280x720^)
	echo ^(5^) 1080p ^(1920x1080^) ^(Default^)
) else (
	echo ^(1^) 240p ^(373x240^)
	echo ^(2^) 360p ^(560x360^)
	echo ^(3^) 480p ^(747x480^)
	echo ^(4^) 720p ^(1120x720^)
	echo ^(5^) 1080p ^(1680x1080^) ^(Default^)
)
echo:
:resolutionretry
set /p RESOLUTIONOPTION= Option: 
if "%ISVIDEOWIDE%"=="1" (
	if "%RESOLUTIONOPTION%"=="1" ( set WIDTH=426 & set HEIGHT=240 & goto format )
	if "%RESOLUTIONOPTION%"=="2" ( set WIDTH=640 & set HEIGHT=360 & goto format )
	if "%RESOLUTIONOPTION%"=="3" ( set WIDTH=854 & set HEIGHT=480 & goto format )
	if "%RESOLUTIONOPTION%"=="4" ( set WIDTH=1280 & set HEIGHT=720 & goto format )
	if "%RESOLUTIONOPTION%"=="5" ( set WIDTH=1920 & set HEIGHT=1080 & goto format )
) else (
	if "%RESOLUTIONOPTION%"=="1" ( set WIDTH=373 & set HEIGHT=240 & goto format )
	if "%RESOLUTIONOPTION%"=="2" ( set WIDTH=560 & set HEIGHT=360 & goto format )
	if "%RESOLUTIONOPTION%"=="3" ( set WIDTH=747 & set HEIGHT=480 & goto format )
	if "%RESOLUTIONOPTION%"=="4" ( set WIDTH=1120 & set HEIGHT=720 & goto format )
	if "%RESOLUTIONOPTION%"=="5" ( set WIDTH=1680 & set HEIGHT=1080 & goto format )
)
echo Invalid option. Please try again. && goto resolutionretry

:format
cls
echo Which format would you like your video to be in?
echo:
echo ^(1^) MPEG-4 Video File ^(H.264/AAC^) ^(Default^)
echo ^(2^) Audio/Video Interleave ^(x264/LAME^)
echo ^(3^) WebM Video File ^(VPX9/Vorbis^)
echo ^(4^) Windows Media Video ^(WMV2/WMAV2^)
echo:
:formatretry
set /p FORMATTYPE= Option: 
if "%FORMATTYPE%"=="1" (
	set FILESUFFIX=mp4
	set VCODEC=h264
	set ACODEC=aac
	set CRF=17
	set ADDITIONAL=-crf "%CRF%"
	goto outputcheck
)
if "%FORMATTYPE%"=="2" (
	set FILESUFFIX=avi
	set VCODEC=libx264
	set ACODEC=libmp3lame
	goto outputcheck
)
if "%FORMATTYPE%"=="3" (
	set FILESUFFIX=webm
	set VCODEC=libvpx
	set ACODEC=libvorbis
	goto outputcheck
)
if "%FORMATTYPE%"=="4" (
	set FILESUFFIX=wmv
	set VCODEC=wmv2
	set ACODEC=wmav2
	goto outputcheck
)
echo Invalid option. Please try again. && goto formatretry

:outputcheck
if "%DEVMODE%"=="y" (
	if "%VCODEC%"=="h264" ( goto crfvalue )
) else goto output

:crfvalue
if "%FILESUFFIX%"=="mp4" (
set CRF=17
echo ^(Developer mode-exclusive option^)
echo:
echo What quality ^(CRF^) do you want your video to be in?
echo ^(0 is lossless, 17 is the default, 51 is lowest quality^)
echo:
echo ^(NOTE: ONLY enter a number between 0 and 51, otherwise it
echo could screw up the entire exporting process for this session.
echo If you wanna keep it at the default value of 17, you can just
echo press Enter.^)
echo:
set /p CRF= CRF: 
goto output
) else goto output

:output
set ADDITIONAL=-crf "%CRF%"
cls
echo Where would you like to output to?
echo Press Enter to output to the utilities\renders folder.
echo:
echo Example of a path: C:\Users\Someone\Videos
echo:
set /p OUTPUT_PATH= Path:
echo:
echo What would you like your video file to be named?
echo Press enter to make the filename %OUTPUT_FILE%.
echo ^(.%FILESUFFIX% will be added automatically.^)
echo:
set /p OUTPUT_FILENAME= Filename:
set OUTPUT_FILE=%OUTPUT_FILENAME%.%FILESUFFIX%
echo:
taskkill /f /im avidemux.exe >nul 2>&1
if not exist "renders" ( mkdir "renders" )
goto render

:render_yesoutro
cls
echo Starting ffmpeg...
PING -n 3 127.0.0.1>nul
echo Going through process 1 of 4...
if "%VERBOSEWRAPPER%"=="y" (
	call ffmpeg\ffmpeg.exe -i "file:%FFMPEGINPUT%" -vf scale="%WIDTH%:%HEIGHT%" %VF%-r 25 -filter:a loudnorm,volume=%VOLUME% -vcodec h264 -acodec aac -crf 17 -y "%TEMPPATH%" && echo Process completed. || echo Process failed. && set ERROR=y
) else (
	call ffmpeg\ffmpeg.exe -i "file:%FFMPEGINPUT%" -vf scale="%WIDTH%:%HEIGHT%" %VF%-r 25 -filter:a loudnorm,volume=%VOLUME% -vcodec h264 -acodec aac -crf 17 -y "%TEMPPATH%">nul && echo Process completed. || echo Process failed. && set ERROR=y
)

if "%ERROR%"=="n" (
	PING -n 2 127.0.0.1>nul
	echo Going through process 2 of 4...
	if "%VERBOSEWRAPPER%"=="y" (
		call ffmpeg\ffmpeg.exe -i "file:%TEMPPATH%" -c copy -y "%TEMPPATH2%" && echo Process completed. || echo Process failed. && set ERROR=y
	) else (
		call ffmpeg\ffmpeg.exe -i "file:%TEMPPATH%" -c copy -y "%TEMPPATH2%">nul && echo Process completed. || echo Process failed. && set ERROR=y
	)
)

if "%ERROR%"=="n" (
	PING -n 2 127.0.0.1>nul
	echo Going through process 3 of 4...
	if exist "tmpconcat.txt" ( del tmpconcat.txt )
	echo file '%TEMPPATH2%'>>tmpconcat.txt
	if %ISVIDEOWIDE%==0 (
		echo file '%OUTRO149%'>>tmpconcat.txt
	) else (
		echo file '%OUTRO169%'>>tmpconcat.txt
	)
	if "%VERBOSEWRAPPER%"=="y" (
		call ffmpeg\ffmpeg.exe -f concat -safe 0 -i "file:%CD%\tmpconcat.txt" -codec copy -y "%TEMPPATH3%" && echo Process completed. || echo Process failed. && set ERROR=y
	) else (
		call ffmpeg\ffmpeg.exe -f concat -safe 0 -i "file:%CD%\tmpconcat.txt" -codec copy -y "%TEMPPATH3%">nul && echo Process completed. || echo Process failed. && set ERROR=y
	)
)

if "%ERROR%"=="n" (
	PING -n 2 127.0.0.1>nul
	del tmpconcat.txt>nul
	echo Going through process 4 of 4...
	if "%VERBOSEWRAPPER%"=="y" (
		call ffmpeg\ffmpeg.exe -i "file:%TEMPPATH3%" -vcodec %VCODEC% -acodec %ACODEC% %ADDITIONAL% "%OUTPUT_PATH%\%OUTPUT_FILE%" && echo Process completed. || echo Process failed. && set ERROR=y
	) else (
		call ffmpeg\ffmpeg.exe -i "file:%TEMPPATH3%" -vcodec %VCODEC% -acodec %ACODEC% %ADDITIONAL% "%OUTPUT_PATH%\%OUTPUT_FILE%">nul && echo Process completed. || echo Process failed. && set ERROR=y
	)
)
goto render_completed

:render_nooutro
echo Starting ffmpeg...
echo Going through process 1 of 1...
if "%VERBOSEWRAPPER%"=="y" (
	call ffmpeg\ffmpeg.exe -i "file:%FFMPEGINPUT%" -vf scale="%WIDTH%:%HEIGHT%" %VF%-r 25 -filter:a loudnorm,volume=%VOLUME% -vcodec %VCODEC% -acodec %ACODEC% %ADDITIONAL% -y "%OUTPUT_PATH%\%OUTPUT_FILE%" && echo Process completed. || echo Process failed. && set ERROR=y
) else (
	call ffmpeg\ffmpeg.exe -i "file:%FFMPEGINPUT%" -vf scale="%WIDTH%:%HEIGHT%" %VF%-r 25 -filter:a loudnorm,volume=%VOLUME% -vcodec %VCODEC% -acodec %ACODEC% %ADDITIONAL% -y "%OUTPUT_PATH%\%OUTPUT_FILE%">nul && echo Process completed. || echo Process failed. && set ERROR=y
)
goto render_completed

:render
if %OUTRO%==1 (
	goto render_yesoutro
) else (
	goto render_nooutro
)


if "%ERROR%"=="n" (
	echo Deleting any temporary files...
	set MISCTEMP=%CD%\misc\temp\*
	for %%i in (%TEMPPATH%,%TEMPPATH2%,%TEMPPATH3%,%MISCTEMP%) do (
		if exist "%%i" ( del "%%i" )
	)
	echo:
)
:render_completed
if "%VERBOSEWRAPPER%"=="n" ( cls )
if "%ERROR%"=="n" (
	set WHATTODONEXT=""
	echo The entire rendering process has been complete^^!
	echo:
	echo Press 1 to open the rendered file
	echo Press 2 to go to the render output folder
	echo Press 3 to exit out of this window
	echo Press 4 to export another video
	echo:
	:final_choice
	set /p WHATTODONEXT= Option:
	if "!whattodonext!"=="1" (
		start "" "%OUTPUT_PATH%\%OUTPUT_FILE%"
		echo:
		goto final_choice
	)
	if "!whattodonext!"=="2" (
		start explorer.exe /select,"%OUTPUT_PATH%\%OUTPUT_FILE%"
		echo:
		goto final_choice
	)
	if "!whattodonext!"=="3" exit
	if "!whattodonext!"=="4" (
		set RESTARTVALUE=1
		cls
		goto restart
	)
	echo:
	goto final_choice
) else (
	set PROCESSFAILCH=""
	echo ERROR: One or more of the FFMPEG processes failed!
	echo:
	echo For this reason, Wrapper: Offline did NOT remove any
	echo of the temporary files this time.
	echo:
	echo Press 1 to try again
	echo Press 2 to restart the UI
	echo Press 3 to restart the actual window
	echo Press 4 to exit out of this window
	echo:
	:processfailchoice
	set ERROR=n
	set /p PROCESSFAILCH= Option: 
	if "!processfailch!"=="1" (
	set ERROR=n
	goto render
	)
	if "!processfailch!"=="2" (
		set RESTARTVALUE=1
		cls
		goto restart
	)
	if "!processfailch!"=="3" ( start "" %0 & exit )
	if "!processfailch!"=="4" exit
	echo Time to choose.
	echo:
	goto processfailchoice
)