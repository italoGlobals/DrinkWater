#!/bin/bash

yarn cache clean
yarn install

npx expo prebuild --platform android
cd android/
./gradlew clean assembleRelease

cp ./app/build/outputs/apk/release/app-release.apk /app/output/app-release.apk
