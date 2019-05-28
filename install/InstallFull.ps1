function print_info($plainText) {
  Write-Host "INFO" -NoNewLine -BackgroundColor DarkGreen -ForegroundColor White
  Write-Host " $plainText"
}

function print_warning($text) {
  Write-Host "WARNING" -NoNewLine -BackgroundColor DarkMagenta -ForegroundColor White
  Write-Host " $text"
}

function exit_program() {
  Write-Host "Program terminated. Press `"q`" to exit"

  $key = $Host.UI.RawUI.ReadKey()
  if($key.Character -eq "q") {
    exit
  }
  exit_program
}

function get_scoop_size() {
  $scoopSize = Read-Host

  try {
    $scoopSizeInt = [int]$scoopSize

    if($scoopSizeInt -le 4 -and $scoopSizeInt -ge 0) {
      $scoopSizeBytes = ([Math]::Pow(1024, 3) * $scoopSizeInt) - 1
      return $scoopSizeBytes
    }
    else {
      Write-Host "Not a valid input. n | 0 < n < 4"
      return get_scoop_sizeq
    }
  }
  # If user input does not enter number, reprompt
  catch {
    Write-Host "Not a valid input. You must enter a number to proceed"
    return get_scoop_size
  }
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
$finalNumber = [int]$finalNumber

Clear-Disk -Number $finalNumber -Confirm -RemoveData

print_info "How many Gibibytes do you want to leave for Scoop? (Recommended: 2; Maximum: 4)"
$scoopSizeBytes = get_scoop_size

$scoopDrive = New-Partition -DiskNumber $finalNumber -Size $scoopSizeBytes -AssignDriveLetter | Format-Volume -FileSystem "NTFS" -NewFileSystemLabel "SCOOP"
$workstationDrive = New-Partition -DiskNumber $finalNumber -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem "exFAT" -NewFileSystemLabel "WORKSTATION" -AllocationUnitSize 4096

$scoopDrive | Format-List | Out-String | Write-Host
$workstationDrive | Format-List | Out-String | Write-Host

$scoopDriveLetter = $scoopDrive.DriveLetter
$workstationDriveLetter = $workstationDrive.DriveLetter


## FOR SCOOP ##
Set-Location "${scoopDriveLetter}:\"

New-Item -Path "./_scoop" -ItemType Directory | Out-Null
New-Item -Path "./_scoop-programs" -ItemType Directory | Out-Null

$scoopItself = "${scoopItself}\scoop"
$env:SCOOP = $scoopItself
[environment]::setEnvironmentVariable("SCOOP", $scoopItself, "User")


$scoopPrograms = "${scoopDriveLetter}:\scoop-programs"
$env:SCOOP_GLOBAL = $scoopPrograms
[environment]::setEnvironmentVariable("SCOOP_GLOBAL", $scoopPrograms, "User")

## FOR WORKSTATION ##
Set-Location "${workstationDriveLetter}:\"

# Download portable-workstation scripts
Write-Host "Downloading and unzipping portable-workstation repository"
$portableWorkstationFolder = "./portable-workstation.zip"
Invoke-WebRequest -Uri "https://github.com/eankeen/portable-workstation/archive/master.zip" -Method "GET" -TimeoutSec 0 -OutFile $portableWorkstationFolder
Expand-Archive -Path $portableWorkstationFolder -DestinationPath "./" -Force
Rename-Item -Path "./portable-workstation-master" -NewName "./_portable-scripts"
Remove-Item -Path $portableWorkstationFolder

# Download powershell core
Write-Host "Downloading and unzipping PowerShell Core 6.2 32bit"
$powershellCoreFolder = "./_portable-powershell.zip"
New-Item -Path "./_portable-binaries" -ItemType Directory | Out-Null
Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v6.2.0/PowerShell-6.2.0-win-x86.zip" -Method "GET" -TimeoutSec 0 -OutFile "$powershellCoreFolder"
Expand-Archive -Path $powershellCoreFolder -DestinationPath "./_portable-binaries/powershell" -Force
Remove-Item -Path $powershellCoreFolder

# Create .bat style to execute portable-workstation scripts
Write-Host "Creating `"_portable-start.bat`""
$portableStartBatchScript = "_portable-start.bat"
New-Item -Path $portableStartBatchScript -ItemType File -Force | Out-Null
Add-Content -Path $portableStartBatchScript -Value "cd .\_portable-scripts"
Add-Content -Path $portableStartBatchScript -Value  "start ..\_portable-binaries\powershell\pwsh.exe -ExecutionPolicy Bypass -file .\ExecutePortableScripts.ps1"

# Create required folders
New-Item -Path "./_portable-shortcuts" -ItemType Directory | Out-Null

# Create portable.config.json
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/portable.config.json" -Method GET -OutFile "portable.config.json"
$portableConfig = Get-Content -Path "./portable.config.json" -Raw | ConvertFrom-Json
$portableConfig.refs.appDir = "OMMIT"
$portableConfig.refs.cmderConfigDir = "OMMIT"
$portableConfig.scoopRefs.scoopProgramsDir = "./_scoop-programs"
$portableConfig.scoopRefs.scoopDir = "./_scoop"

$portableConfig | Set-Content -Path "./_portable-scripts/portable.config.json" -Encoding ASCII -Force

## Revisit scoop
print_info "Almost done. Now will install scoop. If you're receiving errors of using proper execution policy, simply change the execution policy and invoke the following command"
print_info "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://get.scoop.sh')"

Set-Location "${scoopDriveLetter}:\"
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://get.scoop.sh')
