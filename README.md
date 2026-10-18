# robotstudio-sdk-nuget

Compile-time reference packages for ABB RobotStudio add-in projects, built from a local RobotStudio installation.

| Package | Contents | Taken from |
|---|---|---|
| `Lagun271.RobotStudio.Sdk.Ref` | `ABB.Robotics.Math`, `ABB.Robotics.RobotStudio`, `.Controllers`, `.Documents`, `.Environment`, `.Stations`, `.Stations.Forms`, `.UI` | `ABB\SDK\RobotStudio <ver> SDK` |
| `Lagun271.RobotStudio.PcSdk.Ref` | `ABB.Robotics.Controllers.PC` | `ABB\SDK\RobotStudio <ver> SDK` |

Only packages taken from ABB's published SDK folder are packed here. `StationManagement.dll`
(`ABBInternal.*`, taken from RobotStudio's `Bin` folder rather than the SDK folder) is
**not** part of the public SDK and is not packaged or redistributed by this repo.

Assemblies are packed under `ref/net10.0/` only: projects compile against them, nothing is copied to the add-in
output, and RobotStudio supplies the real assemblies at runtime. The package version is the RobotStudio build
(for example `26.3.11794` for RobotStudio 2026).

Not packed from the SDK folder: `RspakTool.dll` (packaging tool), `RobotStudio.Resources.dll` (UI resources),
`Microsoft.Extensions.FileSystemGlobbing.dll` (available from nuget.org).

## Licensing

ABB licenses the RobotStudio SDK under BSD-3-Clause (full text and copyright notice in
[`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md), as
[published by ABB](https://developercenter.robotstudio.com/api/robotstudio/articles/Introduction/License-Agreement.html)),
which permits redistribution in binary form.

ABB and RobotStudio are trademarks of ABB. This project is not affiliated with or endorsed by ABB.

The above is specifically about the packaged reference assemblies. This repo's own code (project
files, build scripts) is licensed under MIT — see [`LICENSE`](LICENSE).

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
