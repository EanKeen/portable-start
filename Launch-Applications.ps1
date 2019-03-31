function launch_app($app, $absolutePathToApp) {
  print_info "application" "launching $($app.name)"
  &$absolutePathToApp
  # Start-Process -FilePath $absolutePathToApp
  # Start-Process -FilePath $absolutePathToApp -RedirectStandardOutput "./stdout.txt" -RedirectStandardError "./stderr.txt" -WindowStyle Minimized
}

function prompt_to_launch_app($app, $appExeName, $absolutePathToApp) {
  # If app is already running
  if(Get-Process $appExeName -ea SilentlyContinue) {
    $appAlreadyRunning = $true
  }
  else {
    $appAlreadyRunning = $false
  }

  if($app.launch -eq "prompt") {
    if($appAlreadyRunning) {
      $warning = "Would you like to open $($app.name) again? It's already running."
    }
    elseif(!$appAlreadyRunning) {
      $warning = "Would you like to open $($app.name)?"
    }
    print_warning $warning

    $key = $Host.UI.RawUI.ReadKey()
    Write-Host "`r`n"
    if($key.Character -eq "y") {
      launch_app $app $absolutePathToApp
      return
    }
    elseif($key.Character -eq "n") {
      print_info "application" "not launching $($app.name)"
      return
    }

    # Any other character, repeat input
    prompt_to_launch_app $app $appExeName $absolutePathToApp
  }
  elseif($app.launch -eq "auto" -and $appAlreadyRunning -eq $false) {
    launch_app $app $absolutePathToApp
  }
  elseif($app.launch -eq "autoForce") {
    launch_app $app $absolutePathToApp
  }
}

function prompt_to_launch_apps($var, $config) {
  foreach($app in $config.applications) {
    $absolutePathToApp = normalize_path $var.appDir $app.path
    $appExeName = Split-Path -Path $app.path -Leaf

    if($app.launch -eq $null) {
      Add-Member -InputObject $app -MemberType NoteProperty -Name "launch" -Value "prompt"
    }

    prompt_to_launch_app $app $appExeName $absolutePathToApp
  }
}