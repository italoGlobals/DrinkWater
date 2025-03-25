#!/bin/bash

yarn cache clean
yarn install

npx expo prebuild --platform android
cd android/
export GRADLE_OPTS="-Xmx8192m -XX:MaxPermSize=4096m"
./gradlew clean assembleRelease --info --stacktrace

cp ./app/build/outputs/apk/release/app-release.apk /app/output/app-release.apk
