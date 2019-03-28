function create_folder_variables($var, $json) {
  $binDir = get_directory($json.config.relativePathToBinary)
  $cmderConfigDir = get_directory($json.config.relativePathToCmderConfig)
  $appDir = get_directory($json.config.relativePathToApplications)
  $portableDir = $(Split-Path $PSCommandPath)

  $var | Add-Member -MemberType NoteProperty -Name binDir -Value $binDir
  $var | Add-Member -MemberType NoteProperty -Name cmderConfigDir -Value $cmderConfigDir
  $var | Add-Member -MemberType NoteProperty -Name portableDir -Value $portableDir
  $var | Add-Member -MemberType NoteProperty -Name appDir -Value $appDir
  
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
