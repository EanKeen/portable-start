# Schema

## Overview

To use portable-workstation, you must setup a config file. Inside `_portable-scripts`, create a `portable.config.json`. Anything in this config file overwrites what's in `default.config.json`. Do *not* modify `default.config.json`. Find `default.config.json` [here](https://github.com/eankeen/portable-workstation/blob/master/default.config.json).

Inside of `portable.config.json`, you can add the following properties

## `aliases`

An array of objects that looks like the following.

```json
{
  "name": "gs",
  "value": "git status"
}
```

```md
name: required
value: required
```

## `aliasesObj`

An object that contains the following properties

### `bash`, `ps`, and / or `cmd`

An array of objects that looks like the following.

```json
{
  "name": "ll",
  "value": "ls -al"
}
```

```md
name: required
value: required
```

## `applications`

An array of objects that look like If name is not included, it will default to whatever is before the forward / backwards slash.

```json
{
  "path": "cmder/Cmder"
}
```

```json
{
  "name": "QuickLook",
  "path": "quicklook/QuickLook",
  "launch": "auto"
}
```

```md
name: optional
path: required
launch: optional
```

## `binaries`

An array of objects that look like the following. If name is not included, it will default to whatever is before the forward / backwards slash.

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

```md
name: optional
path: required
```

## `refs`

An object that contains the following properties.

```json
{
  "appDir": "../_portable-applications",
  "binDir": "../_portable-binaries",
  "shortcutsDir": "../_portable-shortcuts",
  "scoopAppsDir": "OMMIT",
  "scoopDir": "OMMIT",
  "cmderConfigDir": "../_portable-applications/cmder/config",
  "hookFile": "../_portable-scripts/custom/script.ps1"
}
```

All `refs` paths are relative to `portable.config.json`.

## `scoopRefs`

An object that contains the following properties

```json
{
  "programsDir": "./_scoop-programs",
  "mainDir": "./_scoop"
}
```

All `refs` paths are relative to the drive letter that stores Scoop files / programs