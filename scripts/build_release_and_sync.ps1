param(
  [string]$BuildOutputPath = "build/app/outputs/flutter-apk/app-release.apk",
  [string]$ReleaseFolderPath = "release"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$absoluteBuildOutputPath = Join-Path $repoRoot $BuildOutputPath
$absoluteReleaseFolderPath = Join-Path $repoRoot $ReleaseFolderPath

Push-Location $repoRoot
try {
  flutter build apk --release
} finally {
  Pop-Location
}

& "$PSScriptRoot/sync_release.ps1" -BuildOutputPath $absoluteBuildOutputPath -ReleaseFolderPath $absoluteReleaseFolderPath