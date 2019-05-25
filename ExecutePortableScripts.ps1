# LOAD HELPER FUNCTIONS
Write-Host "Load helper functions" -BackgroundColor White -ForegroundColor Black
. ./util/PrintToConsole.ps1
. ./util/WriteToConfig.ps1
. ./util/General.ps1

# GENERATE CONFIG OBJECT
print_title "Create basic config"
. ./GenerateConfig.ps1
Set-Variable -Name "config" -Value $(generate_config) -Scope Private

# VALIDATE CONFIG
print_title "Validate config object"
. ./ValidateConfig.ps1
validate_config $config

# GENERATE VARS OBJECT
print_title "Create basic vars"
. ./GenerateVars.ps1
Set-Variable -Name "vars" -Value $(generate_vars $config) -Scope Private

# RUN CUSTOM FILE WITH HOOK ACCESS
if(Test-Path -Path $vars.sourceToAccessHooks) { . "$($vars.sourceToAccessHooks)" }
attempt_to_run_hook "portable_hook_after_create_variables `$config `$var"

# CREATE CMDER CONFIG FILES
print_title "Create Cmder config files"
. ./CreateCmderConfig.ps1
cmder_config_write $vars $config
attempt_to_run_hook "portable_hook_after_create_cmder_files `$config `$var"

# CREATE STUFF FOR SCOOP
print_title "Create Scoop variales"
. ./CreateScoop.ps1
create_scoop $vars $config
attempt_to_run_hook "portable_hook_after_create_scoop_files `$config `$var"

# LAUNCH APPLICATIONS
print_title "Launch applications"
. ./LaunchApplications
prompt_to_launch_apps $vars $config
attempt_to_run_hook "portable_hook_after_launch_apps `$config `$var"

exit_program
