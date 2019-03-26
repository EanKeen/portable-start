function create_folder_variables($json, $var) {
  $binaryDir = get_directory($json.config.relativePathToBinary)
  $cmderConfigDir = get_directory($json.config.relativePathToCmderConfig)
  $portableDir = $(Split-Path $PSCommandPath)

  $var | Add-Member -MemberType NoteProperty -Name binaryDir -Value $binaryDir
  $var | Add-Member -MemberType NoteProperty -Name cmderConfigDir -Value $cmderConfigDir
  $var | Add-Member -MemberTYpe NoteProperty -Name portableDir -Value $portableDir
  
  print_info "`$vars.binaryDir" $var.binaryDir
  print_info "`$vars.cmderConfigDir" $var.cmderConfigDir
  print_info "`$vars.portableDir" $var.portableDir
}

function create_config_file_variables($json, $var) {
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