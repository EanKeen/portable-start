# Check to be sure all paths user is entering is correct
function check_path_exists($pathName, $pathValue) {
    if (Test-Path -Path $pathValue) {
        print_info $pathName "`"$pathValue`" reference exists"
    }
    else {
        print_error $pathName "`"$pathValue`" reference does not exist"
        exit_program
    }
}

function check_relPathsTo($var, $config) {
    foreach ($relPath in $config.relPathsTo.PsObject.Properties) {
        check_path_exists $relPath.Name $relPath.Value
    }
}

function check_paths_in_config_exist($var, $config) {
    check_relPathsTo $var $config
}

