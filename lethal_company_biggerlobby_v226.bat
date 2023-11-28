:: Feel free to ask Nico on Discord @rydan or Twitter @RydanTweets if you have any questions :)

:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!
:: DO NOT TOUCH ANYTHING BELOW!!!

@ECHO off

:: Exit if this script is run as administrator (prevents breaking changes to the Windows root directory in case of misconfigured paths etc.)
NET SESSION >NUL 2>&1 
IF %ERRORLEVEL% EQU 0 GOTO adminFailsafe

SET "ModsDirectoryName=Lethal_Company_Downloads"

SET "v_BepInEx=5.4.22"
SET "dl_BepInEx=https://github.com/BepInEx/BepInEx/releases/download/v5.4.22/BepInEx_x64_5.4.22.0.zip"

SET "v_LethalCompanyAPI=1.4.0"
SET "dl_LethalCompanyAPI=https://gcdn.thunderstore.io/live/repository/packages/2018-LC_API-1.4.0.zip"

SET "v_BiggerLobby=2.2.6"
SET "dl_BiggerLobby=https://gcdn.thunderstore.io/live/repository/packages/bizzlemip-BiggerLobby-2.2.60.zip"

ECHO This might take a second or two, please leave this window open!
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

ECHO ^>^> Closing Lethal Company if it's open...

:: Exit Lethal Company if it is running
taskkill /f /im "Lethal Company.exe"

:: Wait 2 seconds to make sure all related processes had time to exit
TIMEOUT 2 > NUL

:: Delete any old versions of the modded Lethal Company files under the current path (where this file is located)
IF EXIST "%ModsDirectoryName%" @RD /S /Q "%ModsDirectoryName%\"

:: Create a directory called "%ModsDirectoryName%" under the root path (the root path is wherever this .bat script file is located)
IF NOT EXIST "%ModsDirectoryName%\" MKDIR "%ModsDirectoryName%"
IF NOT EXIST "%ModsDirectoryName%\Lethal_Company_API_v%v_LethalCompanyAPI%" MKDIR "%ModsDirectoryName%\Lethal_Company_API_v%v_LethalCompanyAPI%"
IF NOT EXIST "%ModsDirectoryName%\BiggerLobby_v%v_BiggerLobby%" MKDIR "%ModsDirectoryName%\BiggerLobby_v%v_BiggerLobby%"

ECHO:

:: Remove any old versions of the mods and framework
ECHO ^>^> Removing any older versions of the mod...
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx" @RD /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\"
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\changelog.txt" DEL /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\changelog.txt"
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\doorstop_config.ini" DEL /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\doorstop_config.ini"
IF EXIST "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\winhttp.dll" DEL /S /Q "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\winhttp.dll"

ECHO:
ECHO ^>^> Downloading all necessary files...
ECHO  Downloading BepInEx modding framework v%v_BepInEx% ...
:: Download the BepInEx modding framework zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_BepInEx%', '%CD%\%ModsDirectoryName%\BepInEx_Modding_Framework_v%v_BepInEx%.zip')"
:: Exit if the BepInEx modding framework could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\BepInEx_Modding_Framework_v%v_BepInEx%.zip" GOTO bepInExNotDownloaded

ECHO  Downloading Lethal Company API v%v_LethalCompanyAPI% ...
:: Download the Lethal Company API zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_LethalCompanyAPI%', '%CD%\%ModsDirectoryName%\Lethal_Company_API_v%v_LethalCompanyAPI%.zip')"
:: Exit if the Lethal Company API could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\Lethal_Company_API_v%v_LethalCompanyAPI%.zip" GOTO lethalCompanyApiNotDownloaded

ECHO  Downloading BiggerLobby v%v_BiggerLobby% ...
:: Download the BiggerLobby zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_BiggerLobby%', '%CD%\%ModsDirectoryName%\BiggerLobby_v%v_BiggerLobby%.zip')"
:: Exit if the BiggerLobby could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\BiggerLobby_v%v_BiggerLobby%.zip" GOTO biggerLobbyNotDownloaded

ECHO:
ECHO ^>^> Moving all files to the correct places...

ECHO  Unpacking BepInEx modding framework v%v_BepInEx% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\BepInEx_Modding_Framework_v%v_BepInEx%.zip'" -DestinationPath "'%LethalCompanyInstallationPath%\steamapps\common\Lethal Company'"

ECHO  Unpacking Lethal Company API v%v_LethalCompanyAPI% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\Lethal_Company_API_v%v_LethalCompanyAPI%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\Lethal_Company_API_v%v_LethalCompanyAPI%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\Lethal_Company_API_v%v_LethalCompanyAPI%\BepInEx\plugins" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" /E /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO  Unpacking BiggerLobby v%v_BiggerLobby% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\BiggerLobby_v%v_BiggerLobby%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\BiggerLobby_v%v_BiggerLobby%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\BiggerLobby_v%v_BiggerLobby%\BepInEx\plugins" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" /E /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO:
ECHO ==^> SUCCESS!
ECHO:
ECHO ###############################################################
ECHO:
ECHO If you run into any issues, feel free to send Nico a message!
ECHO:
ECHO - Discord: rydan
ECHO - Twitter: @RydanTweets
ECHO:
ECHO ###############################################################
ECHO:
ECHO ==^> YOU CAN CLOSE THIS WINDOW AND START THE GAME NOW!
ECHO:
PAUSE
EXIT /B

:steamNotFound
ECHO:
ECHO Error: Steam installation could not be found.
ECHO:
PAUSE
EXIT /B

:lethalCompanyNotFound
ECHO:
ECHO Error: Lethal Company does not seem to be installed! Please install Lethal Company through Steam and try again.
ECHO:
PAUSE
EXIT /B

:bepInExNotDownloaded
ECHO:
ECHO Error: The BepInEx modding framework v%v_BepInEx% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:lethalCompanyApiNotDownloaded
ECHO:
ECHO Error: The Lethal Company API v%v_LethalCompanyAPI% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:biggerLobbyNotDownloaded
ECHO:
ECHO Error: The BiggerLobby v%v_BiggerLobby% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:adminFailsafe 
ECHO:
ECHO Error: Please do NOT run this script as administrator!
ECHO:
PAUSE
EXIT /B