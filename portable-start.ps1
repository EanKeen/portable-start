# Import JSON
$json = Get-Content portable.config.json | ConvertFrom-Json

# Load functions required by nearly all modules
Write-Host "Load helper functions" -BackgroundColor White -ForegroundColor Black
. ./Initialize-Helper-Functions.ps1

# Load variables
$variable = New-Object -TypeName psobject
Set-Variable -Name "vars" -Value $variable -Scope Private

. ./Setup-Portable.ps1
print_title "Check file paths exist"
check_paths_in_config_exist $vars $json
print_title "Create variabels"
create_folder_variables $vars $json
create_config_file_variables $vars $json

# Creates Cmder config files
# cmder_config_exists creates files if they don't exist, else prompt to override
print_title "Create Cmder config files"
. ./Create-Cmder-Config.ps1
$willWriteCmderConfig = ask_to_create_cmder_config $vars $json

# If no config exists or if want to overwrite config, create config
if($willWriteCmderConfig -eq $true) {
  cmder_config_write $vars $json
}

# Creates Cmder Binaries
print_title "Create binaries"
. ./Download-Binaries.ps1

# Launch Applications
print_title "Launch applications"
. ./Launch-Applications
prompt_to_launch_apps $vars $json

exit_program