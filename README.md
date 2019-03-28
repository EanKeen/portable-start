# portable-workstation
## Schema for portable.config.json

```json
{
    "config"
}
```

{
  "config": {
    "name": "Edwin Kofler",
    "relativePathToBinary": "../_binary",
    "relativePathToCmderConfig": "../cmder/config",
    "relativePathToApplications": "../"
  },
  "applications": [
    {
      "name": "Cmder",
      "path": "cmder/Cmder"
    },
    {
      "name": "QuickLook",
      "path": "quicklook/QuickLook",
      "launch": "auto"
    },
    {
      "name": "Ueli",
      "path": "ueli/ueli",
      "launch": "auto"
    }
  ],
  "paths": [
    {
      "path": "7zip-cli"
    },
    {
      "path": "7zip-cli-a"
    }
  ],
  "variables": [
    {
      "name": "six",
      "value": "6"
    },
    {
      "name": "seven",
      "value": "7"
    }
  ],
  "aliases": [
    {
      "name": "gs",
      "value": "git status"
    }
  ]
}