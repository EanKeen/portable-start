# portable-workstation

## Roadmap

- Automatically create shortcuts
- integrate with scoop
- autohotkey?
- use is_directory to fix issue with only creating directories when prompted

# Home

This Portable Workstation project includes scripts for geting a development workstation started on a Windows PC from a thumbdrive. However, a thumbdrive is not a requirement.

## Summary

This repository contains tooling that allows you to use whatever tooling you need across computers. Access your Cmd, Powershell, or Bash console with Cmder. Add binaries to the PATHS of all (or some of) your shells with only *one* file. Add aliases and variables to some or to all of your shells. Manage any portable applications you have, such as VSCode, Sublime Text, Blender, Audacity, 7Zip etc. in a single file. Create shortcuts to these applications for easy access. Configure all these features from one, easy to understand `.json` file.

## Simple Installation

In any directory of your thumbdrive, open a Cmd window and paste the following

```batch
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/EanKeen/portable-workstation/master/install/Install.ps1'))"
```

See the [docs](https://eankeen.github.io/portable-workstation) for more details.