# Convert alises declared in bash: [], ps: [], cmd: [], into the aliasesObj: {} 
function convert_config_aliases($config, $nameOfArrayWithAliases) {
  $arrayWithAliases = $config.aliasesObj."$nameOfArrayWithAliases"
}

function create_base_config() {
  if(Test-Path -Path "./portable.config.json") {
    print_info "config" "portable.config.json found. Using portable.config.json"
    $configFile = "./portable.config.json"
  }
  else {
    print_info "config" "portable.config.json not found. Using default.config.json"
    $configFile = "./default.config.json"
  }
  
  $config = New-Object -TypeName PsObject
  try {
    $configAsString = Get-Content -Path $configFile -Raw
    $config = ConvertFrom-Json $configAsString -ErrorAction Stop
  }
  catch {
    print_error "config" "Config not valid JSON. Creating blank configuration object"
    # by default $config is PsObject
  }
  $config
}

function merge_config_from_defaultConfig($config, $defaultConfig) {
  add_prop_to_obj $config "relPathsTo" $(New-Object -TypeName PsObject)
  add_prop_to_obj $config.relPathsTo "applications" $defaultConfig.relPathsTo.applications
  add_prop_to_obj $config.relPathsTo "binaries" $defaultConfig.relPathsTo.binaries
  add_prop_to_obj $config.relPathsTo "cmderConfig" $defaultConfig.relPathsTo.cmderConfig
  add_prop_to_obj $config.relPathsTo "shortcuts" $defaultConfig.relPathsTo.shortcuts
 
  add_prop_to_obj $config "aliasesObj" $(New-Object -TypeName PsObject)
  add_prop_to_obj $config.aliasesObj "bash" $("[]" | ConvertFrom-Json)
  add_prop_to_obj $config.aliasesObj "ps" $("[]" | ConvertFrom-Json)
  add_prop_to_obj $config.aliasesObj "cmd" $("[]" | ConvertFrom-Json)
  add_prop_to_obj $config "aliases" $("[]" | ConvertFrom-Json)
  add_prop_to_obj $config "binaries" $("[]" | ConvertFrom-Json)
  add_prop_to_obj $config "variables" $("[]" | ConvertFrom-Json)

  # convert_config_aliases $config "bash"
  # convert_config_aliases $config"ps"
  # convert_config_aliases $config "cmd"
}

function create_config() {
  $config = create_base_config
  $defaultConfig = Get-Content -Path "./default.config.json" -Raw | ConvertFrom-Json

  merge_config_from_defaultConfig $config $defaultConfig

  $config | ConvertTo-Json | Out-File -FilePath "./abstraction.config.json" -Encoding "ASCII"
  $config
}

function global_vars() {
  print_info "`$vars" "Creating global object"
  New-Object -TypeName PsObject
}
