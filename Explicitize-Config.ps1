function global_json() {
    # print_info "`$json" "Creating global object"
    $configFile = "./new.portable.config.json"
    # todo: fix bug where portable.config.json is found but does not contain an object
    if(Test-Path -Path $configFile) {
        $json = Get-Content -Path $configFile | ConvertFrom-Json
        fill_default_json_props $json
        $json
        return
    }
    $json = New-Object -TypeName PsObject
    fill_default_json_props $json
}

function global_vars() {
    print_info "`$vars" "Creating global object"
    $b = New-Object -TypeName PsObject
    print_warning "e" $b
}
