#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then 
    echo "Por favor, execute como root (sudo)"
    exit 1
fi

update_system() {
  apt-get update && apt-get upgrade -y
  apt-get install -y openjdk-17-jdk ruby-full build-essential zip unzip curl
}

run_fetch() {
  apt-get install -y screenfetch
  screenfetch
}

init_sdkman() {
  curl -s "https://get.sdkman.io" | bash
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}

list_and_get_sdk_versions() {
  readonly TARGET_JAVA_VERSION="17.0.14-jbr"
  readonly TARGET_NODEJS_VERSION="22.0.0"
  readonly TARGET_MAVEN_VERSION="3.9.6"
  readonly TARGET_GRADLE_VERSION="9.6.1"
  readonly TARGET_RUBY_VERSION="3.3.1"

  local JAVA_VERSION=$(sdk list java | grep $TARGET_JAVA_VERSION | awk '{print $6}')
  local NODEJS_VERSION=$(nvm ls-remote | grep $TARGET_NODEJS_VERSION | awk '{print $2}')
  local MAVEN_VERSION=$(sdk list maven | grep $TARGET_MAVEN_VERSION | awk '{print $6}')
  local GRADLE_VERSION=$(sdk list gradle | grep $TARGET_GRADLE_VERSION | awk '{print $6}')
  local RUBY_VERSION=$(sdk list ruby | grep $TARGET_RUBY_VERSION | awk '{print $6}')

  echo "Versões selecionadas:"
  echo "Java: $JAVA_VERSION"
  echo "NodeJS: $NODEJS_VERSION"
  echo "Maven: $MAVEN_VERSION"
  echo "Gradle: $GRADLE_VERSION"
  echo "Ruby: $RUBY_VERSION"

  export SDK_JAVA_VERSION="$JAVA_VERSION"
  export SDK_NODEJS_VERSION="$NODEJS_VERSION"
  export SDK_MAVEN_VERSION="$MAVEN_VERSION"
  export SDK_GRADLE_VERSION="$GRADLE_VERSION"
  export SDK_RUBY_VERSION="$RUBY_VERSION"
}

set_sdk_versions() {
  sdk install java $SDK_JAVA_VERSION
  sdk install maven $SDK_MAVEN_VERSION
  sdk install gradle $SDK_GRADLE_VERSION
  sdk install ruby $SDK_RUBY_VERSION
}

use_sdk_versions() {
  sdk use java 17.0.14-jbr
  sdk use nodejs $NODEJS_VERSION
  sdk use ruby latest
}

configure_environment() {
  export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
  export ANDROID_HOME="/var/jenkins_home/Android/Sdk"

  echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> $HOME/.bashrc
  echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> $HOME/.bashrc
  echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/current"' >> $HOME/.bashrc
  echo 'export ANDROID_HOME="/var/jenkins_home/Android/Sdk"' >> $HOME/.bashrc
}

init_node_environment() {
  echo "Configurando ambiente Node.js e JavaScript..."
  
  # Instala NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  # Configura Node.js
  nvm install $TARGET_NODEJS_VERSION
  nvm use $TARGET_NODEJS_VERSION
  
  # Instala Yarn globalmente
  npm install -g yarn
  
  # Configura variáveis de ambiente para Node.js
  echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> $HOME/.bashrc
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> $HOME/.bashrc
  
  # Verifica as instalações
  echo "Versões instaladas:"
  echo "Node.js: $(node --version)"
  echo "NPM: $(npm --version)"
  echo "Yarn: $(yarn --version)"
}

source "$HOME/.bashrc"

update_system
run_fetch
init_sdkman
list_and_get_sdk_versions
set_sdk_versions
use_sdk_versions
configure_environment
init_node_environment
