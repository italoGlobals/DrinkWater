#!/bin/bash
set -e

readonly REQUIRED_PACKAGES="openjdk-17-jdk build-essential zip unzip curl git libssl-dev libreadline-dev zlib1g-dev libffi-dev libyaml-dev"
readonly CONFIG_DIR="$HOME/.config/dev-environment"

readonly JAVA_VERSION="17.0.14-jbr"
readonly NODE_VERSION="22.0.0"
readonly RUBY_VERSION="3.3.1"

readonly BUILD_TYPES=("production" "development")

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Por favor, execute como root (sudo)"
        exit 1
    fi
}

log_info() { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1" >&2; }

update_system() {
    check_root
    log_info "Atualizando sistema e instalando dependências..."
    apt-get update && apt-get upgrade -y
    apt-get install -y $REQUIRED_PACKAGES
}

setup_sdkman() {
    log_info "Configurando SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk selfupdate force
    sdk update
}

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

    gem install bundler -v 2.5.9

    if [ -f "Gemfile" ]; then
        bundle install
    else
        gem install fastlane
    fi

    log_info "Ruby instalado:"
    ruby --version
    gem --version
}

install_sdk_versions() {
    log_info "Instalando Java..."
    sdk install java $JAVA_VERSION --default
}

setup_environment() {
    log_info "Configurando variáveis de ambiente..."
    local env_file="$HOME/.bashrc"
    
    mkdir -p "$HOME/Android/Sdk"
    
    cat << EOF >> "$env_file"
export SDKMAN_DIR="\$HOME/.sdkman"
[[ -s "\$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "\$HOME/.sdkman/bin/sdkman-init.sh"
export JAVA_HOME="\$HOME/.sdkman/candidates/java/current"
export ANDROID_HOME="\$HOME/Android/Sdk"
export PATH="\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
export NVM_DIR="\$HOME/.nvm"

export FASTLANE_SKIP_UPDATE_CHECK=1
export FASTLANE_DISABLE_COLORS=1
export FASTLANE_OPT_OUT_USAGE=1
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
EOF
    source "$HOME/.bashrc"
}

setup_android_sdk() {
    log_info "Instalando Android SDK..."
    
    # Criar diretório para o Android SDK
    mkdir -p "$HOME/Android/Sdk"
    export ANDROID_HOME="$HOME/Android/Sdk"
    
    # Download do cmdline-tools, que é necessário para instalar outros componentes
    local CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
    local CMDLINE_TOOLS_ZIP="cmdline-tools.zip"
    
    cd "$ANDROID_HOME"
    curl -o "$CMDLINE_TOOLS_ZIP" "$CMDLINE_TOOLS_URL"
    unzip -q "$CMDLINE_TOOLS_ZIP"
    rm "$CMDLINE_TOOLS_ZIP"
    
    # Reorganizar diretórios conforme esperado pelo SDK Manager
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    
    # Adicionar ao PATH
    export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    
    # Aceitar licenças
    yes | sdkmanager --licenses
    
    # Instalar componentes necessários do Android SDK
    sdkmanager --install \
        "platform-tools" \
        "platforms;android-33" \
        "build-tools;33.0.0" \
        "extras;android;m2repository" \
        "extras;google;m2repository"
        
    log_info "Android SDK instalado com sucesso em $ANDROID_HOME"
}

build_android() {
    if [ -z "$1" ]; then
        log_error "Especifique 'production' ou 'development' como argumento"
        exit 1
    fi

    if [ ! -f "package.json" ]; then
        log_error "Arquivo package.json não encontrado. Certifique-se de estar no diretório correto."
        exit 1
    fi

    log_info "Configurando local.properties..."
    echo "sdk.dir=$ANDROID_HOME" > android/local.properties

    log_info "Instalando dependências do projeto..."
    yarn install || { log_error "Falha ao instalar dependências"; exit 1; }

    log_info "Executando prebuild do Expo..."
    npx expo prebuild || { log_error "Falha no prebuild do Expo"; exit 1; }

    cd android || { log_error "Não foi possível acessar o diretório android"; exit 1; }

    declare -A BUILD_ACTIONS=(
        [${BUILD_TYPES[0]}]="build_aab"
        [${BUILD_TYPES[1]}]="build_apk"
    )

    local action=${BUILD_ACTIONS[$1]}

    if [ -z "$action" ]; then
        log_error "Ambiente inválido. Use 'production' ou 'development'"
        exit 1
    fi

    if ! command -v fastlane &> /dev/null; then
        log_error "Fastlane não instalado. Execute 'gem install fastlane'"
        exit 1
    fi

    log_info "Iniciando build para ambiente: $1"
    fastlane android "$action" || { log_error "Falha no build"; exit 1; }
    log_info "🚀 Build finalizado com sucesso! 🚀"
}

main() {
    update_system
    setup_sdkman
    install_sdk_versions
    setup_android_sdk
    setup_ruby
    setup_node
    setup_environment
    log_info "Instalação concluída com sucesso!"
    build_android ${BUILD_TYPES[1]}
}

main
