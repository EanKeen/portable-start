function global_json() {
  if(Test-Path -Path "./portable.config.json") {
    print_info "config" "portable.config.json found. Using portable.config.json"
    $configFile = "./portable.config.json"
  }
  else {
    print_info "config" "portable.config.json not found. Using default.config.json"
    $configFile = "./default.config.json"
  }
  
  $configJsonString = Get-Content -Path $configFile -Raw
  try {
    $configJson = ConvertFrom-Json $configJsonString -ErrorAction Stop
  }
  catch {
    print_error "config" "Config not valid JSON. Creating blank configuration object"
    $configJson = New-Object -TypeName PsObject
  }
 
  print_info "json" ($configJson | ConvertTo-Json)

  $configJson | ConvertTo-Json | Out-File -FilePath "./abstraction.config.json" -Encoding "ASCII"
  $configJson
}

function global_vars() {
  print_info "`$vars" "Creating global object"
  New-Object -TypeName PsObject
}
