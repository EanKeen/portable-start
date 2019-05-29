# Check to be sure all paths user is entering is correct

function check_path_exists($pathName, $pathValue) {
  if (Test-Path -Path $pathValue) {
    print_info "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference exists"
    return
  }
  else {
    print_error "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference does NOT exist. Create the path or edit your config object"
    exit_program
  }
}

function validate_applications($config) {
  foreach($app in $config.applications) {
    $normalizedAppDir = normalize_path $config.refs.appDir $app.path
    check_path_exists $app.name $normalizedAppDir
  }
}

function validate_binaries($config) {
  foreach($binary in $config.binaries) {
    $normalizedBinDir = normalize_path $config.refs.binDir $binary.path
    check_path_exists $binary.name $normalizedBinDir
  }
}

function validate_refs($config) {
  foreach ($relativePath in $config.refs.PsObject.Properties) {
    if($relativePath.Value -ne "OMIT") {
      $absolutePath = normalize_path (Get-Location).Path $relativePath.Value
      check_path_exists $relativePath.Name $absolutePath
    }
  }
}

function validate_scoopRefs($config) {
  foreach ($relativePath in $config.scoopRefs.PsObject.Properties) {
    if($relativePath.Value -ne "OMIT") {
      $absolutePath = normalize_path (get_scoop_drive) $relativePath.Value
      check_path_exists $relativePath.Name $absolutePath
    }
  }
}

function validate_config($config, $var) {
  validate_applications $config
  validate_binaries $config
  validate_refs $config
  validate_scoopRefs $config
}
