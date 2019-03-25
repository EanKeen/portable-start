# Creates / overwrites config files
function create_config_files($json, $variables) {
  # Remove config files if they already exist
  if(Test-Path $variables.bashConfig -PathType Leaf) {
    Remove-Item -Path $variables.bashConfig
  }
  if(Test-Path $variables.psConfig -PathType Leaf) {
    Remove-Item -Path $variables.psConfig
  }
  if(Test-Path $variables.cmdConfig -PathType Leaf) {
    Remove-Item -Path $variables.cmdConfig
  }

  # Create new config items (none should exist in dir now)
  New-Item $variables.bashConfig | Out-Null
  New-Item $variables.psConfig | Out-Null
  New-Item $variables.cmdConfig | Out-Null
}
 
function cmder_config_ask_create($json, $variables) {
  if((Test-Path -Path $variables.cmdConfig) -or
  (Test-Path -Path $variables.psConfig) -or
  (Test-Path -Path $variables.bashConfig)) {
    print_warning "You alrady have Cmder config files. Overwrite them?"

    $key = $Host.UI.RawUI.ReadKey()
    Write-Host "`n`n"
    if($key.Character -eq 'y') {
      # Yes, overwrite existing config files
      create_config_files $json $variables
      $True
    }
    elseif($key.Character -eq 'n') {
      # No, don't want to overwrite existing config files, do nothing
    }
    else {
      # Any other character, repeat input
      cmder_config_ask_create
    }
  }
  else {
    # No config files exist, make and write to them
    create_config_files $json $variables
    $True
  }
}
