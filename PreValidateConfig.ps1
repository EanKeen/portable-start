function prevalidate_applications($applications) {
  foreach($app in $applications) {
    if($app | obj_not_has_prop "path") {
      print_error "fill_applications" "An application specified does not have the `"path`" property. Add this required property to `"$app`"."
      exit_program
    }
  }
}

function prevalidate_binaries($binaries) {
  foreach($bin in $binaries) {
    if($bin | obj_not_has_prop "path") {
      print_error "fill_binaries" "A binary specified does not have the `"path`" property. Add this required property to `"$app`"."
      exit_program
    }
  }
}

# TODO: // Check for duplication
function prevalidate_aliases($aliases) {
  foreach($alias in $aliases) {
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

# Validates the user's config *before* any transformations
# // TODO: Verify json is legit and valid before validating
function prevalidate_config() {
  $config = Get-Content -Path "./portable.config.json" -Raw | ConvertFrom-Json

  prevalidate_applications $config.applications
  prevalidate_binaries $config.binaries
  prevalidate_aliases $config.aliases
}
