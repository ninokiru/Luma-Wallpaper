
<p align="center">
  <img alt="Files Logo" src="resources/figma_promo_16x9.jpg" width="450" />
  <h2 align="center">Luma Wallpaper</h2>
</p>

[![GitHub release](https://img.shields.io/github/release/ninokiru/Luma-Wallpaper/all.svg)](https://github.com/ninokiru/Luma-Wallpaper/releases)
[![Github all releases](https://img.shields.io/github/downloads/ninokiru/Luma-Wallpaper/total.svg)](https://github.com/ninokiru/Luma-Wallpaper/releases)
[![GitHub stars](https://img.shields.io/github/stars/ninokiru/Luma-Wallpaper.svg)](https://github.com/ninokiru/Luma-Wallpaper/stargazers)
[![Documentation](https://img.shields.io/badge/Docs-WIP-red.svg)](https://github.com/ninokiru/Luma-Wallpaper#features)
[![Issues](https://img.shields.io/github/issues/ninokiru/Luma-Wallpaper.svg)](https://github.com/ninokiru/Luma-Wallpaper/issues)

## Contents
- [About](#about)
- [Features](#features)
- [Download](#download)
- [Support](#support)
- [License](#license)

## About
<img src="/resources/main_preview.gif" width="600" height="338"/>

Luma Wallpaper — animated desktop wallpapers, bring your desktop to life!

#### Questions and help:
* <a href="https://github.com/ninokiru/Luma-Wallpaper/issues">GitHub issues</a> — this fork is small, so everything is answered there.
* <a href="https://www.reddit.com/r/LivelyWallpaper/">Reddit</a> — the upstream Lively community.

## Features
*Wait a sec, preview gif clips take some time to load.*
#### Types Of Wallpapers
| Wallpaper | Example |  Interactive | Resolution | Performance |
|--|--|--|--|--|
| Video/GIF | <img src="/resources/wallpaper_video.gif" width="256" height="144"/><br><a href="https://www.pexels.com/video/blue-texture-abstract-leaves-7710243/">Video</a> by Rostislav Uzunov | No| Fixed | Fixed |
| Webpage | <img src="/resources/wallpaper_html.gif" width="256" height="144"/><br><a href="http://louie.co.nz/25th_hour/"> 25th Hour</a> by Loius Coyle  | Yes| Variable | Variable |
| Application/Games | <img src="/resources/wallpaper_emulator.gif" width="256" height="144"/><br>Run Unity or Godot games as wallpaper | Yes | Variable | Variable |
#### Screensavers
<img src="/resources/screen_saver.gif" width="600" height="338"/>

* Any wallpaper can be used as a screensaver, started by the idle timer inside Luma.
* Multiple monitors supported; each screen keeps its own layout.
* Lock the session when the screensaver ends, with a fade in option.
#### Automation
<img src="/resources/rotary_demo.gif" width="600" height="338"/>

* Luma Wallpaper can be controlled with command line arguments from terminal.
* Integrate with other languages like Python or scripting software AutoHotKey.
* [Learn more..](https://github.com/ninokiru/Luma-Wallpaper/blob/main/src/Lively/Lively.Common/CommandlineArgs.cs)
#### Lively API
<img src="/resources/music_api.gif" width="600" height="338"/>

* Powerful set of API for developers to create interactive wallpapers.
* Get hardware readings, audio graph, music information..
* The property contract every wallpaper can rely on is
  [`schemas/livelyPropertiesSchema.json`](https://github.com/ninokiru/Luma-Wallpaper/blob/main/schemas/livelyPropertiesSchema.json).

#### Machine Learning
<img src="/resources/wallpaper_depth.gif" width="600" height="338"/>

* Leverage Machine Learning inference to create dynamic wallpapers.
* The depth model is downloaded on first use from inside the app.
#### More Features
- One renderer for every format: video, gif, image, webpage and shadertoy all play through
  the same WebView2 player, so a wallpaper costs one process instead of three runtimes.
- Video decode runs on the GPU whenever the adapter supports it, including the integrated
  Intel UHD 620/710/730 class chips, with a per screen frame rate budget to cap the load.
- Overlay effects (blur, color grading, vignette, chromatic aberration, ripple) and pointer
  parallax can be applied to any wallpaper.
- Wallpaper playlist with a schedule, shuffle included.
- Easy to use; Just drag'n'drop media or webpages into Luma Wallpaper to set as wallpaper.
- Latest Windows 11 design using WinUI 3 + WindowsAppSDK framework, light theme by default.
- Efficient, Luma Wallpaper is native application designed for Windows 10 and 11.
- Fully opensource & free; no blackmagic, no features behind paywall.
- Interface in English and Vietnamese.
#### Performance
 * Wallpaper playback pauses when fullscreen application/games run on the machine (~0% cpu, gpu usage). 
 * Set wallpaper playback rules based on running foreground application.
 * Can be set to pause wallpaper when running on battery power (laptops.)
 * Wallpaper automatically pauses when running remote desktop session.

**_Luma Wallpaper is not officially affiliated with Unity technologies, godot, shadertoy;_**
## Download
Every build is published on [GitHub Releases](https://github.com/ninokiru/Luma-Wallpaper/releases)
and needs Windows 10 1903 or newer, x64 only.

- **Installer** (`luma_setup_x64_full_v*.exe`) — sets up the app, the start menu entry and the
  Visual C++ runtime if it is missing. The in-app update button runs this file for you.
- **Portable** (`luma-win-x64-portable.zip`) — unpack anywhere and start `Lively.exe`; nothing
  is written outside the user's data folder.

## Support
Are you a Luma Wallpaper fan and want to help out? here are some options..

#### Programmer
Code contributions are welcome, see [CONTRIBUTING.md](https://github.com/ninokiru/Luma-Wallpaper/blob/main/CONTRIBUTING.md).

#### Designer
Help improve UI/UX of Luma Wallpaper, open an issue with a screenshot of the screen you mean.

#### Localization
The interface ships in English and Vietnamese only, both maintained in this repository under
`src/Lively/Lively.UI.WinUI/Strings`.

#### Suggestions & Bug report
Suggest new features or file bug reports to improve Luma Wallpaper, [learn more..](https://github.com/ninokiru/Luma-Wallpaper/issues)

#### Spread the word
Star this repository or tell your friend about it.

## License
Luma Wallpaper is licensed under [GPL-v3.](https://github.com/ninokiru/Luma-Wallpaper/blob/main/LICENSE)
It is a fork of [Lively Wallpaper](https://github.com/rocksdanister/lively) by Dani John.
