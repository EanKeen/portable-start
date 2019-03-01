function print_info($warning, $content) {
    Write-Host $warning -
}

function print_warning() {

}

function print_error() {
    
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

