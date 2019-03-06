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

# Creates Cmder config files
# cmder_config_exists auto creates files if they don't exist
# If file exists, prompt to overwrite
print_title "Create Cmder config files"
. ./Cmder-Config-Create.ps1
$willWriteConfig = cmder_config_ask_create
print_info "willWriteConfig" $willWriteConfig

# If no config exists or if want to overwrite config, create config
if($willWriteConig -eq $true) {
    . ./Create-Config-Write.ps1
    cmder_config_write
}

# End
print_title "Press any key to exit"
$key = $Host.UI.RawUI.ReadKey()
Write-Host "`n"
exit