title Wrapper: Offline Settings Script
:: Interactive config.bat changer
:: Author: benson#0411
:: License: MIT

:: DON'T EDIT THIS FILE! If you need a text version of the settings like it used to be, edit utilities\config.bat. This file is now just an interface for changing that file.

:: Initialize (stop command spam, clean screen, make variables work, set to UTF-8)
@echo off && cls
SETLOCAL ENABLEDELAYEDEXPANSION

:: Move to base folder, and make sure it worked (otherwise things would go horribly wrong)
pushd "%~dp0"
if !errorlevel! NEQ 0 goto error_location
if not exist utilities\config.bat ( goto error_location )
if not exist start_wrapper.bat ( goto error_location )
goto noerror_location
:error_location
echo Doesn't seem like this script is in the Wrapper: Offline folder.
goto end
:devmodeerror
echo Ooh, sorry. You have to have developer mode on
echo in order to access these features.
echo:
echo Please turn developer mode on, then try again.
goto reaskoptionscreen
:noerror_location

:: Prevents CTRL+C cancelling and keeps window open when crashing
if "!SUBSCRIPT!"=="" (
	if "%~1" equ "point_insertion" goto point_insertion
	start "" /wait /B "%~F0" point_insertion
	exit
)
:point_insertion

:: patch detection
if exist "patch.jpg" echo MESSAGE GOES HERE && goto end

:: Preload variable
set CFG=utilities\config.bat
set TMPCFG=utilities\tempconfig.bat
set ENV=wrapper\env.json
set BACKTODEFAULTTOGGLE=n
set BASILISKENABLE=n
set BASILISKDISABLE=n
set CHROMIUMENABLE=n
set CHROMIUMDISABLE=n
set BACKTOCUSTOMTOGGLE=n
set BACKTOCUSTOMTOGGLE2=n

:: Load current settings
if "%SUBSCRIPT%"=="" ( 
	set SUBSCRIPT=y
	call !cfg!
	set "SUBSCRIPT="
) else (
	call !cfg!
)

::::::::::
:: Menu ::
::::::::::
:: this code is a form of hell have fun going through it cause i dont :)
:optionscreen
cls
echo:
echo Enter 0 to leave settings
echo Enter the number next to the option to change it.
echo Enter a ? before the number for more info on the option.
echo:

if !DEVMODE!==y (
	echo STANDARD OPTIONS:
	echo:
)

:: Verbose
if !VERBOSEWRAPPER!==y (
	echo ^(1^) Verbose mode is[92m ON [0m
) else ( 
	echo ^(1^) Verbose mode is[91m OFF [0m
)
:: Browser options
if !INCLUDEDCHROMIUM!==y (
	echo ^(2^) Browser set to[92m included Chromium [0m
	if !APPCHROMIUM!==y (
		echo     ^(3^) Headless mode is[92m ON [0m
	) else ( 
		echo     ^(3^) Headless mode is[91m OFF [0m
	)
	goto postbrowsershow
)
if !INCLUDEDBASILISK!==y (
	echo ^(2^) Browser set to[92m included Basilisk [0m
)
if not !CUSTOMBROWSER!==n (
	echo ^(2^) Browser set to[91m custom browser [0m
	echo     ^(3^) Browser path: !CUSTOMBROWSER!
)
if !INCLUDEDCHROMIUM!==n (
	if !INCLUDEDBASILISK!==n (
		if !CUSTOMBROWSER!==n (
			echo ^(2^) Browser set to[91m default system browser [0m
		)
	)
)
:postbrowsershow
:: Skip checking dependenceis
if !SKIPCHECKDEPENDS!==n (
	echo ^(4^) Checking dependencies is[92m ON [0m
) else ( 
	echo ^(4^) Checking dependencies is[91m OFF [0m
)
:: Waveforms
if exist "wrapper\static\info-nowave.json" (
	echo ^(5^) Waveforms are[92m ON [0m
) else ( 
	echo ^(5^) Waveforms are[91m OFF [0m
)
:: Debug mode
if exist "wrapper\static\page-nodebug.js" (
	echo ^(6^) Debug mode is[92m ON [0m
) else ( 
	echo ^(6^) Debug mode is[91m OFF [0m
)
:: Dark mode
if exist "wrapper\pages\css\global-light.css" if not exist "wrapper\pages\html\_OLDLISTVIEW.txt" (
	echo ^(7^) Dark mode is[92m ON [0m
)
if exist "wrapper\pages\css\global-dark.css" if not exist "wrapper\pages\html\_OLDLISTVIEW.txt" ( 
	echo ^(7^) Dark mode is[91m OFF [0m
)
if exist "wrapper\pages\html\_OLDLISTVIEW.txt" (
	echo Dark mode cannot be enabled on the classic Video List.
)
:: Rich presence
if exist "wrapper\main-norpc.js" (
	echo ^(8^) Discord rich presence is[92m ON [0m
) else ( 
	echo ^(8^) Discord rich presence is[91m OFF [0m
)
:: Video Lists
if exist "wrapper\pages\html\_LISTVIEW.txt" (
	echo ^(9^) View on the video list is set to[91m List [0m
)
if exist "wrapper\pages\html\_GRIDVIEW.txt" (
	echo ^(9^) View on the video list is set to[91m Grid [0m
)
if exist "wrapper\pages\html\_OLDLISTVIEW.txt" (
	echo ^(9^) View on the video list is set to[91m Classic List [0m
)
:: Watermark
if exist "wrapper\static\info-nowatermark.json" (
	echo ^(10^) Wrapper: Offline watermark is[92m ON [0m
) else ( 
	echo ^(10^) Wrapper: Offline watermark is[91m OFF [0m
)
:: Truncated themelist
if exist "wrapper\_THEMES\_themelist-allthemes.xml" (
	echo ^(11^) Truncated themelist is[92m ON [0m
) else ( 
	echo ^(11^) Truncated themelist is[91m OFF [0m
)
:: Cepstral
if exist "wrapper\tts\info-cepstral.json" (
	echo ^(12^) Provider for Cepstral/VoiceForge voices is[92m VFProxy [0m
	if exist "wrapper\tts\main-seamus.js" (
		echo     ^(13^) VFProxy server is[92m PHP Webserver ^(localhost:8181^) [0m
	) else (
		if !CEPSTRAL!==y (
			echo     ^(13^) VFProxy server is[91m seamus-server.tk [0m
		)
	)
) else (
	if !CEPSTRAL!==y (
		echo ^(12^) Provider for Cepstral/VoiceForge voices is[91m Cepstral website [0m
	)
)
:: Developer mode
if !DEVMODE!==y (
	echo ^(14^) Developer mode is[92m ON [0m
) else ( 
	echo ^(14^) Developer mode is[91m OFF [0m
)
:: Character solid archive
if exist "server\characters\characters.zip" (
    echo ^(15^) Original LVM character IDs are[91m OFF [0m
)

if !DEVMODE!==y (
	echo:
	echo DEVELOPER OPTIONS:
	echo:
)

:: Dev options
:: These are really specific options that no casual user would ever really need
if !DEVMODE!==y (
	if !SKIPDEPENDINSTALL!==n (
		echo ^(D1^) Installing dependencies is[92m ON [0m
	) else ( 
		echo ^(D1^) Installing dependencies is[91m OFF [0m
	)
	if !DRYRUN!==y (
		echo ^(D2^) Dry run mode is[92m ON [0m
	) else ( 
		echo ^(D2^) Dry run mode is[91m OFF [0m
	)
	if !BROWSER_TYPE!==chrome (
		echo ^(D3^) Browser type set to[92m Chrome [0m
	)
	if !BROWSER_TYPE!==firefox (
		echo ^(D3^) Browser type set to[91m Firefox [0m
	)
	if !BROWSER_TYPE!==n (
		echo ^(D3^) Browser type[91m not set [0m
	)
	if !PORT!==4343 (
		echo ^(D4^) Localhost port for Wrapper: Offline frontend is[92m 4343 [0m
	) else ( 
		echo ^(D4^) Localhost port for Wrapper: Offline frontend is[91m !PORT! [0m
	)
)
:reaskoptionscreen
echo:
set /p CHOICE=Choice:
if "!choice!"=="0" goto end
:: Verbose
if "!choice!"=="1" (
	set TOTOGGLE=VERBOSEWRAPPER
	if !VERBOSEWRAPPER!==n (
		set TOGGLETO=y
	) else (
		set TOGGLETO=n
	)
	set CFGLINE=11
	goto toggleoption
)
if "!choice!"=="?1" (
	echo When enabled, two extra windows with more info about what Offline is doing.
	echo The launcher will also say more about what it's doing, and never clear itself.
	echo Mostly meant for troubleshooting and development. Default setting is off.
	goto reaskoptionscreen
)
:: Browser settings
if "!choice!"=="2" goto browsertype
if "!choice!"=="?2" (
	echo When set to included Chromium ^(or Basilisk^), it opens a browser that comes with Offline.
	echo This older browser will keep running Flash after new browsers block it completely.
	echo If you don't want to use it, you can use your default browser, or a specific executable.
	echo Default setting is included Chromium. Most should probably keep that default.
	goto reaskoptionscreen
)
if "!choice!"=="3" (
	if !INCLUDEDCHROMIUM!==y (
		set TOTOGGLE=APPCHROMIUM
		if !APPCHROMIUM!==n (
			set TOGGLETO=y
		) else (
			set TOGGLETO=n
		)
		set CFGLINE=23
		goto toggleoption
	)
	if !CUSTOMBROWSER!==y (
		goto setcustombrowser
	)
)
if "!choice!"=="?3" (
	if !INCLUDEDCHROMIUM!==y (
		echo This setting runs Chromium in headless mode, hiding everything except the title bar and webpage.
		echo This gives more room to work with, and generally just looks nicer. Default is on.
		goto reaskoptionscreen
	)
	if !CUSTOMBROWSER!==y (
		echo This setting defines which browser Offline launches with when set to use a custom browser.
		echo This needs to be a path to a browser executable. (exe file, such as chrome.exe)
		goto reaskoptionscreen
	)
)
:: Check depends
if "!choice!"=="4" (
	set TOTOGGLE=SKIPCHECKDEPENDS
	if !SKIPCHECKDEPENDS!==n (
		set TOGGLETO=y
	) else (
		set TOGGLETO=n
	)
	set CFGLINE=14
	goto toggleoption
)
if "!choice!"=="?4" (
	echo Turning this off skips checking for Flash, Node.js, http-server, and if the HTTPS cert is installed.
	echo This is automatically disabled when Offline launches and finds all dependencies.
	echo If you're on a new computer, or having issues with security messages, you may wanna turn this back on.
	goto reaskoptionscreen
)
:: Waveforms
if "!choice!"=="5" goto waveformchange
if "!choice!"=="?5" (
	echo By default, waveforms for audio are generated in the video editor.
	echo:
	echo While useful, the editor freezes while it generates, which could be too annoying or slow for some.
	echo:
	echo Turning this off will simply add a repeating pre-made pattern in place of true waveforms.
	goto reaskoptionscreen
)
:: Debug Mode
if "!choice!"=="6" goto debugmodechange
if "!choice!"=="?6" (
	echo By default, debug mode is enabled in the video editor.
	echo:
	echo While useful with showing asset IDs and paths, it freezes when you use character search in ANY theme, 
        echo which can be very annoying to some.
        echo:
	echo Turning this off will stop the asset IDs and paths from showing, and in addition,
        echo will also make character search work again.
	goto reaskoptionscreen
)
:: Dark Mode
if "!choice!"=="7" goto darkmodechange
if "!choice!"=="?7" (
	echo By default, dark mode is enabled on the video and theme lists.
        echo:
	echo Dark mode is used to help reduce eyestrain when viewing those lists, and
        echo also improves the user experience quite a bit.
        echo:
	echo Turning this off will revert Offline back to the original light theme.
	goto reaskoptionscreen
)
:: Rich presence
if "!choice!"=="8" goto rpcchange
if "!choice!"=="?8" (
	echo By default, Discord rich presence is enabled.
        echo:
	echo It's used to show when you're using Wrapper: Offline
        echo in your "Playing A Game" status on Discord, much like
        echo how lots of modern computer games will show on your
        echo Discord status when you're playing them.
        echo:
	echo Turning this off will make Offline stop saying
        echo when you're using it on Discord.
	goto reaskoptionscreen
)
:: List/grid/oldlist view
if "!choice!"=="9" (
	if exist "wrapper\pages\html\_LISTVIEW.txt" goto gridview
	if exist "wrapper\pages\html\_GRIDVIEW.txt" goto oldlistview
	if exist "wrapper\pages\html\_OLDLISTVIEW.txt" goto listview
)
if "!choice!"=="?9" (
	echo By default, grid view is disabled.
        echo:
	echo Most people are used to the table view, but some
	echo people wanted a grid view, so we added it incase
	echo people wanted it.
        echo:
	echo Turning this on will make Offline show the
        echo video list in a grid view rather than a
		echo table view.
	goto reaskoptionscreen
)
:: Watermark
if "!choice!"=="10" (
	if !DEVMODE!==y (
		echo ^(This message is only for those with Developer Mode on.^)
		echo:
		echo NOTE: If you'd like to use a custom watermark, you
		echo will need to replace the watermark file hidden somewhere
		echo in go_full.swf with a different one using JPEXS FFDEC.
		echo The watermark HAS to be a .swf or it won't work.
		echo:
		echo Unless you modify go_full.swf to change the watermark,
		echo by default it will use the Wrapper: Offline watermark.
		echo:
		echo If you prefer to not have a watermark at all and just
		echo add your watermark in post, that's fine too.
		echo:
		pause
	)
	goto watermarktoggle
)
if "!choice!"=="?10" (
    echo By default, Wrapper: Offline puts a watermark in the corner of the screen to show that it was
    echo made using the software. If you do not want the watermark in the way and you need to use this
    echo software for things like media production and all that, you are free to toggle the option to
    echo disable the watermark if you'd like.
    goto reaskoptionscreen
)
:: Truncated themelist
if "!choice!"=="11" goto allthemechange
if "!choice!"=="?11" (
	echo Cuts down the amount of themes that clog up the themelist in the videomaker.
	echo Keeping this off is highly suggested.
	echo However, if you want to see everything the program has to offer, turn this on.
	goto reaskoptionscreen
)
:: Cepstral
if "!choice!"=="12" goto cepstralchange
if "!choice!"=="?12" (
	echo By default, Wrapper: Offline uses the included VFProxy
	echo for the VoiceForge voices, as VoiceForge was turned
	echo into a mobile app, causing the original API to be
	echo deleted. Someone managed to hack the APK and find the
	echo link, but it outputs in WAV only, so we made a PHP
	echo wrapper for it ^(VFProxy^) which is intended to bypass
	echo ratelimits and automatically convert it to MP3 using LAME.
	echo:
	echo However, some people seem to be having issues with getting
	echo it working without any problem.
	echo:
	echo Toggling this setting will make it so Wrapper: Offline no
	echo longer launches VFProxy and instead gets the Cepstral voices
	echo from the actual Cepstral website's demo.
	goto reaskoptionscreen
)
if "!choice!"=="13" goto vfproxyserverchange
if "!choice!"=="?13" (
	echo This setting runs the localhost version of xomdjl_'s VFProxy.
	echo This makes it easier to use without having to use an external server.
	echo:
	echo However, some people seem to be having problems with this.
	echo:
	echo Toggling this setting will allow you to use either the localhost VFProxy
	echo or the seamus-server.tk host of VFProxy.
	echo:
	echo ^(It's important to note that the seamus-server.tk host of VFProxy is
	echo only up everyday until 11PM CST/12AM EST/04:00 UTC and goes back up
	echo the next day, so if you run into any problems with that host and it's
	echo after that time, that may be why.^)
	goto reaskoptionscreen
)
:: Check depends
if "!choice!"=="14" (
	set TOTOGGLE=DEVMODE
	if !DEVMODE!==n (
		set TOGGLETO=y
	) else (
		set TOGGLETO=n
	)
	set CFGLINE=42
	goto toggleoption
)
if "!choice!"=="?14" (
	echo Wrapper: Offline is free and open-source, and a lot of folks in the community like to make mods for it.
	echo:
	echo Turning on developer mode will provide you with some useful features for development or making your own
	echo mods for Wrapper: Offline, mostly the mods having to do with the batch script.
	echo:
	echo The developer settings will be visible both in these settings and in the Wrapper launcher.
	goto reaskoptionscreen
)
:: Character solid archive
if exist "server\characters\characters.zip" (
    if "!choice!"=="15" goto extractchars
    if "!choice!"=="?15" (
        echo When first getting Wrapper: Offline, all non-stock characters are put into a single zip file.
        echo This is because if they're all separate, extracting takes forever and is incredibly annoying.
        echo If you wish to import characters made on the LVM when it was still up and hosted by Vyond,
        echo you can extract them here. They will still be compressed, just in separate files to be usable.
        goto reaskoptionscreen
    )
)

if !DEVMODE!==n (
	if /i "!choice!"=="D1" ( goto devmodeerror )
	if /i "!choice!"=="?D1" ( goto devmodeerror )
	if /i "!choice!"=="D2" ( goto devmodeerror )
	if /i "!choice!"=="?D2" ( goto devmodeerror )
	if /i "!choice!"=="D3" ( goto devmodeerror )
	if /i "!choice!"=="?D3" ( goto devmodeerror )
	if /i "!choice!"=="D4" ( goto devmodeerror )
	if /i "!choice!"=="?D4" ( goto devmodeerror )
)

if !DEVMODE!==y (
	if /i "!choice!"=="D1" (
		set TOTOGGLE=SKIPDEPENDINSTALL
		if !SKIPDEPENDINSTALL!==n (
			set TOGGLETO=y
		) else (
			set TOGGLETO=n
		)
		set CFGLINE=17
		goto toggleoption
	)
	if /i "!choice!"=="?D1" (
		echo Disabling this will still check for dependencies, but won't install them.
		echo I'm not sure why I added this, but I don't have a reason to take it out.
		goto reaskoptionscreen
	)
	if /i "!choice!"=="D2" (
		set TOTOGGLE=DRYRUN
		if !DRYRUN!==n (
			set TOGGLETO=y
		) else (
			set TOGGLETO=n
		)
		set CFGLINE=32
		goto toggleoption
	)
	if /i "!choice!"=="?D2" (
		echo Turning this on will run through all of the launcher's code without affecting anything.
		echo Useful for debugging the launcher without uninstalling things and all that.
		goto reaskoptionscreen
	)
	if /i "!choice!"=="D3" goto manualbrowsertype
	if /i "!choice!"=="?D3" (
		echo Tells the launcher what kind of browser is in use. Should be autoset by CUSTOMBROWSER.
		echo Mostly used by the Flash installer to tell what version to install.
		goto reaskoptionscreen
	)
	if /i "!choice!"=="D4" goto changeportnumber
	if /i "!choice!"=="?D4" (
		echo By default, the port number of the frontend is 4343.
		echo:
		echo However, some people seem to be having issues with Wrapper: Offline and
		echo sometimes it has to do with what port the frontend is on.
		echo:
		echo Toggling this feature will allow you to change the port number that
		echo the frontend is on.
		goto reaskoptionscreen
	)
)
if "!choice!"=="clr" goto optionscreen
if "!choice!"=="cls" goto optionscreen
if "!choice!"=="clear" goto optionscreen
echo Time to choose. && goto reaskoptionscreen

:::::::::::::::::::
:: Toggle option ::
:::::::::::::::::::
:toggleoption
echo Toggling setting...
:: Find line after setting to edit
set /a AFTERLINE=!cfgline!+1
:: Loop through every line until one to edit
if exist !tmpcfg! del !tmpcfg!
set /a count=1
for /f "tokens=1,* delims=0123456789" %%a in ('find /n /v "" ^< !cfg!') do (
	set "line=%%b"
	>>!tmpcfg! echo(!line:~1!
	set /a count+=1
	if !count! GEQ !cfgline! goto linereached
)
:linereached
:: Overwrite the original setting
echo set !totoggle!=!toggleto!>> !tmpcfg!
echo:>> !tmpcfg!
:: Print the last of the config to our temp file
more +!afterline! !cfg!>> !tmpcfg!
:: Make our temp file the normal file
copy /y !tmpcfg! !cfg! >nul
del !tmpcfg!
:: Set in here for displaying
set !totoggle!=!toggleto!
if !BACKTODEFAULTTOGGLE!==y goto backtodefault
if !BASILISKENABLE!==y goto enablebasilisk
if !BASILISKDISABLE!==y goto disablebasilisk
if !BACKTOCUSTOMTOGGLE!==y goto backtocustom
if !BACKTOCUSTOMTOGGLE2!==y goto backtocustom2
goto optionscreen

::::::::::::::::::
:: Browser type ::
::::::::::::::::::
:browsertype
echo:
echo NOTE: If you are using your default browser or a custom
echo browser to run Wrapper: Offline, go to the utilities
echo folder and run FlashPatch.exe as admin. It will then patch
echo the timebomb bug where your Chromium or Firefox-based browser
echo will not load any Flash content and will instead show
echo the "f(i)" icon.
echo:
echo Press 1 to use Offline's included Chromium (recommended)
echo Press 2 to use Offline's included Basilisk
echo Press 3 to use your default browser set in Windows
echo Press 4 to use a specific browser of your choice
echo Press 0 to cancel changing
echo:
:browserreask
set /p BROWSERCHOICE= Response:
echo:
if /i "!browserchoice!"=="0" goto optionscreen
if /i "!browserchoice!"=="1" (
	set TOTOGGLE=INCLUDEDCHROMIUM
	set TOGGLETO=y
	set CFGLINE=20
	goto toggleoption
)
if /i "!browserchoice!"=="2" (
    set BASILISKENABLE=y
	set TOTOGGLE=INCLUDEDCHROMIUM
	set TOGGLETO=n
	set CFGLINE=20
	goto toggleoption
)
if /i "!browserchoice!"=="3" (
	set BACKTODEFAULTTOGGLE=y
	set BASILISKDISABLE=y
	set TOTOGGLE=INCLUDEDCHROMIUM
	set TOGGLETO=n
	set CFGLINE=20
	goto toggleoption
	:enablebasilisk
	set BASILISKENABLE=n
	set TOTOGGLE=INCLUDEDBASILISK
	set TOGGLETO=y
	set CFGLINE=39
	goto toggleoption
	:disablebasilisk
	set BASILISKDISABLE=n
	set TOTOGGLE=INCLUDEDBASILISK
	set TOGGLETO=n
	set CFGLINE=39
	goto toggleoption
	:enablechromium
	if !INCLUDEDBASILISK!==y ( set BASILISKDISABLE=y )
	set CHROMIUMENABLE=n
	set TOTOGGLE=INCLUDEDCHROMIUM
	set TOGGLETO=y
	set CFGLINE=20
	goto toggleoption
	:disablechromium
	set CHROMIUMDISABLE=n
	set TOTOGGLE=INCLUDEDCHROMIUM
	set TOGGLETO=n
	set CFGLINE=20
	goto toggleoption
	:backtodefault
	set BACKTODEFAULTTOGGLE=n
	set TOTOGGLE=CUSTOMBROWSER
	set TOGGLETO=n
	set CFGLINE=30
	goto toggleoption
)
if /i "!browserchoice!"=="4" goto setcustombrowser
echo You must answer what browser. && goto browserreask

:::::::::::::::::::::::::
:: Custom Browser Path ::
:::::::::::::::::::::::::
:setcustombrowser
echo:
echo Drag a browser executable (such as chrome.exe) into this window and press enter.
echo Enter 0 to cancel changing the custom browser.
:browserpathreask
echo:
set /p TOGGLETO= File:
if /i "!TOGGLETO!"=="0" goto optionscreen
if not exist "!toggleto!" echo That doesn't seem to exist. & goto browserpathreask

:: Set custom browser
set TOTOGGLE=CUSTOMBROWSER
set CFGLINE=30
set BACKTOCUSTOMTOGGLE=y
goto toggleoption

:: Attempt to set browser type
:backtocustom
set BACKTOCUSTOMTOGGLE=n
set BACKTOCUSTOMTOGGLE2=y
for %%a in (!TOGGLETO!) do (
	set CBNAME=%%~na
	set "TOGGLETO="
	:: Chrome-based
	if !cbname!==chrome set TOGGLETO=chrome
	if !cbname!==chrome64 set TOGGLETO=chrome
	if !cbname!==opera set TOGGLETO=chrome
	if !cbname!==brave set TOGGLETO=chrome
	if !cbname!==torch set TOGGLETO=chrome
	if !cbname!==microsoftedge set TOGGLETO=chrome
	:: Firefox-based
	if !cbname!==firefox set TOGGLETO=firefox
	if !cbname!==palemoon set TOGGLETO=firefox
	if !cbname!==tor set TOGGLETO=firefox
	if !cbname!==Basilisk-Portable set TOGGLETO=firefox
	if !cbname!==basilisk set TOGGLETO=firefox
	:: Trident-based
	if !cbname!==iexplore ( 
		if not exist "%tmp%\flashpatchocxWO.txt" ( goto runflashpatch )
		set TOGGLETO=trident
	)
	if !cbname!==maxthon ( 
		if not exist "%tmp%\flashpatchocxWO.txt" ( goto runflashpatch )
		set TOGGLETO=trident
	)
	:: Stupid
	if !cbname!==netscape echo go back to 1996 & set TOGGLETO=n
	:: Unknown
	if !toggleto!=="" set TOGGLETO=n
)
set TOTOGGLE=BROWSER_TYPE
set CFGLINE=33
goto toggleoption

:: Run FlashPatch if the browser chosen is Trident-based
:runflashpatch
echo Before we change your browser to this Trident-based browser,
echo since it pulls from whichever ActiveX version of Flash Player
echo is included with Internet Explorer, it's required that you run
echo FlashPatch to get rid of the timebomb on the ActiveX version of
echo Flash Player that IE depends on.
echo ^(This will only be required once.^)
echo:
net session >nul 2>&1
if %errorLevel% == 0 (
	echo It looks like you're running this as admin, so you're good to go.
	echo:
	pause
	echo:
	echo Opening FlashPatch...
	start utilities\FlashPatch.exe
	PING -n 4 127.0.0.1>nul
	echo Started FlashPatch^^!
	echo:
	pause
	echo FlashPatch was already run.>%tmp%\flashpatchocxWO.txt
) else (
	echo However, in order to go through this process, you MUST run
	echo this batch file with administrator privileges in order for it
	echo to work.
	echo:
	echo The Wrapper: Offline settings will now close so that you can
	echo reopen this as admin.
	echo:
	pause & exit
)

:: Turn off included Chromium
:backtocustom2
set BACKTOCUSTOMTOGGLE2=n
set TOTOGGLE=INCLUDEDCHROMIUM
set TOGGLETO=n
set CFGLINE=20
goto toggleoption

:: Manually set browser type (dev option)
:manualbrowsertype
echo:
echo:
echo Press 1 for Chrome
echo Press 2 for Firefox
echo Press 3 for Trident
echo Press 4 for Unknown
echo Press 0 to cancel changing
echo:
:browsertypereask
set /p TYPECHOICE= Response:
echo:
if /i "!typechoice!"=="0" goto end
if /i "!typechoice!"=="1" set TOGGLETO=chrome
if /i "!typechoice!"=="2" set TOGGLETO=firefox
if /i "!typechoice!"=="3" set TOGGLETO=trident
if /i "!typechoice!"=="4" set TOGGLETO=n
echo You must answer with a browser type. && goto browsertypereask
set TOTOGGLE=BROWSER_TYPE
set CFGLINE=33
goto toggleoption

:: Change port number for frontend of Wrapper: Offline (dev option)
:changeportnumber
echo Which port number would you like to change the frontend to?
echo:
echo Press 1 to change it to 80
echo Press 2 to change it to a custom port number
echo Press 3 if you're changing it back to 4343
echo:
:portnumberreask
set /p PORTCHOICE= Option: 
echo:
if /i "!portchoice!"=="0" goto end
if /i "!portchoice!"=="1" ( 
	set PORTNUMBER=80
	goto porttoggle
)
if /i "!portchoice!"=="2" (
	echo Which port would you like the frontend to be hosted on?
	echo:
	set /p PORTNUMBER= Port: 
	goto porttoggle
)
if /i "!portchoice!"=="3" (
	set PORTNUMBER=4343
	goto porttoggle
)
echo You must answer with a valid option. && goto portnumberreask

:porttoggle
echo Toggling setting...
if exist "!env!" del "!env!"
echo {>> !env!
echo 	"CHAR_BASE_URL": "https://localhost:4664/characters",>> !env!
echo 	"THUMB_BASE_URL": "https://localhost:4664/thumbnails",>> !env!
echo 	"XML_HEADER": "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n",>> !env!
echo 	"CROSSDOMAIN": "<cross-domain-policy><allow-access-from domain=\"*\"/></cross-domain-policy>",>> !env!
echo 	"FILE_WIDTH": 1000,>> !env!
echo 	"GATHER_THREADS": 100,>> !env!
echo 	"GATHER_THRESH1": 250000000,>> !env!
echo 	"GATHER_THRESH2": 328493000,>> !env!
echo 	"GATHER_THRESH3": 400000000,>> !env!
echo 	"FILE_NUM_WIDTH": 9,>> !env!
echo 	"XML_NUM_WIDTH": 3,>> !env!
echo 	"SERVER_PORT": !PORTNUMBER!,>> !env!
echo 	"SAVED_FOLDER": "./_SAVED",>> !env!
echo 	"CACHÉ_FOLDER": "./_CACHÉ",>> !env!
echo 	"THEME_FOLDER": "./_THEMES",>> !env!
echo 	"PREMADE_FOLDER": "./_PREMADE",>> !env!
echo 	"EXAMPLE_FOLDER": "./_EXAMPLES",>> !env!
echo 	"WRAPPER_VER": "1.3.0",>> !env!
echo 	"WRAPPER_BLD": "12",>> !env!
echo 	"NODE_TLS_REJECT_UNAUTHORIZED": "0">> !env!
echo }>> !env!
set TOTOGGLE=PORT
set TOGGLETO=!PORTNUMBER!
set CFGLINE=45
goto toggleoption
	

:::::::::::::::::::::::::
:: Truncated Themelist ::
:::::::::::::::::::::::::
:allthemechange
echo Toggling setting...
pushd wrapper\_THEMES
if exist "_themelist-allthemes.xml" (
	:: disable
	ren _themelist.xml _themelist-lessthemes.xml
	ren _themelist-allthemes.xml _themelist.xml
) else ( 
	:: enable
	ren _themelist.xml _themelist-allthemes.xml
	ren _themelist-lessthemes.xml _themelist.xml
)
popd
goto optionscreen

:::::::::::::::
:: Waveforms ::
:::::::::::::::
:waveformchange
echo Toggling setting...
pushd wrapper\static
if exist "watermarkON.txt" (
	if exist "info-nowave-watermark.json" (
		:: disable (watermark)
		ren info.json info-wave-watermark.json
		ren info-nowave-watermark.json info.json
	) else (
		:: enable (watermark)
		ren info.json info-wave.json
		ren info-nowave.json info.json
	)
) else (
	if exist "info-nowave.json" (
		:: disable
		ren info.json info-wave.json
		ren info-nowave.json info.json
	) else (
		:: enable
		ren info.json info-nowave.json
		ren info-wave.json info.json
	)
)
popd
goto optionscreen

::::::::::::::::
:: Debug Mode ::
::::::::::::::::
:debugmodechange
echo Toggling setting...
pushd wrapper\static
if exist "page-nodebug.js" (
	:: disable
	ren page.js page-debug.js
	ren page-nodebug.js page.js
) else ( 
	:: enable
	ren page.js page-nodebug.js
	ren page-debug.js page.js
)
popd
goto optionscreen

::::::::::::::::
:: Dark Mode  ::
::::::::::::::::
:darkmodechange
echo Toggling setting...
pushd wrapper\pages\css
if exist "global-light.css" (
	:: disable
	ren global.css global-dark.css
	ren global-light.css global.css
	ren themelist.css themelist-dark.css
	ren themelist-light.css themelist.css
	ren list.css list-dark.css
	ren list-light.css list.css
) else ( 
	:: enable
	ren global.css global-light.css
	ren global-dark.css global.css
	ren themelist.css themelist-light.css
	ren themelist-dark.css themelist.css
	ren list.css list-light.css
	ren list-dark.css list.css
)
popd
pushd server\animation\414827163ad4eb60
if exist "cc-light.swf" (
	:: disable
	ren cc.swf cc-dark.swf
	ren cc-light.swf cc.swf
) else ( 
	:: enable
	ren cc.swf cc-light.swf
	ren cc-dark.swf cc.swf
)
popd
goto optionscreen

::::::::::::::::::
:: Discord RPC  ::
::::::::::::::::::
:rpcchange
echo Toggling setting...
pushd wrapper
if exist "main-norpc.js" (
	:: disable
	ren main.js main-rpc.js
	ren main-norpc.js main.js
) else ( 
	:: enable
	ren main.js main-norpc.js
	ren main-rpc.js main.js
)
popd
goto optionscreen

::::::::::::::::::
:: Video List   ::
::::::::::::::::::
:gridview
echo Toggling setting...
pushd wrapper\pages\html

ren list.html table.html
ren grid.html list.html
ren _LISTVIEW.txt _GRIDVIEW.txt
 
popd
goto optionscreen

:oldlistview
echo Toggling setting...
pushd wrapper\pages\html

ren list.html grid.html
ren oldlist.html list.html
ren _GRIDVIEW.txt _OLDLISTVIEW.txt
 
popd
goto optionscreen

:listview
echo Toggling setting...
pushd wrapper\pages\html

ren list.html oldlist.html
ren table.html list.html
ren _OLDLISTVIEW.txt _LISTVIEW.txt
 
popd
goto optionscreen

:extractchars
if exist "server\characters\characters.zip" (
    echo Are you sure you wish to enable original LVM character IDs?
    echo This will take a while, depending on your computer.
    echo Characters will still be compressed, just put into separate usable files.
    echo Press Y to do it, press N to not do it.
    echo:
    :replaceaskretry
    set /p REPLACECHOICE= Response:
    echo:
    if not '!replacechoice!'=='' set replacechoice=%replacechoice:~0,1%
    if /i "!replacechoice!"=="0" goto end
    if /i "!replacechoice!"=="y" goto startextractchars
    if /i "!replacechoice!"=="n" goto optionscreen
    echo You must answer Yes or No. && goto replaceaskretry
    
    :startextractchars
    echo Opening 7za.exe...
    echo:
    start "utilities\7za.exe" e server\characters\characters.zip -o server\characters
    echo The extraction process should be starting now.
    echo When done, press any key to delete the .zip file.
    echo:
    pause
    del server\characters\characters.zip
)
goto optionscreen

:::::::::::::::::::::::::
:: Truncated Themelist ::
:::::::::::::::::::::::::
:allthemechange
echo Toggling setting...
pushd wrapper\_THEMES
if exist "themelist-allthemes.xml" (
	:: disable
	ren themelist.xml themelist-lessthemes.xml
	ren themelist-allthemes.xml themelist.xml
) else ( 
	:: enable
	ren themelist.xml themelist-allthemes.xml
	ren themelist-lessthemes.xml themelist.xml
)
popd
goto optionscreen

:::::::::::::::
:: Cepstral  ::
:::::::::::::::
:cepstralchange
echo Toggling setting...
pushd wrapper\tts
if exist "info-cepstral.json" (
	:: disable
	ren info.json info-vfproxy.json
	ren info-cepstral.json info.json
) else ( 
	:: enable
	ren info.json info-cepstral.json
	ren info-vfproxy.json info.json
)
popd
set TOTOGGLE=CEPSTRAL
if !CEPSTRAL!==n (
	set TOGGLETO=y
) else (
	set TOGGLETO=n
)
set CFGLINE=35
goto toggleoption

:::::::::::::::
:: Cepstral  ::
:::::::::::::::
:vfproxyserverchange
echo Toggling setting...
pushd wrapper\tts
if exist "main-seamus.js" (
	:: disable
	ren load.js load-localvfproxy.js
	ren main-seamus.js load.js
) else ( 
	:: enable
	ren load.js main-seamus.js
	ren load-localvfproxy.js load.js
)
popd
set TOTOGGLE=CEPSTRAL
if !CEPSTRAL!==n (
	set TOGGLETO=y
) else (
	set TOGGLETO=n
)
set CFGLINE=35
goto toggleoption

::::::::::::::::
:: Watermarks ::
::::::::::::::::
:watermarktoggle
echo Toggling setting...
pushd wrapper\static
if exist "info-nowatermark.json" (
	:: disable
	ren info.json info-watermark.json
	ren info-nowatermark.json info.json
	if exist "watermarkON.txt" ( del watermarkON.txt )
) else ( 
	:: enable
	ren info.json info-nowatermark.json
	ren info-watermark.json info.json
	echo This .TXT file is required for incase you decide to disable waveforms but you want to keep the watermark.>watermarkON.txt
)
popd
goto optionscreen

:end
endlocal
if "%SUBSCRIPT%"=="" (
	echo Closing...
	pause & exit
) else (
	exit /b
)