#!/bin/bash

yarn cache clean
yarn install

npx expo prebuild --platform android
cd android/
./gradlew clean assembleRelease

RELEASE_VERSION=$(date -Iminutes)

mkdir -p /app/output/$RELEASE_VERSION

cp ./app/build/outputs/apk/release/app-release.apk /app/output/$RELEASE_VERSION/app-release.apk
