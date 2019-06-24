# LOAD HELPER FUNCTIONS
Write-Host "Load Helpers" -BackgroundColor White -ForegroundColor Black
. ./util/PrintToConsole.ps1
. ./util/WriteToConfig.ps1
. ./util/General.ps1

. ./ConfigureVariables.ps1
$config = configure_variables
print_info "Your Config"
Write-Host $config | ConvertTo-Json | Write-Host


# RUN CUSTOM FILE WITH HOOK ACCESS
$hookFile = "./custom/script.ps1"
if(Test-Path -Path $hookFile) { . $hookFile }
attempt_to_run_hook $config "portable_hook_after_start `$config"

# CREATE STUFF FOR SCOOP
print_title "Configure Scoop"
. ./ConfigureScoop.ps1
configure_scoop $config
attempt_to_run_hook $config "portable_hook_after_scoop `$config"
print_info "Done"

exit_program
