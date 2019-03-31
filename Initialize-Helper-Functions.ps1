## Prints with different formatting
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

## Other helper functions
# Combines relative path relative to absolute path
function normalize_path($absPath, $relPath) {
  [IO.Path]::GetFullPath((Join-Path $absPath $relPath))
  return
}

function attempt_to_run_hook($expression) {
  $functionName = $expression.Split(" ")[0]

  if(Get-Command $functionName -errorAction SilentlyContinue) {
    print_title "Running hook $functionName"
    Invoke-Expression $expression
  }
}

function add_prop_to_obj($obj, $prop, $propValue) {
  if($obj | obj_not_has_prop $prop) {
    Add-Member -InputObject $obj -Name $prop -Value $propValue -MemberType NoteProperty
  }
}

function obj_not_has_prop() {
  param(
    [Parameter(ValueFromPipeline = $true)]
    [object]
    $obj,

    [Parameter(Position = 0, Mandatory = $true)]
    [string]
    $prop
  )

  process {
    $propFound = $false
    $obj.PsObject.Properties | ForEach-Object {
      if(($_.Name -eq $prop) -and -not $propFound) {
        $propFound = $true
        return
      }
    }
    if(-not $propFound) {
    }
    !$propFound
  }
}

function exit_program() {
  print_title "Exiting program. Press `"q`" to exit"

  $key = $Host.UI.RawUI.ReadKey()
  if($key.Character -eq "q") {
    exit
  }
  exit_program
}

## Writes to a particular Cmder config
function write_to_config($var, $configFile, $content) {
  if($configFile -eq $var.allConfig) {
    write_to_config $var $var.bashConfig $content
    write_to_config $var $var.psConfig $content
    write_to_config $var $var.cmdConfig $content
    return
  }
  # Add-Content -Path $configFile -Value $content -Encoding "ASCII"
  "$content" | Out-File -Encoding "ASCII" -Append -FilePath $configFile  
}

## Writes to a particular Cmder config, but more suited to a specific case (comment, variable, path, alias)
function write_comment_to_config($var, $configFile, $comment) {
  if($configFile -eq $var.allConfig) {
    write_comment_to_config $var $var.bashConfig $comment
    write_comment_to_config $var $var.psConfig $comment
    write_comment_to_config $var $var.cmdConfig $comment
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $var.bashConfig "# $comment"
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $var.psConfig "# $comment"
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $var.cmdConfig ":: $comment"
  }
  print_info "comment" "Adding `"$($comment.Substring(0, 15))...`" to `"$(Split-Path $configFile -Leaf)`""
}

function write_variable_to_config($var, $configFile, $variableName, $variableValue) {
  if($configFile -eq $var.allConfig) {
    write_variable_to_config $var $var.bashConfig $variableName $variableValue
    write_variable_to_config $var $var.psConfig $variableName $variableValue
    write_variable_to_config $var $var.cmdConfig $variableName $variableValue
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $configFile "$variableName=`"$variableValue`""
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $configFile "`$$variableName=`"$variableValue`""
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $configFile "set $variableName=$variableValue"
  }
  print_info "variable" "Adding `"$variableName`" to `"$variableValue`" for `"$(Split-path $configFile -Leaf)`""
}

function write_path_to_config($var, $configFile, $binName, $filePath) {
  if($configFile -eq $var.allConfig) {
    write_path_to_config $var $var.bashConfig $binName $filePath
    write_path_to_config $var $var.psConfig $binName $filePath
    write_path_to_config $var $var.cmdConfig $binName $filePath
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $vars $var.bashConfig "export PATH=\$((Convert-Path $filePath)):`$PATH".Replace(":\", "\").Replace("\", "/")
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $vars $var.psConfig "`$env:Path = `"${filePath};`" + `$env:Path"
  }
  elseif($configFile -eq $var.cmdConfig) {
    write_to_config $var $var.cmdConfig "set PATH=${filePath};%PATH%"
  }
  print_info "path" "Adding `"$binName`" to PATH for `"$(Split-Path $configFile -Leaf)`""
}

function write_alias_to_config($var, $configFile, $aliasName, $aliasValue) {
  if($configFile -eq $var.allConfig) {
    write_alias_to_config $var $var.bashConfig $aliasName $aliasValue
    write_alias_to_config $var $var.psConfig $aliasName $aliasValue
    write_alias_to_config $var $var.cmdConfig $aliasName $aliasValue
    return
  }
  elseif($configFile -eq $var.bashConfig) {
    write_to_config $var $configFile "alias $aliasName=`"$aliasValue`""
  }
  elseif($configFile -eq $var.psConfig) {
    write_to_config $var $configFile "function fn-$aliasName { $aliasValue }"
    write_to_config $var $configFile "Set-Alias -Name `"$aliasName`" -Value `"fn-$aliasName`""
  }
  elseif($configFile -eq $var.cmdConfig) {
    # For now, aliases are not included for batch
    # Append to pre-created user_aliases.cmd
    # Write-Line-To-File "alias $alias=$aliasValue" $configFile
    # Write-Line-To-File "doskey $alias=$aliasValue" $configFile
  }
  print_info "alias" "Adding `"$aliasName`" as `"$aliasValue`" for `"$(Split-Path -Path $configFile)`""
}
