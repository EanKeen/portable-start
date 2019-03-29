$json = Get-Content portable.config.json | ConvertFrom-Json
Set-Variable -Name "vars" -Value $(New-Object -TypeName psobject) -Scope Private

Write-Host "Load helper functions" -BackgroundColor White -ForegroundColor Black
. ./Initialize-Helper-Functions.ps1

. ./Setup-Portable.ps1
print_title "Check file paths exist"
check_paths_in_config_exist $vars $json
. "$($json.relPathsTo.sourceToAccessHooks)"

print_title "Create variables"
create_folder_variables $vars $json
create_config_file_variables $vars $json
attempt_to_run_hook "after_create_variables `$json `$var"

# print_title "Create binaries"
# . ./Download-Binaries.ps1
# attempt_run "after_download_binaries `$json `$var"

print_title "Create Cmder config files"
. ./Create-Cmder-Config.ps1
$willWriteCmderConfig = ask_to_create_cmder_config $vars $json
if($willWriteCmderConfig) {
  cmder_config_write $vars $json
}
attempt_to_run_hook "after_create_cmder_files `$json `$var"

print_title "Create shortcuts"
. ./Create-Shortcuts.ps1
create_shortcuts $vars $json
attempt_to_run_hook "after_create_shortcuts `$json `$var"

print_title "Launch applications"
. ./Launch-Applications
prompt_to_launch_apps $vars $json
attempt_to_run_hook "after_launch_apps `$json `$var"

exit_program