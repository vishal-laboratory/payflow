param(
  [string]$BuildOutputPath = "build/app/outputs/flutter-apk/app-release.apk",
  [string]$ReleaseFolderPath = "release"
)

$ErrorActionPreference = "Stop"

flutter build apk --release

& "$PSScriptRoot/sync_release.ps1" -BuildOutputPath $BuildOutputPath -ReleaseFolderPath $ReleaseFolderPath