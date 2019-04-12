function create_config() {
  if (Test-Path -Path "./portable.config.json") {
    print_info "create_config" "portable.config.json found. Using portable.config.json"
    $configFile = "./portable.config.json"
  }
  else {
    print_info "create_config" "portable.config.json not found. Using default.config.json"
    $configFile = "./default.config.json"
  }
  
  $config = New-Object -TypeName PsObject
  try {
    $configAsString = Get-Content -Path $configFile -Raw
    $config = ConvertFrom-Json $configAsString -ErrorAction Stop
  }
  catch {
    print_error "create_config" "Config not valid JSON. Creating blank configuration object"
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
      add_object_prop $alias "use" $("[]" | ConvertTo-Json | Out-Null) 
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

# MERGE FUNCTIONS
function merge_relPathsTo($config, $defaultConfig) {
  add_object_prop $config "relPathsTo" $(New-Object -TypeName PsObject)
  add_object_prop $config.relPathsTo "applications" $defaultConfig.relPathsTo.applications
  add_object_prop $config.relPathsTo "binaries" $defaultConfig.relPathsTo.binaries
  add_object_prop $config.relPathsTo "cmderConfig" $defaultConfig.relPathsTo.cmderConfig
  add_object_prop $config.relPathsTo "shortcuts" $defaultConfig.relPathsTo.shortcuts
  add_object_prop $config.relPathsTo "sourceToAccessHooks" $defaultConfig.relPathsTo.sourceToAccessHooks
}

function merge_aliases($config, $defaultConfig) {
  add_object_prop $config "aliases" $("[]" | ConvertFrom-Json)

  add_object_prop $config "aliasesObj" $(New-Object -TypeName PsObject)
  add_object_prop $config.aliasesObj "bash" $("[]" | ConvertFrom-Json)
  add_object_prop $config.aliasesObj "ps" $("[]" | ConvertFrom-Json)
  add_object_prop $config.aliasesObj "cmd" $("[]" | ConvertFrom-Json)
  merge_aliases_from_default $config $defaultConfig.aliases
  add_shells_property_for_aliasesObj $config
  merge_aliases_from_aliasesObj $config
}

function check_aliases_use_prop($config) {
  foreach($alias in $config.aliases) {
    if($alias | obj_not_has_prop "use") {
      Add-Member -InputObject $alias -Name "use" -Value @("bash", "ps", "cmd") -MemberType NoteProperty
    }
  }
}

function fill_applications($config) {
  add_object_prop $config "applications" $("[]" | ConvertFrom-Json)

  foreach($app in $config.applications) {
    if($app | obj_not_has_prop "path") {
      print_error "fill_applications" "An application specified does not have the `"path`" property. Add this required property to `"$app`"."
      exit_program
    }

    if($app | obj_not_has_prop "name") {
      $newName = $($app.path).Replace("/", "\").Replace(".", "").Split("\")[0]

      # Convert "strings" => "Strings"
      $newName = (Get-Culture).TextInfo.ToTitleCase($newName.ToLower())
      Add-Member -InputObject $app -Name "name" -Value $newName -MemberType NoteProperty
    }

    if($app | obj_not_has_prop "launch") {
      Add-Member -InputObject $app -Name "launch" -Value "prompt" -MemberType NoteProperty
    }
  }
}

function fill_binaries($config) {
  add_object_prop $config "binaries" $("[]" | ConvertFrom-Json)

  foreach($binary in $config.binaries) {
    if($binary | obj_not_has_prop "path") {
      print_error "fill_binaries" "A binary specified does not have the `"path`" property. Add this required property to `"$app`"."
      exit_program
    }
    if($binary | obj_not_has_prop "name") {
      $newName = $binary.path
      # $newName = $($binary.path).Replace("/", "\").Replace(".", "").Split("\")[0]

      Add-Member -InputObject $binary -Name "name" -Value $newName -MemberType NoteProperty
    }
  }
}

function fill_variables($config) {
  add_object_prop $config "variables" $("[]" | ConvertFrom-Json)
}

function generate_config() {
  $config = create_config
  $defaultConfig = Get-Content -Path "./default.config.json" -Raw | ConvertFrom-Json

  merge_relPathsTo $config $defaultConfig
  merge_aliases $config $defaultConfig
  check_aliases_use_prop $config
  fill_applications $config
  fill_binaries $config
  fill_variables $config

  # Remove the `aliasesObj` property because those have been copied over to `aliases` array
  $config.PsObject.Properties.Remove("aliasesObj")
  $config | ConvertTo-Json -Depth 8 | Out-File -FilePath "./log/abstraction.config.json" -Encoding "ASCII"
  $config
}
