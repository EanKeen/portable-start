function print_title($highlightedTextB) {
  Write-Host "`r`n$highlightedText" -BackgroundColor White -ForegroundColor Black
}

function print_info($highlightedText, $plainText) {
  Write-Host $highlightedText -NoNewLine -BackgroundColor DarkGreen -ForegroundColor White
  Write-Host " $plainText"
}

function print_warning($highlightedText, $plainText) {
  Write-Host $highlightedText -NoNewLine -BackgroundColor DarkYellow -ForegroundColor White
  Write-Host " $plainText"
}
