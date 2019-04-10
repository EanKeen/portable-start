function create_folder_variables($var, $config) {
  $absolutePathToBinDir = (Resolve-Path -Path $config.relPathsTo.binaries).Path
  $absolutePathToCmderConfigDir = (Resolve-Path -Path $config.relPathsTo.cmderConfig).Path
  $absolutePathToAppDir = (Resolve-Path -Path $config.relPathsTo.applications).Path
  $absolutePathToPortableDir = $(Split-Path $PSCommandPath)

  add_object_prop $var "binDir" $absolutePathToBinDir
  add_object_prop $var "cmderConfigDir" $absolutePathToCmderConfigDir
  add_object_prop $var "appDir" $absolutePathToAppDir
  add_object_prop $var "portableDir" $absolutePathToPortableDir

  print_info "`$vars.binDir" $var.binDir
  print_info "`$vars.cmderConfigDir" $var.cmderConfigDir
  print_info "`$vars.portableDir" $var.portableDir
  print_info "`$vars.appDir" $var.appDir
}

function create_cmder_profile_variables($var, $config) {
  $bashConfig = Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.sh"
  $psConfig = Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.ps1"
  $cmdConfig = Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.cmd"
  $allConfig = "allConfigFiles"

  add_object_prop $var "bashConfig" $bashConfig
  add_object_prop $var "psConfig" $psConfig
  add_object_prop $var "cmdConfig" $cmdConfig
  add_object_prop $var "allConfig" $allConfig

  print_info "`$vars.bashConfig" $bashConfig
  print_info "`$vars.psConfig" $psConfig
  print_info "`$vars.cmdConfig" $cmdConfig
  print_info "`$vars.allConfig" $allConfig
}

function generate_vars($config) {
  $vars = New-Object -TypeName PsObject

  create_folder_variables $vars $config
  create_cmder_profile_variables $vars $config
  print_error "var" $($vars | ConvertTo-Json -Depth 8)
  $vars
}
