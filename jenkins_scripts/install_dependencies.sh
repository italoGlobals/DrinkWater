#!/bin/bash
# Instalar Ruby e Fastlane
apt-get update && apt-get upgrade -y && apt-get install -y ruby-full build-essential
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
gem install fastlane -N

# Instalar Java e configurar JAVA_HOME
apt-get install -y openjdk-17-jdk
# Encontrar o diretório real do Java
JAVA_PATH=$(update-alternatives --list java | grep -o '^.*java-17.*/' | head -n 1)
export JAVA_HOME="${JAVA_PATH%/bin/}"
echo "export JAVA_HOME=${JAVA_HOME}" >> $HOME/.bashrc
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> $HOME/.bashrc

# Verificar instalação do Java
echo "Java instalado em: $JAVA_HOME"
java -version

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 22
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> $HOME/.bashrc
. $HOME/.bashrc 

yarn install
npx expo prebuild
