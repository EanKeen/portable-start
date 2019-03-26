# Import necessary JSON
$json = Get-Content portable-config.json | ConvertFrom-Json

# Load functions required by nearly all modules
. ./Initialize-Helper-Functions.ps1
print_title "Load helper functions"

# Load variables
print_title "Create variables"
$vars = New-Object -TypeName psobject
Set-Variable -Name "variables" -Value $vars -Scope Private

. ./Create-Variables.ps1
create_folder_variables $json $vars
create_config_file_variables $json $vars

# Creates Cmder config files
# cmder_config_exists auto creates files if they don't exist
# If file exists, prompt to overwrite
print_title "Create Cmder config files"
. ./Create-Cmder-Config.ps1
$willWriteConfig = ask_to_create_cmder_config $json $vars
print_info "willWriteConfig" $willWriteConfig

# If no config exists or if want to overwrite config, create config
if($willWriteConfig -eq $true) {
    . ./Create-Config-Write.ps1
    cmder_config_write $json $vars
}

# End
print_title "Press any key to exit"
$key = $Host.UI.RawUI.ReadKey()
Write-Host "`n"
exit