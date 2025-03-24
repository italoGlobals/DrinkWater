#!/bin/bash
echo "Cleaning yarn cache"  
yarn cache clean
echo "Installing dependencies"
yarn install

echo "Prebuilding expo"
npx expo prebuild --platform android

echo "Starting to create release"
cd android/
./gradlew clean assembleRelease

RELEASE_VERSION=$(date -Iminutes)
echo "Release version is $RELEASE_VERSION"

echo "Renaming release directory to release version"
mv ./app/build/outputs/apk/release ./app/build/outputs/apk/$RELEASE_VERSION

echo "Creating release_outputs directory"
mkdir -p /app/release_outputs

echo "Copying release output to release_outputs"
cp -r ./app/build/outputs/apk release_outputs

# Copiar para o diretório raiz do projeto (assumindo que /app/output está mapeado como volume)
echo "Copying release files to project root"
mkdir -p /app/output
cp -r ./app/build/outputs/apk/* /app/output/

echo "Build successful"
