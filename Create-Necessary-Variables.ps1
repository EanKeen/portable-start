function create_folder_variables() {
  # Get the directories of folders
  $binaryDir = get_directory($config.relativePathToBinary)
  Set-Variable -Name "binaryDir" -Value $binaryDir -Scope Global
  print_info "Bin Directory:" " $binaryDir"

  $cmderConfigDir = get_directory($config.relativePathToCmderConfig)
  Set-Variable -Name "cmderConfigDir" -Value $cmderConfigDir -Scope Global
  print_info "Cmder Configuration Directory:" " $cmderConfigDir"

  $portableDir = $(Split-Path $PSCommandPath)
  Set-Variable -Name "portableDir" -Value $portableDir -Scope Global
  print_info "Portable Directory:" " $portableDir"
}

function create_file_variables() {
  Set-Variable -Name "bashConfig" -Value "$cmderConfigDir/user_profile.sh" -Scope Global
  print_info ""
  Write-Host "Bash Config "
  Set-Variable -Name "psConfig" -Value "./user_profile.ps1" -Scope Global
  Set-Variable -Name "cmdConfig" -Value "./user_profile.cmd" -Scope Global
  Set-Variable -Name "allConfig" -Value "allConfigFiles" -Scope Global
}