function create_global_scoop_drive($var) {
  if($var.isUsing.opts.scoopDriveName) {
    $scoopDrive = Get-Disk | Get-Partition | Get-Volume | ForEach-Object {
    if($_.FileSystemLabel -eq "SCOOP") {
        $_.DriveLetter
        return
      }
    }
  }
  else {
    $portableDisk = Get-Partition -DriveLetter (Get-Location).Drive.Name | Select-Object -ExpandProperty "DiskNumber"
    $scoopDrive = "$(Get-Partition -DiskNumber $portableDisk | Get-Volume | ForEach-Object {
      if($_.FileSystemLabel -eq $var.opt.driveName) {
        $_.DriveLetter | Out-Host
        return
      }
    })"
  }
  "${scoopDrive}:\"
}

function create_global_portable_drive() {
  (Get-Location).Drive.Root
}

function create_global_portable_disk_letter() {
  Get-Partition -DriveLetter (Get-Location).Drive.Name | Select-Object -ExpandProperty "DiskNumber"
}

function create_global_variables($var) {
  Set-Variable -Name "SCOOP_DRIVE" -Value (create_global_scoop_drive $var) -Scope Global
  Set-Variable -Name "PORTABLE_DRIVE" -Value (create_global_portable_drive) -Scope Global
  Set-Variable -Name "PORTABLE_DISK_LETTER" -Value (create_global_portable_disk_letter) -Scope Global
  
  print_info "create_global_variables" "Creating global variable `$SCOOP_DRIVE: $SCOOP_DRIVE"
  print_info "create_global_variables" "Creating global variable `$PORTABLE_DRIVE: $PORTABLE_DRIVE"
  print_info "create_global_variables" "Creating global variable `$PORTABLE_DISK_LETTER: $PORTABLE_DISK_LETTER"
}