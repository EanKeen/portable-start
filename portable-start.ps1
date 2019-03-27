# Import JSON
$json = Get-Content portable.config.json | ConvertFrom-Json

# Load functions required by nearly all modules
Write-Host "Load helper functions" -BackgroundColor White -ForegroundColor Black
. ./Initialize-Helper-Functions.ps1

# Load variables
print_title "Create variables"
$variable = New-Object -TypeName psobject
Set-Variable -Name "vars" -Value $variable -Scope Private

. ./Create-Variables.ps1
create_folder_variables $vars $json
create_config_file_variables $vars $json

# Creates Cmder config files
# cmder_config_exists creates files if they don't exist, else prompt to override
print_title "Create Cmder config files"
. ./Create-Cmder-Config.ps1
$willWriteConfig = ask_to_create_cmder_config $vars $json

# If no config exists or if want to overwrite config, create config
if($willWriteConfig -eq $true) {
    cmder_config_write $vars $json
}

# Creates Cmder Binaries
print_title "Create binaries"
. ./Download-Binaries.ps1

# End
print_title "Press any key to exit"
$key = $Host.UI.RawUI.ReadKey()
Write-Host `r`n
exit