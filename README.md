<div align="center">

<a href="https://mihon.app">
    <img src="./.github/assets/logo.png" alt="Mihon logo" title="Mihon logo" width="80"/>
</a>

# Mihon Personal

A personal fork of [Mihon](https://github.com/mihonapp/mihon) carrying a couple of
unmerged patches, built with its own identity and release channel.

**Not an official Mihon build.** It installs *alongside* the official app as
`app.mihon.personal`, is signed with a private key, and updates from this fork's
releases.

</div>

## What's different from upstream

**Installs alongside official Mihon.** Its own package (`app.mihon.personal`),
label (*Mihon Personal*), icon (purple) and app data. Library, history, settings
and tracker logins are fully independent from the official app. Debug builds use
`app.mihon.dev`.

**Carried patches.** Open upstream pull requests that are not merged yet:

| PR | Change |
| --- | --- |
| [#3974](https://github.com/mihonapp/mihon/pull/3974) | Fetch chapters when batch downloading unfetched library manga |
| [#3975](https://github.com/mihonapp/mihon/pull/3975) | Add a "Delete temporary files" action to the download queue |

**Self-updating.** The built-in updater is re-pointed at this fork, so new
releases appear in-app under *About → Check for updates*.

**Shared downloads (optional).** Pointing this build and official Mihon at the
same storage folder lets them share downloaded chapters: paths are derived from
the source, manga title and a hash of the chapter URL, so both compute identical
filenames. Each app has a *Reindex downloads* action if it doesn't pick them up.
Library data is still private to each app.

## Install

Requires Android 8.0 or higher.

```bash
adb install -r mihon-arm64-v8a-<version>.apk
```

Grab the asset matching your device ABI from
[the latest release](../../releases/latest) — `arm64-v8a` for most phones, or the
universal APK if unsure.

Because it is signed with a different key than official Mihon, it can never
update *over* it. The two coexist as separate apps, so installing this does not
affect an existing Mihon install or its data.

## Building

```bash
./gradlew :app:assembleRelease   # minified release, package app.mihon.personal
./gradlew :app:assembleDebug     # debug, package app.mihon.dev
```

Release builds are signed using `keystore.properties` at the repo root, which is
git-ignored.

## Releases

Releases are produced by the **Personal Upstream Sync** workflow, run by hand
from the Actions tab (it is not on a schedule):

```bash
gh workflow run "Personal Upstream Sync" --repo arashari/mihon --ref personal
```

It merges `mihonapp/mihon` `main` into `personal` — keeping this repo's own
`.github/workflows` and `README.md` — builds, signs, and publishes the result as
`personal-<version>`.

The version is upstream's `versionName` with the branch commit count appended as
a fourth component, e.g. `0.20.4.8021`. The updater only compares as many
components as the installed version has, so **the fourth component must stay** —
publishing a three-component tag would mean the update is silently never offered.

## Upstream

Everything below is inherited from the upstream project.

### Features

* Local reading of content.
* A configurable reader with multiple viewers, reading directions and other settings.
* Tracker support: [MangaBaka](https://mangabaka.org), [MyAnimeList](https://myanimelist.net/), [AniList](https://anilist.co/), [Kitsu](https://kitsu.app/), [MangaUpdates](https://mangaupdates.com), [Shikimori](https://shikimori.one), [Bangumi](https://bgm.tv/), and [Hikka](https://hikka.io/).
* Categories to organize your library.
* Light and dark themes.
* Schedule updating your library for new chapters.
* Create backups locally to read offline or to your desired cloud service.
* Plus much more...

[Code of conduct](./CODE_OF_CONDUCT.md) · [Contributing guide](./CONTRIBUTING.md)

### Credits

Thank you to all the people who have contributed!

<a href="https://github.com/mihonapp/mihon/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=mihonapp/mihon" alt="Mihon app contributors" title="Mihon app contributors" width="800"/>
</a>

### Disclaimer

The developer(s) of this application does not have any affiliation with the content providers available, and this application hosts zero content.

### License

<pre>
Copyright © 2015 Javier Tomás
Copyright © 2024 Mihon Open Source Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>
