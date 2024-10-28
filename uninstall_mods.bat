:: Feel free to ask Nico on Discord @rydan or Twitter @RydanTweets if you have any questions :)

:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!

@ECHO off

SET "CurrentDir=%~DP0%"
SET "ModsDirectoryName=UZGyW76rjvqyXPMaRk7R"

ECHO [94mNico's Lethal Company Mods Uninstaller[0m
ECHO:

ECHO [91mThis could take a minute, please leave this window open![0m
ECHO:

:: Find the Steam installation path
FOR /F "usebackq delims=" %%I IN (`
  powershell -c "(Get-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam').SteamExe"
`) DO SET SteamExecutablePath=%%I

FOR /F "usebackq delims=" %%I IN (`
  powershell -c "(Get-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam').SteamPath"
`) DO SET SteamDirectoryPath=%%I

:: Exit if Steam cannot be found
IF NOT DEFINED SteamExecutablePath GOTO gotoSteamNotFound
IF NOT DEFINED SteamDirectoryPath GOTO gotoSteamNotFound

:: Find the game's Steam installation path
FOR /F "usebackq delims=" %%I IN (`
	powershell -c "$steamDirs=@(); foreach($line in Get-Content '%SteamDirectoryPath%/steamapps/libraryfolders.vdf') { if($line -match [regex] '""""path""""'){ $temp = $line -replace '\s+""""path""""\s+""""(.*)""""','$1'; $temp = $temp.replace('\\', '\'); $steamDirs += $temp; } } return $steamDirs"
`) DO (
	IF EXIST "%%I\steamapps\common\Lethal Company" SET GameInstallationPath=%%I
)

:: Exit if the game's Steam installation path cannot be found
IF NOT DEFINED GameInstallationPath GOTO gotoGameNotFound

ECHO [92m^>^>^> Making sure the game is closed...[0m

:: Exit the game if it is running
taskkill /f /im "Lethal Company.exe" > NUL 2>&1

:: Wait 2 seconds to make sure all related processes had time to exit
TIMEOUT 2 > NUL

:: Delete any old versions of the modded files under the current path (where this file is located)
IF EXIST "%CurrentDir%%ModsDirectoryName%" @RD /S /Q "%CurrentDir%%ModsDirectoryName%\"

:: Create a directory called "%ModsDirectoryName%" under the root path (the root path is wherever this .bat script file is located)
IF NOT EXIST "%CurrentDir%%ModsDirectoryName%\" MKDIR "%CurrentDir%%ModsDirectoryName%"

ECHO:

:: Remove any old versions of the mods and framework
ECHO [92m^>^>^> Getting rid of all mod files...[0m
IF EXIST "%GameInstallationPath%\steamapps\common\Lethal Company\BepInEx" @RD /S /Q "%GameInstallationPath%\steamapps\common\Lethal Company\BepInEx\"
IF EXIST "%GameInstallationPath%\steamapps\common\Lethal Company\changelog.txt" DEL /S /Q "%GameInstallationPath%\steamapps\common\Lethal Company\changelog.txt"
IF EXIST "%GameInstallationPath%\steamapps\common\Lethal Company\doorstop_config.ini" DEL /S /Q "%GameInstallationPath%\steamapps\common\Lethal Company\doorstop_config.ini"
IF EXIST "%GameInstallationPath%\steamapps\common\Lethal Company\winhttp.dll" DEL /S /Q "%GameInstallationPath%\steamapps\common\Lethal Company\winhttp.dll"

ECHO:
ECHO [92m^>^>^> Removal complete![0m
ECHO:

ECHO ###########################################################################
ECHO ###########################################################################
ECHO:
ECHO [101;93mYou may close this window and run the game via Steam now![0m
ECHO:
ECHO [94mIf you experience any issues you can reach me here![0m
ECHO:
ECHO [94m- Discord:[0m rydan
ECHO [94m- Twitter:[0m @RydanTweets
ECHO:
ECHO:
PAUSE
EXIT /B

:gotoSteamNotFound
ECHO:
ECHO [91mERROR: Steam could not be found! There is nothing to uninstall.[0m
ECHO:
PAUSE
EXIT /B

:gotoGameNotFound
ECHO:
ECHO [91mERROR: Game could not be found! There is nothing to uninstall.[0m
ECHO:
PAUSE
EXIT /B
