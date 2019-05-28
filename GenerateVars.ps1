function create_from_refs($var, $config) {
  $variables = @(
    @{ configVar="appDir"; internalVar="appDir" },
    @{ configVar="binDir"; internalVar="binDir" },
    @{ configVar="shortcutsDir"; internalVar="shortcutsDir" },
    @{ configVar="scoopAppsDir"; internalVar="scoopAppsDir" },
    @{ configVar="scoopDir"; internalVar="scoopDir" },
    @{ configVar="cmderConfigDir"; internalVar="cmderConfigDir" },
    @{ configVar="hookFile"; internalVar="hookFile"}
  )

  foreach($obj in $variables) {
    if($config.refs.$($obj.configVar) -ne "OMMIT") {
      $absolutePath = (Resolve-Path -Path $config.refs.$($obj.configVar)).Path
      add_object_prop $var $obj.internalVar $absolutePath
    }
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

function create_from_use($var, $config) {
  $use = @(
    @{ configVar="scoop"; internalVar="usingScoop" },
    @{ configVar="appDir"; internalVar="usingAppDir" },
    @{ configVar="shortcutsDir"; internalVar="usingShortcutsDir" }
  )

  foreach($u in $use) {
    $willHave = $false
    if($u -eq "true" -or $u -eq $true -or $u -eq "TRUE") {
      $willHave = $true
    }

    add_object_prop $var $u.internalVar $willHave
  }
}

function print_variables($var) {
  foreach($individualVar in $var.PsObject.Properties) {
    print_info "`$vars.$($individualVar.Name)" $individualVar.Value
  }
}

function generate_vars($config) {
  $var = New-Object -TypeName PsObject

  create_from_refs $var $config
  create_from_cmderConfigDir $var $config
  create_from_use $var $config
  print_variables $var

  $var | ConvertTo-Json -Depth 8 | Out-File -FilePath "./log/abstraction.var.json" -Encoding "ASCII"
  $var
}
