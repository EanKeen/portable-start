function write_to_config($var, $configFile, $content) {
  if($configFile -eq $var.refs.allConfig) {
    write_to_config $var $var.refs.bashConfig $content
    write_to_config $var $var.refs.psConfig $content
    write_to_config $var $var.refs.cmdConfig $content
    return
  }
  elseif(($configFile -ne $var.refs.bashConfig) -and ($configFile -ne $var.refs.psConfig) -and ($configFile -ne $var.refs.cmdConfig)) {
    print_warning "write_to_config" "Cannot use write_to_config function on `"$configFile`" because it is not a Cmder config file"
    return
  }

  # Add-Content -Path $configFile -Value $content -Encoding "ASCII"
  "$content" | Out-File -Encoding "ASCII" -Append -FilePath $configFile  
}

## Writes to a particular Cmder config, but more suited to a specific case (comment, variable, path, alias)
function write_comment_to_config($var, $configFile, $comment) {
  if($configFile -eq $var.refs.allConfig) {
    write_comment_to_config $var $var.refs.bashConfig $comment
    write_comment_to_config $var $var.refs.psConfig $comment
    write_comment_to_config $var $var.refs.cmdConfig $comment
    return
  }
  elseif($configFile -eq $var.refs.bashConfig) {
    write_to_config $var $var.refs.bashConfig "# $comment"
  }
  elseif($configFile -eq $var.refs.psConfig) {
    write_to_config $var $var.refs.psConfig "# $comment"
  }
  elseif($configFile -eq $var.refs.cmdConfig) {
    write_to_config $var $var.refs.cmdConfig ":: $comment"
  }
  elseif($configFile -eq $var.refs.cmdUserAliases) {
    ":: $comment" | Out-File -Encoding "ASCII" -Append -FilePath $var.refs.cmdUserAliases
  }

  $commentSnippet = $comment
  if($comment.length -gt 30) {
    $commentSnippet = "$($comment.Substring(0, [System.Math]::Min(30, $comment.Length)))..."
  }
  print_info "write_comment_to_config" "Adding `"$commentSnippet`" to `"$(Split-Path -Path $configFile -Leaf)`""
}

function write_variable_to_config($var, $configFile, $variableName, $variableValue) {
  if($configFile -eq $var.refs.allConfig) {
    write_variable_to_config $var $var.refs.bashConfig $variableName $variableValue
    write_variable_to_config $var $var.refs.psConfig $variableName $variableValue
    write_variable_to_config $var $var.refs.cmdConfig $variableName $variableValue
    return
  }
  elseif($configFile -eq $var.refs.bashConfig) {
    write_to_config $var $configFile "$variableName=`"$variableValue`""
  }
  elseif($configFile -eq $var.refs.psConfig) {
    write_to_config $var $configFile "`$$variableName=`"$variableValue`""
  }
  elseif($configFile -eq $var.refs.cmdConfig) {
    write_to_config $var $configFile "set $variableName=$variableValue"
  }
  elseif($configFile -eq $var.refs.cmdUserAliases) {
    print_warning "write_variable_to_config" "Cannot write variable to `"$$var.refs.cmdUserAliases`" because it can only contain aliases and comments"
    return
  }
  else {
    return
  }
  print_info "write_variable_to_config" "Adding `"$variableName`" to `"$variableValue`" for `"$(Split-path -Path $configFile -Leaf)`""
}

function write_path_to_config($var, $configFile, $binName, $filePath) {
  if($configFile -eq $var.refs.allConfig) {
    write_path_to_config $var $var.refs.bashConfig $binName $filePath
    write_path_to_config $var $var.refs.psConfig $binName $filePath
    write_path_to_config $var $var.refs.cmdConfig $binName $filePath
    return
  }
  elseif($configFile -eq $var.refs.bashConfig) {
    write_to_config $var $var.refs.bashConfig "export PATH=\$((Convert-Path $filePath)):`$PATH".Replace(":\", "\").Replace("\", "/")
  }
  elseif($configFile -eq $var.refs.psConfig) {
    write_to_config $var $var.refs.psConfig "`$env:Path = `"${filePath};`" + `$env:Path"
  }
  elseif($configFile -eq $var.refs.cmdConfig) {
    write_to_config $var $var.refs.cmdConfig "set PATH=${filePath};%PATH%"
  }
  elseif($configFile -eq $var.refs.cmdUserAliases) {
    print_warning "write_path_to_config" "Cannot write path to `"$$var.refs.cmdUserAliases`" because it can only contain aliases and comments"
    return
  }
  else {
    print_warning "write_path_to_config" "Cannot write path to `"$$var.refs.cmdUserAliases`""
    return
  }
  print_info "write_path_to_config" "Adding `"$binName`" to PATH for `"$(Split-Path -Path $configFile -Leaf)`""
}

function write_alias_to_config($var, $configFile, $aliasName, $aliasValue) {
  if($configFile -eq $var.refs.allConfig) {
    write_alias_to_config $var $var.refs.bashConfig $aliasName $aliasValue
    write_alias_to_config $var $var.refs.psConfig $aliasName $aliasValue
    write_alias_to_config $var $var.refs.cmdConfig $aliasName $aliasValue
    return
  }
  elseif($configFile -eq $var.refs.bashConfig) {
    write_to_config $var $configFile "alias $aliasName=`"$aliasValue`""
  }
  elseif($configFile -eq $var.refs.psConfig) {
    write_to_config $var $configFile "function fn-$aliasName { $aliasValue }"
    write_to_config $var $configFile "Set-Alias -Name `"$aliasName`" -Value `"fn-$aliasName`""
  }
  elseif($configFile -eq $var.refs.cmdConfig) {
    "${aliasName}=${aliasValue}" | Out-File -Encoding "ASCII" -Append -FilePath $var.refs.cmdUserAliases
  }
  elseif($configFile -eq $var.refs.cmdUserAliases) {
    print_warning "write_alias_to_config" "Cannot write alias to `"$$var.refs.cmdUserAliases`" because it can only contain aliases and comments"
    return
  }
  else {
    print_warning "write_alias_to_config" "Cannot write path to `"$$var.refs.cmdUserAliases`""
    return
  }
  print_info "write_alias_to_config" "Adding `"$aliasName`" as `"$aliasValue`" for `"$(Split-Path -Path $configFile -Leaf)`""
}
