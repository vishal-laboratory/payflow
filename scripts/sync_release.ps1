param(
  [string]$BuildOutputPath = "build/app/outputs/flutter-apk/app-release.apk",
  [string]$ReleaseFolderPath = "release"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $BuildOutputPath)) {
  throw "Release APK not found at '$BuildOutputPath'. Run 'flutter build apk --release' first."
}

New-Item -ItemType Directory -Force -Path $ReleaseFolderPath | Out-Null

$releaseApkPath = Join-Path $ReleaseFolderPath "payflow-latest.apk"
$releaseInfoPath = Join-Path $ReleaseFolderPath "release-info.txt"

Copy-Item -Force $BuildOutputPath $releaseApkPath

$buildInfo = @(
  "Source: $BuildOutputPath"
  "Copied: $(Get-Date -Format o)"
  "Target: $releaseApkPath"
) -join [Environment]::NewLine

Set-Content -Path $releaseInfoPath -Value $buildInfo

Write-Host "Synced latest release to $releaseApkPath"