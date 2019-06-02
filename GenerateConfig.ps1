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

function merge_aliases($config, $defaultConfig) {
  $arr = "[]" | ConvertFrom-Json
  $obj = New-Object -TypeName PsObject
  
  add_object_prop $config "aliases" $arr

  add_object_prop $config "aliasesObj" $obj
  add_object_prop $config.aliasesObj "bash" $arr
  add_object_prop $config.aliasesObj "ps" $arr
  add_object_prop $config.aliasesObj "cmd" $arr

  # Only add alias to array if defaultAlias is not present in regular config
  foreach ($alias in ($defaultConfig.aliases)) {
    if (alias_does_not_exist $config.aliases $alias.name) {
      $config.aliases = $config.aliases += $alias
    }
  }

  foreach($alias in $config.aliases) {
    if($alias | obj_not_has_prop "use") {
      Add-Member -InputObject $alias -Name "use" -Value @("bash", "ps", "cmd") -MemberType NoteProperty
    }
  }
}

# aliasObj does not merge from default.config.json because default.config.json doesn't contain `aliasesObj`
function merge_aliasesObj($config) {
  $aliases = @("bash", "ps", "cmd")
  foreach ($genericAlias in $aliases) {
    # specificAlias represents an actual alias entry in the config file
    foreach ($specificAlias in $config.aliasesObj.($genericAlias)) {
      $config.aliases += $specificAlias
    }
  }

   # Add the .use property for each alias object
   foreach ($alias in $config.aliasesObj.bash) {
    add_shell_to_alias $config $alias @("bash")
  }
  foreach ($alias in $config.aliasesObj.ps) {
    add_shell_to_alias $config $alias @("ps")
  }
  foreach ($alias in $config.aliasesObj.cmd) {
    add_shell_to_alias $config $alias @("cmd")
  }
}

function merge_refs($config, $defaultConfig) {
  $obj = New-Object -TypeName PsObject

  add_object_prop $config "refs" $obj

  foreach($ref in $defaultConfig.refs.PsObject.Properties) {
    add_object_prop $config.refs $ref.Name $defaultConfig.refs.($ref.Name)
  }
}

function merge_scoopRefs($config, $defaultConfig) {
  $obj = New-Object -TypeName PsObject
  add_object_prop $config "scoopRefs" $obj

  foreach($scoopRef in $defaultConfig.scoopRefs.PsObject.Properties) {
    add_object_prop $config.scoopRefs $scoopRef.Name $defaultConfig.scoopRefs.($scoopRef.Name)
  }
}

function merge_opts($config, $defaultConfig) {
  $obj = New-Object -TypeName PsObject
  add_object_prop $config "opts" $obj

  foreach($opt in $defaultConfig.opts.PsObject.Properties) {
    add_object_prop $config.opts $opt.Name $defaultConfig.opts.($opt.Name)
  }
}

function fill_applications($config) {
  $arr = "[]" | ConvertFrom-Json
  add_object_prop $config "applications" $arr

  foreach($app in $config.applications) {
    if($app | obj_not_has_prop "name") {
      $oldName = $app.path
      $newName

      $key = "\"
      if($oldName.IndexOf("\") -eq -1) { $key = "/" }

      $lastPathDelimiter = $oldName.LastIndexOf($key) + 1
      $upToDot = $oldName.LastIndexOf(".") - 1

      if($upToDot -le 1) { $upToDot = $oldName.Length }

      $newName = $oldName.Substring($lastPathDelimiter, $oldName.Length - $upToDot)
    
      # Convert "strings" => "Strings"
      # $newName = (Get-Culture).TextInfo.ToTitleCase($newName.ToLower())
      add_object_prop $app "name" $newName
    }

    if($app | obj_not_has_prop "launch") {
      add_object_prop $app "launch" "prompt"
    }
  }
}

function fill_binaries($config) {
  $arr = "[]" | ConvertFrom-Json
  add_object_prop $config "binaries" $arr

  foreach($binary in $config.binaries) {
    if($binary | obj_not_has_prop "name") {
      $newName = $binary.path
      $newName = $($binary.path).Replace("/", "\").Replace(".", "").Split("\")[0]

      add_object_prop $binary "name" $newname
    }
  }
}

function fill_variables($config) {
  $arr = "[]" | ConvertFrom-Json

  add_object_prop $config "variables" $arr
}

function generate_config() {
  $config = create_config
  $defaultConfig = Get-Content -Path "./default.config.json" -Raw | ConvertFrom-Json

  merge_aliases $config $defaultConfig
  merge_aliasesObj $config
  merge_refs $config $defaultConfig
  merge_scoopRefs $config $defaultConfig
  merge_opts $config $defaultConfig

  # Nothing to merge, just filling
  fill_applications $config
  fill_binaries $config
  fill_variables $config

  # Remove the `aliasesObj` property because those have been copied over to `aliases` array
  $config.PsObject.Properties.Remove("aliasesObj")
  $config | ConvertTo-Json -Depth 8 | Out-File -FilePath "./log/abstraction.config.json" -Encoding "ASCII"
  $config
}
