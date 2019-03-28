function launch_app($appName, $absolutePathsToApp) {
  # if(Get-Process $exeName -ea SilentlyContinue) {

  # }
  print_info "application" "launching $appName"
  Start-Process -FilePath $absolutePathsToApp | Out-Null
}

function prompt_to_launch_app($appName, $exeName, $absolutePathsToApp, $appPrompt) {
  if($appPrompt -eq "prompt") {
    print_warning "Would you like to open ${appName}?"
    $key = $Host.UI.RawUI.ReadKey()
    Write-Host "`r`n"
    if($key.Character -eq 'y') {
      launch_app $appName $absolutePathsToApp
    }
    elseif($key.Character -eq 'n') {}
    else {
      # Any other character, repeat input
      prompt_to_launch_app $appName $absolutePathsToApp $appPrompt
    }
  }
  elseif($appPrompt -eq "auto") {
    launch_app $appName $absolutePathsToApp
  }
}

function prompt_to_launch_apps($var, $json) {
  foreach($app in $json.applications)
    $absolutePathsToApp = normalize_path $var.appDir $appPathRelative
    $appExeName = Split-Path -Path $appPathRelative -Leaf

    if($app.launch -eq $null) {
      $app.launch = "prompt"
    }


    prompt_to_launch_app $appName $pathExeName $absolutePathsToApp
  }
}