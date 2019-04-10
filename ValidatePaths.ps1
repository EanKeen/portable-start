# Check to be sure all paths user is entering is correct
function create_path($pathName, $pathValue) {
  print_warning "create_path" "Creating item for $pathName at $pathValue"
  $pathLiteralValid = $true
  if($pathLiteralValid) {
    if($pathIsAFolder) {
      New-Item -Path $pathValue -ItemType Directory | Out-Null
    }
    else {
      New-Item -Path $pathValue -ItemType File | Out-Null
    }
    print_info "create_path" "creating path `"pathName`" at `"$pathValue`""
  }
  else {
    print_error "create_path" "Could not create item for $pathName at $pathValue. String not a valid path reference."
    exit_program
  }
}
function check_path_exists($pathName, $pathValue) {
    if (Test-Path -Path $pathValue) {
        print_info "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference exists"
    }
    else {
        print_error "check_path_exists" "path $pathName at `"$pathValue`" reference does not exist"
        # create_path $pathname $pathValue
        # If the path cannot be created, `create-path` function terminates program
    }
}

function validate_relPathsTo($config) {
    foreach ($relativePath in $config.relPathsTo.PsObject.Properties) {
      check_path_exists $relativePath.Name $relativePath.Value
    }
}

function validate_config($config) {
    validate_relPathsTo $config
}

