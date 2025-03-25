#!/bin/bash

yarn cache clean
yarn install

npx expo prebuild --platform android
cd android/
./gradlew clean assembleRelease

RELEASE_VERSION=$(date -Iminutes)

mv ./app/build/outputs/apk/release ./app/build/outputs/apk/$RELEASE_VERSION
mkdir -p /app/release_outputs
cp -r ./app/build/outputs/apk release_outputs
mkdir -p /app/output
cp -r ./app/build/outputs/apk/* /app/output/
