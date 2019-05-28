# Check to be sure all paths user is entering is correct

function check_path_exists($pathName, $pathValue) {
  if($pathValue -eq "OMMIT") {
    return
  }
  elseif (Test-Path -Path $pathValue) {
    print_info "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference exists"
    return
  }
  else {
    print_error "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference does NOT exist. Create the path or edit your config object"
    exit_program
  }
}

function validate_refs($config) {
  foreach ($relativePath in $config.refs.PsObject.Properties) {
    check_path_exists $relativePath.Name $relativePath.Value
  }
}

function validate_bins($config) {
  foreach($binary in $config.binaries) {
    $normalizedBin = normalize_path $config.refs.binDir $binary.path
    check_path_exists $binary.name $normalizedBin
  }
}

function validate_config($config) {
  validate_refs $config
  validate_bins $config
}

