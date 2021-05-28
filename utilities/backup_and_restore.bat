@echo off >NUL 2>&1
title Loading...
PING -n 2 127.0.0.1>nul
if not exist ..\utilities ( goto error )
:backupstart
title Backup and restore tool for Wrapper: Offline
cls
echo Backup and restore tool for Wrapper: Offline
echo Created by MJ, the Spirit
echo:
if exist "backups" (
echo First, choose to back up either of the listed folders,
echo or to create a restore point of your backup folder.
echo -------------------------------------------------------
) else (
echo First, select a folder.
echo --------------------------------------
)
echo Enter 1 to back up the _SAVED folder
echo Enter 2 to back up the imported assets folder
if exist "backups" (
echo Enter 3 to create a restore point of your backup folder
)
echo:
:selection
echo:
set /p FOLDERID= Choice:
if "%FOLDERID%"=="1" goto saved
if "%FOLDERID%"=="2" goto import
if "%FOLDERID%"=="3" goto zip_backup
echo Please select a folder. && goto selection

:saved
echo:
echo:
echo Folder selected: _SAVED
echo:
echo Next, choose an action that you want to perform with this folder.
echo -----------------------------------------------------------------
echo Enter 1 to create a backup
echo Enter 2 to restore the contents using the backup
echo Enter 0 to go back
:savedselection
echo:
set /p SAVEDID= Choice: 
if "%SAVEDID%"=="1" goto saved_backup
if "%SAVEDID%"=="2" goto saved_restore
if "%SAVEDID%"=="0" goto backupstart
echo Please select an action. && goto savedselection

:import
echo:
echo:
echo Folder selected: Imported assets
echo:
echo Next, choose an action that you want to perform with this folder.
echo -----------------------------------------------------------------
echo Enter 1 to create a backup
echo Enter 2 to restore the contents using the backup
echo Enter 0 to go back
echo:
:importselection
set /p IMPORTID= Choice:
if "%IMPORTID%"=="1" goto import_backup
if "%IMPORTID%"=="2" goto import_restore
if "%IMPORTID%"=="0" goto backupstart
echo Please select an action. && goto importselection

:saved_backup
echo:
echo:
echo Finally, select if you want the characters, movies, thumbnails or the entire folder backed up.
echo ----------------------------------------------------------------------------------------------
echo Enter 1 to back up the characters
echo Enter 2 to back up the movies
echo Enter 3 to back up the thumbnails
echo Enter 4 to back up the entire folder
echo Enter 0 to go back
echo:
echo:
set SAVEDBACKUPID=0
echo:
set /p SAVEDBACKUPID= Choice:
if %SAVEDBACKUPID%==1 (
robocopy "..\wrapper\_SAVED" "backups\Wrapper Content Backup\Characters" /E char*
) else if %SAVEDBACKUPID%==2 (
robocopy "..\wrapper\_SAVED" "backups\Wrapper Content Backup\Movies" /E movie*
) else if %SAVEDBACKUPID%==3 (
robocopy "..\wrapper\_SAVED" "backups\Wrapper Content Backup\Thumbnails" /E thumb*
) else if %SAVEDBACKUPID%==4 (
robocopy "..\wrapper\_SAVED" "backups\Wrapper Content Backup\!Entire Folder" /E
) else if %SAVEDBACKUPID%==0 (
cls
goto saved
)

title Backup complete!
echo Done! Check the folder called ^"backups^"; there should be a subfolder called 
echo ^"Wrapper Content Backup^" in there with the files that you chose to back up.
echo:
echo Feel free to check the logs above. Press 1 to restart or press Enter to exit.
set EXIT=0
set /p EXIT= Choice: 
if %EXIT%==1 (
goto backupstart
) else explorer "backups"
exit

:saved_restore
cls
echo This tool is about to restore the contents of your _SAVED folder made from your backup.
echo Please remove any files that you don't want to restore before continuing.
echo:
echo In case of any errors with restoration of the files that you want restored,
echo they shall be backed up into a folder called ^"Old Saved Folder Content^".
echo ----------------------------------------------------------------------------------------
echo Select what you would like to restore...
echo:
echo Enter 1 to restore the characters
echo Enter 2 to restore the movies
echo Enter 3 to restore the thumbnails
echo Enter 4 to restore the entire folder
echo Enter 0 to go back
echo:
echo:
set SAVEDRESTOREID=0
echo:
set /p SAVEDRESTOREID= Choice:
if %SAVEDRESTOREID%==1 (
robocopy "..\wrapper\_SAVED" "backups\Old Saved Folder Content\Characters" /E char*
del "..\wrapper\_SAVED\char*.*" /a /q
robocopy "backups\Wrapper Content Backup\Characters" "..\wrapper\_SAVED" /E
) else if %SAVEDRESTOREID%==2 (
robocopy "..\wrapper\_SAVED" "backups\Old Saved Folder Content\Movies" /E movie*
del "..\wrapper\_SAVED\movie*.xml" /a /q
robocopy "backups\Wrapper Content Backup\Movies" "..\wrapper\_SAVED" /E
) else if %SAVEDRESTOREID%==3 (
robocopy "..\wrapper\_SAVED" "backups\Old Saved Folder Content\Thumbnails" /E thumb*
del "..\wrapper\_SAVED\thumb*.png" /a /q
robocopy "backups\Wrapper Content Backup\Thumbnails" "..\wrapper\_SAVED" /E
) else if %SAVEDRESTOREID%==4 (
robocopy "..\wrapper\_SAVED" "backups\Old Saved Folder Content\!Entire Folder" /E 
del "..\wrapper\_SAVED" /q
robocopy "backups\Wrapper Content Backup\!Entire Folder" "..\wrapper\_SAVED" /E
) else if %SAVEDRESTOREID%==0 (
cls
goto saved
)

title Restoration complete!
echo Restoration complete!
echo: 
echo Feel free to check the logs above. Press 1 to restart or press Enter to exit.
set EXIT=0
set /p EXIT= Choice: 
if %EXIT%==1 (
goto backupstart
) else exit


:import_backup
echo:
echo:
echo Finally, select if you want the backgrounds, props, audios (music/sounds) or the entire folder backed up.
echo ---------------------------------------------------------------------------------------------------------
echo Enter 1 to back up the backgrounds
echo Enter 2 to back up the props
echo Enter 3 to back up the audios
echo Enter 4 to back up the entire folder
echo Enter 0 to go back
echo:
echo:
set IMPORTBACKUPID=0
echo:
set /p IMPORTBACKUPID= Choice:
if %IMPORTBACKUPID%==1 (
robocopy "..\server\store\3a981f5cb2739137\import\bg" "backups\Imported Assets Backup\Backgrounds" /E
) else if %IMPORTBACKUPID%==2 (
robocopy "..\server\store\3a981f5cb2739137\import\prop" "backups\Imported Assets Backup\Props" /E
) else if %IMPORTBACKUPID%==3 (
robocopy "..\server\store\3a981f5cb2739137\import\sound" "backups\Imported Assets Backup\Audios" /E
) else if %IMPORTBACKUPID%==4 (
robocopy "..\server\store\3a981f5cb2739137\import" "backups\Imported Assets Backup\!Entire Folder" /E
) else if %IMPORTBACKUPID%==0 (
cls
goto import
)

echo:
title Backup complete!
echo Done! Check the folder called ^"backups^"; there should be a subfolder called  
echo ^"Imported Assets Backup^" there in with the files that you chose to back up.
echo:
echo Feel free to check the logs above. Press 1 to restart or press Enter to exit.
set EXIT=0
set /p EXIT= Choice: 
if %EXIT%==1 (
goto backupstart
) else explorer "backups"
exit


:import_restore
cls
echo This tool is about to restore the contents of the folder where you've imported your assets.
echo Please remove any assets that you don't want to restore before continuing.
echo:
echo In case of any errors with restoration of the files that you want restored,
echo they shall be backed up into a folder called ^"Old Import Folder Content^".
echo -------------------------------------------------------------------------------------------
echo Select what you would like to restore...
echo:
echo Enter 1 to restore the backgrounds
echo Enter 2 to restore the props
echo Enter 3 to restore the audios
echo Enter 4 to restore the entire folder
echo Enter 0 to go back
echo:
set IMPORTRESTOREID=0
:echo
set /p IMPORTRESTOREID= Choice:
if %IMPORTRESTOREID%==1 (
robocopy "..\server\store\3a981f5cb2739137\import\bg" "backups\Old Import Folder Content\Backgrounds" /E
del /q /s ..\server\store\3a981f5cb2739137\import\bg
robocopy "backups\Imported Assets Backup\Backgrounds" "..\server\store\3a981f5cb2739137\import\bg" /E
) else if %IMPORTRESTOREID%==2 (
robocopy "..\server\store\3a981f5cb2739137\import\prop" "backups\Old Import Folder Content\Props" /E
del /q /s ..\server\store\3a981f5cb2739137\import\prop
robocopy "backups\Imported Assets Backup\Props" "..\server\store\3a981f5cb2739137\import\prop" /E
) else if %IMPORTRESTOREID%==3 (
robocopy "..\server\store\3a981f5cb2739137\import\sound" "backups\Old Import Folder Content\Audios" /E
del /q /s ..\server\store\3a981f5cb2739137\import\sound
robocopy "backups\Imported Assets Backup\Audios" "..\server\store\3a981f5cb2739137\import\sound" /E
) else if %IMPORTRESTOREID%==4 (
robocopy "..\server\store\3a981f5cb2739137\import" "backups\Old Import Folder Content\!Entire Folder" /E
del /q ..\server\store\3a981f5cb2739137\import
md "..\server\store\3a981f5cb2739137\import"
robocopy "backups\Imported Assets Backup\!Entire Folder" "..\server\store\3a981f5cb2739137\import" /E
) else if %IMPORTRESTOREID%==0 (
cls
goto import
)

title Restoration complete!
echo Restoration complete!
echo: 
echo Feel free to check the logs above. Press 1 to restart or press Enter to exit.
set EXIT=0
set /p EXIT= Choice: 
if %EXIT%==1 (
goto backupstart
) else exit

:error
title ERROR: Not in right folder!
echo Hmmm... it looks like you attempted to start this tool
echo up while it's not in the utilities folder.
echo:
echo The tool can't do anything if it's not in there.
echo You might've started this in a subfolder.
echo:
echo Please make sure that this tool is in the folder mentioned
echo above with the other tools (not in a subfolder),
echo and then try starting it up again.
echo:
pause
exit

:zip_backup
if exist "backups" goto zipdisclaimer
if not exist "backups" goto nozip
		:zipdisclaimer
		cls
		set ZIPCONFIRM=1
		echo This tool is about to make a restore point of your backup folder.
		echo It'll be put into a .zip file showing its date and time as the filename.
		echo:
		echo Think of this like Windows' restore point feature,
		echo but in Wrapper: Offline form.
		echo:
		echo Press Enter to create a restore point or 0 to go back.
		echo:
		echo:
		set /p ZIPCONFIRM= Choice:
			if %ZIPCONFIRM%==0 goto backupstart (
			) else (
			goto zipprocess
			)
			:zipprocess
			if not exist "backups\Restore points" ( mkdir "Restore points" )
			set RESTORENAME=%date:~-4,4%-%date:~-7,2%-%date:~-10,2%T%time:~-11,2%-%time:~-8,2%-%time:~-5,2%Z.zip
			cls
			call 7za.exe a "backups\Restore points\%RESTORENAME%" "backups/Wrapper Content Backup" >nul
			cls
			call 7za.exe a "backups\Restore points\%RESTORENAME%" "backups/Imported Assets Backup" >nul
			cls
			call 7za.exe a "backups\Restore points\%RESTORENAME%" "backups/Old Saved Folder Content" >nul
			cls
			call 7za.exe a "backups\Restore points\%RESTORENAME%" "backups/Old Import Folder Content" >nul
			cls
			echo Restore point created.
			echo Name: %RESTORENAME%
			echo:
			echo Press 1 to view your restore points
			echo Press 2 to restart
			echo Press 0 to exit
			echo:
			goto zipselect
	
	:nozip
	echo Please select a folder.
	goto selection
	)

:zipselect
set ZIPCHOICE=0
set /p ZIPCHOICE= Option: 
if %ZIPCHOICE%==1 (
	explorer backups\Restore points
	goto zipselect
	)
if %ZIPCHOICE%==2 (
	goto backupstart
) else (
exit
)


:: Tool created in W:O 1.3.0. This took around an hour to make and test at first, but then I got the idea of upgrading it, which took me around 2 more days to do so. It was long to code and test, but I'm glad that it's finally done. ~ MJ
