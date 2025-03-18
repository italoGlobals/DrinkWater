#!/bin/bash

# Executa o prebuild do Expo
npx expo prebuild

# Navega para o diretório android
cd android

if [ "$1" = "production" ]; then
    bundle exec fastlane build_aab
elif [ "$1" = "development" ]; then
    fastlane android build_apk
else
    echo "Especifique 'production' ou 'development' como argumento"
    exit 1
fi

echo "NÃO MANDEM CEBOLA PRA MINHA CASA, NÃO MANDEM CEBOLA, NÃO MANDEM CEBOLA PRA MINHA CASA, NÃO MANDEM CEBOLA"
