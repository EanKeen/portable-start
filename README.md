# portable-workstation

Bootstraps the creation of a USB configured with Cmder.

## Installation Procedure

Nukes and partitions a selected disk. It downloads the following programs (including the Scoop package manager). See the [docs](https://eankeen.github.io/portable-workstation) for more information.

- Powershell
- Scoop
- Cmder (via Scoop)
- Git (via Scoop)

Paste the following in any elevated Cmd or PowerShell shell to install (and nuke) a thumbdrive.

```batch
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/InstallFull.ps1'))"
```
