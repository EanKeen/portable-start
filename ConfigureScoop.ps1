function configure_scoop($config) {
  [environment]::setEnvironmentVariable("SCOOP", $config.scoopMainDir, "User")
  $env:SCOOP = $config.scoopMainDir

  [environment]::setEnvironmentVariable("SCOOP_GLOBAL", $config.scoopGlobalDir, "User")
  $env:SCOOP_GLOBAL= $config.scoopGlobalDir
}
