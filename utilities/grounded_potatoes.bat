@echo off

title Grounses Script Generator

:grounses
echo What is yor lazy potato characters name?
echo:
set /p CHARACTER= Character: 
echo:
echo What did  he/she/they/it/potato do?
echo:
set /p WRONGDOING= Wrongdoing: 
echo:
echo Generating grounded message...
set GROUNDED=O! %CHARACTER%, how pogoto der u %WRONGDOING%! That's it! You're grounses 4 %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% potatoes! Go 2 iyour lazy potato rum naw!
echo Grounded message:
start mshta vbscript:Execute("CreateObject(""SAPI.SpVoice"").Speak(""%GROUNDED%"")(window.close)")
echo %GROUNDED%
echo:
echo Press 1 to copy it to clipboard
echo Press 2 to save it to a .TXT file in utilities\lazy_grounded_messages
echo Press 3 to generate another one
echo Press 4 to exit
echo:
:grounsesreask
set /p OPTION= Option: 
if "%OPTION%"=="1" (
echo:
echo|set/p=%GROUNDED%|clip
echo Copied to clipboard.
echo:
pause & exit
)
if "%OPTION%"=="2" (
echo:
echo %GROUNDED%>"lazy_grounded_messages\%CHARACTER% does %WRONGDOING% and gets grounses.txt"
echo Saved to .TXT file.
echo:
pause & exit
)
if "%OPTION%"=="3" (
cls
goto grounses
)
if "%OPTION%"=="4" (
exit
)
if "%OPTION%"=="" (
echo You must choose a valid option.
goto grounsesreask
)
