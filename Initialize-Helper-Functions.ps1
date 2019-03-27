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

function write_to_config($var, $file, $content) {
    if($file -eq $var.allConfig) {
        write_to_config $var $var.bashConfig $content
        write_to_config $var $var.psConfig $content
        write_to_config $var $var.cmdConfig $content
        return
    }
    # Add-Content -Path $file -Value $content -Encoding "ASCII"
    "$content" | Out-File -Encoding "ASCII" -Append -FilePath $file  
}

function write_comment_to_config($var, $file, $content) {
    if($file -eq $var.allConfig) {
        write_comment_to_config $var $var.bashConfig $content
        write_comment_to_config $var $var.psConfig $content
        write_comment_to_config $var $var.cmdConfig $content
        return
    }
    elseif($file -eq $var.bashConfig) {
        write_to_config $var $var.bashConfig "# $content"
    }
    elseif($file -eq $var.psConfig) {
        write_to_config $var $var.psConfig "# $content"
    }
    elseif($file -eq $var.cmdConfig) {
        write_to_config $var $var.cmdConfig ":: $content"
    }
    print_info "comment" "Adding `"$($content.Substring(0, 15))...`" to `"$(config_file_readable $var $file)`""
}

function write_variable_to_config($var, $file, $variableName, $variableValue) {
    if($file -eq $var.allConfig) {
        write_variable_to_config $var $var.bashConfig $variableName $variableValue
        write_variable_to_config $var $var.psConfig $variableName $variableValue
        write_variable_to_config $var $var.cmdConfig $variableName $variableValue
        return
    }
    elseif($file -eq $var.bashConfig) {
        write_to_config $var $file "$variableName=`"$variableValue`""
    }
    elseif($file -eq $var.psConfig) {
        write_to_config $var $file "`$$variableName=`"$variableValue`""
    }
    elseif($file -eq $var.cmdConfig) {
        write_to_config $var $file "set $variableName=$variableValue"
    }
    print_info "variable" "Setting `"$variableName`" to `"$variableValue`" for `"$(config_file_readable $var $file)`""
}

function write_path_to_config($var, $file, $binName, $content) {
    if($file -eq $var.allConfig) {
        write_path_to_config $var $var.bashConfig $binName $content
        write_path_to_config $var $var.psConfig $binName $content
        write_path_to_config $var $var.cmdConfig $binName $content
        return
    }
    elseif($file -eq $var.bashConfig) {
        write_to_config $vars $var.bashConfig "export PATH=\$((Convert-Path $content)):`$PATH".Replace(":\", "\").Replace("\", "/")
    }
    elseif($file -eq $var.psConfig) {
        write_to_config $vars $var.psConfig "`$env:Path = `"${content};`" + `$env:Path"
    }
    elseif($file -eq $var.cmdConfig) {
        write_to_config $var $var.cmdConfig "set PATH=${content};%PATH%"
    }
    print_info "path" "Adding `"$binName`" to PATH for `"$(config_file_readable $var $file)`""
}

function write_alias_to_config($var, $file, $aliasName, $aliasValue) {
    if($file -eq $var.allConfig) {
        write_alias_to_config $var $var.bashConfig $aliasName $aliasValue
        write_alias_to_config $var $var.psConfig $aliasName $aliasValue
        write_alias_to_config $var $var.cmdConfig $aliasName $aliasValue
        return
    }
    elseif($file -eq $var.bashConfig) {
        write_to_config $var $file "alias $aliasName=`"$aliasValue`""
    }
    elseif($file -eq $var.psConfig) {
        write_to_config $var $file "function fn-$aliasName { $aliasValue }"
        write_to_config $var $file "Set-Alias -Name `"$aliasName`" -Value `"fn-$aliasName`""
    }
    elseif($file -eq $var.cmdConfig) {
        # For now, aliases are not included for batch
        # Append to pre-created user_aliases.cmd
        # Write-Line-To-File "alias $alias=$aliasValue" $file
        # Write-Line-To-File "doskey $alias=$aliasValue" $file
    }
    print_info "alias" "Setting `"$aliasName`" to `"$aliasValue`" for `"$(config_file_readable $var $file)`""
}

function get_directory($dir) {
    (Resolve-Path "$dir").Path
    return
}

function config_file_readable($var, $configFile) {
    if($configFile -eq $var.bashConfig) {
        "user_profile.sh"
    }
    elseif($configFile -eq $var.psConfig) {
        "user_profile.ps1"
    }
    elseif($configFile -eq $var.cmdConfig) {
        "user_profile.cmd"
    }
    return
}

# Combines relative path relative to absolute path
function normalize_path($absPath, $relPath) {
    [IO.Path]::GetFullPath((Join-Path $absPath $relPath))
    return
}