Write-Host "Would you like to automatically install Scoop? Your drive *must* be NTFS."
$keyScoop = $Host.UI.RawUI.ReadKey();
Write-Host `r`n

# Download portable-workstation scripts
Write-Host "Downloading and unzipping portable-workstation repository"
$_portableworkstationFile = "./portable-workstation.zip"
Invoke-WebRequest -Uri "https://github.com/EanKeen/portable-workstation/archive/master.zip" -Method "GET" -TimeoutSec 0 -OutFile $_portableworkstationFile
Expand-Archive -Path $_portableworkstationFile -DestinationPath "./" -Force
Rename-Item -Path "./portable-workstation-master" -NewName "./_portable-scripts"
Remove-Item -Path $_portableworkstationFile

# Download powershell
Write-Host "Downloading and unzipping PowerShell Core 6.2 32bit"
New-Item -Path "./_portable-binaries" -ItemType Directory | Out-Null
$_powershellFile = "./_portable-powershell.zip"
Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v6.2.0/PowerShell-6.2.0-win-x86.zip" -Method "GET" -TimeoutSec 0 -OutFile "$_powershellFile"
Expand-Archive -Path $_powershellFile -DestinationPath "./_portable-binaries/powershell" -Force

# Download cmder
Write-Host "Downloading and unzipping Cmder (with Git for Windows)"
New-Item -Path "./_portable-applications" -ItemType Directory | Out-Null
$_cmderFile = "cmder1311.zip"
Invoke-WebRequest -Uri "https://github.com/cmderdev/cmder/releases/download/v1.3.11/cmder.zip" -Method "GET" -TimeoutSec 0 -OutFile "$_cmderFile"
Expand-Archive -Path $_cmderFile -DestinationPath "./_portable-applications/cmder"

# Download Scoop
if($keyScoop.Character -eq "y") {
  $_scoopInstallationFolder = "./_portable-scoop"
  $_scoopInstallationFolder = Resolve-Path -Path $_scoopInstallationFolder
  [environment]::setEnvironmentVariable("SCOOP", $_scoopInstallationFolder, "User")
  $env:SCOOP = $_scoopInstallationFolder

  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Invoke-Expression (New-Object System.Net.WebClient).DownloadString("https://get.scoop.sh")
  
  $_scoopInstalledProgramsFolder = "./portable-scoop-programs"
  New-Item -Path $_scoopInstalledProgramsFolder -Type Directory 
  $_scoopInstalledProgramsFolder = Resolve-Path -Path $_scoopInstalledProgramsFolder
  [environment]::setEnvironmentVariable("SCOOP_GLOBAL", $_scoopInstalledProgramsFolder, "User")
  $env:SCOOP_GLOBAL = $_scoopInstalledProgramsFolder
}

# Create .bat style to execute portable-workstation scripts
Write-Host "Creating `"_portable-start.bat`""
$_portableStartFile = "_portable-start.bat"
New-Item -Path $_portableStartFile -ItemType File -Force | Out-Null
Add-Content -Path $_portableStartFile -Value "cd .\_portable-scripts"
Add-Content -Path $_portableStartFile -Value  "start ..\_portable-binaries\powershell\pwsh.exe -ExecutionPolicy Bypass -file .\ExecutePortableScripts.ps1"
