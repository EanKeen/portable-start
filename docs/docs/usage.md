# Usage
Clone this project in any directory on USB.
```bash
git clone https://github.com/EanKeen/portable-workstation.git
cd portable-workstation
touch portable.config.json
```

Then, just setup a configuration schema [here](/schema).

Then, just run `Portable-Start.ps1`. I would recommend setting up a `.bat` file that opens it.
```cmd
start ..\_bin\powershell\pwsh.exe -ExecutionPolicy Bypass -file .\Portable-Start.ps1
:: or
start powershell -ExecutionPolicy Bypass -file .\Portable-Start.ps1

```