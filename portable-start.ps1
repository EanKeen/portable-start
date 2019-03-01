 # Import necessary JSON
$json = Get-Content portable-config.json | ConvertFrom-Json

# Creating variables that will be referenced later
$config = $json.config
$paths = $json.paths
$aliases = $json.aliases
$variables = $json.variables

# Load in support PowerShell files
. ./Helper-Functions.ps1

. ./Create-Necessary-Variables.ps1
# Variables created in this file
# $binaryDir
# $cmderConfigDir
# $portableDir

# $bashConfig
# $psConfig
# $cmdConfig
# $allConfig

create_folder_variables
create_file_variables

# . ./Cmder-Config-Interfacing.ps1
# $createConfig = cmder_config_exists



Write-Host "Press any key to exit" 
$key = $Host.UI.RawUI.ReadKey()
Write-Host "`n"
exit
