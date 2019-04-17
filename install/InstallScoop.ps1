# If user chooses to skip installing Scoop on the initial script, they can use
# this script to autmaticaly install everything later, since an NTFS drive is required


$_scoopFolder = "./_portable-binaries/scoop"
[environment]::setEnvironmentVariable("SCOOP", $_scoopFolder, "User")
$env:SCOOP = $_scoopFolder
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Get-ExecutionPolicy
Invoke-Expression (New-Object System.Net.WebClient).DownloadString("https://get.scoop.sh")

[environment]::setEnvironmentVariable("SCOOP_GLOBAL", ".\_portable-scoop", "User")
$env:SCOOP_GLOBAL = ".\_portable-scoop"