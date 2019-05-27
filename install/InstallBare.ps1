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

# Download cmder
Write-Host "Downloading and unzipping Cmder (with Git for Windows)"
$cmderFolder = "cmder1311.zip"
New-Item -Path "./_portable-applications" -ItemType Directory | Out-Null
Invoke-WebRequest -Uri "https://github.com/cmderdev/cmder/releases/download/v1.3.11/cmder.zip" -Method "GET" -TimeoutSec 0 -OutFile "$cmderFolder"
Expand-Archive -Path $cmderFolder -DestinationPath "./_portable-applications/cmder"
Remove-Item -Path $cmderFolder

# Create .bat style to execute portable-workstation scripts
Write-Host "Creating `"_portable-start.bat`""
$portableStartBatchScript = "_portable-start.bat"
New-Item -Path $portableStartBatchScript -ItemType File -Force | Out-Null
Add-Content -Path $portableStartBatchScript -Value "cd .\_portable-scripts"
Add-Content -Path $portableStartBatchScript -Value  "start ..\_portable-binaries\powershell\pwsh.exe -ExecutionPolicy Bypass -file .\ExecutePortableScripts.ps1"

# Create required folders
New-Item -Path "./_portable-shortcuts" -ItemType Directory | Out-Null
New-Item -Path "./_portable-binaries" -ItemType Directory | Out-Null