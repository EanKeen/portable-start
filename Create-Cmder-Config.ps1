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
        Write-Host "`n`n"
        if ($key.Character -eq 'y') {
            # Yes, overwrite existing config files
            create_config_files $json $var
            $True
        }
        elseif ($key.Character -eq 'n') {
            # No, don't want to overwrite existing config files, do nothing
        }
        else {
            # Any other character, repeat input
            ask_to_create_cmder_config $json $var
        }
    }
    else {
        # No config files exist, make and write to them
        create_config_files $json $var
        $True
    }
}
