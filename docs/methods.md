# Built-In Methods

You can customize how this application functions by using the in-built hooks. There in-build methods you can use. Most are in `initialize-helper-functions.ps1`.

## `print_title`

```ps
"title" | print_title
print_title "title"
```

## `print_info`

```ps
"info description" | print_info "info heading"
print_info "info heading" "info description"
```

## `print_warning`

```ps
"warning description" | print_warning "warning heading"
print_warning "warning heading" "warning description"
```

## `print_error`

```ps
"error description" | print_error "error heading"
print_error "error heading" "error description"
```

## `normalize_path`

```ps
normalize_path $absolutePath $relativePath
normalize_path "F:\alfa\bravo" "..\charlie"
normalize_path "G:/delta/echo" "foxtrot/golf"
```

## `add_object_prop`

If property exists, this method does not overwrite.

```ps
add_object_prop $obj $prop $propValue
add_object_prop $(New-Object -TypeName PsObject) "sierra" "s"
```

## `obj_not_has_prop`

Returns boolean value. Used by `add_object_prop`

```ps
$obj | obj_not_has_prop $prop`
$(New-Object -TypeName PsObject | Add-Member -Name "tango" -Value "t" -MemberType NoteProperty) | obj_not_has_prop "tango"`
```

## `exit_program`

Program's press 'q' to exit screen

```ps
exit_program
```

## `write_to_config`

Writes to a `user_profile.sh` `user_profile.ps1` or `user_profile.cmd` Cmder config file. used by `write_(comment|variable|path|alias)_to_config`

```ps
write_to_config $var $configFile $content
write_to_config $var $var.allConfig "Writing content to all config files"
write_to_config $var $var.psConfig "Writing content to only Cmder ps config file"
```

## `write_comment_to_config`

```ps
write_comment_to_config $var $configFile $comment
```

## `write_variable_to_config`

```ps
write_variable_to_config $var $configFile $variableName $variableValue
write_variable_to_config $var $var.cmdConfig "seven" "8"
```

## `write_path_to_config`

```ps
write_path_to_config $var $configFile $binName $filePath
write_path_to_config $var $var.allConfig "Java" "C:/zebra/bin/java"
```

## `write_alias_to_config`

```ps
write_alias_to_config $var $configFile $aliasName $aliasValue
write_alias_to_config $var $var.allConfig "gs" "git status"
```
