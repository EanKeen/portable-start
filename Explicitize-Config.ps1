function add_props_to_relPathsTo_prop($config, $defaultConfig) {
  if($config.relPathsTo | obj_not_has_prop "applications") {
    Add-Member -InputObject $config -Name "applications" -Value $defaultConfig.relPathsTo.applications -MemberType NoteProperty
  }
  if($config.relPathsTo | obj_not_has_prop "binaries") {
    Add-Member -InputObject $config -Name "binaries" -Value $defaultConfig.relPathsTo.binaries -MemberType NoteProperty
  }
  if($config.relPathsTo | obj_not_has_prop "cmderConfig") {
    Add-Member -InputObject $config -Name "cmderConfig" -Value $defaultConfig.relPathsTo.cmderConfig -MemberType NoteProperty
  }
  if($config.relPathsTo | obj_not_has_prop "shortcuts") {
    Add-Member -InputObject $config -Name "shortcuts" -Value $defaultConfig.relPathsTo.shortcuts -MemberType NoteProperty
  }
  if($config.relPathsTo | obj_not_has_prop "sourceToAccessHooks") {
    Add-Member -InputObject $config -Name "sourceToAccessHooks" -Value "" -MemberType NoteProperty
  }
}

function add_relPathsTo_prop($config, $defaultConfig) {
  if($config | obj_not_has_prop "relPathsTo") {
    Add-Member -InputObject $config -Name "relPathsTo" -Value $(New-Object -TypeName PsObject) -MemberType NoteProperty
    return
  }
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
  
  $defaultConfig = Get-Content -Path "./default.config.json" -Raw | ConvertFrom-Json
  add_relPathsTo_prop $config $defaultConfig
  add_props_to_relPathsTo_prop $config $defaultConfig

  $config | ConvertTo-Json | Out-File -FilePath "./abstraction.config.json" -Encoding "ASCII"
  $config
}

function global_vars() {
  print_info "`$vars" "Creating global object"
  New-Object -TypeName PsObject
}
