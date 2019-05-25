function create_fromRelPathsTo($var, $config) {
  $variables = @(
    @{ configVar="applications"; internalVar="appDir" },
    @{ configVar="binaries"; internalVar="binDir" },
    @{ configVar="shortcuts"; internalVar="shortcutsDir" },
    @{ configVar="scoopApps"; internalVar="scoopAppsDir" },
    @{ configVar="cmderConfig"; internalVar="cmderConfigDir" },
    @{ configVar="sourceToAccessHooks"; internalVar="sourceToAccessHooks"}
  )

  foreach($obj in $variables) {
    $absolutePath = (Resolve-Path -Path $config.relPathsTo.$($obj.configVar)).Path
      add_object_prop $var $obj.internalVar $absolutePath
  }
  
  $absolutePathToPortableDir = $(Split-Path $PSCommandPath)
  add_object_prop $var "portableDir" $absolutePathToPortableDir
}

function create_from_cmderConfigDir($var, $config) {
  $variables = @(
    @{ cmderFileName="user_profile.sh"; internalVar="bashConfig" },
    @{ cmderFileName="user_profile.ps1"; internalVar="psConfig" },
    @{ cmderFileName="user_profile.cmd"; internalVar="cmdConfig" },
    @{ cmderFileName="user_aliases.cmd"; internalVar="cmdUserAliases" }
  )

  foreach($obj in $variables) {
    $absolutePath = Join-Path -Path $var.cmderConfigDir -ChildPath $obj.cmderFileName
    add_object_prop $var $obj.internalVar $absolutePath
  }

  $allConfig = "allConfigFiles"
  add_object_prop $var "allConfig" $allConfig
}

function print_variables($var) {
  foreach($individualVar in $var.PsObject.Properties) {
    print_info "`$vars.$($individualVar.Name)" $individualVar.Value
  }
}

function generate_vars($config) {
  $var = New-Object -TypeName PsObject

  create_fromRelPathsTo $var $config
  create_from_cmderConfigDir $var $config
  print_variables $var

  $var | ConvertTo-Json -Depth 8 | Out-File -FilePath "./log/abstraction.var.json" -Encoding "ASCII"
  $var
}
