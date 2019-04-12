# Check to be sure all paths user is entering is correct
# These are not paths added to PATH, but relative paths as properties of `relPathsTo` object

function prompt_to_create_path($pathName, $pathValue) {
  print_info "prompt_to_create_path" "Would you like to create an item at `"$pathValue`" for `"$pathname`"?"
  $key = $Host.UI.RawUI.ReadKey()
  Write-Host "`r`n"
  if($key.Character -eq "y") { }
  elseif($key.Character -eq "n") { return }
  else { prompt_to_create_path $pathName $pathValue }

  if(Test-Path -Path $pathValue -IsValid) {
    New-Item -Path $pathValue -Force | Out-Null
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
  }
  else {
    print_error "check_path_exists" "path `"$pathName`" at `"$pathValue`" reference does not exist"
    prompt_to_create_path $pathName $pathValue
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

