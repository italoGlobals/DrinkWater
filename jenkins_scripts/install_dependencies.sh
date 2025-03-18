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

# Instala Java 17 e Ruby via SDKMAN
sdk install java 17.0.14-jbr
sdk install ruby

# Configura Bundler e instala dependências Ruby
gem install bundler
bundle install

# Instala Node.js usando NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 22
nvm use 22

# Instala Yarn
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Configura variáveis de ambiente e adiciona ao .bashrc para persistência
export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.14-jbr"
export ANDROID_HOME="/var/jenkins_home/Android/Sdk"

echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.14-jbr"' >> $HOME/.bashrc
echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> $HOME/.bashrc
echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> $HOME/.bashrc
echo 'export ANDROID_HOME="/var/jenkins_home/Android/Sdk"' >> $HOME/.bashrc

. $HOME/.bashrc 
source "$HOME/.bashrc"

# Instala dependências do projeto
yarn install
