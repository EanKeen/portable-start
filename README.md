# portable-workstation

## Schema for portable.config.json

will have actual good documentation later

```json
{
  "config": {
    "name": "Edwin Kofler", // doesn't do anything yet
    "relativePathToBinary": "../_binary",
    "relativePathToCmderConfig": "../cmder/config",
    "relativePathToApplications": "../",
    "applications": [
      {
        "name": "Cmder",
        "path": "cmder/Cmder"
      },
      {
        "name": "QuickLook",
        "path": "quicklook/QuickLook",
        "launch": "auto" // optional. Launch keywords include auto, prompt, and autoForce. "prompt" is default. autoForce launches the app even if it already exists
      }
    ],
    "paths": [
      {
        "name": "cmake", // optional. Just for better loggin in output
        "path": "cmake/bin"
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
}
```
