# Hooks
From the `sourceToAccessHooks` property in your config, you can reference a PowerShell file. In there, you can access the following hooks:

* `after_create_variables`
* `after_create_cmder_files`
* `after_create_shortcuts`
* `after launch apps`

The `$config` is precisely what you see in `abstraction.config.json`.
Example
```ps
function after_create_variables($config, $var) {
  print_info "task" "Done creating variables"
}
```

Learn the built-in functions you can use [here](/methods)