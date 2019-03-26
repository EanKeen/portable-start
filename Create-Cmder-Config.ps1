function write_line_to_file() {}

function cmder_config_write($json, $var) {
    $json.paths | ForEach-Object -Process {
        # loop through each path declared in the json file
        $binaryFileLocation = $_.Name
        $binaryToAddToPath = "$binDir/${path}"
        $binDir = $var.binaryDir

        write_line_to_file "export PATH=/$binDir/${path}:`$PATH".Replace("\", "/").Replace(":/", "/") $var.bashConfig
        write_line_to_file "`$env:Path = `"$binDir/$path;`" + `$env:Path".Replace("\", "/") $var.psConfig
        write_line_to_file "set PATH=$binDir/$path;%PATH%".Replace("\", "/") $var.cmdConfig

        
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${var.bashConfig}`""
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${var.psConfig}`""
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${var.cmdConfig}`""
        Write-Host "`r"
    }
}

# Creates / overwrites config files
function create_config_files($json, $var) {
    # Remove config files if they already exist
    if (Test-Path $var.bashConfig -PathType Leaf) {
        Remove-Item -Path $var.bashConfig
    }
    if (Test-Path $var.psConfig -PathType Leaf) {
        Remove-Item -Path $var.psConfig
    }
    if (Test-Path $var.cmdConfig -PathType Leaf) {
        Remove-Item -Path $var.cmdConfig
    }

    # Create new config items (none should exist in dir now)
    New-Item $var.bashConfig | Out-Null
    New-Item $var.psConfig | Out-Null
    New-Item $var.cmdConfig | Out-Null
}
 
function ask_to_create_cmder_config($json, $var) {
    if ((Test-Path -Path $var.cmdConfig) -or
        (Test-Path -Path $var.psConfig) -or
        (Test-Path -Path $var.bashConfig)) {
        print_warning "You alrady have Cmder config files. Overwrite them?"

        $key = $Host.UI.RawUI.ReadKey()
        Write-Host "`r`n"
        if ($key.Character -eq 'y') {
            # Yes, overwrite existing config files
            create_config_files $json $var
            $true
        }
        elseif ($key.Character -eq 'n') {
            # No, don't want to overwrite existing config files, do nothing
            $false
        }
        else {
            # Any other character, repeat input
            ask_to_create_cmder_config $json $var
        }
    }
    else {
        # No config files exist, make and write to them
        create_config_files $json $var
        $true
    }
}
