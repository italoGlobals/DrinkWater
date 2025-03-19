#!/bin/bash

# Build the Docker image
docker build -t drinkwater-android-builder .

# Run the container and copy the APK
docker run --rm -v $(pwd)/android/app/build/outputs/apk/release:/app/android/app/build/outputs/apk/release drinkwater-android-builder

echo "Build completed! APK should be available in android/app/build/outputs/apk/release/" 
