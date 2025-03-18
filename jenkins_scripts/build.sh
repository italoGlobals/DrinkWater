#!/bin/bash
set -e  # Parar execução em caso de erro

# Verifica se o Expo está instalado
if ! command -v expo &> /dev/null; then
    echo "Erro: Expo CLI não está instalado"
    exit 1
fi

# Executa o prebuild do Expo
npx expo prebuild

# Navega para o diretório android
cd android || exit 1

if [ "$1" = "production" ]; then
    bundle exec fastlane build_aab
elif [ "$1" = "development" ]; then
    bundle exec fastlane build_apk
else
    echo "Erro: Especifique 'production' ou 'development' como argumento"
    exit 1
fi

echo "NÃO MANDEM CEBOLA PRA MINHA CASA, NÃO MANDEM CEBOLA, NÃO MANDEM CEBOLA PRA MINHA CASA, NÃO MANDEM CEBOLA"
