# Creates / overwrites config files
function create_config_files {
  Set-Location -Path $cmderConfigDir

  # Remove config files if they exist
  if(Test-Path $bashConfig -PathType Leaf) {
    Remove-Item -Include $bashConfig
  }
  if(Test-Path $psConfig -PathType Leaf) {
    Remove-Item -Include $psConfig
  }
  if(Test-Path $cmdConfig -PathType Leaf) {
    Remove-Item -Include $cmdConfig
  }

  # Create new config items (none should exist in dir now)
  New-Item "user_profile.cmd" | Out-Null
  New-Item "user_profile.ps1" | Out-Null
  New-Item "user_profile.sh" | Out-Null

  Set-Location -Path portableDir
}

function cmder_config_exists() {
  Set-Location -Path $cmderConfigDir
  if((Test-Path $cmdConfig) -or (Test-Path $psConfig) -or (Test-Path $bashConfig)) {
    Write-Host "You already have config files. Overwrite them?"
  #}

    $key = $Host.UI.RawUI.ReadKey()
    Write-Host "`n`n"
    if($key.Character -eq 'y') {
      # Yes, overwrite existing config files
      Create-Config-Files
      Write-Config-Files
    }
    elseif($key.Character -eq 'n') {
      # No, don't want to overwrite existing config files, skip to next step
    }
    else {
      # Any other character, repeat input
      Ask-To-Create-Config-Files
    }
  }
  else {
    # No config files exist, make and write to them
    Create-Config-Files
    Write-Config-Files
  }
}

function create_cmder_configs() {
  Set-Location $cmderConfigDir

  # Remove config files if they exist
  if(Test-Path $bashConfig -PathType Leaf) {
    Remove-Item $bashConfig
  }
  if(Test-Path $psConfig -PathType Leaf) {
    Remove-Item $psConfig
  }
  if(Test-Path $cmdConfig -PathType Leaf) {
    Remove-Item $cmdConfig
  }

  # Create new config items (none should exist in dir now)
  New-Item "user_profile.cmd" | Out-Null
  New-Item "user_profile.ps1" | Out-Null
  New-Item "user_profile.sh" | Out-Null
}