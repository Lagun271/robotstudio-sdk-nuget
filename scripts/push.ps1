<#
.SYNOPSIS
  Pushes the packed .nupkg files to nuget.org.

.DESCRIPTION
  Needs a nuget.org API key with push rights for the Lagun271.* package IDs, either passed via
  -ApiKey or set in the NUGET_API_KEY environment variable. Existing versions are skipped
  (--skip-duplicate); bump RobotStudio or unlist/delete the version on nuget.org to republish.

.EXAMPLE
  ./scripts/pack.ps1; ./scripts/push.ps1
#>
param(
    [string]$ApiKey = $env:NUGET_API_KEY,
    [string]$Source = 'https://api.nuget.org/v3/index.json',
    [string]$Dotnet = 'dotnet.exe'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $repoRoot 'artifacts\nuget'
$packages = @(Get-ChildItem $outDir -Filter *.nupkg -ErrorAction SilentlyContinue)
if ($packages.Count -eq 0) {
    throw "No packages in $outDir. Run ./scripts/pack.ps1 first."
}

if (-not $ApiKey) { throw 'No nuget.org API key. Pass -ApiKey or set $env:NUGET_API_KEY.' }

foreach ($package in $packages) {
    & $Dotnet nuget push $package.FullName --source $Source --api-key $ApiKey --skip-duplicate
    if ($LASTEXITCODE -ne 0) {
        throw "Push failed for $($package.Name)."
    }
}
