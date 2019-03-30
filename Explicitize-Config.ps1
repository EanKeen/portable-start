function global_json() {
  $configJson = New-Object -TypeName PsObject
  if(Test-Path -Path "./portable.config.json") {
    print_info "config" "portable.config.json found. Using portable.config.json"

    $configJson = Get-Content -Path "./portable.config.json" | ConvertFrom-Json
  }
  # If no portable config found use default.config.json
  else {
    print_info "config" "portable.config.json not found. Using default.config.json"

    $configJson = Get-Content -Path "./default.config.json" | ConvertFrom-Json
  }
  
  if($configJson | ConvertTo-Json | Test-Json) {
    $configJson = $configJson 
  }
  else {
    print_error "config" "Config not valid JSON. Creating blank configuration object"
    $configJson = New-Object -TypeName PsObject
  }

  $configJson | ConvertTo-Json | Out-File -FilePath "./abstraction.config.json" -Encoding "ASCII"
}

function global_vars() {
  print_info "`$vars" "Creating global object"
  New-Object -TypeName PsObject
}
