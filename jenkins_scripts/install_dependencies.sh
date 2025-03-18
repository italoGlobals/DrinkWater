#!/bin/bash
set -e

# Constantes globais
readonly REQUIRED_PACKAGES="openjdk-17-jdk build-essential zip unzip curl git libssl-dev libreadline-dev zlib1g-dev libffi-dev libyaml-dev"
readonly CONFIG_DIR="$HOME/.config/dev-environment"

# Versões das ferramentas
readonly JAVA_VERSION="17.0.14-jbr"
readonly NODE_VERSION="22.0.0"
readonly RUBY_VERSION="3.3.1"

# Verificação de root apenas quando necessário
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Por favor, execute como root (sudo)"
        exit 1
    fi
}

# Logging
log_info() { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1" >&2; }

# Atualizar sistema
update_system() {
    check_root
    log_info "Atualizando sistema e instalando dependências..."
    apt-get update && apt-get upgrade -y
    apt-get install -y $REQUIRED_PACKAGES
}

# Configurar SDKMAN
setup_sdkman() {
    log_info "Configurando SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk selfupdate force
    sdk update
}

# Instalar Node.js com NVM
setup_node() {
    log_info "Configurando ambiente Node.js..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    nvm install $NODE_VERSION
    nvm use $NODE_VERSION
    npm install -g yarn

    log_info "Verificando instalação Node.js:"
    node --version
    npm --version
    yarn --version
}

# Instalar Ruby com rbenv
setup_ruby() {
    log_info "Configurando Ruby com rbenv..."
    
    if [ ! -d "$HOME/.rbenv" ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        mkdir -p ~/.rbenv/plugins
        git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    fi
    
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"

    if ! rbenv versions | grep -q "$RUBY_VERSION"; then
        rbenv install $RUBY_VERSION
        rbenv global $RUBY_VERSION
    fi

    log_info "Ruby instalado:"
    ruby --version
    gem --version
}

# Instalar Java com SDKMAN
install_sdk_versions() {
    log_info "Instalando Java..."
    sdk install java $JAVA_VERSION --default
}

# Configurar variáveis de ambiente
setup_environment() {
    log_info "Configurando variáveis de ambiente..."
    local env_file="$HOME/.bashrc"
    cat << EOF >> "$env_file"
export SDKMAN_DIR="\$HOME/.sdkman"
[[ -s "\$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "\$HOME/.sdkman/bin/sdkman-init.sh"
export JAVA_HOME="\$HOME/.sdkman/candidates/java/current"
export ANDROID_HOME="\$HOME/Android/Sdk"
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
EOF
    source "$HOME/.bashrc"
}

# Build Android
build_android() {
    if [ -z "$1" ]; then
        log_error "Especifique 'production' ou 'development' como argumento"
        exit 1
    fi

    if [ ! -f "package.json" ]; then
        log_error "Arquivo package.json não encontrado. Certifique-se de estar no diretório correto."
        exit 1
    fi

    log_info "Instalando dependências do projeto..."
    yarn install || { log_error "Falha ao instalar dependências"; exit 1; }

    log_info "Executando prebuild do Expo..."
    npx expo prebuild || { log_error "Falha no prebuild do Expo"; exit 1; }

    cd android || { log_error "Não foi possível acessar o diretório android"; exit 1; }

    log_info "Iniciando build para ambiente: $1"
    case "$1" in
        "production")
            if ! command -v fastlane &> /dev/null; then
                log_error "Fastlane não instalado. Execute 'gem install fastlane'"
                exit 1
            fi
            bundle exec fastlane build_aab --verbose
            ;;
        "development")
            if ! command -v fastlane &> /dev/null; then
                log_error "Fastlane não instalado. Execute 'gem install fastlane'"
                exit 1
            fi
            bundle exec fastlane build_apk --verbose
            ;;
        *)
            log_error "Ambiente inválido. Use 'production' ou 'development'"
            exit 1
            ;;
    esac

    log_info "🚀 Build finalizado com sucesso! 🚀"
}

# Função principal
main() {
    update_system
    setup_sdkman
    install_sdk_versions
    setup_ruby
    setup_node
    setup_environment
    log_info "Instalação concluída com sucesso!"
    build_android "production"
}

main
