# TODO: Add this stuff to the commands of the Cmder
function set_scoop_env_vars($var) {
  [environment]::setEnvironmentVariable("SCOOP", $var.scoopRefs.mainDir, "User")
  $env:SCOOP = $var.scoopRefs.mainDir

  [environment]::setEnvironmentVariable("SCOOP_GLOBAL", $var.scoopRefs.programsDir, "User")
  $env:SCOOP_GLOBAL= $var.scoopRefs.programsDir
}

# Explicitly add Scoop to the PATH
function add_scoop_path($var) {
  write-host "doing it now"
  write_comment_to_config $var $var.refs.allConfig "Add Scoop to path - from ConfigureScoop.ps1"
  $scoopPath = normalize_path $var.scoopRefs.mainDir "./shims"
  write_path_to_config $var $var.refs.allConfig "Scoop" $scoopPath
}

function configure_scoop($var) {
  set_scoop_env_vars $var
  add_scoop_path $var
}
