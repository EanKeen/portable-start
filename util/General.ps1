## Other helper functions
# Combines relative path relative to absolute path

function normalize_path($absPath, $relPath) {
  [IO.Path]::GetFullPath((Join-Path $absPath $relPath))
}

function get_scoop_drive($config, $var) {
  # $portableDisk = Get-Partition -DriveLetter (Get-Location).Drive.Name | Select-Object -ExpandProperty "DiskNumber"
  # $scoopDrive = "$(Get-Partition -DiskNumber $portableDisk | ForEach-Object {
  #   if($_.DriveLetter -ne ((Get-Location).Drive.Name)) {
  #     Get-Volume -DriveLetter $_.DriveLetter | ForEach-Object {
  #       if($_.FileSystemType -eq "NTFS") {
  #         $_ | Select-Object -ExpandProperty "DriveLetter"
  #       }
  #     }
  #   }
  # }):\"

  # if($var.scoop.driveName) {
  #   $scoopDrive = "$(Get-Partition -DiskNumber $portableDisk | Get-Volume | ForEach-Object {
  #     if($_.FileSystemLabel -eq $config.opt.driveName) {
  #       $_.DriveLetter
  #       return
  #     }
  #   }):\"
  # }

  # if($null -eq $scoopDrive -or "" -eq $scoopDrive) {
  #   $scoopDrive = "E:\"
  # }

  # $scoopDrive
  "E:\"
}

function log($prirority, $function, $message) {

}

function attempt_to_run_hook ($var, $expression) {
  if(-not $var.isUsing.hookFile) {
    return
  }

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
    # print_info "add_object_prop" "Property `"$prop`" already exists on object as `"$(ConvertTo-Json $propValue)`""
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
