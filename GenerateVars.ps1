function create_from_refs($var, $config) {
  foreach($ref in $config.refs.PsObject.Properties) {
    if($ref.Value -eq "OMMIT") {
      # add_object_prop $var $ref.Name "OMMIT"
    }
    else {
      $absolutePath = (Resolve-Path -Path $ref.Value).Path
      add_object_prop $var $ref.Name $absolutePath
    }
  }

  add_object_prop $var "isUsing" $(New-Object -TypeName PsObject)
  if($config.refs.scoopAppsDir -eq "OMMIT" -or $config.refs.scoopDir -eq "OMMIT") {
    add_object_prop $var.isUsing "scoop" $false
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

function create_isUsing($var, $config) {
  add_object_prop $var "isUsing" $(New-Object -TypeName PsObject)

  foreach($ref in $config.refs.PsObject.Properties) {
    if($ref.Value -eq "OMMIT") {
      add_object_prop $var.isUsing $ref.Name $false
    }
    else {
      add_object_prop $var.isusing $ref.Name $true
    }
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
  create_isUsing $var $config
  print_variables $var

  $var | ConvertTo-Json -Depth 8 | Out-File -FilePath "./log/abstraction.var.json" -Encoding "ASCII"
  $var
}
