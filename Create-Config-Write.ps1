function write_line_to_file() {}

function cmder_config_write($json, $v) {
    $json.paths | ForEach-Object -Process {
        # loop through each path declared in the json file
        $binaryFileLocation = $_.Name
        $binaryToAddToPath = "$binDir/${path}"
        $binDir = $v.binaryDir

        write_line_to_file "export PATH=/$binDir/${path}:`$PATH".Replace("\", "/").Replace(":/", "/") $v.bashConfig
        write_line_to_file "`$env:Path = `"$binDir/$path;`" + `$env:Path".Replace("\", "/") $v.psConfig
        write_line_to_file "set PATH=$binDir/$path;%PATH%".Replace("\", "/") $v.cmdConfig

        
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${v.bashConfig}`""
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${v.psConfig}`""
        Write-Host "Adding `"$binaryToAddToPath`" to PATH for `"${v.cmdConfig}`""
        Write-Host "`r"
    }
}
