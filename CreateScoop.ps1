# TODO: Add this stuff to the commands of the Cmder
function set_scoop_env_vars($var, $config) {
  [environment]::setEnvironmentVariable("SCOOP", $var.scoop.mainDir, "User")
  $env:SCOOP = $var.scoop.mainDir

  [environment]::setEnvironmentVariable("SCOOP_GLOBAL", $var.scoop.programsDir, "User")
  $env:SCOOP_GLOBAL= $var.scoop.programsDir
}