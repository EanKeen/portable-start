function add_relPathsTo_prop($config, $defaultConfig) {
  # Write-Host $($config | obj_has_prop -prop "relPathsTo")
  if(-not ($config | obj_has_prop "relPathsTo")) {
    Add-Member -InputObject $config -Name "relPathsTo" -Value $defaultConfig.relPathsTo -MemberType NoteProperty
    return
  }
  add_relPathsTo_prop $config $defaultConfig

  print_error "my" $($config | ConvertTo-Json)
}

function global_json() {
  if(Test-Path -Path "./portable.config.json") {
    print_info "config" "portable.config.json found. Using portable.config.json"
    $configFile = "./portable.config.json"
  }
  else {
    print_info "config" "portable.config.json not found. Using default.config.json"
    $configFile = "./default.config.json"
  }
  
  try {
    $configAsString = Get-Content -Path $configFile -Raw
    $config = ConvertFrom-Json $configAsString -ErrorAction Stop
  }
  catch {
    print_error "config" "Config not valid JSON. Creating blank configuration object"
    $config = New-Object -TypeName PsObject
  }
  
  $defaultConfig = Get-Content -Path "./default.config.json"
  add_relPathsTo_prop $config $defaultConfig

  $config | ConvertTo-Json | Out-File -FilePath "./abstraction.config.json" -Encoding "ASCII"
  $config
}

function global_vars() {
  print_info "`$vars" "Creating global object"
  New-Object -TypeName PsObject
}
