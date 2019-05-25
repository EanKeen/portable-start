# Schema

## Overview

To use portable-workstation, you must setup a config file. Inside `_portable-scripts`, create a `portable.config.json`. Anything in this config file overwrites what's in `default.config.json`. Do *not* modify `default.config.json`.

## default.config.json

```json
{
  "relPathsTo": {
    "applications": "../_portable-applications",
    "binaries": "../_portable-binaries",
    "shortcuts": "../_portable-shortcuts",
    "scoopApps": "../_portable-scoops",
    "cmderConfig": "../_portable-applications/cmder/config",
    "sourceToAccessHooks": "../_portable-custom/script.ps1"
  },
  "aliases": [
    {
      "name": "e.",
      "value": "explorer .",
      "use": ["cmd"]
    },
    {
      "name": "gl",
      "value": "git log --oneline --all --graph --decorate  $*",
      "use": ["cmd"]
    }
  ]
}
```

## Schema

Inside of `portable.config.json`, you can add the following properties

## `aliases`

An array of objects that looks like the following. Both `name` and `value` are required.

```json
{
  "name": "gs",
  "value": "git status"
}
```

## `aliasesObj`

An object that contains the following properties

### `bash`

An array of objects that looks like the following. Both `name` and `value` are required.

```json
{
  "name": "ll",
  "value": "ls -al"
}
```

### `ps`

An array of objects that looks like the following. Both `name` and `value` are required.

```json
{
  "name": "test",
  "value": "New-Object -TypeName PsObject | ConvertTo-Json | Write-Host"
}
```

### `cmd`

An array of objects that looks like the following. Both `name` and `value` are required.

```json
{
  "name": "e .",
  "value": "explorer .",
}
```

## `applications`

An array of objects that look like the following. Path is required. Name is optional. If name is not included, it will default to whatever is before the forward / backwards slash.

```json
{
  "path": "cmder/Cmder"
}
```

```json
{
  "name": "VSCode",
  "path": "vscode/Code"
},
```

```json
{
  "path": "quicklook/QuickLook",
  "launch": "auto"
}
```

## `binaries`

An array of objects that look like the following. Path is required. Name is optional. If name is not included, it will default to whatever is before the forward / backwards slash.

```json
{
  "name": "VScode",
  "path": "../_portable-applications/vscode"
}
```

```json
{
  "path": "cmake/bin"
}
```

## `relPathsTo`

An object that contains the following properties.

```json
{
  "applications": "../_portable-applications",
  "binaries": "../_portable-binaries",
  "shortcuts": "../_portable-shortcuts",
  "scoopApps": "../_portable-scoops",
  "cmderConfig": "../_portable-applications/cmder/config",
  "sourceToAccessHooks": "../_portable-custom/script.ps1"
}
```

All properties are relative to a file inside `_portable-scripts` (ex. `ExecutePortableScripts.ps1` or `portable.config.json`)