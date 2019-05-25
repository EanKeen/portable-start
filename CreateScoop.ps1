# TODO: Add this stuff to the commands of the Cmder
function create_scoop($var, $config) {
  $_scoopFolder = "$($config.binDir)\scoop"
  [environment]::setEnvironmentVariable("SCOOP", $_scoopFolder, "User")
  $env:SCOOP = $_scoopFolder

  [environment]::setEnvironmentVariable("SCOOP_GLOBAL", $vars.scoopAppsDir, "User")
  $env:SCOOP_GLOBAL= $vars.scoopAppsDir
}