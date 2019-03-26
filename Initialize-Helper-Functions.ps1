function print_title($highlighted) {
    Write-Host
    Write-Host $highlighted -BackgroundColor White -ForegroundColor Black
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

function write_line_to_file($vars, $file, $content) {
    if($file -eq $vars.allConfig) {
        write_line_to_file $addToPath $var.bashConfig
        write_line_to_file $addToPath $var.psConfig
        write_line_to_file $addToPath $var.cmdConfig
        return
    }
    "$content" | Out-File -Encoding "ASCII" -Append -FilePath $file  
}

function get_directory($dir) {
    (Resolve-Path "$dir").Path
    return
}

# Combines relative path relative to absolute path
function normalize_path($absPath, $relPath) {
    [IO.Path]::GetFullPath((Join-Path $absPath $relPath))
    return
}