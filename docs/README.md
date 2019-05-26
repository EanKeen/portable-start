# Home

This Portable Workstation project includes scripts for geting a development workstation started on a Windows PC from a thumbdrive. However, a thumbdrive is not a requirement.

## Summary

This repository contains tooling that allows you to use whatever tooling you need across computers. Access your Cmd, Powershell, or Bash console with Cmder. Add binaries to the PATHS of all (or some of) your shells with only *one* file. Add aliases and variables to some or to all of your shells. Manage any portable applications you have, such as VSCode, Sublime Text, Blender, Audacity, 7Zip etc. in a single file. Create shortcuts to these applications for easy access. Configure all these features from one, easy to understand `.json` file.

## Simple Installation

### Install Bare

Using Bare only gives you Powershell and Cmder. It works, but you must manually configure other apps or binaries to use with it. See the [docs](https://eankeen.github.io/portable-workstation) for more information.

- Cmder (with Git for Windows)
- Powershell

Paste the following in any directory of your thumbdrive to install it in that directory.

```batch
@"%SystemRoot%\System32\WinsdowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/EanKeen/portable-workstation/master/install/InstallBare.ps1'))"
```

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/EanKeen/portable-workstation/master/install/InstallBare.ps1'))
```

### Method Full (Recommended)

This directly installs Powershell and Scoop. From Scoop, the script automatically gets configured for Cmder and Git, downloaded with Scoop. Scoop must be installed on an NTFS volume because it utilized NTFS Symbolic Links. This script asks you which USB disk drive you'd like to nuke. After nuking, it partitions everything properly, and makes everything *just work™*. You must run an elevated shell (Cmd) to run this script. See the [docs](https://eankeen.github.io/portable-workstation) for more information.

- Powershell
- Scoop
- Cmder (via Scoop)
- Git (via Scoop)

If you see something like `Access to a CIM resource was not available to the client`, etc., it means you need to run an elevated Powershell console.

```batch
@"%SystemRoot%\System32\WinsdowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/EanKeen/portable-workstation/master/install/InstallFull.ps1'))"
```

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/EanKeen/portable-workstation/master/install/InstallFull.ps1'))
```

See the [installation](installation.md) for more details.