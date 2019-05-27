# Check to be sure all paths user is entering is correct

function check_path_exists($pathName, $pathValue) {
  if (Test-Path -Path $pathValue) {
    print_info "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference exists"
    return
  }
  elseif($pathValue -eq "OMMIT") {
    
  }
  else {
    print_error "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference does NOT exist. Create the path or edit your config object"
    exit_program
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

