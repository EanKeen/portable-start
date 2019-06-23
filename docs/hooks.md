# Hooks

From the `sourceToAccessHooks` property in your config, you can reference a PowerShell file. In there, you can access the following hooks:

```powershell
portable_hook_after_start
portable_hook_after_create_scoop_files
```

The time at which they're executed can be implied from the name of the hook.

## Example

```powershell
function portable_hook_after_create_variables($config, $var) {
  print_info "task" "Done creating variables"
}
```
