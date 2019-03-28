## Prints with different formatting
function print_title($highlighted) {
  Write-Host "`r`n$highlighted" -BackgroundColor White -ForegroundColor Black
}

function print_info($highlighted, $plain) {
  Write-Host $highlighted -NoNewLine -BackgroundColor DarkGreen -ForegroundColor White
  Write-Host " $plain"
}

function print_warning($highlighted, $plain) {
  Write-Host $highlighted -NoNewLine -BackgroundColor DarkYellow -ForegroundColor White
  Write-Host " $plain"
}

function print_error($highlighted, $plain) {
  Write-Host $highlighted -NoNewLine -BackgroundColor DarkMagenta -ForegroundColor White
  Write-Host " $plain"
}

## Other helper functions
# Combines relative path relative to absolute path
function normalize_path($absPath, $relPath) {
  [IO.Path]::GetFullPath((Join-Path $absPath $relPath))
  return
}

## Writes to a particular Cmder config
function write_to_config($var, $configFile, $content) {
  if($configFile -eq $var.allConfig) {
    write_to_config $var $var.bashConfig $content
    write_to_config $var $var.psConfig $content
    write_to_config $var $var.cmdConfig $content
    return
  }
  # Add-Content -Path $configFile -Value $content -Encoding "ASCII"
  "$content" | Out-File -Encoding "ASCII" -Append -FilePath $configFile  
}

## Writes to a particular Cmder config, but more suited to a specific case (comment, variable, path, alias)
function write_comment_to_config($var, $configFile, $content) {
  if($configFile -eq $var.allConfig) {
    write_comment_to_config $var $var.bashConfig $content
    write_comment_to_config $var $var.psConfig $content
    write_comment_to_config $var $var.cmdConfig $content
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $var.bashConfig "# $content"
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $var.psConfig "# $content"
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $var.cmdConfig ":: $content"
  }
  print_info "comment" "Adding `"$($content.Substring(0, 15))...`" to `"$(Split-Path $configFile -Leaf)`""
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
  print_info "variable" "Setting `"$variableName`" to `"$variableValue`" for `"$(Split-path $configFile -Leaf)`""
}

function write_path_to_config($var, $configFile, $binName, $content) {
  if($configFile -eq $var.allConfig) {
    write_path_to_config $var $var.bashConfig $binName $content
    write_path_to_config $var $var.psConfig $binName $content
    write_path_to_config $var $var.cmdConfig $binName $content
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $vars $var.bashConfig "export PATH=\$((Convert-Path $content)):`$PATH".Replace(":\", "\").Replace("\", "/")
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $vars $var.psConfig "`$env:Path = `"${content};`" + `$env:Path"
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $var.cmdConfig "set PATH=${content};%PATH%"
  }
  print_info "path" "Adding `"$binName`" to PATH for `"$(Split-Path $configFile -Leaf)`""
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
    # For now, aliases are not included for batch
    # Append to pre-created user_aliases.cmd
    # Write-Line-To-File "alias $alias=$aliasValue" $configFile
    # Write-Line-To-File "doskey $alias=$aliasValue" $configFile
  }
  print_info "alias" "Setting `"$aliasName`" to `"$aliasValue`" for `"$(Split-Path -Path $configFile)`""
}
