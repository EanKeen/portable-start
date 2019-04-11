function write_shortcut($shortcutName, $shortcutLocation, $shortcutReference) {
  print_info "write_shortcut" "Writing $shortcutName to $shortcutReference (not really)"
  # $WshShell = New-Object -comObject WScript.Shell
  # $Shortcut = $WshShell.CreateShortcut($shortcutLocation)
  # $Shortcut.TargetPath = $shortcutReference
  # $Shortcut.Save()
  # New-Item -ItemType SymbolicLink -Path $shortcutName -Name $shortcutLocation -Value $shortcutReference
}
function create_shortcuts ($var, $config) {
  foreach($app in $config.applications) {
    if($app.name -eq $null) {
      $exeName = Split-Path $app.path -Leaf
      Add-Member -InputObject $app -MemberType NoteProperty -Name "name" -Value $exeName
    }

    write_shortcut $app.name $var.appDir $(normalize_path $var.appDir $app.path)
  }
}
