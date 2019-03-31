function propIsInObject($obj, $prop) {
  $propFound = $false
  $obj.PsObject.Properties | ForEach-Object {
    if(($_.Name -eq $prop) -and -not $propFound) {
      # Write-Host "$prop is in $obj"
      $propFound = $true
      return
    }
  }
  if(-not $propFound) {
    # Write-Host "$prop is NOT IN $obj"
  }
  $propFound
}

# $config = Get-Content -Path "./portable.config.json" -Raw | ConvertFrom-Json
$config = Get-Content -Path "./test.json" -Raw | ConvertFrom-Json

propIsInObject $config "aliasesObj"
propIsInObject $config "aaa"
propIsInObject $config "bbb"
propIsInObject $config "bbbfoo"
propIsInObject $config "bbbaaa"
propIsInObject $config "babel"
propIsInObject $(New-Object -TypeName PsObject) ""
propIsInObject $(New-Object -TypeName PsObject) "aliasesObj"


