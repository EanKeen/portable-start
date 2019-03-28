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
        if ($key.Character -eq 'y') {
            launch_app $appName $absolutePathsToApp
        }
        elseif ($key.Character -eq 'n') {}
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
    $json.applications | ForEach-Object -Process {
        $appName = $_.Name
        $relativePathToApp = $_.Path
        $appPrompt = $_.Launch

        $absolutePathsToApp = normalize_path $var.appDir $relativePathToApp
        if($appPrompt -eq $null) {
            $appPrompt = "prompt"
        }

        $exeName = Split-Path -Path $relativePathToApp -Leaf

       prompt_to_launch_app $appName $exeName $absolutePathsToApp $appPrompt
    }
}