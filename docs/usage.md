# Usage

View purpose of each generated folder. Customize any of the default folder names inside of `portable.config.json`; details at [schema](schema.md) page.

## Generated Folders

### Applications (`./_portable-applications`)

* Add any portable apps here
* Make sure to add an entry to `portable.config.json` (more info [here](schema.md))
* Avoid creating folders with a single item
* Shortcut will be generated for each at `./portable-shortcuts` (about shortcuts [here](###shortcuts-(`./portable-shortcuts`)))

### Binaries (`./_portable-binaries`)

* Add any binaries here
* Make sure to add an entry in `portable.config.json` (more info [here](schema.md))
* wip: integrate scoop so you don't have to manually download binaries

### Custom Scripts (`./_portable-custom`)

* Contains this repository
* Location of `portable.config.json`. (more info on [schema](schema.md) page)

### Scripts (`./_portable-scripts`)

* Default script location at `./_portable-custom/script.ps1`
* Custom script is dotted
* More information about accessing hooks at [hooks](hooks.md) page
* Use built-in methods found in [methods](methods.md) page

### Shortcuts (`./portable-shortcuts`)

* Any applications added in `./_portable-applications` and added to `portable.config.json` will have shortcuts created here (more info [here](schema.md))
