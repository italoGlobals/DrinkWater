#!/bin/bash
docker build -t drinkwater-android-builder .

docker run --rm -v $(pwd)/android/app/build/outputs/apk/release:/app/android/app/build/outputs/apk/release drinkwater-android-builder
