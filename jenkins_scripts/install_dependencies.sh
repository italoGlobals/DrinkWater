#!/bin/bash

# Funções de utilidade
check_installation() {
    if [ ! -d "$1" ]; then
        echo "Erro: $2 não foi instalado corretamente"
        exit 1
    fi
}

# Configuração inicial
setup_initial_packages() {
    # Instalação de pacotes básicos com sudo
    DEBIAN_FRONTEND=noninteractive apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y ruby-full zip unzip curl wget openjdk-17-jdk
}

# Configuração do Android SDK
setup_android_sdk() {
    # Criar diretório do Android SDK com permissões corretas
    mkdir -p $HOME/Android/Sdk
    chown -R jenkins:jenkins $HOME/Android/Sdk
    export ANDROID_HOME="$HOME/Android/Sdk"

    # Download e instalação do Android Command Line Tools
    cd $HOME/Android/Sdk
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip -o commandlinetools-linux-9477386_latest.zip
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    rm -rf cmdline-tools/LICENSE cmdline-tools/NOTICE cmdline-tools/source.properties
    
    # Configurar PATH do Android SDK
    export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

    # Instalar componentes do Android SDK
    yes | sdkmanager --sdk_root=$ANDROID_HOME --licenses
    sdkmanager --sdk_root=$ANDROID_HOME --install "platform-tools" "platforms;android-33" "build-tools;33.0.0" "ndk;26.1.10909125"

    # Verificar instalação do NDK
    check_installation "$ANDROID_HOME/ndk/26.1.10909125" "NDK"
}

# Configuração do ambiente de desenvolvimento
setup_development_environment() {
    # Instalar SDKMAN com permissões corretas
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    chown -R jenkins:jenkins $HOME/.sdkman

    # Instalar Java via SDKMAN
    sdk install java 17.0.14-jbr

    # Instalar ferramentas Ruby
    gem install bundler fastlane

    # Instalar Node.js via NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install 22

    # Instalar Yarn
    curl -o- -L https://yarnpkg.com/install.sh | bash
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
}

# Configuração do ambiente
setup_environment_variables() {
    # Definir variáveis de ambiente
    export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.14-jbr"
    
    # Criar arquivo local.properties
    echo "sdk.dir=$ANDROID_HOME" > android/local.properties

    # Adicionar variáveis e aliases ao .bashrc
    cat << EOF >> $HOME/.bashrc
# Variáveis de ambiente
export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.14-jbr"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:\$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:\$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"

# Aliases Android SDK
alias avdmanager="\$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager"
alias sdkmanager="\$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
alias adb="\$ANDROID_HOME/platform-tools/adb"
alias fastboot="\$ANDROID_HOME/platform-tools/fastboot"

# Aliases úteis para desenvolvimento
alias android-tools="echo 'Comandos disponíveis: avdmanager, sdkmanager, adb, fastboot'"
EOF

    source "$HOME/.bashrc"
}

# Instalação das dependências do projeto
setup_project_dependencies() {
    yarn install
    yarn add expo-system-ui
    yarn global add expo-cli
}

# Execução principal
main() {
    setup_initial_packages
    setup_android_sdk
    setup_development_environment
    setup_environment_variables
    setup_project_dependencies
}

# Iniciar execução
main
