function print_title() {
  # Input Method 1: Piped stirng highlightedText
  # Input Method 2: Non-piped string highlightedText
  param(
    [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
    [string]
    $highlightedTextPiped,

    [Parameter(Position = 0, Mandatory = $false)]
    [string]
    $highlightedTextB
  )

  process {
    $highlghtedText
    if($highlightedTextPiped) { $highlightedText = $highlightedTextPiped }
    if($highlightedTextB) { $highlightedText = $highlightedTextB }
    if($highlightedTextPiped -and $highlightedTextB) { $highlightedText = "print_title does not accept two inputs. Get rid of either piped input or first parameter." }
    Write-Host "`r`n$highlightedText" -BackgroundColor White -ForegroundColor Black
  }
}

function print_info() {
  # Input Method 1: Piped string $plainText; first non-piped string highlightedText
  # Input Method 2: First non-piped string $highlightedText, second non-piped string plainText
  param(
    [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
    [string]
    $plainTextPiped,

    [Parameter(Position = 0, Mandatory = $false)]
    [string]
    $highlightedText,

    [Parameter(Position = 1, Mandatory = $false)]
    [string]
    $plainText
  )

  process {
    if($plainTextPiped) { $plainText = $plainTextPiped }
    if($plainTextPiped -and $plainText -and ($plainText -eq "")) { $plainText = "print_info does not accept two inputs. Get rid of either piped input or second parameter." }
    Write-Host $highlightedText -NoNewLine -BackgroundColor DarkGreen -ForegroundColor White
    Write-Host " $plainText"
  }
}

function print_warning() {
  # Input Method 1: Piped string $plainText; first non-piped string highlightedText
  # Input Method 2: First non-piped string $highlightedText, second non-piped string plainText
  param(
    [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
    [string]
    $plainTextPiped,

    [Parameter(Position = 0, Mandatory = $false)]
    [string]
    $highlightedText,

    [Parameter(Position = 1, Mandatory = $false)]
    [string]
    $plainText
  )
  
  process {
    if($plainTextPiped) { $plainText = $plainTextPiped }
    if($plainTextPiped -and $plainText -and ($plainText -eq "")) { $plainText = "print_warning does not accept two inputs. Get rid of either piped input or second parameter." }
    Write-Host $highlightedText -NoNewLine -BackgroundColor DarkYellow -ForegroundColor White
    Write-Host " $plainText"
  }
}

function print_error() {
  # Input Method 1: Piped string $plainText; first non-piped string highlightedText
  # Input Method 2: First non-piped string $highlightedText, second non-piped string plainText
  param(
    [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
    [string]
    $plainTextPiped,

    [Parameter(Position = 0, Mandatory = $false)]
    [string]
    $highlightedText,

    [Parameter(Position = 1, Mandatory = $false)]
    [string]
    $plainText
  )
  
  process {
    if($plainTextPiped) { $plainText = $plainTextPiped }
    if($plainTextPiped -and $plainText -and ($plainText -eq "")) { $plainText = "print_error does not accept two inputs. Get rid of either piped input or second parameter." }
    Write-Host $highlightedText -NoNewLine -BackgroundColor DarkMagenta -ForegroundColor White
    Write-Host " $plainText"
  }
}
