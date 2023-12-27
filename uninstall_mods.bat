:: Feel free to ask Nico on Discord @rydan or Twitter @RydanTweets if you have any questions :)

:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!

@ECHO off

ECHO Lethal Company mods uninstall script v1.0.0 (last updated on December 27th, 2023 at 3:03pm PT)
ECHO:

ECHO This might take a second or two, please leave this window open.
ECHO:

:: Find the Steam installation path
FOR /F "usebackq delims=" %%I IN (`
  powershell -c "(Get-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam').SteamExe"
`) DO SET SteamExecutablePath=%%I

FOR /F "usebackq delims=" %%I IN (`
  powershell -c "(Get-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam').SteamPath"
`) DO SET SteamDirectoryPath=%%I

:: Exit if Steam cannot be found
IF NOT DEFINED SteamExecutablePath GOTO steamNotFound
IF NOT DEFINED SteamDirectoryPath GOTO steamNotFound

:: Find the Lethal Company Steam installation path
FOR /F "usebackq delims=" %%I IN (`
	powershell -c "$steamDirs=@(); foreach($line in Get-Content '%SteamDirectoryPath%/steamapps/libraryfolders.vdf') { if($line -match [regex] '""""path""""'){ $temp = $line -replace '\s+""""path""""\s+""""(.*)""""','$1'; $temp = $temp.replace('\\', '\'); $steamDirs += $temp; } } return $steamDirs"
`) DO (
	IF EXIST "%%I\steamapps\common\Lethal Company" SET LethalCompanyInstallationPath=%%I
)

:: Exit if the Lethal Company Steam installation path cannot be found
IF NOT DEFINED LethalCompanyInstallationPath GOTO lethalCompanyNotFound

ECHO ^>^>^> Closing the game...

:: Exit Lethal Company if it is running
taskkill /f /im "Lethal Company.exe" > NUL 2>&1

:: Wait 2 seconds to make sure all related processes had time to exit
TIMEOUT 2 > NUL

ECHO:

:: Remove any old versions of the mods and framework
ECHO ^>^>^> Removing all existing mod files...
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx" @RD /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\"
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\changelog.txt" DEL /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\changelog.txt"
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\doorstop_config.ini" DEL /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\doorstop_config.ini"
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\winhttp.dll" DEL /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\winhttp.dll"

ECHO:
ECHO ^>^>^> Done.

ECHO:
ECHO ###########################################################################
ECHO ###########################################################################
ECHO ###########################################################################
ECHO:
ECHO If you run into any issues, you can reach me here:
ECHO - Discord: rydan
ECHO - Twitter: @RydanTweets
ECHO:
ECHO:
ECHO ==^> SUCCESS^! YOU CAN CLOSE THIS WINDOW AND START THE DEFAULT GAME VIA STEAM NOW!
ECHO:
PAUSE
EXIT /B

:steamNotFound
ECHO:
ECHO ERROR: Steam could not be found!
ECHO:
PAUSE
EXIT /B

:lethalCompanyNotFound
ECHO:
ECHO ERROR: Lethal Company could not be found! It looks like you don't have it installed.
ECHO:
PAUSE
EXIT /B
