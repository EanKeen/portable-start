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
