#!/bin/bash

yarn cache clean
yarn install

npx expo prebuild --platform android
node optimize-build.js

cd android/

./gradlew clean
./gradlew assembleRelease --stacktrace

if [ ! -f "./app/build/outputs/apk/release/app-release.apk" ]; then
    echo "Erro: APK não foi gerado em ./app/build/outputs/apk/release/app-release.apk"
    exit 1
fi

mkdir -p /app/output

cp ./app/build/outputs/apk/release/app-release.apk /app/output/app-release.apk
