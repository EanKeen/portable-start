# Creates / overwrites config files
function create_config_files {
  # Remove config files if they already exist
  if(Test-Path $bashConfig -PathType Leaf) {
    Remove-Item -Path $bashConfig
  }
  if(Test-Path $psConfig -PathType Leaf) {
    Remove-Item -Path $psConfig
  }
  if(Test-Path $cmdConfig -PathType Leaf) {
    Remove-Item -Path $cmdConfig
  }

  # Create new config items (none should exist in dir now)
  New-Item $bashConfig | Out-Null
  New-Item $psConfig | Out-Null
  New-Item $cmdConfig | Out-Null
}

function write_config_files() {

}

function cmder_config_exists() {
  if((Test-Path $cmdConfig) -or (Test-Path $psConfig) -or (Test-Path $bashConfig)) {
    print_warning "You alrady have config files. Overwrite them?"

    $key = $Host.UI.RawUI.ReadKey()
    Write-Host "`n`n"
    if($key.Character -eq 'y') {
      # Yes, overwrite existing config files
      create_config_files
      write_config_files
    }
    elseif($key.Character -eq 'n') {
      # No, don't want to overwrite existing config files, do nothing
    }
    else {
      # Any other character, repeat input
      cmder_config_exists
    }
  }
  else {
    # No config files exist, make and write to them
    create_config_files
    write_config_files
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