function create_folder_variables($json, $variables) {
  $binaryDir = get_directory($json.config.relativePathToBinary)
  $cmderConfigDir = get_directory($json.config.relativePathToCmderConfig)
  $portableDir = $(Split-Path $PSCommandPath)

  $variables | Add-Member -MemberType NoteProperty -Name binaryDir -Value $binaryDir
  $variables | Add-Member -MemberType NoteProperty -Name cmderConfigDir -Value $cmderConfigDir
  $variables | Add-Member -MemberTYpe NoteProperty -Name portableDir -Value $portableDir
  
  print_info "`$variables.binaryDir" $variables.binaryDir
  print_info "`$variables.cmderConfigDir" $variables.cmderConfigDir
  print_info "`$variables.portableDir" $variables.portableDir
}

function create_file_variables($json, $variables) {
  $bashConfig = Join-Path -Path $variables.cmderConfigDir -ChildPath "user_profile.sh"
  $psConfig = Join-Path -Path $variables.cmderConfigDir -ChildPath "user_profile.ps1"
  $cmdConfig = Join-Path -Path $variables.cmderConfigDir -ChildPath "user_profile.cmd"
  $allConfig = "allConfigFiles"

  $variables | Add-Member -MemberType NoteProperty -Name bashConfig -Value $bashConfig
  $variables | Add-Member -MemberType NoteProperty -Name psConfig -Value $psConfig
  $variables | Add-Member -MemberType NoteProperty -Name cmdConfig -Value $cmdConfig
  $variables | Add-Member -MemberType NoteProperty -Name allConfig -value $allConfig
  
  print_info "`$variables.bashConfig" $bashConfig
  print_info "`$variables.psConfig" $psConfig
  print_info "`$variables.cmdConfig" $cmdConfig
  print_info "`$variables.allConfig" $allConfig
}