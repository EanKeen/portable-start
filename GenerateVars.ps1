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

# Creates isUsing
function create_isUsing_prop($var, $config, $propName) {
  add_object_prop $var "isUsing" $(New-Object -TypeName PsObject)

  add_object_prop $var.isUsing $propName $(New-Object -TypeName PsObject)

  foreach($option in $config.($propName).PsObject.Properties) {
    if($option.Value -eq "OMIT") {
      add_object_prop $var.isUsing.($propName) $option.Name $false
    }
    else {
      add_object_prop $var.isUsing.($propName) $option.Name $true
    }
  }
}

function create_from_refs($var, $config) {
  add_object_prop $var "refs" $(New-Object -TypeName PsObject)

  foreach($ref in $config.refs.PsObject.Properties) {
    if($ref.Value -eq "OMIT") {
      # add_object_prop $var $ref.Name "OMIT"
    }
    else {
      $absolutePath = (Resolve-Path -Path $ref.Value).Path
      add_object_prop $var.refs $ref.Name $absolutePath
    }
  }

  $cmderConfigMappings = @(
    @{ cmderFileName="user_profile.sh"; internalVar="bashConfig" },
    @{ cmderFileName="user_profile.ps1"; internalVar="psConfig" },
    @{ cmderFileName="user_profile.cmd"; internalVar="cmdConfig" },
    @{ cmderFileName="user_aliases.cmd"; internalVar="cmdUserAliases" }
  )

  foreach($obj in $cmderConfigMappings) {
    $absolutePath = Join-Path -Path $var.refs.cmderConfigDir -ChildPath $obj.cmderFileName
    add_object_prop $var.refs $obj.internalVar $absolutePath
  }

  $allConfig = "allConfigFiles"
  $absolutePathToPortableDir = Split-Path $PSCommandPath

  add_object_prop $var.refs "portableDir" $absolutePathToPortableDir
  add_object_prop $var.refs "allConfig" $allConfig
}

function create_from_scoopRefs($var, $config) {
  add_object_prop $var "scoopRefs" (New-Object -TypeName PsObject)

  foreach($scoopRef in $config.scoopRefs.PsObject.Properties) {
    if($scoopRef.Value -eq "OMIT") {
      # add_object_prop $var $scoopRef.Name "OMIT"
    }
    else {
      $absolutePath = normalize_path $SCOOP_DRIVE $scoopRef.Value
      add_object_prop $var.scoopRefs $scoopRef.Name $absolutePath
    }
  }
}

function print_variables($var) {
  $props = @("opts", "isUsing.refs", "isUsing.scoopRefs", "isUsing.opts", "isUsing.custom", "refs", "scoopRefs")
  
  foreach($object in $var.PsObject.Properties) {
    # Object may not be an object, but we'll treat it like one
    foreach($prop in $var.($object.Name).PsObject.Properties) {
      if($object.Name -eq "isUsing") {
        foreach($p in $var.($object.Name).($prop.Name).PsObject.Properties) {
          print_info "`$vars.$($object.Name).$($prop.Name).$($p.Name)" $p.Value
        }
      }
      else {
        print_info "`$vars.$($object.Name).$($prop.Name)" $prop.Value
      }
    }
  }
}


function generate_vars($config) {
  $var = New-Object -TypeName PsObject

  create_from_opts $var $config

  # CREATE PROPS FOR "isUsing" prop
  add_object_prop $var "isUsing" $(New-Object -TypeName PsObject)
  create_isUsing_prop $var $config "refs"
  create_isUsing_prop $var $config "scoopRefs"
  create_isUsing_prop $var $config "opts"
  create_isUsing_prop $var $cofig "custom"
  
  # Depends on some parts of $var
  create_global_variables $var
  
  # Depends on variables created from create_global_variables 
  create_from_refs $var $config
  create_from_scoopRefs $var $config
  
  print_variables $var 

  $var | ConvertTo-Json -Depth 8 | Out-File -FilePath "./log/abstraction.var.json" -Encoding "ASCII"
  $var
}
