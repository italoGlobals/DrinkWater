#!/bin/bash
set -e

# Constantes globais
readonly REQUIRED_PACKAGES="openjdk-17-jdk ruby-full build-essential zip unzip curl"
readonly CONFIG_DIR="$HOME/.config/dev-environment"

# Versões das ferramentas
readonly JAVA_VERSION="17.0.14-jbr"
readonly NODE_VERSION="22.0.0"
readonly MAVEN_VERSION="3.9.6"
readonly RUBY_VERSION="3.3.1"

# Verificação de root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Por favor, execute como root (sudo)"
        exit 1
    fi
}

# Função para logging
log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

# Sistema
update_system() {
    log_info "Atualizando sistema e instalando dependências básicas..."
    apt-get update && apt-get upgrade -y
    apt-get install -y $REQUIRED_PACKAGES
}

# SDKMAN
setup_sdkman() {
    log_info "Configurando SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    
    sdk selfupdate force
    sdk update
}

# Node.js
setup_node() {
    log_info "Configurando ambiente Node.js..."
    
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    nvm install $NODE_VERSION
    nvm use $NODE_VERSION
    npm install -g yarn
    
    verify_node_installation
}

verify_node_installation() {
    log_info "Verificando instalação Node.js:"
    echo "Node.js: $(node --version)"
    echo "NPM: $(npm --version)"
    echo "Yarn: $(yarn --version)"
}

# Instalação SDK
install_sdk_versions() {
    log_info "Instalando versões das ferramentas..."
    
    # Install Java
    sdk install java $JAVA_VERSION --default
    sdk use java $JAVA_VERSION
    
    # Install Maven
    sdk install maven $MAVEN_VERSION
    sdk use maven $MAVEN_VERSION
    
    # Install Ruby
    sdk install ruby $RUBY_VERSION
    sdk use ruby $RUBY_VERSION
}

# Configuração do ambiente
setup_environment() {
    log_info "Configurando variáveis de ambiente..."
    
    local env_file="$HOME/.bashrc"
    cat << EOF >> "$env_file"
export SDKMAN_DIR="\$HOME/.sdkman"
[[ -s "\$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "\$HOME/.sdkman/bin/sdkman-init.sh"
export JAVA_HOME="\$HOME/.sdkman/candidates/java/current"
export ANDROID_HOME="/var/jenkins_home/Android/Sdk"
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
EOF
}

# Função principal
main() {
    check_root
    update_system
    setup_sdkman
    install_sdk_versions
    setup_node
    setup_environment
    
    log_info "Instalação concluída com sucesso!"
    source "$HOME/.bashrc"
}

# Execução do script
main
