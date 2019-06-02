function add_shell_to_alias() {
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
    add_object_prop $alias "use" $("[]" | ConvertTo-Json | Out-Null)
  
    foreach ($shell in $shells) {
      $alias.use += $shell
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
