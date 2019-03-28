# Check to be sure all paths user is entering is correct
function check_paths_in_config_exist($var, $json) {
  Test-Path $json.config.relativePathToBinary
}
function create_folder_variables($var, $json) {
  $absolutePathToBinDir = (Resolve-Path -Path $json.config.relativePathToBinary).Path
  $absolutePathToCmderConfigDir = (Resolve-Path -Path $json.config.relativePathToCmderConfig).Path
  $absolutePathToAppDir = (Resolve-Path -Path $json.config.relativePathToApplications).Path
  $absolutePathToPortableDir = $(Split-Path $PSCommandPath)

  Add-Member -InputObject $var -MemberType NoteProperty -Name binDir -Value $absolutePathToBinDir
  Add-Member -InputObject $var -MemberType NoteProperty -Name cmderConfigDir -Value $absolutePathToCmderConfigDir
  Add-Member -InputObject $var -MemberType NoteProperty -Name appDir -Value $absolutePathToAppDir
  Add-Member -InputObject $var -MemberType NoteProperty -Name portableDir -Value $absolutePathToPortableDir
  
  print_info "`$vars.binDir" $var.binDir
  print_info "`$vars.cmderConfigDir" $var.cmderConfigDir
  print_info "`$vars.portableDir" $var.portableDir
  print_info "`$vars.appDir" $var.appDir
}

function create_config_file_variables($var, $json) {
  $bashConfig = Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.sh"
  $psConfig = Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.ps1"
  $cmdConfig = Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.cmd"
  $allConfig = "allConfigFiles"

  Add-Member -InputObject $var -MemberType NoteProperty -Name bashConfig -Value $bashConfig
  Add-Member -InputObject $var -MemberType NoteProperty -Name psConfig -Value $psConfig
  Add-Member -InputObject $var -MemberType NoteProperty -Name cmdConfig -Value $cmdConfig
  Add-Member -InputObject $var -MemberType NoteProperty -Name allConfig -value $allConfig
  
  print_info "`$vars.bashConfig" $bashConfig
  print_info "`$vars.psConfig" $psConfig
  print_info "`$vars.cmdConfig" $cmdConfig
  print_info "`$vars.allConfig" $allConfig
}
