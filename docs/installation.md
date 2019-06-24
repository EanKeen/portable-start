# Installation

## Full Installation (Recommended)

Bootstraps the creation of a USB configured with Scoop using an elevated Batch or PowerShell shell. It does the following

* Downloads & unzips portable-workstation repository
* Downloads & unzips PowerShell Core 6.2 32bit (~52 MB)
* Creates `.bat` file to run `ExecutePortableScripts.ps1` (so you just have to double click it the `.bat` file)
* Downloads Scoop
* Downloads Cmder (via Scoop)
* Downloads Git (via Scoop)

### With Batch Script

```cmd
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/InstallFull.ps1'))"
```

### With PowerShell Script

```ps
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/eankeen/portable-workstation/master/install/InstallFull.ps1'))
```

The scrip above should work, if you're still having problems with [ExecutionPolicy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6), you may need to manually set it as `unrestricted` temporarily. Or, just use the Batch script.

## Generated Installation Folders

### Scripts (`./_portable-scripts`)

* Default script location at `./_portable-custom/script.ps1`
* Custom script is dotted
* More information about accessing hooks at [hooks](hooks.md) page
* Use built-in methods found in [methods](methods.md) page

### Binaries (`./_portable-binaries`)

* Folder powershell is automatically installed into
* Right now it doesn't really do anything, but maybe you can integrate it with Cmder or something

## Next steps

Everything is now setup!
You should have access to the `scoop` command. Learn more about it [here](https://github.com/lukesampson/scoop). Be sure to check out the [ConEmu](https://conemu.github.io/en/ConEmuEnvironment.html) documentation if you're using Cmder.

If you want to customize your installation further, see [customization](./customization.md)
