<div align="center">

# 🎵 MyPod — nivednb’s personal web edition

An installable, offline-friendly music player with a classic click-wheel look.
This edition was developed under the direction of [nivednb](https://github.com/nivednb),
building on [ClassiPod](https://github.com/adeeteya/Classipod) by
[Aditya R](https://github.com/adeeteya) and its contributors.

**[Open the web app](https://nivednb.github.io/Classipod/)** ·
[What's different](#whats-different-in-this-edition) ·
[Credits and license](#credits-and-license)

</div>

## What’s different in this edition

This fork adds and adapts features for a personal, installable web player:

- **Your own offline library:** import audio and M3U/M3U8 playlists from Files;
  cache the application shell and browse imported music on your device.
- **A more personal look:** first-generation-inspired screen and wheel options,
  adjustable wheel colors and labels, 3D appearance, and optional split screen.
- **More ways to browse:** artwork-oriented song views, folder browsing,
  playlist matching, and language-based grouping where the source is clear.
- **Games and controls:** Brick, Snake, 2048 and Solitaire; wheel sound options;
  and a configurable 30–240 second return to Now Playing during playback.
- **Faster repeat visits:** locally cached metadata and artwork help reduce
  repeated library processing.

This product includes software developed by Aditya R.

## Scan to open MyPod

<a href="https://nivednb.github.io/Classipod/"><img src="../screenshots/open-mypod-qr.png" width="180" alt="QR code to open MyPod"></a>

Scan with your phone’s camera or [open MyPod](https://nivednb.github.io/Classipod/).
The existing address and on-device library remain the same.

## Use the web app

**[Open MyPod](https://nivednb.github.io/Classipod/)** — this public link
opens an installable, standalone web app. Share the link; each person imports
their own audio and playlists on their own device. The link does not share your
library or automatically sync libraries between devices.

On iPhone, open the link in Safari, tap **Share → Add to Home Screen**, enable
**Open as Web App** if offered, then open the new icon. On Android, use Chrome's
**Install app** or **Add to Home screen** option. Open the installed app online
first, then choose **Music → Folders → Import songs from Files**. Once the app
shows **Offline app ready**, imported songs can play without a connection,
subject to browser storage and audio-format support. Import M3U/M3U8 playlists
from **Music → Folders → Import playlists** after importing their songs.

Your selected audio is copied to local browser storage, not uploaded to this
repository. Storage is per device/browser profile; Home Screen apps and Safari
tabs can use separate storage. Keep original files: clearing website data,
uninstalling an app, storage pressure, or browser policy can remove local data.
Demo and optional Subsonic server streams need a network connection. This player
does not download music or share other people's libraries.

See the [web app guide](personal-player.md) for setup, supported formats,
playlist matching, troubleshooting, appearance, and limitations.

The upstream project also supports native Android, iOS, macOS, Windows and
Linux builds. The native download links below refer to upstream releases and
may not include changes in this web fork.

Local files play offline. Server music requires your own compatible server,
an account on that server, and a network connection. MyPod does not include
a music subscription, offline server downloads, or server playlist syncing.

## ✨ Features

### 🗃️ Your library, local and streamed

- 🌐 Stream from Subsonic-compatible servers such as Navidrome through
  **Settings → Library Settings → Subsonic**.
- 🏠 Combine local and server tracks, or use **Hide Local Music** while streaming.
- 🧑‍🎤 Browse songs, artists, album artists, albums, and genres.
- 🔍 Search songs, artists, albums, and your MyPod playlists.
- 📂 Discover Android music through MediaStore. Select a parent music folder on
  iOS, macOS, Windows, or Linux and scan its subfolders automatically.
- ⚡ Cache metadata and artwork for faster startup, refresh the library,
  rebuild the index and exclude folders.
- 📋 Inspect unreadable files and retry guidance in **Missing Tracks**.
- 🧹 Optionally hide duplicate filenames without deleting music files.
- 📃 Create and save custom MyPod playlists.
- ⭐ Rate songs, with ratings and edits stored in MyPod.
- 📝 View embedded lyrics when available.
- 🎶 Play MP3, WAV, FLAC, M4A, MP4, Ogg, Opus, AAC, AIFF, APE, and MOV audio,
  subject to the platform's playback support.

### 🎧 Playback and controls

- 🎡 Navigate with the rotating click wheel or touchscreen.
- ⏮️ Skip tracks, seek forward or backward, and adjust volume in the app.
- 🔀 Shuffle songs or whole albums, keeping album tracks in disc/track order.
- ➰ Repeat one song or the current queue.
- 💾 Restore the previous queue and selected song after reopening, paused at
  the beginning of the song.
- 💤 Set a sleep timer for 15, 30, 45, or 60 minutes, or the end of the song.
- 📱 Enjoy background playback and mobile media controls, Windows system media
  controls, and Linux MPRIS controls where supported.
- 📡 Recover server playback after temporary connection failures, with buffering
  feedback and a Retry action when needed.
- ⏩ Scrub to a previewed position before committing the seek.
- 💿 See queue position and progress in Now Playing, with access to ratings,
  shuffle controls, and available lyrics.

### 📱 The iPod Classic-inspired interface

- 🎞️ Explore Cover Flow with **Original** and **Big** layouts, smooth wheel
  motion, and animated transitions.
- 🪞 Enjoy reflective album artwork.
- 🎨 Choose light, dark or pixel-style first-generation screen themes and
  device colors including Silver, Black and OLED Black.
- ⚙️ Adjust wheel style, color, labels, position, 3D appearance and split screen.
- 📺 Browse with split-screen previews and scrolling titles.
- 🔤 See a letter indicator while scrolling quickly through your collection.
- 📌 Return to remembered selections and scroll positions when navigating back.
- ⏱️ Automatically return to Now Playing after inactivity during playback;
  temporary Now Playing controls also return to the progress view.
- 🔉 Hear bundled iPod-inspired click wheel sounds.
- 📳 Enable vibration feedback on supported devices.
- 🖥️ Use responsive layouts and fullscreen Immersive Mode.
- 🔋 View battery level and charging status where supported.
- 🎮 Play offline Brick, Snake, 2048 and draw-one Solitaire from **Games**.
- 📖 Get started with the introductory tutorial.
- ℹ️ Find app information in the About screen.
- 🌍 Use MyPod in your language with a multilingual interface.

### 🎵 Supported audio formats

MyPod imports a format when its metadata can be read and at least one
configured playback backend can play it. Playback availability therefore varies
by platform:

| Format         | Extensions               | Expected playback                               |
|----------------|--------------------------|-------------------------------------------------|
| MP3            | `.mp3`                   | Android, iOS, Windows, Linux, web               |
| PCM WAV        | `.wav`                   | Android, iOS, Windows, Linux, web               |
| FLAC           | `.flac`                  | Android, iOS, Windows, Linux, major browsers    |
| AAC in MP4     | `.m4a`, `.mp4`           | Android, iOS, Windows, Linux, major browsers    |
| Ogg Vorbis     | `.ogg`                   | Android, Windows, Linux, supporting browsers    |
| Ogg Opus       | `.opus`                  | Android, Windows, Linux, supporting browsers    |
| Raw ADTS AAC   | `.aac`                   | Android, iOS, Windows, Linux; browser-dependent |
| AIFF / AIFF-C  | `.aif`, `.aiff`, `.aifc` | iOS, Windows, Linux                             |
| Monkey's Audio | `.ape`                   | Windows, Linux                                  |
| QuickTime      | `.mov`                   | iOS, Windows, Linux; browser-dependent          |

## Connect to Subsonic or Navidrome

Open **Settings → Library Settings → Subsonic** and enter the server's base
URL (including any reverse-proxy path), username and password. ClassiPod
supports token-authenticated Subsonic API 1.13+ servers, including Navidrome.
The connection is checked before saving. Native apps combine server and local
music; the web can combine server tracks with imported browser music. Demo songs
are hidden while the server is enabled.

**Configure Subsonic** edits the connection or removes it. Turning Subsonic off
keeps its configuration and cache, hides its tracks, and stops server playback.
**Hide Local Music** shows only server music while Subsonic is enabled.
**Prevent Duplicate Tracks** hides matching filenames without deleting files.
Saved playlist entries remain available when the same server is reconnected.
**Refresh Library** fetches a new catalog; **Re-index** also clears cached
server artwork. Failed scans retain the previous catalog. Ratings and edits
stay in MyPod and are not written back to the server.

Native passwords use OS secure storage. Web passwords last only until reload;
re-enter the password through Configure Subsonic or when starting playback.
Metadata and artwork are cached, but audio is streamed and requires a connection.
Server playlist synchronization and offline audio downloads are not included.

Web servers must allow CORS from the MyPod origin. Browsers block HTTP
servers from an HTTPS app. Native apps allow HTTP for user-configured servers,
including LAN IP addresses, using app-wide Android and Apple transport
exceptions because server hosts are not known at build time. HTTPS certificates
are still validated. HTTP traffic is unencrypted; prefer HTTPS when available.
Transport configuration changes require rebuilding and reinstalling the app;
hot reload does not apply them.
Linux secure storage requires the system Secret Service/libsecret; Windows
builds require the Visual Studio ATL component used by flutter_secure_storage.

## Native apps and original project

The link above is **this fork’s web app**. The original developer's native
Android, iOS, macOS, Windows and Linux downloads are available from the
[upstream project](https://github.com/adeeteya/Classipod). Those downloads are
upstream builds and do not necessarily include this fork's web changes or games.
This fork does not currently offer an App Store release of its own.

## 🔌 Plugins

| Name                                                                                          | Usage                                                                               |
|-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| [**audio_service**](https://pub.dev/packages/audio_service)                                   | To support background audio playback                                                |
| [**audio_service_mpris**](https://pub.dev/packages/audio_service_mpris) | Linux system media controls |
| [**audio_service_win**](https://pub.dev/packages/audio_service_win) | Windows system media controls |
| [**flutter_secure_storage**](https://pub.dev/packages/flutter_secure_storage) | Store native server credentials securely |
| [**http**](https://pub.dev/packages/http) | Connect to Subsonic-compatible servers |
| [**battery_plus**](https://pub.dev/packages/battery_plus)                                     | Shows phone battery level and status                                                |
| [**cupertino_icons**](https://pub.dev/packages/cupertino_icons)                               | For ios style icons                                                                 |
| [**device_preview_plus**](https://pub.dev/packages/device_preview_plus)                       | For visualizing how the app looks on different devices and screens                  |
| [**disable_battery_optimization**](https://github.com/adeeteya/Disable-Battery-Optimizations) | To Disable vendor or android specific battery optimizations for background playback |
| [**file_picker**](https://pub.dev/packages/file_picker)                                       | To select the directory from which the music files are scanned                      |
| [**flutter_localizations**](https://pub.dev/packages/flutter_localizations)                   | For in-app localization map data                                                    |
| [**flutter_riverpod**](https://pub.dev/packages/flutter_riverpod)                             | For State Management                                                                |
| [**flutter_taglib**](https://github.com/adeeteya/flutter_taglib)                               | To read local audio metadata and embedded artwork                                   |
| [**go_router**](https://pub.dev/packages/go_router)                                           | To handle routing within the app                                                    |
| [**hive_ce**](https://pub.dev/packages/hive_ce)                                               | To Cache Auio Metadata and store playlists                                          |
| [**hive_ce_flutter**](https://pub.dev/packages/hive_ce_flutter)                               | For flutter specific libs of hive                                                   |
| [**intl**](https://pub.dev/packages/intl)                                                     | For internalization and localization of the app                                     |
| [**just_audio**](https://pub.dev/packages/just_audio)                                         | To play audio files                                                                 |
| [**just_audio_media_kit**](https://pub.dev/packages/just_audio_media_kit)                     | To play audio files on Windows and Linux                                            |
| [**media_kit_libs_linux**](https://pub.dev/packages/media_kit_libs_linux)                     | Media kit Libraries for Linux                                                       |
| [**media_kit_libs_windows_audio**](https://pub.dev/packages/media_kit_libs_windows_audio)     | Media kit Libraries for Windows                                                     |
| [**on_audio_query**](https://github.com/adeeteya/on_audio_query)                              | To discover music through Android MediaStore                                   |
| [**path_provider**](https://pub.dev/packages/path_provider)                                   | To fetch app data directories                                                       |
| [**permission_handler**](https://pub.dev/packages/permission_handler)                         | To check and request for file and audio access permissions                          |
| [**shared_preferences**](https://pub.dev/packages/shared_preferences)                         | To store system settings                                                            |
| [**tutorial_coach_mark**](https://pub.dev/packages/tutorial_coach_mark)                       | To provide app tutorial to the users                                                |
| [**universal_html**](https://pub.dev/packages/universal_html)                                 | For Launching the app in full-screen mode on web versions                           |
| [**url_launcher**](https://pub.dev/packages/url_launcher)                                     | For Launching the Donation Page Link                                                |
| [**vibration**](https://pub.dev/packages/vibration)                                           | Used for vibration while using device controls                                      |
| [**vibration_web**](https://pub.dev/packages/vibration_web)                                   | Used for vibration on the webapp version                                            |
| [**build_runner**](https://pub.dev/packages/build_runner)                                     | For code generation                                                                 |
| [**flutter_lints**](https://pub.dev/packages/flutter_lints)                                   | For using recommended flutter lints                                                 |
| [**flutter_test**](https://pub.dev/packages/flutter_test)                                     | For unit and widget testing the app                                                 |
| [**hive_ce_generator**](https://pub.dev/packages/hive_ce_generator)                           | For automatically generating Hive TypeAdapters                                      |
| [**riverpod_lint**](https://pub.dev/packages/riverpod_lint)                                   | For using riverpod specific linting rules                                           |

## Credits and license

- **Original ClassiPod:** [Aditya R](https://github.com/adeeteya) and the
  [upstream contributors](https://github.com/adeeteya/Classipod/graphs/contributors).
- **This edition:** developed under the direction of
  [nivednb](https://github.com/nivednb), with AI-assisted implementation and
  iterative testing and feedback. See [the changelog](../CHANGELOG.md) for changes.
- **License:** the original [BSD-4-Clause license](../LICENSE), copyright
  © 2025 Aditya R, remains intact. This product includes software developed by
  Aditya R. Third-party assets and dependencies may have their own terms.
- **Icon attribution:** <a href="https://www.flaticon.com/free-icons/ipod">iPod icons created by Freepik - Flaticon</a>.

This is an independent fork and is not an official release endorsed by the
original project or Apple. Credit for this fork is a project acknowledgment;
it does not alter the license or create a new mandatory attribution condition.
See [credits and rights notes](credits-and-rights.md) for the project
history and open questions.
