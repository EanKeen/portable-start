function create_config() {
  if (Test-Path -Path "./portable.config.json") {
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

function use_shells_for_alias() {
  param(
    [Parameter(Position = 0)]
    [object]
    $config,

    [Parameter(Position = 1)]
    [object]
    $alias,

    [Parameter(Position = 2)]
    [string[]]
    $shells = @("bash", "ps", "cmd")
  )

  process {
    if ($alias.use | obj_not_has_prop "use") {
      add_prop_to_obj $alias "use" $("[]" | ConvertTo-Json | Out-Null)
      foreach ($shell in $shells) {
        $alias.use += $shell
      }
    }
  }
}

function alias_does_not_exist($configAliasArray, $defaultAliasName) {
  $aliasExists = $false
  foreach ($alias in $configAliasArray) {
    if ($alias.name -eq $defaultAliasName) {
      $aliasExists = $true
    }
  }
  !$aliasExists
}

function merge_aliases_from_default($config, $defaultConfigAliasArray) {
  foreach ($alias in $defaultConfigAliasArray) {
    if (alias_does_not_exist $config.aliases $alias.name) {
      $config.aliases = $config.aliases += $alias
      Write-Verbose "add_aliases_to_obj -- Adding $($alias.name)) alias to config"
    }
    else {
      Write-Verbose "add_aliases_to_obj -- Not adding $($alias.name)) alias to config"
    }
  }
}

function add_shells_property_for_aliasesObj($config) {
  foreach ($alias in $config.aliasesObj.bash) {
    use_shells_for_alias $config $alias @("bash")
  }
  foreach ($alias in $config.aliasesObj.ps) {
    use_shells_for_alias $config $alias @("ps")
  }
  foreach ($alias in $config.aliasesObj.cmd) {
    use_shells_for_alias $config $alias @("cmd")
  }
}

function merge_aliases_from_aliasesObj($config) {
  $aliases = @("bash", "ps", "cmd")
  foreach ($aliasArray in $aliases) {
    foreach ($alias in $config.aliasesObj."$aliasArray") {
      $config.aliases += $alias
    }
  }
}

# MERGE FUNCTION
function merge_relPathsTo($config, $defaultConfig) {
  add_prop_to_obj $config "relPathsTo" $(New-Object -TypeName PsObject)
  add_prop_to_obj $config.relPathsTo "applications" $defaultConfig.relPathsTo.applications
  add_prop_to_obj $config.relPathsTo "binaries" $defaultConfig.relPathsTo.binaries
  add_prop_to_obj $config.relPathsTo "cmderConfig" $defaultConfig.relPathsTo.cmderConfig
  add_prop_to_obj $config.relPathsTo "shortcuts" $defaultConfig.relPathsTo.shortcuts
  add_prop_to_obj $config.relPathsTo "sourceToAccessHooks" ""
}

function merge_aliases($config, $defaultConfig) {
  add_prop_to_obj $config "aliases" $("[]" | ConvertFrom-Json)

  add_prop_to_obj $config "aliasesObj" $(New-Object -TypeName PsObject)
  add_prop_to_obj $config.aliasesObj "bash" $("[]" | ConvertFrom-Json)
  add_prop_to_obj $config.aliasesObj "ps" $("[]" | ConvertFrom-Json)
  add_prop_to_obj $config.aliasesObj "cmd" $("[]" | ConvertFrom-Json)
  merge_aliases_from_default $config $defaultConfig.aliases
  add_shells_property_for_aliasesObj $config
  merge_aliases_from_aliasesObj $config
}

function merge_binaries($config, $defaultConfig) {
  add_prop_to_obj $config "binaries" $("[]" | ConvertFrom-Json)
}

function merge_variables($config, $defaultConfig) {
  add_prop_to_obj $config "variables" $("[]" | ConvertFrom-Json)
}

function generate_config() {
  $config = create_config
  $defaultConfig = Get-Content -Path "./default.config.json" -Raw | ConvertFrom-Json

  merge_relPathsTo $config $defaultConfig
  merge_aliases $config $defaultConfig
  merge_binaries $config $defaultConfig
  merge_variables $config $defaultConfig

  $config | ConvertTo-Json -Depth 8 | Out-File -FilePath "./abstraction.config.json" -Encoding "ASCII"
  $config
}
