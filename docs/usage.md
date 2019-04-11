# Usage
## Setup with Batch Script
```cmd
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/EanKeen/portable-workstation/blob/master/install/Install.ps1'))"
```
`Install.ps1` downloads the files from this repository and downloads PowerShell Core 6.2, so it may take a few minutes. PowerShell Core 6.2 is about 52 MB. Lastly, it automatically creates a `portable.config.json` with an entry to the PowerShell Core 6.2 binary.

## Setup with Powershell Script

```ps
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/EanKeen/portable-workstation/master/install/Install.ps1'))
```

`Install.ps1` downloads the files from this repository and downloads PowerShell Core 6.2, so it may take a few minutes. PowerShell Core 6.2 is about 52 MB. Lastly, it automatically creates a `portable.config.json` with an entry to the PowerShell Core 6.2 binary.

If you have troubles setting the execution policy
```ps
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri "https://github.com/EanKeen/portable-workstation/master/install/Install.ps1" -OutFile "Install.ps1"; ./Install.ps1
```

## Clone the Repository
```bash
git clone https://github.com/EanKeen/portable-workstation.git
cd portable-workstation
./ExecutePortableScripts.ps1
```
If you are experiencing problems make sure you have the right [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6).
```ps
# Temporarily change execution policy when running script
Set-ExecutionPolicy Bypass -Scope Process -Force; ./ExecutePortableScripts.ps1

# If that doesn't seem to work, change it manually
Get-ExecutionPolicy # view execution policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted # change execution policy to unrestricted
./ExecutePortableScripts.ps1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned # change execution back from unrestricted to something safer
```

Then, just setup a configuration schema [here](/schema).

Then, just run `Portable-Start.ps1`. I would recommend setting up a `.bat` file that executes it.
```cmd
start powershell -ExecutionPolicy Bypass -file .\Execute-PortableScripts.ps1
```

I would recommend downloading and using the PowerShell Core binary so you can use this on other computers that don't have the latest PowerShell version.
```cmd
start ..\path\to\powershell\pwsh.exe -ExecutionPolicy Bypass -file .\Execute-PortableScripts.ps1
```