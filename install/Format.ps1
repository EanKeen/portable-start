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

function prompt_for_to_be_nuked_disk_drive_number($predictedDiskToNuke) {
  Write-Host
  $newDriveNumber = Read-Host
 
  # If user input is blank, retry
  if("" -eq $newDriveNumber) {
    Write-Host "Not a valid input. Do not input nothing"
    return prompt_for_to_be_nuked_disk_drive_number $driveNumberToNuke
    break
  }
  # If user input matches exact case, continue
  elseif($newDriveNumber -eq "nuke $predictedDiskToNuke") {
    return $newDriveNumber.Substring(5)
    break
  }
  elseif($newDriveNumber -eq $predictedDiskToNuke) {
    Write-Host "Please type `"nuke $predictedDiskToNuke`" (without quotations) to continue"
    prompt_for_to_be_nuked_disk_drive_number $predictedDiskToNuke
  }

  # If user input matches valid drive letter, continue
  try {
    $newDriveNumberAsInt = [int]$newDriveNumber

    if($newDriveNumberAsInt -lt (Get-Disk).Count -and $newDriveNumberAsInt -ge 0) {
      return $newDriveNumberAsInt
    }
    else {
      Write-Host "Not a valid input. Your number did not correspond to a valid drive number"
      return prompt_for_to_be_nuked_disk_drive_number $predictedDiskToNuke
    }
  }
  # If user input does not match number, reprompt
  catch {
    Write-Host "Not a valid input. You must enter a number or `"nuke $predictedDiskToNuke`" to proceed"
    return prompt_for_to_be_nuked_disk_drive_number $predictedDiskToNuke
  }
}

function get_drive_number_to_nuke() {
  param(
    [Parameter(Mandatory = $false)]
    $diskNumberToNuke
  )

  print_info "Scanning Drives"
  $disks = Get-Disk
  
  # Defalut to nuking last disk drive (will reprompt, of course)
  $predictedDiskNumberToNuke = $disks.Count - 1
  if($diskNumberToNuke) {
    $predictedDiskNumberToNuke = $diskNumberToNuke
  }

  $driveToNuke | Out-Null # without Out-Null crap is piped out
  $newDisks = @()

  # Filter out all disks except disk drive corresponding to $predictedDiskNumberToNuke
  foreach($disk in $disks) {
    if($disk.Number -ne $predictedDiskNumberToNuke) {
      $newDisks += $disk
    }
    else {
      $driveToNuke = $disk
    }
  }
  
  print_info "These drives will be untouched"  
  Write-Host ($newDisks | Out-String).Trim()

  Write-Host
  print_warning "This drive will be nuked"
  Write-Host (Get-Disk -Number $predictedDiskNumberToNuke | Out-String).Trim()
  
  Write-Host
  print_warning "This will NUKE ALL data on drive number `"$predictedDiskNumberToNuke`". Do you wish to proceed?"
  print_warning "Type `"nuke $predictedDiskNumberToNuke`" to proceed. If want to nuke another disk, write only disk drive number below (you will be reprompted)"
  $diskDriveToNuke = prompt_for_to_be_nuked_disk_drive_number $predictedDiskNumberToNuke

  if($diskDriveToNuke -eq $predictedDiskNumberToNuke) {
    $diskDriveToNuke
  }
  else {
    $diskDriveToNuke = get_drive_number_to_nuke $diskDriveToNuke
    $diskDriveToNuke
  }
}

$finalNumber = get_drive_number_to_nuke
Write-Host "$finalNumber will be erased"

exit_program