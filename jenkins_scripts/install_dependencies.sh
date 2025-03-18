#!/bin/bash
# Install required packages without sudo (since it's not available in the container)
apt-get update && apt-get upgrade -y && apt-get install -y openjdk-17-jdk ruby-full build-essential zip unzip curl wget

# Create Android SDK directory
mkdir -p $HOME/Android/Sdk

export ANDROID_HOME="$HOME/Android/Sdk"
# Download and install Android Command Line Tools
cd $HOME/Android/Sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
rm -rf cmdline-tools/LICENSE cmdline-tools/NOTICE cmdline-tools/source.properties
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

alias avdmanager="$HOME/Android/Sdk/cmdline-tools/latest/bin/avdmanager"
alias sdkmanager="$HOME/Android/Sdk/cmdline-tools/latest/bin/sdkmanager"
alias adb="$HOME/Android/Sdk/platform-tools/adb"
alias fastboot="$HOME/Android/Sdk/platform-tools/fastboot"
# Accept licenses and install required Android SDK packages
yes | sdkmanager --licenses
sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.0" "ndk;26.1.10909125"

# Aceitar licenças novamente após a instalação do NDK (com mais yes)
for i in {1..10}; do yes | sdkmanager --licenses; done

# Verificar se o NDK foi instalado corretamente
if [ ! -d "$ANDROID_HOME/ndk/26.1.10909125" ]; then
    echo "Erro: NDK não foi instalado corretamente"
    exit 1
fi

# Install SDKMAN and source it properly
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install required SDKs
sdk install java 17.0.14-jbr
sdk install ruby

# Instalar o Bundler explicitamente
gem install bundler
gem install fastlane

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

# Create local.properties file for Android SDK location
echo "sdk.dir=$ANDROID_HOME" > android/local.properties

# Add environment variables to .bashrc
cat << EOF >> $HOME/.bashrc
export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.14-jbr"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:\$PATH"
EOF

source "$HOME/.bashrc"

# Install project dependencies
yarn install
yarn add expo-system-ui

# Install Expo CLI globally
yarn global add expo-cli
