function write_line_to_file() {}

function cmder_config_write($json, $variables) {
    $json.paths | ForEach-Object -Process {
        # loop through each path declared in the json file
        $binaryFileLocation = $_.Name
        $binaryToAddToPath = "$binDir/${path}"
        $binDir = $variables.binaryDir

        write_line_to_file "export PATH=/$binDir/${path}:`$PATH".Replace("\", "/").Replace(":/", "/") $variables.bashConfig
        write_line_to_file "`$env:Path = `"$binDir/$path;`" + `$env:Path".Replace("\", "/") $variables.psConfig
        write_line_to_file "set PATH=$binDir/$path;%PATH%".Replace("\", "/") $variables.cmdConfig

        
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${variables.bashConfig}`""
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${variables.psConfig}`""
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${variables.cmdConfig}`""
        Write-Host "`r"
    }
}
