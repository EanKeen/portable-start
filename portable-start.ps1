 # Import necessary JSON
$json = Get-Content portable-config.json | ConvertFrom-Json

# Creating variables that will be referenced later
$config = $json.config
$paths = $json.paths
$aliases = $json.aliases
$variables = $json.variables

# Load functions required by nearly all modules
. ./Helper-Functions.ps1
print_title "Load helper functions"


# Load global variables
# Dirs:  $binaryDir, $cmderConfigDir, $portableDir
# Files: $bashConfig, $psConfig, $cmdConfig, $allConfig
print_title "Load global variables"
. ./Create-Necessary-Variables.ps1
create_folder_variables
create_file_variables

print_title "Create Cmder config files"
. ./Cmder-Config-Interfacing.ps1
$isConfigPreexisting = cmder_config_exists



Write-Host "Press any key to exit" 
$key = $Host.UI.RawUI.ReadKey()
Write-Host "`n"
exit
