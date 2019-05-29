# LOAD HELPER FUNCTIONS
Write-Host "Load helper functions" -BackgroundColor White -ForegroundColor Black
. ./util/PrintToConsole.ps1
. ./util/WriteToConfig.ps1
. ./util/General.ps1
. ./util/GenerateConfigUtil.ps1

# PRE-GEN VALIDATE CONFIG
print_title "Prevalidate config object"
. ./PrevalidateConfig.ps1
prevalidate_config

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
if(Test-Path -Path $vars.hookFile) { . "$($vars.hookFile)" }
attempt_to_run_hook $vars "portable_hook_after_create_variables `$config `$var"

# CREATE CMDER CONFIG FILES
if($vars.isUsing.cmderConfigDir) {
  print_title "Create Cmder config files"
  . ./CreateCmderConfig.ps1
  cmder_config_write $vars $config
  attempt_to_run_hook $vars "portable_hook_after_create_cmder_files `$config `$var"
}

# CREATE STUFF FOR SCOOP
if($vars.isUsing.scoop.mainDir) {
  print_title "Create Scoop variables"
  . ./CreateScoop.ps1
  set_scoop_env_vars $vars $config
  attempt_to_run_hook $vars "portable_hook_after_set_scoop_env_vars `$config `$var"
}

# LAUNCH APPLICATIONS
print_title "Launch applications"
if($vars.isUsing.appDir) {
  . ./LaunchApplications
  prompt_to_launch_apps $vars $config
  attempt_to_run_hook $vars "portable_hook_after_launch_apps `$config `$var"
}
exit_program
