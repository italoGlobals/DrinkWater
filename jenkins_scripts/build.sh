#!/bin/bash

npx expo prebuild

if [ "$1" = "production" ]; then
    ls .
    # fastlane android build_aab
fi

if [ "$1" = "development" ]; then
    cd android/
    ./gradlew clean
    ./gradlew assembleRelease
    ls /app/build/outputs/apk/release/
fi

echo "NÃO MANDEM CEBOLA PRA MINHA CASA, NÃO MANDEM CEBOLA, NÃO MANDEM CEBOLA PRA MINHA CASA, NÃO MANDEM CEBOLA"
