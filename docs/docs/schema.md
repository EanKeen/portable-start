# Schema
To use portable-workstation, you must setup a config file. At the root of your directory
```bash
mkdir portable.config.json
```

# Required Attributes
```json
{
"relPathsTo": {
    "applications": "../",
    "binaries": "../_bin",
    "cmderConfig": "../cmder/config",
    "shortcuts": "../../_portable-shortcuts",
    "sourceToAccessHooks": "./use_hooks.ps1"
  }
}
```

# Implicit Declaration


# Explicit Declaration