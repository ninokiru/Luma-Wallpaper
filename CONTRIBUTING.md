# Contributing to Luma Wallpaper

Luma Wallpaper is a fork of [Lively Wallpaper](https://github.com/rocksdanister/lively).
Everything below is what this repository actually does; there is no wiki and no separate
documentation site, so if a page and this file disagree, the code wins.

## Building

The project is built by [`.github/workflows/build.yml`](.github/workflows/build.yml) on
`windows-latest`. That workflow is the reference setup — a local build only needs the .NET SDK
and workloads it installs:

- **.NET SDK 8** with the Windows Desktop workload (`net8.0-windows` WPF and WinUI projects).
- **MSBuild / C++ toolchain** for the native packages the media and ML code pull in.
- **Inno Setup 6**, used only by the installer job.

Three projects are published and merged into one flat folder:

| Project | Output | Role |
|--|--|--|
| `src/Lively/Lively` | `Lively.exe` | core: desktop handling, wallpaper orchestration, gRPC server |
| `src/Lively/Lively.UI.WinUI` | `Lively.UI.WinUI.exe` | the window the user sees |
| `src/Lively/Lively.Player.WebView2` | `Lively.Player.WebView2.exe` | the only renderer, one process per screen |

`Lively.UI.Shared` is a shared project without its own `.csproj`; its files compile inside the
UI project. Anything else under `src/Lively` (`Lively.Utility.Screensaver`,
`Lively.Utility.Commandline`, `ConsoleDemo`) is a leftover from upstream that the workflow never
publishes — do not add features there.

Pushing a `v*` tag makes the workflow create a GitHub Release with the installer and the portable
archive attached. The in-app updater reads that same release list, so the asset names
(`luma_setup_x64_full_v*`, `luma-win-x64-portable`) are part of the contract and must not change.

## Pull requests

- Target `main`, one topic per pull request, and say which screen or behaviour it affects.
- The CI build is the only gate; when it fails, the annotations it prints are the review.
- Keep the diff readable: no reformatting of untouched files, and new binary assets belong in
  `resources`, not under `src`.

## Interface text

Both languages live in the repository, side by side and with identical key sets:

- `src/Lively/Lively.UI.WinUI/Strings/en-US/Resources.resw`
- `src/Lively/Lively.UI.WinUI/Strings/vi-VN/Resources.resw`

A page binds a control with `x:Uid="SomeKey"` and the loader appends `.Header`, `.Description`,
`.Text` or `.Content`. Adding a control without the matching node in **both** files leaves an
empty label in one of them, so translate in the same pull request. English and Vietnamese are
the only shipped languages; others were dropped and will not be accepted back.

## Reporting problems

Open [an issue](https://github.com/ninokiru/Luma-Wallpaper/issues) with the version shown on the
Updates page, the Windows build, and the logs from `%LocalAppData%\Luma Wallpaper\logs` — the
core, the UI and every player write one file each.
