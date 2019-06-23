# LOAD HELPER FUNCTIONS
Write-Host "Load Helpers" -BackgroundColor White -ForegroundColor Black
. ./util/PrintToConsole.ps1
. ./util/WriteToConfig.ps1
. ./util/General.ps1
. ./util/CreateGlobalVariables.ps1

. ./ConfigureVariables.ps1


# RUN CUSTOM FILE WITH HOOK ACCESS
if(Test-Path -Path $vars.refs.hookFile) { . "$($vars.refs.hookFile)" }
attempt_to_run_hook $vars "portable_hook_after_start `$config `$var"


# CREATE STUFF FOR SCOOP
if($vars.isUsing.opts.scoopDriveName) {
  print_title "Configure Scoop"
  . ./ConfigureScoop.ps1
  configure_scoop $vars
  attempt_to_run_hook $vars "portable_hook_after_set_scoop_env_vars `$config `$var"
}

exit_program
