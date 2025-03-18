#!/bin/bash
# Install required packages with sudo
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y openjdk-17-jdk ruby-full build-essential zip unzip curl

# Install SDKMAN and source it properly
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install required SDKs
sdk install java 17.0.14-jbr
sdk install ruby
sdk install fastlane

# Install Node.js and make sure it's available
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 22

# Install Yarn
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Set environment variables
export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.14-jbr"
export ANDROID_HOME="$HOME/Android/Sdk"
# Add environment variables to .bashrc
echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.14-jbr"' >> $HOME/.bashrc
echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> $HOME/.bashrc
echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> $HOME/.bashrc
echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> $HOME/.bashrc

. $HOME/.bashrc 

# Install project dependencies
yarn install
npx expo prebuild
