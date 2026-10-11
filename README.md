# robotstudio-sdk-nuget

Compile-time reference packages for ABB RobotStudio add-in projects, built from a local RobotStudio installation.

| Package | Contents | Taken from |
|---|---|---|
| `Lagun271.RobotStudio.Sdk.Ref` | `ABB.Robotics.Math`, `ABB.Robotics.RobotStudio`, `.Controllers`, `.Documents`, `.Environment`, `.Stations`, `.Stations.Forms`, `.UI` | `ABB\SDK\RobotStudio <ver> SDK` |
| `Lagun271.RobotStudio.PcSdk.Ref` | `ABB.Robotics.Controllers.PC` | `ABB\SDK\RobotStudio <ver> SDK` |
| `Lagun271.RobotStudio.Internal.Ref` | `StationManagement` (`ABBInternal.*`, not public SDK) | `ABB\RobotStudio <ver>\Bin` |

Assemblies are packed under `ref/net10.0/` only: projects compile against them, nothing is copied to the add-in
output, and RobotStudio supplies the real assemblies at runtime. The package version is the RobotStudio build
(for example `26.3.11794` for RobotStudio 2026).

Not packed from the SDK folder: `RspakTool.dll` (packaging tool), `RobotStudio.Resources.dll` (UI resources),
`Microsoft.Extensions.FileSystemGlobbing.dll` (available from nuget.org).

## Licensing

The packaged DLLs are ABB property and are not redistributable. Publish only to the private
`nuget.pkg.github.com/Lagun271` feed and keep this repository private. The repository never contains the DLLs;
packages are built locally from an installed RobotStudio.

## Pack and push

Requires RobotStudio and the RobotStudio SDK installed, and a GitHub CLI token with package scopes:

```powershell
gh auth refresh -h github.com -s write:packages,read:packages
./scripts/pack.ps1            # -> artifacts/nuget/*.nupkg
./scripts/push.ps1            # -> https://nuget.pkg.github.com/Lagun271/index.json
```

## Consume

`NuGet.Config` in the consuming repo:

```xml
<packageSources>
  <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
  <add key="lagun271" value="https://nuget.pkg.github.com/Lagun271/index.json" />
</packageSources>
<packageSourceMapping>
  <packageSource key="nuget.org"><package pattern="*" /></packageSource>
  <packageSource key="lagun271"><package pattern="Lagun271.*" /></packageSource>
</packageSourceMapping>
```

Restore needs credentials for the `lagun271` source (a token with `read:packages`), for example:

```powershell
dotnet nuget update source lagun271 --username <github-user> --password (gh auth token) --store-password-in-clear-text --configfile $env:APPDATA\NuGet\NuGet.Config
```

Project reference (compile-only; nothing is copied to the output):

```xml
<PackageReference Include="Lagun271.RobotStudio.Sdk.Ref" Version="26.3.11794" PrivateAssets="all" />
```
