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

These packages contain compile-time reference assemblies only — trimmed to public type/member
signatures, with implementation bodies stripped. No ABB RobotStudio implementation code is
distributed; RobotStudio supplies the real assemblies at runtime. The repository never contains
the DLLs; packages are built locally from an installed RobotStudio.

ABB and RobotStudio are trademarks of ABB. This project is not affiliated with or endorsed by ABB.

## Pack and push

Requires RobotStudio and the RobotStudio SDK installed, and a nuget.org API key with push rights
for the `Lagun271.*` package IDs:

```powershell
./scripts/pack.ps1                              # -> artifacts/nuget/*.nupkg
./scripts/push.ps1 -ApiKey <nuget.org API key>   # -> https://api.nuget.org
```

## Consume

Plain nuget.org packages — no custom source, no credentials:

```xml
<packageSources>
  <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
</packageSources>
```

Project reference (compile-only; nothing is copied to the output):

```xml
<PackageReference Include="Lagun271.RobotStudio.Sdk.Ref" Version="26.3.11794" PrivateAssets="all" />
```
