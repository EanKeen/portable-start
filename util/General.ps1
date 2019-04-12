## Other helper functions
# Combines relative path relative to absolute path
function normalize_path($absPath, $relPath) {
  [IO.Path]::GetFullPath((Join-Path $absPath $relPath))
}

function attempt_to_run_hook($expression) {
  $functionName = $expression.Split(" ")[0]

  if(Get-Command $functionName -ErrorAction SilentlyContinue) {
    print_title "Running hook $functionName"
    Invoke-Expression $expression
  }
}

function add_object_prop($obj, $prop, $propValue) {
  if($obj | obj_not_has_prop $prop) {
    Add-Member -InputObject $obj -Name $prop -Value $propValue -MemberType NoteProperty
  }
  else {
    print_info "add_object_prop" "Property `"$prop`" already exists on object as `"$(ConvertTo-Json $propValue)`""
  }
}

function obj_has_prop() {
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
    $propFound
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
