function get_scoop_drive_letter($driveName) {
  Get-Disk | Get-Partition | Get-Volume | ForEach-Object {
    if($_.FileSystemLabel -eq $driveName) {
        $_.DriveLetter
        return
      }
    }
}
function configure_variables() {
  $configFile = Get-Content 'portable.config.json' | Out-String | ConvertFrom-Json

  # s short for 'scoop'
  $sDriveName = get_scoop_drive_letter $configFile.scoopDriveName
  $sMainDir = normalize_path "${sDriveName}:\" $configFile.scoopMainDir
  $sGlobalDir = normalize_path "${sDriveName}:\" $configFile.scoopGlobalDir
  $portableDriveLetter = (Get-Location).Drive.Name
  $portableDiskNumber = Get-Partition -DriveLetter $portableDriveLetter | Select-Object -ExpandProperty "DiskNumber"

  $config = New-Object -Type PsObject
  $config | Add-Member -NotePropertyName 'scoopDriveLetter' -NotePropertyValue $sDriveName
  $config | Add-Member -NotePropertyName 'scoopMainDir' -NotePropertyValue $sMainDir
  $config | Add-Member -NotePropertyName 'scoopGlobalDir' -NotePropertyValue $sGlobalDir
  $config | Add-Member -NotePropertyName 'portableDriveLetter' -NotePropertyValue $portableDriveLetter
  $config | Add-Member -NotePropertyName 'portableDiskNumber' -NotePropertyValue $portableDiskNumber
  $config
}
