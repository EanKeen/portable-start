function create_folder_variables($var, $json) {
  $absolutePathToBinDir = (Resolve-Path -Path $json.config.relativePathToBinary).Path
  $absolutePathToCmderConfigDir = (Resolve-Path -Path $json.config.relativePathToCmderConfig).Path
  $absolutePathToAppDir = (Resolve-Path -Path $json.config.relativePathToApplications).Path
  $absolutePathToPortableDir = $(Split-Path $PSCommandPath)

  $var | Add-Member -MemberType NoteProperty -Name binDir -Value $absolutePathToBinDir
  $var | Add-Member -MemberType NoteProperty -Name cmderConfigDir -Value $absolutePathToCmderConfigDir
  $var | Add-Member -MemberType NoteProperty -Name appDir -Value $absolutePathToAppDir
  $var | Add-Member -MemberType NoteProperty -Name portableDir -Value $absolutePathToPortableDir
  
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

  $var | Add-Member -MemberType NoteProperty -Name bashConfig -Value $bashConfig
  $var | Add-Member -MemberType NoteProperty -Name psConfig -Value $psConfig
  $var | Add-Member -MemberType NoteProperty -Name cmdConfig -Value $cmdConfig
  $var | Add-Member -MemberType NoteProperty -Name allConfig -value $allConfig
  
  print_info "`$vars.bashConfig" $bashConfig
  print_info "`$vars.psConfig" $psConfig
  print_info "`$vars.cmdConfig" $cmdConfig
  print_info "`$vars.allConfig" $allConfig
}
