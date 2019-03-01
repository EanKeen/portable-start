function create_folder_variables() {
  # Get the directories of folders
  $binaryDir = get_directory($config.relativePathToBinary)
  Set-Variable -Name "binaryDir" -Value $binaryDir -Scope Global
  print_info "binaryDir" $binaryDir

  $cmderConfigDir = get_directory($config.relativePathToCmderConfig)
  Set-Variable -Name "cmderConfigDir" -Value $cmderConfigDir -Scope Global
  print_info "cmderConfigDir" $cmderConfigDir

  $portableDir = $(Split-Path $PSCommandPath)
  Set-Variable -Name "portableDir" -Value $portableDir -Scope Global
  print_info "portableDir" $portableDir
}

function create_file_variables() {
  $bashConfig = Join-Path -Path $cmderConfigDir -ChildPath "user_profile.sh"
  Set-Variable -Name "bashConfig" -Value $bashConfig -Scope Global
  print_info "bashConfig" $bashConfig

  $psConfig = Join-Path -Path $cmderConfigDir -ChildPath "user_profile.ps1"
  Set-Variable -Name "psConfig" -Value $psConfig -Scope Global
  print_info "psConfig" $psConfig

  $cmdConfig = Join-Path -Path $cmderConfigDir -ChildPath "user_profile.cmd"
  Set-Variable -Name "cmdConfig" -Value $cmdConfig -Scope Global
  print_info "cmdConfig" $cmdConfig

  $allConfig = "allConfigFiles"
  Set-Variable -Name "allConfig" -Value $allConfig -Scope Global
  print_info "allConfig" $allConfig
}