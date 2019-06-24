# Combines relative path relative to absolute path (see https://stackoverflow.com/a/13847304)
function normalize_path($absPath, $relPath) {
  [IO.Path]::GetFullPath((Join-Path $absPath $relPath))
}

# adds a property on an object if it does not already exist
function add_object_prop($obj, $prop, $propValue) {
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
    !($obj | obj_not_has_prop $prop)
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

# internal
function attempt_to_run_hook ($var, $expression) {
  if(-not $var.isUsing.refs.hookFile) {
    return
  }

  $functionName = $expression.Split(" ")[0]

  if(Get-Command $functionName -ErrorAction SilentlyContinue) {
    print_title "Running hook $functionName"
    Invoke-Expression -Command $expression
  }
}

function create_global_variables($var) {
  Set-Variable -Name "SCOOP_DRIVE" -Value (create_global_scoop_drive $var) -Scope Global
  Set-Variable -Name "PORTABLE_DRIVE" -Value (create_global_portable_drive) -Scope Global
  Set-Variable -Name "PORTABLE_DISK_LETTER" -Value (create_global_portable_disk_letter) -Scope Global
  
  print_info "create_global_variables" "Creating global variable `$SCOOP_DRIVE: $SCOOP_DRIVE"
  print_info "create_global_variables" "Creating global variable `$PORTABLE_DRIVE: $PORTABLE_DRIVE"
  print_info "create_global_variables" "Creating global variable `$PORTABLE_DISK_LETTER: $PORTABLE_DISK_LETTER"
}