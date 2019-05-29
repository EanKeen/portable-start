function create_constants($var, $config) {
  add_object_prop $var PORTABLE_DRIVE (Get-Location).Drive.Root
  add_object_prop $var SCOOP_DRIVE (get_scoop_drive)
  add_object_prop $var PORTABLE_DISK_LETTER (Get-Partition -DriveLetter (Get-Location).Drive.Name | Select-Object -ExpandProperty "DiskNumber")
}

function create_from_refs($var, $config) {
  foreach($ref in $config.refs.PsObject.Properties) {
    if($ref.Value -eq "OMIT") {
      # add_object_prop $var $ref.Name "OMIT"
    }
    else {
      $absolutePath = (Resolve-Path -Path $ref.Value).Path
      add_object_prop $var $ref.Name $absolutePath
    }
  }
  
  $absolutePathToPortableDir = (Split-Path $PSCommandPath)
  add_object_prop $var "portableDir" $absolutePathToPortableDir
}

function create_from_scoopRefs($var, $config) {
  add_object_prop $var "scoop" (New-Object -TypeName PsObject)

  foreach($scoopRef in $config.scoopRefs.PsObject.Properties) {
    if($scoopRef.Value -eq "OMIT") {
      # add_object_prop $var $scoopRef.Name "OMIT"
    }
    else {
      $absolutePath = normalize_path (get_scoop_drive) $scoopRef.Value
      add_object_prop $var.scoop $scoopRef.Name $absolutePath
    }
  }
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

function create_from_opts($var, $config) {
  $obj = New-Object -TypeName PsObject
  add_object_prop $var "opts" $obj

  foreach($opt in $config.opts.PsObject.Properties) {
    if($opt.Value -eq "OMIT") {
      # add_object_prop $var $op.Name "OMIT"
    }
    else {
      add_object_prop $var.opts $opt.Name $opt.Value
    }
  }
}

function create_isUsing($var, $config) {
  add_object_prop $var "isUsing" $(New-Object -TypeName PsObject)

  add_object_prop $var.isUsing "refs" $(New-Object -TypeName PsObject)
  foreach($ref in $config.refs.PsObject.Properties) {
    if($ref.Value -eq "OMIT") {
      add_object_prop $var.isUsing.refs $ref.Name $false
    }
    else {
      add_object_prop $var.isusing.refs $ref.Name $true
    }
  }

  add_object_prop $var.isUsing "scoopRefs" (New-Object -TypeName PsObject)
  foreach($scoopRef in $config.scoopRefs.PsObject.Properties) {
    if($scoopRef.Value -eq "OMIT") {
      add_object_prop $var.isUsing.scoopRefs $scoopRef.Name $false
    }
    else {
      add_object_prop $var.isUsing.scoopRefs $scoopRef.Name $true
    }
  }

  add_object_prop $var.isUsing "opts" (New-Object -TypeName PsObject)
  foreach($opt in $config.opts.PsObject.Properties) {
    if($opt.Value -eq "OMIT") {
      add_object_prop $var.isUsing.opts $opt.Name $false
    }
    else {
      add_object_prop $var.isUsing.opts $opt.Name $true
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

  create_constants $var $config
  create_from_refs $var $config
  create_from_scoopRefs $var $config
  create_from_cmderConfigDir $var $config
  create_from_opts $var $config
  create_isUsing $var $config
  print_variables $var

  $var | ConvertTo-Json -Depth 8 | Out-File -FilePath "./log/abstraction.var.json" -Encoding "ASCII"
  $var
}
