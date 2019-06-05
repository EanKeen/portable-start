# portable-workstation

## Home

This Portable Workstation project includes scripts for geting a development workstation started on a Windows PC from a thumbdrive. However, a thumbdrive is not a requirement.

## Roadmap

- Create shortcuts

## Summary

This repository contains tooling that allows you to use whatever tooling you need across computers. Access your Cmd, Powershell, or Bash console with Cmder. Add binaries to the PATHS of all (or some of) your shells with only *one* file. Add aliases and variables to some or to all of your shells. Manage any portable applications you have, such as VSCode, Sublime Text, Blender, Audacity, 7Zip etc. in a single file. Create shortcuts to these applications for easy access. Configure all these features from one, easy to understand `.json` file.

## Simple Installation

### Method Full (Recommended)

#### Do not test yet. Not yet complete

Nukes and partitions a selected disk. It downloads the following programs (including the Scoop package manager). See the [docs](https://eankeen.github.io/portable-workstation) for more information.

- Powershell
- Scoop
- Cmder (via Scoop)
- Git (via Scoop)

Paste the following in any elevated Cmd or PowerShell shell to install (and nuke) a thumbdrive.

```batch
@"%SystemRoot%\System32\WinsdowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/InstallFull.ps1'))"
```

### Install Bare

It downloads the following programs. There is no package manager. See the [docs](https://eankeen.github.io/portable-workstation) for more information.

- Cmder (with Git for Windows)
- Powershell

Paste the following in any directory of your thumbdrive to install it in that directory.

```batch
@"%SystemRoot%\System32\WinsdowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/InstallBare.ps1'))"
```

See the [docs](https://eankeen.github.io/portable-workstation) for more details.
