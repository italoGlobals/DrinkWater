#!/bin/bash
set -e

update_system() {
  apt-get update && apt-get upgrade -y
  apt-get install -y openjdk-17-jdk ruby-full build-essential zip unzip curl
}

init_sdkman() {
  curl -s "https://get.sdkman.io" | bash
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}

list_and_get_sdk_versions() {
  local JAVA_VERSION="17.0.14-jbr"
  local MAVEN_VERSION=$(sdk list maven | grep "\*" | awk '{print $6}')
  local GRADLE_VERSION=$(sdk list gradle | grep "\*" | awk '{print $6}')
  local NODEJS_VERSION="22.0.0"
  local RUBY_VERSION=$(sdk list ruby | grep "\*" | awk '{print $6}')

  echo "Versões selecionadas:"
  echo "Java: $JAVA_VERSION"
  echo "Maven: $MAVEN_VERSION"
  echo "Gradle: $GRADLE_VERSION"
  echo "NodeJS: $NODEJS_VERSION"
  echo "Ruby: $RUBY_VERSION"

  export SDK_JAVA_VERSION="$JAVA_VERSION"
  export SDK_MAVEN_VERSION="$MAVEN_VERSION"
  export SDK_GRADLE_VERSION="$GRADLE_VERSION"
  export SDK_NODEJS_VERSION="$NODEJS_VERSION"
  export SDK_RUBY_VERSION="$RUBY_VERSION"
}

set_sdk_versions() {
  sdk install java $SDK_JAVA_VERSION
  sdk install maven $SDK_MAVEN_VERSION
  sdk install gradle $SDK_GRADLE_VERSION
  sdk install nodejs $SDK_NODEJS_VERSION
  sdk install ruby $SDK_RUBY_VERSION
}

use_sdk_versions() {
  sdk use java 17.0.14-jbr
  sdk use nodejs 22.0.0
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

. $HOME/.bashrc 
source "$HOME/.bashrc"

update_system
init_sdkman
list_and_get_sdk_versions
set_sdk_versions
use_sdk_versions
configure_environment

yarn install
