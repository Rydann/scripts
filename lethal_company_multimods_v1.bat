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

SET "v_MoreSuits=1.3.2"
SET "dl_MoreSuits=https://thunderstore.io/package/download/x753/More_Suits/1.3.2/"

SET "v_AdditionalSuits=1.0.2"
SET "dl_AdditionalSuits=https://thunderstore.io/package/download/AlexCodesGames/AdditionalSuits/1.0.2/"

SET "v_ShipLobby=1.0.1"
SET "dl_ShipLobby=https://thunderstore.io/package/download/tinyhoot/ShipLobby/1.0.1/"

SET "v_ReservedItemSlotCore=1.2.9"
SET "dl_ReservedItemSlotCore=https://thunderstore.io/package/download/FlipMods/ReservedItemSlotCore/1.2.9/"

SET "v_ReservedFlashlightSlot=1.3.2"
SET "dl_ReservedFlashlightSlot=https://thunderstore.io/package/download/FlipMods/ReservedFlashlightSlot/1.3.2/"

SET "v_ReservedWalkieSlot=1.2.2"
SET "dl_ReservedWalkieSlot=https://thunderstore.io/package/download/FlipMods/ReservedWalkieSlot/1.2.2/"

SET "v_SkipToMultiplayerMenu=1.0.0"
SET "dl_SkipToMultiplayerMenu=https://thunderstore.io/package/download/FlipMods/SkipToMultiplayerMenu/1.0.0/"

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

ECHO  Downloading MoreSuits v%v_MoreSuits% ...
:: Download the MoreSuits zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_MoreSuits%', '%CD%\%ModsDirectoryName%\MoreSuits_v%v_MoreSuits%.zip')"
:: Exit if the MoreSuits could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\MoreSuits_v%v_MoreSuits%.zip" GOTO moreSuitsNotDownloaded

ECHO  Downloading AdditionalSuits v%v_AdditionalSuits% ...
:: Download the AdditionalSuits zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_AdditionalSuits%', '%CD%\%ModsDirectoryName%\AdditionalSuits_v%v_AdditionalSuits%.zip')"
:: Exit if the AdditionalSuits could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\AdditionalSuits_v%v_AdditionalSuits%.zip" GOTO additionalSuitsNotDownloaded

ECHO  Downloading ShipLobby v%v_ShipLobby% ...
:: Download the ShipLobby zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_ShipLobby%', '%CD%\%ModsDirectoryName%\ShipLobby_v%v_ShipLobby%.zip')"
:: Exit if the ShipLobby could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\ShipLobby_v%v_ShipLobby%.zip" GOTO shipLobbyNotDownloaded

ECHO  Downloading ReservedItemSlotCore v%v_ReservedItemSlotCore% ...
:: Download the ReservedItemSlotCore zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_ReservedItemSlotCore%', '%CD%\%ModsDirectoryName%\ReservedItemSlotCore_v%v_ReservedItemSlotCore%.zip')"
:: Exit if the ReservedItemSlotCore could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\ReservedItemSlotCore_v%v_ReservedItemSlotCore%.zip" GOTO reservedItemSlotCoreNotDownloaded

ECHO  Downloading ReservedFlashlightSlot v%v_ReservedFlashlightSlot% ...
:: Download the ReservedFlashlightSlot zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_ReservedFlashlightSlot%', '%CD%\%ModsDirectoryName%\ReservedFlashlightSlot_v%v_ReservedFlashlightSlot%.zip')"
:: Exit if the ReservedFlashlightSlot could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\ReservedFlashlightSlot_v%v_ReservedFlashlightSlot%.zip" GOTO reservedFlashlightSlotNotDownloaded

ECHO  Downloading ReservedWalkieSlot v%v_ReservedWalkieSlot% ...
:: Download the ReservedWalkieSlot zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_ReservedWalkieSlot%', '%CD%\%ModsDirectoryName%\ReservedWalkieSlot_v%v_ReservedWalkieSlot%.zip')"
:: Exit if the ReservedWalkieSlot could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\ReservedWalkieSlot_v%v_ReservedWalkieSlot%.zip" GOTO reservedWalkieSlotNotDownloaded

ECHO  Downloading SkipToMultiplayerMenu v%v_SkipToMultiplayerMenu% ...
:: Download the SkipToMultiplayerMenu zip archive
powershell -Command "(New-Object Net.WebClient).DownloadFile('%dl_SkipToMultiplayerMenu%', '%CD%\%ModsDirectoryName%\SkipToMultiplayerMenu_v%v_SkipToMultiplayerMenu%.zip')"
:: Exit if the SkipToMultiplayerMenu could not be downloaded
IF NOT EXIST "%CD%\%ModsDirectoryName%\SkipToMultiplayerMenu_v%v_SkipToMultiplayerMenu%.zip" GOTO skipToMultiplayerMenuNotDownloaded

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

ECHO  Unpacking MoreSuits v%v_MoreSuits% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\MoreSuits_v%v_MoreSuits%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\MoreSuits_v%v_MoreSuits%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\MoreSuits_v%v_MoreSuits%\BepInEx\plugins" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" /E /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO  Unpacking AdditionalSuits v%v_AdditionalSuits% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\AdditionalSuits_v%v_AdditionalSuits%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\AdditionalSuits_v%v_AdditionalSuits%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\AdditionalSuits_v%v_AdditionalSuits%\plugins\resAdditionalSuits" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins\moresuits" /E /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO  Unpacking ShipLobby v%v_ShipLobby% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\ShipLobby_v%v_ShipLobby%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\ShipLobby_v%v_ShipLobby%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\ShipLobby_v%v_ShipLobby%\plugins\ShipLobby" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" /E /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO  Unpacking ReservedItemSlotCore v%v_ReservedItemSlotCore% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\ReservedItemSlotCore_v%v_ReservedItemSlotCore%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\ReservedItemSlotCore_v%v_ReservedItemSlotCore%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\ReservedItemSlotCore_v%v_ReservedItemSlotCore%" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" "ReservedItemSlotCore.dll" /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO  Unpacking ReservedFlashlightSlot v%v_ReservedFlashlightSlot% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\ReservedFlashlightSlot_v%v_ReservedFlashlightSlot%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\ReservedFlashlightSlot_v%v_ReservedFlashlightSlot%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\ReservedFlashlightSlot_v%v_ReservedFlashlightSlot%" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" "ReservedFlashlightSlot.dll" /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO  Unpacking ReservedWalkieSlot v%v_ReservedWalkieSlot% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\ReservedWalkieSlot_v%v_ReservedWalkieSlot%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\ReservedWalkieSlot_v%v_ReservedWalkieSlot%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\ReservedWalkieSlot_v%v_ReservedWalkieSlot%\BepInEx\plugins" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" /NFL /NDL /NJH /NJS /nc /ns /np > NUL

ECHO  Unpacking SkipToMultiplayerMenu v%v_SkipToMultiplayerMenu% ...
powershell Expand-Archive -LiteralPath "'%CD%\%ModsDirectoryName%\SkipToMultiplayerMenu_v%v_SkipToMultiplayerMenu%.zip'" -DestinationPath "'%CD%\%ModsDirectoryName%\SkipToMultiplayerMenu_v%v_SkipToMultiplayerMenu%\'"
ROBOCOPY "%CD%\%ModsDirectoryName%\SkipToMultiplayerMenu_v%v_SkipToMultiplayerMenu%\BepInEx\plugins" "%LethalCompanyInstallationPath%\steamapps\common\Lethal Company\BepInEx\plugins" /NFL /NDL /NJH /NJS /nc /ns /np > NUL

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

:moreSuitsNotDownloaded
ECHO:
ECHO Error: The MoreSuits v%v_MoreSuits% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:additionalSuitsNotDownloaded
ECHO:
ECHO Error: The AdditionalSuits v%v_AdditionalSuits% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:shipLobbyNotDownloaded
ECHO:
ECHO Error: The ShipLobby v%v_ShipLobby% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:reservedItemSlotCoreNotDownloaded
ECHO:
ECHO Error: The ReservedItemSlotCore v%v_ReservedItemSlotCore% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:reservedFlashlightSlotNotDownloaded
ECHO:
ECHO Error: The ReservedFlashlightSlot v%v_ReservedFlashlightSlot% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:reservedWalkieSlotNotDownloaded
ECHO:
ECHO Error: The ReservedWalkieSlot v%v_ReservedWalkieSlot% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:skipToMultiplayerMenuNotDownloaded
ECHO:
ECHO Error: The SkipToMultiplayerMenu v%v_SkipToMultiplayerMenu% could not be downloaded, please try again! If this problem persists please let Nico know :)
ECHO:
PAUSE
EXIT /B

:adminFailsafe 
ECHO:
ECHO Error: Please do NOT run this script as administrator!
ECHO:
PAUSE
EXIT /B