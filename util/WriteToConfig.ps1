function write_to_config($var, $configFile, $content) {
  if($configFile -eq $var.allConfig) {
    write_to_config $var $var.bashConfig $content
    write_to_config $var $var.psConfig $content
    write_to_config $var $var.cmdConfig $content
    return
  }
  elseif(($configFile -ne $var.bashConfig) -and ($configFile -ne $var.psConfig) -and ($configFile -ne $var.cmdConfig)) {
    print_warning "write_to_config" "Cannot use write_to_config function on `"$configFile`" because it is not a Cmder config file"
    return
  }

  # Add-Content -Path $configFile -Value $content -Encoding "ASCII"
  "$content" | Out-File -Encoding "ASCII" -Append -FilePath $configFile  
}

## Writes to a particular Cmder config, but more suited to a specific case (comment, variable, path, alias)
function write_comment_to_config($var, $configFile, $comment) {
  if($configFile -eq $var.allConfig) {
    write_comment_to_config $var $var.bashConfig $comment
    write_comment_to_config $var $var.psConfig $comment
    write_comment_to_config $var $var.cmdConfig $comment
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $var.bashConfig "# $comment"
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $var.psConfig "# $comment"
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $var.cmdConfig ":: $comment"
  }
  elseif($configFile -eq $var.cmdUserAliases) {
    ":: $comment" | Out-File -Encoding "ASCII" -Append -FilePath $var.cmdUserAliases
  }

  $commentSnippet = $comment
  if($comment.length -gt 30) {
    $commentSnippet = "$($comment.Substring(0, [System.Math]::Min(30, $comment.Length)))..."
  }
  print_info "write_comment_to_config" "Adding `"$commentSnippet`" to `"$(Split-Path -Path $configFile -Leaf)`""
}

function write_variable_to_config($var, $configFile, $variableName, $variableValue) {
  if($configFile -eq $var.allConfig) {
    write_variable_to_config $var $var.bashConfig $variableName $variableValue
    write_variable_to_config $var $var.psConfig $variableName $variableValue
    write_variable_to_config $var $var.cmdConfig $variableName $variableValue
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $configFile "$variableName=`"$variableValue`""
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $configFile "`$$variableName=`"$variableValue`""
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $configFile "set $variableName=$variableValue"
  }
  elseif($configFile -eq $var.cmdUserAliases) {
    print_warning "write_variable_to_config" "Cannot write variable to `"$$var.cmdUserAliases`" because it can only contain aliases and comments"
    return
  }
  else {
    return
  }
  print_info "write_variable_to_config" "Adding `"$variableName`" to `"$variableValue`" for `"$(Split-path -Path $configFile -Leaf)`""
}

function write_path_to_config($var, $configFile, $binName, $filePath) {
  if($configFile -eq $var.allConfig) {
    write_path_to_config $var $var.bashConfig $binName $filePath
    write_path_to_config $var $var.psConfig $binName $filePath
    write_path_to_config $var $var.cmdConfig $binName $filePath
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $var.bashConfig "export PATH=\$((Convert-Path $filePath)):`$PATH".Replace(":\", "\").Replace("\", "/")
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $var.psConfig "`$env:Path = `"${filePath};`" + `$env:Path"
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $var.cmdConfig "set PATH=${filePath};%PATH%"
  }
  elseif($configFile -eq $var.cmdUserAliases) {
    print_warning "write_path_to_config" "Cannot write path to `"$$var.cmdUserAliases`" because it can only contain aliases and comments"
    return
  }
  else {
    print_warning "write_path_to_config" "Cannot write path to `"$$var.cmdUserAliases`""
    return
  }
  print_info "write_path_to_config" "Adding `"$binName`" to PATH for `"$(Split-Path -Path $configFile -Leaf)`""
}

function write_alias_to_config($var, $configFile, $aliasName, $aliasValue) {
  if($configFile -eq $var.allConfig) {
    write_alias_to_config $var $var.bashConfig $aliasName $aliasValue
    write_alias_to_config $var $var.psConfig $aliasName $aliasValue
    write_alias_to_config $var $var.cmdConfig $aliasName $aliasValue
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $configFile "alias $aliasName=`"$aliasValue`""
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $configFile "function fn-$aliasName { $aliasValue }"
    write_to_config $var $configFile "Set-Alias -Name `"$aliasName`" -Value `"fn-$aliasName`""
  }
  elseif($configFile -eq $var.cmdConfig) {
    "${aliasName}=${aliasValue}" | Out-File -Encoding "ASCII" -Append -FilePath $var.cmdUserAliases
  }
  elseif($configFile -eq $var.cmdUserAliases) {
    print_warning "write_alias_to_config" "Cannot write alias to `"$$var.cmdUserAliases`" because it can only contain aliases and comments"
    return
  }
  else {
    print_warning "write_alias_to_config" "Cannot write path to `"$$var.cmdUserAliases`""
    return
  }
  print_info "write_alias_to_config" "Adding `"$aliasName`" as `"$aliasValue`" for `"$(Split-Path -Path $configFile -Leaf)`""
}
