<#
.SYNOPSIS
  Packs the RobotStudio reference-assembly NuGet packages from a local RobotStudio installation.

.DESCRIPTION
  Package version = assembly version (major.minor.build) of ABB.Robotics.RobotStudio.dll in the SDK,
  so packages always match the RobotStudio build they were taken from. Output: artifacts/nuget/*.nupkg.

.EXAMPLE
  ./scripts/pack.ps1
  ./scripts/pack.ps1 -RobotStudioVersion 2026
#>
param(
    [string]$RobotStudioVersion = '2026',
    [string]$Dotnet = 'dotnet.exe'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$programFilesX86 = ${env:ProgramFiles(x86)}
$sdkDir = Join-Path $programFilesX86 "ABB\SDK\RobotStudio $RobotStudioVersion SDK"
$versionSource = Join-Path $sdkDir 'ABB.Robotics.RobotStudio.dll'

if (-not (Test-Path $versionSource)) {
    throw "RobotStudio $RobotStudioVersion SDK not found: $versionSource"
}

$assemblyVersion = [Reflection.AssemblyName]::GetAssemblyName($versionSource).Version
$packageVersion = '{0}.{1}.{2}' -f $assemblyVersion.Major, $assemblyVersion.Minor, $assemblyVersion.Build
Write-Host "RobotStudio $RobotStudioVersion SDK build $assemblyVersion -> package version $packageVersion"

$outDir = Join-Path $repoRoot 'artifacts\nuget'
if (Test-Path $outDir) { Remove-Item -Recurse -Force $outDir }

Get-ChildItem (Join-Path $repoRoot 'src') -Filter *.csproj -Recurse | ForEach-Object {
    & $Dotnet pack $_.FullName -c Release -nologo -v minimal `
        "-p:RobotStudioVersion=$RobotStudioVersion" `
        "-p:PackageVersion=$packageVersion"
    if ($LASTEXITCODE -ne 0) { throw "dotnet pack failed for $($_.Name)" }
}

Get-ChildItem $outDir -Filter *.nupkg | ForEach-Object { Write-Host "Packed $($_.Name)" }
