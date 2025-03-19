#!/bin/bash

docker build -t drinkwater-android-builder .

docker run --rm \
  -v $(pwd):/app \
  -v node_modules:/app/node_modules \
  -v expo-cache:/app/.expo \
  -v gradle-cache:/root/.gradle \
  drinkwater-android-builder \
  -c "cd /app && yes | npx expo prebuild --platform android && cd android && chmod +x gradlew && ./gradlew assembleRelease"
