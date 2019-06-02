function prevalidate_aliases($config) {
  foreach($alias in $config.aliases) {
    if($alias | obj_not_has_prop "name") {
      print_error "prevalidate_aliases" "Alias must have property `"name`""
      exit_program
    }

    if($alias | obj_not_has_prop "value") {
      print_error "prevalidate_aliases" "Alias must have property `"value`""
      exit_program
    }
  }
}

function prevalidate_aliasesObj($config) {
  foreach($shell in $config.aliasesObj.PsObject.Properties) {
    foreach($shellEntry in $shell) {
      if($shellEntry | obj_not_has_prop "name") {
        print_error "prevalidate_aliasesObj" "Shell entries must have property `"name`""
        exit_program
      }

      if($shellEntry | obj_not_has_prop "value") {
        print_error "prevalidate_aliasesObj" "Shell entries must have property `"value`""
        exit_program
      }
    }
  }
}

function prevalidate_applications($config) {
  # All props exist
  foreach($app in $config.applications) {
    if($app | obj_not_has_prop "path") {
      print_error "prevalidate_applications" "An application specified does not have the `"path`" property. Add this required property to `"$app`""
      exit_program
    }
  }

  # Make sure that it contains slashes
  foreach($app in $config.applications) {
    if($app.path.IndexOf("/") -eq -1 -and $app.path.IndexOf("\") -eq -1) {
      print_error "prevalidate_applications" "You do not have any forward or backwards slashes in your path. Please add them"
      exit_program
    }
  }

  foreach($app in $config.applications) {
    if($app.path.IndexOf("/") -ne -1 -and $app.path.IndexOf("\") -ne -1) {
      print_error "prevalidate_applications" "You have both forward and backwards slashes in your path. Please only use one"
      exit_program
    }
  }
}

function prevalidate_binaries($config) {
  # All props exist
  foreach($bin in $config.binaries) {
    if($bin | obj_not_has_prop "path") {
      print_error "prevalidate_binaries" "A binary specified does not have the `"path`" property. Add this required property to `"$app`""
      exit_program
    }
  }
}

function prevalidate_refs($config) {
  foreach($ref in $config.refs.PsObject.Properties) {
    if($ref -eq "OMITT" -or $ref -eq "OMITT" -or $ref -eq "OMMITT") {
      print_error "prevalidate_refs" "Did you mean to type `"OMIT`"?"
      exit_program
    }
  }
}

function prevalidate_scoopRefs($config) {
  foreach($scoopRef in $config.scoopRefs.PsObject.Properties) {
    if($scoopRef -eq "OMITT" -or $scoopRef -eq "OMITT" -or $scoopRef -eq "OMMITT") {
      print_error "prevalidate_scoopRefs" "Did you mean to type `"OMIT`"?"
      exit_program
    }
  }
}

# For validatoins that neither require $config or $var
function prevalidate_config() {
  $config = Get-Content -Path "./portable.config.json" -Raw | ConvertFrom-Json

  prevalidate_aliases $config
  prevalidate_aliasesObj $config
  prevalidate_applications $config
  prevalidate_binaries $config
  prevalidate_refs $config
  prevalidate_scoopRefs $config

  print_info "prevalidate_config" "Checked errors in portable config not found"
}
