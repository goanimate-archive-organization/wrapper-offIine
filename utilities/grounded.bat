@echo off

title Grounded Script Generator

:grounded
echo What is the character's name?
echo:
set /p CHARACTER= Character: 
echo:
echo What did he/she/they/it do?
echo:
set /p WRONGDOING= Wrongdoing: 
echo:
echo Generating grounded message...
set GROUNDED=OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO! %CHARACTER%, how dare you %WRONGDOING%! That's it! You're grounded 9999999999999999999999999999999999999999999999BEEEEXDTJEQXx 4 %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% years! Go to your room now!
echo Grounded message:
start mshta vbscript:Execute("CreateObject(""SAPI.SpVoice"").Speak(""%GROUNDED%"")(window.close)")
echo %GROUNDED%
echo:
echo Press 1 to copy it to clipboard
echo Press 2 to save it to a .TXT file in utilities\grounded_messages
echo Press 3 to generate another one
echo Press 4 to exit
echo:
:groundedreask
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
echo %GROUNDED%>"grounded_messages\%CHARACTER% does %WRONGDOING% and gets grounded.txt"
echo Saved to .TXT file.
echo:
pause & exit
)
if "%OPTION%"=="3" (
cls
goto grounded
)
if "%OPTION%"=="4" (
exit
)
if "%OPTION%"=="" (
echo You must choose a valid option.
goto groundedreask
)
