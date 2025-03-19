#!/bin/bash

readonly go_to_app="cd /app"
readonly prebuild="yes | npx expo prebuild --platform android"
readonly go_to_android="cd android"
readonly make_gradlew_executable="chmod +x gradlew"
readonly build_release="./gradlew assembleRelease"

docker build -t drinkwater-android-builder .

docker run --rm \
  -v $(pwd):/app \
  -v node_modules:/app/node_modules \
  -v expo-cache:/app/.expo \
  -v gradle-cache:/root/.gradle \
  drinkwater-android-builder \
  -c "$go_to_app && $prebuild && $go_to_android && $make_gradlew_executable && $build_release"
