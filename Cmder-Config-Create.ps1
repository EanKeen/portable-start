# Creates / overwrites config files
function create_config_files($json, $v) {
    # Remove config files if they already exist
    if (Test-Path $v.bashConfig -PathType Leaf) {
        Remove-Item -Path $v.bashConfig
    }
    if (Test-Path $v.psConfig -PathType Leaf) {
        Remove-Item -Path $v.psConfig
    }
    if (Test-Path $v.cmdConfig -PathType Leaf) {
        Remove-Item -Path $v.cmdConfig
    }

    # Create new config items (none should exist in dir now)
    New-Item $v.bashConfig | Out-Null
    New-Item $v.psConfig | Out-Null
    New-Item $v.cmdConfig | Out-Null
}
 
function cmder_config_ask_create($json, $v) {
    if ((Test-Path -Path $v.cmdConfig) -or
        (Test-Path -Path $v.psConfig) -or
        (Test-Path -Path $v.bashConfig)) {
        print_warning "You alrady have Cmder config files. Overwrite them?"

        $key = $Host.UI.RawUI.ReadKey()
        Write-Host "`n`n"
        if ($key.Character -eq 'y') {
            # Yes, overwrite existing config files
            create_config_files $json $v
            $True
        }
        elseif ($key.Character -eq 'n') {
            # No, don't want to overwrite existing config files, do nothing
        }
        else {
            # Any other character, repeat input
            cmder_config_ask_create $json $v
        }
    }
    else {
        # No config files exist, make and write to them
        create_config_files $json $v
        $True
    }
}
