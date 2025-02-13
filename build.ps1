Remove-Item .\*.zip

$mods = @("ruler-mod", "get-a-cab-mod")

foreach( $mod in $mods )
{
  $info = Get-Content $mod/info.json | ConvertFrom-Json
  $archive = ".\$($mod)_$($info.version).zip"
  & 'C:\Program Files\7-Zip\7z.exe' a $archive $mod
  Copy-Item $archive $env:APPDATA\Factorio\mods\
}
