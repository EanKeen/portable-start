function print_title($highlighted) {
    Write-Host
    Write-Host $highlighted -BackgroundColor White -ForegroundColor Black
}

function print_info($highlighted, $plain) {
    Write-Host $highlighted -NoNewLine -BackgroundColor DarkBlue -ForegroundColor White
    Write-Host " $plain"
}

function print_warning($highlighted, $plain) {
    Write-Host $highlighted -NoNewLine -BackgroundColor DarkOrange -ForegroundColor White
    Write-Host " $plain"
}
    
function print_error($highlighted, $plain) {
    Write-Host $highlighted -NoNewLine -BackgroundColor DarkPurple -ForegroundColor White
    Write-Host " $plain"
}

function write_line_to_file($myContent, $file) {
    if($file -eq $allConfig) {
        write_line_to_file $myContent $bashConfig
        write_line_to_file $myContent $psConfig
        write_line_to_file $myContent $cmdConfig
        return
    }
    "$myContent" | Out-File -Encoding "ASCII" -Append -FilePath $file
}

function get_directory($dir) {
    (Resolve-Path "$dir").Path
    return
}
