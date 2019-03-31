# Usage
Clone this project in any directory on USB.
```bash
git clone https://github.com/EanKeen/portable-workstation.git
cd portable-workstation
touch portable.config.json
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