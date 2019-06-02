# LOAD HELPER FUNCTIONS
Write-Host "Load Helpers" -BackgroundColor White -ForegroundColor Black
. ./util/PrintToConsole.ps1
. ./util/WriteToConfig.ps1
. ./util/General.ps1
. ./util/GenerateConfigUtil.ps1



# CREATE VARIABLES
function create_constant_scoop_drive($var, $config) {
  if($var.isUsing.opts.scoopDriveName) {
    $scoopDrive = Get-Disk | Get-Partition | Get-Volume | ForEach-Object {
    if($_.FileSystemLabel -eq "SCOOP") {
        $_.DriveLetter
        return
      }
    }
  }
  else {
    $portableDisk = Get-Partition -DriveLetter (Get-Location).Drive.Name | Select-Object -ExpandProperty "DiskNumber"
    $scoopDrive = "$(Get-Partition -DiskNumber $portableDisk | Get-Volume | ForEach-Object {
      if($_.FileSystemLabel -eq $config.opt.driveName) {
        $_.DriveLetter | Out-Host
        return
      }
    })"
  }
  "${scoopDrive}:/"
}

# PRE-GEN VALIDATE CONFIG
print_title "Prevalidate Config"
. ./PrevalidateConfig.ps1
prevalidate_config

# GENERATE CONFIG OBJECT
print_title "Generate Config"
. ./GenerateConfig.ps1
Set-Variable -Name "config" -Value $(generate_config) -Scope Private

# GENERATE VARS OBJECT
print_title "Generate Vars"
. ./GenerateVars.ps1
Set-Variable -Name "vars" -Value $(generate_vars $config) -Scope Private

# VALIDATE CONFIG
print_title "Validate Config"
. ./ValidateConfig.ps1
validate_config $config $vars

# RUN CUSTOM FILE WITH HOOK ACCESS
if(Test-Path -Path $vars.hookFile) { . "$($vars.hookFile)" }
attempt_to_run_hook $vars "portable_hook_after_create_variables `$config `$var"

# CREATE STUFF FOR SCOOP
if($vars.isUsing.opts.scoopDriveName) {
  print_title "Configure Scoop"
  . ./ConfigureScoop.ps1
  configure_scoop $vars $config
  attempt_to_run_hook $vars "portable_hook_after_set_scoop_env_vars `$config `$var"
}

# CREATE CMDER CONFIG FILES
if($vars.isUsing.refs.cmderConfigDir) {
  print_title "Create Cmder Config"
  . ./CreateCmderConfig.ps1
  cmder_config_write $vars $config
  attempt_to_run_hook $vars "portable_hook_after_create_cmder_files `$config `$var"
}

# LAUNCH APPLICATIONS
if($vars.isUsing.refs.appDir) {
  print_title "Launch Applications"
  . ./LaunchApplications
  prompt_to_launch_apps $vars $config
  attempt_to_run_hook $vars "portable_hook_after_launch_apps `$config `$var"
}

exit_program
