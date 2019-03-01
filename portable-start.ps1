 # Import necessary JSON
$json = Get-Content portable-config.json | ConvertFrom-Json

# Creating variables that will be referenced later
$config = $json.config
$paths = $json.paths
$aliases = $json.aliases
$variables = $json.variables

# Load functions required by nearly all modules
. ./Helper-Functions.ps1
print_title "Loading helper functions"


# Load in globaal variables. They include
# $binaryDir, $cmderConfigDir, $portableDir

# $bashConfig, $psConfig, $cmdConfig, $allConfig
. ./Create-Necessary-Variables.ps1


create_folder_variables
create_file_variables

# . ./Cmder-Config-Interfacing.ps1
# $createConfig = cmder_config_exists



Write-Host "Press any key to exit" 
$key = $Host.UI.RawUI.ReadKey()
Write-Host "`n"
exit
