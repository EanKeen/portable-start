# Hooks
From the `sourceToAccessHooks` property in your config, you can reference a PowerShell file. In there, you can access the following hooks:

* `portable_hook_after_create_variables`
* `portable_hook_after_create_cmder_files`
* `portable_hook_after_create_shortcuts`
* `portable_hook_after_launch apps`

### Example

```ps
function portable_hook_after_create_variables($config, $var) {
  print_info "task" "Done creating variables"
}
```

* `$config` is a superset of `./log/abstraction.config.json`
  *  Data structure found in `./log/abstraction.config.json`, you're safe to use anyting in there
  *  *Do not* access properties of `$config.relPathsTo`, because they are relative paths. Look for absolute paths in `$vars`
* `$vars` is `./log/abstraction.vars.json`

Learn the built-in functions you can use [here](/methods)