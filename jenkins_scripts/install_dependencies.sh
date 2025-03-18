#!/bin/bash
set -e  # Para interromper o script se algum comando falhar

# Atualiza pacotes e instala dependências do sistema
apt-get update && apt-get upgrade -y
apt-get install -y openjdk-17-jdk ruby-full build-essential zip unzip curl

# Instala Ruby e Fastlane
apt install -y ruby ruby-dev
gem install fastlane -NV

# Instala SDKMAN e carrega corretamente no ambiente Jenkins
curl -s "https://get.sdkman.io" | bash
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Instala as ferramentas via SDKMAN
sdk install java 17.0.14-jbr
sdk install maven latest
sdk install gradle latest
sdk install nodejs 22.0.0
sdk install ruby latest

# Configura o ambiente para usar as versões instaladas
sdk use java 17.0.14-jbr
sdk use nodejs 22.0.0
sdk use ruby latest

# Configura variáveis de ambiente
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export ANDROID_HOME="/var/jenkins_home/Android/Sdk"

# Adiciona as configurações ao .bashrc
echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> $HOME/.bashrc
echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> $HOME/.bashrc
echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/current"' >> $HOME/.bashrc
echo 'export ANDROID_HOME="/var/jenkins_home/Android/Sdk"' >> $HOME/.bashrc

. $HOME/.bashrc 
source "$HOME/.bashrc"

# Instala dependências do projeto
yarn install
