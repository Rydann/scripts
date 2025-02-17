:: Feel free to ask Nico on Discord @rydan or Twitter @RydanTweets if you have any questions :)

:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!

@ECHO off

ECHO [94mTibia Settings Backup v1.0[0m (last updated on February 17th, 2025 at 9:45 am PT)
ECHO:

ECHO [91mThis should only take a couple seconds, please leave this window open![0m
ECHO:

SET "_INSTALLDIR=%LOCALAPPDATA%\Tibia"

:: check if Tibia is installed under the default path
IF NOT EXIST "%_INSTALLDIR%\Tibia.exe" GOTO gotoTibiaNotFound

:: store the current date and time in a variable 
FOR /F "TOKENS=2 DELIMS==" %%I IN ('WMIC OS GET LOCALDATETIME /FORMAT:LIST') DO SET _DATETIME=%%I
SET "_TIME=%_DATETIME:~0,4%_%_DATETIME:~4,2%_%_DATETIME:~6,2%_%_DATETIME:~8,2%_%_DATETIME:~10,2%_%_DATETIME:~12,2%"

:: store the current directory path in a variable
SET "_CURRENTDIR=%~DP0%"

ECHO [92m^>^>^> Creating backup...[0m

:: deleting possible duplicate backup if one exits for some reason
IF EXIST "%_CURRENTDIR%tibia-backups\%_TIME%" @RD /S /Q "%_CURRENTDIR%tibia-backups\%_TIME%\"

:: create the backup folder for the current backup if it doesn't exist
IF NOT EXIST "%_CURRENTDIR%tibia-backups\%_TIME%\" MKDIR "%_CURRENTDIR%tibia-backups\%_TIME%"
IF NOT EXIST "%_CURRENTDIR%tibia-backups\%_TIME%\conf\" MKDIR "%_CURRENTDIR%tibia-backups\%_TIME%\conf"
IF NOT EXIST "%_CURRENTDIR%tibia-backups\%_TIME%\characterdata\" MKDIR "%_CURRENTDIR%tibia-backups\%_TIME%\characterdata"
IF NOT EXIST "%_CURRENTDIR%tibia-backups\%_TIME%\minimap\" MKDIR "%_CURRENTDIR%tibia-backups\%_TIME%\minimap"

:: create a copy of the "conf" folder that stores all client settings including hotkeys etc.
ECHO   ^>^> Backing up client settings...[0m
ROBOCOPY "%_INSTALLDIR%\packages\Tibia\conf" "%_CURRENTDIR%tibia-backups\%_TIME%\conf" /E /NFL /NDL /NJH /NJS /nc /ns /np > NUL

:: create a copy of the "characterdata" folder that stores all character data like loot lists, action bars etc.
ECHO   ^>^> Backing up character data...[0m
ROBOCOPY "%_INSTALLDIR%\packages\Tibia\characterdata" "%_CURRENTDIR%tibia-backups\%_TIME%"\characterdata /E /NFL /NDL /NJH /NJS /nc /ns /np > NUL

:: create a copy of the "minimapmarkers.bin" file that stores all minimap markers (we ignore the actual minimap because we can get that from TibiaMaps.io anytime)
ECHO   ^>^> Backing up minimap markers...[0m
ROBOCOPY "%_INSTALLDIR%\packages\Tibia\minimap" "%_CURRENTDIR%tibia-backups\%_TIME%\minimap" "minimapmarkers.bin" /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO:

ECHO [92m^>^>^> Backup "%_TIME%" created![0m

ECHO:

:: delete all backup folders older than 14 days 
ECHO [92m^>^>^> Deleting backups older than 14 days...[0m
FORFILES /P "%_CURRENTDIR%tibia-backups" /D -14 /C "CMD /C IF @ISDIR==TRUE RD /S /Q @FILE" 2>NUL

ECHO:
ECHO [92m^>^>^> Done![0m
ECHO:

ECHO ###########################################################################
ECHO ###########################################################################
ECHO:
ECHO [94mIf you run into any issues you can reach me here:[0m
ECHO:
ECHO [94m- Discord:[0m rydan
ECHO [94m- Twitter:[0m @RydanTweets
ECHO:
ECHO ###########################################################################
ECHO ###########################################################################
ECHO:
ECHO [101;93mPress any key to start Tibia![0m
ECHO:
PAUSE

:: start the Tibia launcher as usual
START /D "%_INSTALLDIR%\Tibia" Tibia.exe
EXIT

:gotoTibiaNotFound
ECHO:
ECHO [91mERROR: Tibia could not be found at the default location! Please make sure to change the path inside the script to wherever you have it installed.[0m
ECHO:
PAUSE
EXIT /B