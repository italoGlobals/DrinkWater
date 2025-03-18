#!/bin/bash
# Instalar Ruby e Fastlane
apt-get update && apt-get upgrade -y && apt-get install -y ruby-full build-essential
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
gem install fastlane -N

# Instalar Java, Node e Yarn
apt-get install -y openjdk-17-jdk
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
