Remove-Item .\*.zip
$info = Get-Content ruler-mod/info.json | ConvertFrom-Json
$archive = ".\ruler-mod_$($info.version).zip"
& 'C:\Program Files\7-Zip\7z.exe' a $archive ruler-mod
Copy-Item $archive $env:APPDATA\Factorio\mods\