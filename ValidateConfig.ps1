# Check to be sure all paths user is entering is correct

function prompt_to_create_path($pathName, $pathValue) {
  print_info "prompt_to_create_path" "Would you like to create a *folder* at `"$pathValue`" for `"$pathName`"?"
  $key = $Host.UI.RawUI.ReadKey()
  Write-Host "`r`n"
  if($key.Character -eq "y") { }
  elseif($key.Character -eq "n") {
    print_error "prompt_to_create_path" "Please create the item at `"$pathValue`" for `"$pathName`""
    exit_program
  }
  else { prompt_to_create_path $pathName $pathValue }

  if(Test-Path -Path $pathValue -IsValid) {
    # Write-Host (Test-Path -Path $pathValue -PathType Container)
    ## Not sure why this doesn't work. TODO: Fix
    if(Test-Path -Path $pathValue -PathType Leaf) {
      New-Item -Path $pathValue -ItemType File -Force | Out-Null
    }
    elseif(Test-Path -Path $pathValue -PathType Container) {
      Write-Host "thing"
      New-Item -Path $pathValue -ItemType Directory -Force | Out-Null
    }
    else {
      New-Item -Path $pathValue -ItemType Directory -Force | Out-Null
    }
    print_info "prompt_to_create_path" "creating path `"$pathName`" at `"$pathValue`""
  }
  else {
    print_error "prompt_to_create_path" "Could not create item for $pathName at $pathValue. String not a valid path reference."
    exit_program
  }
}

function check_path_exists($pathName, $pathValue) {
  if (Test-Path -Path $pathValue) {
    print_info "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference exists"
    return
  }
  else {
    print_error "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference does not exist"
    prompt_to_create_path $pathName $pathValue
  }
}

function validate_relPathsTo($config) {
  foreach ($relativePath in $config.relPathsTo.PsObject.Properties) {
    check_path_exists $relativePath.Name $relativePath.Value $true
  }
}

function validate_bins($config) {
  foreach($binary in $config.binaries) {
    $normalizedBin = normalize_path $config.relPathsTo.binaries $binary.path
    check_path_exists $binary.name $normalizedBin $true
  }
}

function validate_config($config) {
  validate_relPathsTo $config
  validate_bins $config
}

