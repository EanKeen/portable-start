# Hooks
From the `sourceToAccessHooks` property in your config, you can reference a PowerShell file. In there, you can access the following hooks:

```powershell
portable_hook_after_create_variables
portable_hook_after_create_cmder_files
portable_hook_after_create_shortcuts
portable_hook_after_launch apps
```
The time at which they're executed can be implied from the name of the hook.

## Example

```powershell
function portable_hook_after_create_variables($config, $var) {
  print_info "task" "Done creating variables"
}
```

## Varaible `$config`
* A PowerShell Object representation of `./default.config.json`, with some extra transformations
* Any implicit / optional propeties in `./default.config.json` are made explicit
* `$config` is a superset of `./log/abstraction.config.json`
  *  You're safe to use any properties of `$config` found in `./log/abstraction.config.json`
  *  *Do not* access properties of `$config.relPathsTo`, because they are relative paths. Look for absolute paths in `$vars`
* See the [schema](/schema) page for how `$config` is structured

## Variabe `$var`
* `$vars` variable ouputed to `./log/abstraction.vars.json`
* It's an object that contains the following properties

### `$var.appDir`
Absolute path of `$config.relPathsTo.applications`

### `$var.binDir`
Absolute path of `$config.relPathsTo.binaries`

### `$var.shortcutsDir`
Absolute path of `$config.relPathsTo.shortcuts`

### `$var.cmderConfigDir`
Absolute path of `$config.relPathsTo.cmderConfig`

### `$var.sourceToAccessHooks`
Absolute path of `$config.relPathsTo.sourceToAccessHooks`

### `$var.portableDir`
Absolute path of directory in which `./_portable-scripts/ExecutePortableScripts` is located, so absolute path of `./_portable-scripts`

### `$var.bashConfig`, `$var.psConfig`, and `$var.cmdConfig`
Respectively, they are
```powershell
Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.sh"
Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.ps1"
Join-Path -Path $var.cmderConfigDir -ChildPath "user_profile.cmd"
```
Note that these are absolute paths as well.

### `$var.allConfig`
The string "allConfigFiles"

Use this in any place you would use `$var.bashConfig`, `$var.psConfig`, or `$var.cmdConfig`.

### `$var.cmdUserAliases`
Path of file to specify aliases for Cmd (used by Cmder)
```powershell
Join-Path -Path $var.cmderConfigDir -ChildPath "user_aliases.cmd"
```

## `$var.Usable` Methods
Learn the built-in functions you can use [here](/methods)
