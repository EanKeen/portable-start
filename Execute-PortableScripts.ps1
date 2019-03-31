# LOAD HELPER FUNCTIONS
Write-Host "Load helper functions" -BackgroundColor White -ForegroundColor Black
. ./Initialize-Helper-Functions.ps1

print_error "highlighted"
# FILL IN GAPS IN CONFIG
print_title "Create basic config"
. ./Explicitize-Config.ps1
# Set-Variable -Name "vars" -Value $(global_vars) -Scope Private
# Set-Variable -Name "config" -Value $(gen_config_obj) -Scope Private

print_error "json" $(gen_config_obj | ConvertTo-Json)
exit_program

# CHECK PATHS EXIST (move to Explicitize-Config.ps1)
. ./Setup-Portable.ps1
print_title "Check file paths exist"
check_paths_in_config_exist $vars $config
. "$($config.relPathsTo.sourceToAccessHooks)"

# ATTACH VARIABLES TO $VAR (RENAME THIS)
print_title "Create variables"
create_folder_variables $vars $config
create_config_file_variables $vars $config
attempt_to_run_hook "after_create_variables `$config `$var"

# DOWNLOAD BINARIES
# print_title "Create binaries"
# . ./Download-Binaries.ps1
# attempt_run "after_download_binaries `$config `$var"

# CREATE CMDER CONFIG FILES
print_title "Create Cmder config files"
. ./Create-Cmder-Config.ps1
$willWriteCmderConfig = ask_to_create_cmder_config $vars $config
if($willWriteCmderConfig) {
  cmder_config_write $vars $config
}
attempt_to_run_hook "after_create_cmder_files `$config `$var"

# CREATE SHORTCUTS
print_title "Create shortcuts"
. ./Create-Shortcuts.ps1
create_shortcuts $vars $config
attempt_to_run_hook "after_create_shortcuts `$config `$var"

# LAUNCH APPLICATIONS
print_title "Launch applications"
. ./Launch-Applications
prompt_to_launch_apps $vars $config
attempt_to_run_hook "after_launch_apps `$config `$var"

exit_program
