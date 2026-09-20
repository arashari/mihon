#!/usr/bin/env bash
#
# Build Mihon Personal and publish it as a GitHub release on the fork,
# so the app's built-in updater can find it.
#
# Usage:
#   1. bump `versionName` in app/build.gradle.kts (keep 4 components, e.g. 0.20.4.2)
#   2. ./publish.sh
#
set -euo pipefail

cd "$(dirname "$0")"

REPO="arashari/mihon"
export JAVA_HOME="${JAVA_HOME:-/home/ashari/jdk/jdk-21.0.12.1+1}"
export ANDROID_HOME="${ANDROID_HOME:-/home/ashari/Android/Sdk}"

VERSION="$(grep -oP 'versionName = "\K[^"]+' app/build.gradle.kts)"
TAG="v$VERSION"

if [[ ! -f keystore.properties ]]; then
    echo "error: keystore.properties missing (needed to sign the release)" >&2
    exit 1
fi

if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
    echo "error: release $TAG already exists on $REPO" >&2
    echo "bump versionName in app/build.gradle.kts first" >&2
    exit 1
fi

echo "==> building $VERSION"
./gradlew :app:assembleRelease

OUT="app/build/outputs/apk/release"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# Asset names must keep the ABI token: the updater matches on "-arm64-v8a" etc.
cp "$OUT/app-universal-release.apk" "$STAGE/mihon-$VERSION.apk"
for abi in arm64-v8a armeabi-v7a x86 x86_64; do
    cp "$OUT/app-$abi-release.apk" "$STAGE/mihon-$abi-$VERSION.apk"
done

echo "==> publishing $TAG to $REPO"
gh release create "$TAG" \
    --repo "$REPO" \
    --title "Mihon Personal $VERSION" \
    --notes "Personal build. Installs alongside official Mihon as \`app.mihon.personal\`." \
    "$STAGE"/*.apk

echo "==> done: https://github.com/$REPO/releases/tag/$TAG"
