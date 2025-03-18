#!/bin/bash
# Instalar Java, Ruby e Fastlane
apt-get update && apt-get upgrade -y && apt-get install -y openjdk-17-jdk ruby-full build-essential
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
source "$HOME/.bashrc"
sdk install java 17.0.14-jbr
sdk install ruby
sdk install fastlane

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
