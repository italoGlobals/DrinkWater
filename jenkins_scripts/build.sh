#!/bin/bash
set -e  # Para interromper o script se algum comando falhar

yarn install

# Executa o prebuild do Expo
npx expo prebuild

# Navega para o diretório android
cd android

# Executa Fastlane corretamente
if [ "$1" = "production" ]; then
    bundle exec fastlane build_aab --verbose
elif [ "$1" = "development" ]; then
    bundle exec fastlane build_apk --verbose
else
    echo "Especifique 'production' ou 'development' como argumento"
    exit 1
fi

echo "🚀 Build finalizado com sucesso! 🚀"
