# portable-workstation

Bootstraps the creation of a USB configured with Scoop. Contains scripts to make Scoop more portable.

## Archive
This project has been archived. Expect no further deveopment. Rather than using this tool, simply format the file system on your portable device as NTFS. Then follow the [scoop instalation procedures](https://github.com/lukesampson/scoop) and create a simple script that changes environmental variables on the fly. No abstractions that obfuscate a simple procedure; no fancy setup.

## Installation Procedure

Nukes and partitions a selected disk. It installs

- Powershell
- Scoop

Because Scoop is a package manager, you can also install stuff like Cmder, Git, etc.

Paste the following in any elevated Cmd shell to install these scripts. It will ask which USB you'd like to nuke.

```batch
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/InstallFull.ps1'))"
```

See the [docs](https://eankeen.github.io/portable-workstation) for more details.
