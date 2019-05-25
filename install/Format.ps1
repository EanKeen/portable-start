function print_info($plainText) {
  Write-Host "INFO" -NoNewLine -BackgroundColor DarkGreen -ForegroundColor White
  Write-Host " $plainText"
}

function print_warning($text) {
  Write-Host "WARNING" -NoNewLine -BackgroundColor DarkMagenta -ForegroundColor White
  Write-Host " $text"
}

function exit_program() {
  Write-Host "Job cancelled. Press `"q`" to exit"

  $key = $Host.UI.RawUI.ReadKey()
  if($key.Character -eq "q") {
    exit
  }
  exit_program
}

function getDriveNumber($driveLetter) {
  $driveNumberToNuke = 1;
  foreach($partition in Get-Partition) {
    if($partition.DriveLetter -eq $driveLetterToNuke) {
      $driveNumberToNuke = $partition.DiskNumber;
    }
  }
  $driveNumberToNuke
}

function validate_drive_to_delete($driveNumberToNuke) {
  Write-Host
  print_warning "This will NUKE ALL data on drive number `"$driveNumberToNuke`". Do you wish to proceed?"
  print_warning "Type `"nuke $driveNumberToNuke`" to proceed. If want to nuke another disk, write only disk number below (you will be reprompted)"
  $newDriveNumber = Read-Host
 
  # If user input cannot be converted to number, reprompt
  try {
    $newDriveNumberAsInt = [int]$newDriveNumber
  }
  catch {
    Write-Host "Not a valid input. Try again."
    return validate_drive_to_delete $driveNumberToNuke
  }

  # If user input empty, reprompt
  if("" -eq $newDriveNumber) {
    Write-Host "Not a valid input. Try again."
    return validate_drive_to_delete $driveNumberToNuke
  }
  # If user input matches exact case, continue
  elseif($newDriveNumber -eq "nuke $driveNumberToNuke") {
    return $newDriveNumber
  }
  # If user input matches valid drive letter, continue
  elseif($newDriveNumberAsInt -lt (Get-Disk).Count -and $newDriveNumberAsInt -ge 0) {
    return $newDriveNumber
  }
  else {
    Write-Host "Not a valid input. Try again."
    return validate_drive_to_delete $driveNumberToNuke
  }
}

function get_drive_to_delete($driveNumberToNuke) {
  print_info "Scanning Drives"
  $disks = Get-Disk

  $newDisks = @()

  # Filter out all disks except $driveNumberToNuke
  $driveToNuke
  foreach($disk in $disks) {
    if($disk.Number -ne $driveNumberToNuke) {
      $newDisks += $disk
    }
    else {
      $driveToNuke = $disk
    }
  }

  print_info "These drives will be untouched"  
  Write-Host ($newDisks | Format-Table | Out-String).Trim()

  Write-Host
  print_warning "This drive will be nuked"
  Write-Host (Get-Disk -Number $driveNumberToNuke | Out-String).Trim()
  
  $finalDiskToNuke = validate_drive_to_delete $driveNumberToNuke
  if($finalDiskToNuke -eq $driveNumberToNuke) {
    Write-Host "about to wipe disk $finalDiskToNuke"
    return $finalDiskToNuke
  }
  else {
    Write-Host "thing"
    return get_drive_to_delete $finalDiskToNuke
  }
}

$driveLetterToNuke = (Get-Location).Drive.Name
$driveNumberToNuke = getDriveNumber $driveLetterToNuke

$finalNumber = get_drive_to_delete $driveNumberToNuke
Write-Host "$finalNumber will be erased"





exit_program