function print_info($plainText) {
  Write-Host "INFO" -NoNewLine -BackgroundColor DarkGreen -ForegroundColor White
  Write-Host " $plainText"
}

function print_warning($text) {
  Write-Host "WARNING" -NoNewLine -BackgroundColor Red -ForegroundColor White
  Write-Host " $text"
}

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

function exit_program() {
  Write-Host "Program terminated. Press `"q`" to exit"

  $key = $Host.UI.RawUI.ReadKey()
  if($key.Character -eq "q") {
    exit
  }
  Write-Host "`n"
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
  # Write-Host
  $newDriveNumber = Read-Host
 
  # If user input is blank, retry
  if("" -eq $newDriveNumber) {
    Write-Host "Not a valid input. Do not input nothing. Restart the program to continue."
    exit_program
    break
  }
  # If user input matches exact case, continue
  elseif($newDriveNumber -eq "nuke $predictedDiskToNuke") {
    return $newDriveNumber.Substring(5)
    break
  }
  elseif($newDriveNumber -eq $predictedDiskToNuke) {
    Write-Host "Please type `"nuke $predictedDiskToNuke`" (without quotations) to continue"
    return prompt_for_to_be_nuked_disk_drive_number $predictedDiskToNuke
  }

  # If user input matches valid drive letter, continue
  try {
    $newDriveNumberAsInt = [int]$newDriveNumber

    if($newDriveNumberAsInt -lt (Get-Disk).Count -and $newDriveNumberAsInt -ge 0) {
      return $newDriveNumberAsInt
    }
    else {
      Write-Host "Not a valid input. Your number did not correspond to a valid drive number. Try again."
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

try {
  Clear-Disk -Number $finalNumber -Confirm -RemoveData -ErrorAction Stop
}
catch {
  print_info "You likely have some error that that looks like this: 'Clear-Disk : Access to a CIM resource was not available to the client'"
  print_info "You need to be admin to run this script."
  exit_program
}

if($ProcessError) {
  write-host "thing"
}

print_info "How many Gibibytes do you want to leave for Scoop? (Recommended: 2; Maximum: 4)"
$scoopSizeBytes = get_scoop_size

print_info "Some File Explorer windows are probably going to popup. Some might ask you to 'reformat' the drives, but just ignore them and close them out. I haven't got around to prevent them from popping up."

$scoopDrive = New-Partition -DiskNumber $finalNumber -Size $scoopSizeBytes -AssignDriveLetter | Format-Volume -FileSystem "NTFS" -NewFileSystemLabel "SCOOP"
$workstationDrive = New-Partition -DiskNumber $finalNumber -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem "exFAT" -NewFileSystemLabel "WORKSTATION" -AllocationUnitSize 4096

$scoopDrive | Format-List | Out-String | Write-Host
$workstationDrive | Format-List | Out-String | Write-Host

$scoopDriveLetter = $scoopDrive.DriveLetter
$workstationDriveLetter = $workstationDrive.DriveLetter


## FOR SCOOP ##
Set-Location "${scoopDriveLetter}:\"

New-Item -Path "./_scoop" -ItemType Directory | Out-Null
New-Item -Path "./_scoop-global" -ItemType Directory | Out-Null

$scoopItself = "${scoopDriveLetter}:\_scoop"
$env:SCOOP = $scoopItself
[environment]::setEnvironmentVariable("SCOOP", $scoopItself, "User")


$scoopPrograms = "${scoopDriveLetter}:\_scoop-global"
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


# Create portable.config.json
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/portable.config.json" -Method GET -OutFile "portable.config.json"
$portableConfig = Get-Content -Path "./portable.config.json" -Raw | ConvertFrom-Json

$portableConfig | ConvertTo-Json -Depth 100 | Set-Content -Path "./_portable-scripts/portable.config.json" -Encoding ASCII -Force

Remove-Item -Path "./portable.config.json" | Out-Null

## Revisit scoop

print_info "Almost done. About to install scoop. If you're receiving errors of using proper execution policy, simply change the execution policy and invoke the following command"
print_info "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://get.scoop.sh')"

$currentUser = Get-ExecutionPolicy -Scope CurrentUser
$localMachine = Get-ExecutionPolicy -Scope LocalMachine

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope 'LocalMachine'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope 'CurrentUser'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope 'Process'

# don't change user's preexisting settings. just trying to make this script work
Set-ExecutionPolicy -ExecutionPolicy $localMachine -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy $currentUser -Scope CurrentUser

print_info "`$env:SCOOP"
print_info $env:SCOOP
Write-Host
print_info "`$env:SCOOP_GLOBAL"
print_info $env:SCOOP_GLOBAL

Set-Location "${scoopDriveLetter}:\"
Invoke-Expression -Command (New-Object Net.WebClient).DownloadString('https://get.scoop.sh')

Write-Host "Adding 'extras' Scoop bucket'"
scoop bucket add extras

Write-Host "Addng 'cmder-full' Scoop package"
scoop install cmder

Write-Host "Adding 'git' Scoop package"
scoop insstall git
