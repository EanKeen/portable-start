# Hooks

You can use hooks starting from the `custom/script.ps1` file. There are two hooks.

```powershell
portable_hook_after_start
portable_hook_after_scoop
```

The hook name implies when the hook executes. See exactly where they execute in the [`ExecutePortableScripts.ps1`](https://github.com/eankeen/portable-workstation/blob/feat/simplify/ExecutePortableScripts.ps1) file.

## Example

```powershell
function portable_hook_after_scoop($config) {
  print_info "task" "Done creating Scoop environment variables"
}
```

# Built-In Methods

You can customize how this application functions by using the in-built hooks. There in-build methods you can use. Most are in `/util\/.*\.ps1/`.

## Printing Stuff to Console

### `print_title`

*Warning* piping may not completely work 100%, so don't use it when debugging

```powershell
"title" | print_title
print_title "title"
```

### `print_info`

*Warning* piping may not completely work 100%, so don't use it when debugging

```powershell
"info description" | print_info "info heading"
print_info "info heading" "info description"
```

### `print_warning`

*Warning* piping may not completely work 100%, so don't use it when debugging

```powershell
"warning description" | print_warning "warning heading"
print_warning "warning heading" "warning description"
```

### `print_error`

*Warning* piping may not completely work 100%, so don't use it when debugging

```powershell
"error description" | print_error "error heading"
print_error "error heading" "error description"
```

## Writing to the Cmder Configs

### `write_to_config`

Writes to a `user_profile.sh` `user_profile.ps1` or `user_profile.cmd` Cmder config file. used by `write_(comment|variable|path|alias)_to_config`

```powershell
write_to_config $var $configFile $content
write_to_config $var $var.refs.allConfig "Writing content to all config files"
write_to_config $var $var.refs.psConfig "Writing content to only Cmder ps config file"
```

### `write_comment_to_config`

```powershell
write_comment_to_config $var $configFile $comment
```

### `write_variable_to_config`

```powershell
write_variable_to_config $var $configFile $variableName $variableValue
write_variable_to_config $var $var.refs.cmdConfig "seven" "8"
```

### `write_path_to_config`

```powershell
write_path_to_config $var $configFile $binName $filePath
write_path_to_config $var $var.refs.allConfig "Java" "C:/zebra/bin"
write_path_to_config $var $var.refs.allConfig "Go" "C:\xray\bin"
```

### `write_alias_to_config`

```powershell
write_alias_to_config $var $configFile $aliasName $aliasValue
write_alias_to_config $var $var.refs.allConfig "gs" "git status"
```

## Miscenaleious

### `normalize_path`

```powershell
normalize_path $absolutePath $relativePath
normalize_path "F:\alfa\bravo" "..\charlie"
normalize_path "G:/delta/echo" "foxtrot/golf"
```

### `add_object_prop`

If property exists, this method does not overwrite.

```powershell
add_object_prop $obj $prop $propValue
add_object_prop $(New-Object -TypeName PsObject) "sierra" "s"
```

### `obj_not_has_prop`

Returns boolean value. Used by `add_object_prop`

```powershell
$obj | obj_not_has_prop $prop`
$(New-Object -TypeName PsObject | Add-Member -Name "tango" -Value "t" -MemberType NoteProperty) | obj_not_has_prop "tango"`
```

### `exit_program`

Program's press 'q' to exit screen

```powershell
exit_program
```
