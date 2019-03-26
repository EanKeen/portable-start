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

function write_line_to_file($var, $file, $content) {
    if($file -eq $var.allConfig) {
        write_line_to_file $var $var.bashConfig $content
        write_line_to_file $var $var.psConfig $content
        write_line_to_file $var $var.cmdConfig $content
        return
    }
    "$content" | Out-File -Encoding "ASCII" -Append -FilePath $file  
}

function write_path_line_to_file($var, $file, $content) {
    # print_warning "test" $content
    if($file -eq $var.allConfig) {
        write_path_line_to_file $var $var.bashConfig $content
        write_path_line_to_file $var $var.psConfig $content
        write_path_line_to_file $var $var.cmdConfig $content
        return
    }
    elseif($file -eq $var.bashConfig) {
        write_line_to_file $vars $var.bashConfig "export PATH=\$((Convert-Path $content)):`$PATH".Replace(":\", "\").Replace("\", "/")
    }
    elseif($file -eq $var.psConfig) {
        write_line_to_file $vars $var.psConfig "`$env:Path = `"${content};`" + `$env:Path"
    }
    elseif($file -eq $var.cmdConfig) {
        write_line_to_file $var $var.cmdConfig "set PATH=${content};%PATH%"
    }
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