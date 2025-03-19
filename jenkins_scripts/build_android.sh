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

screenfetch_system() {
    apt-get install -y screenfetch
    screenfetch
}

check_sdkman_installed() {
    if [ -d "$HOME/.sdkman" ] && command -v sdk &> /dev/null; then
        log_info "SDKMAN já está instalado"
        return 0
    fi
    return 1
}

check_nvm_installed() {
    if [ -d "$HOME/.nvm" ] && command -v nvm &> /dev/null; then
        log_info "NVM já está instalado"
        return 0
    fi
    return 1
}

check_rbenv_installed() {
    if [ -d "$HOME/.rbenv" ] && command -v rbenv &> /dev/null; then
        log_info "rbenv já está instalado"
        return 0
    fi
    return 1
}

check_gem_installed() {
    if command -v gem &> /dev/null; then
        log_info "gem já está instalado"
        return 0
    fi
    return 1
}

check_sdk_installed() {
    if command -v sdk &> /dev/null; then
        log_info "sdk já está instalado"
        return 0
    fi
    return 1
}

check_java_installed() {
    if command -v java &> /dev/null && [ "$(java --version | cut -d' ' -f2 | cut -d'p' -f1)" == "$JAVA_VERSION" ]; then
        log_info "Java $JAVA_VERSION já está instalado"
        return 0
    fi
    return 1
}

check_node_installed() {
    if command -v node &> /dev/null && [ "$(node --version)" == "v$NODE_VERSION" ]; then
        log_info "Node.js $NODE_VERSION já está instalado"
        return 0
    fi
    return 1
}

check_ruby_installed() {
    if command -v ruby &> /dev/null && [ "$(ruby --version | cut -d' ' -f2 | cut -d'p' -f1)" == "$RUBY_VERSION" ]; then
        log_info "Ruby $RUBY_VERSION já está instalado"
        return 0
    fi
    return 1
}

check_android_sdk_installed() {
    if [ -d "$HOME/Android/Sdk" ] && [ -d "$HOME/Android/Sdk/cmdline-tools" ]; then
        log_info "Android SDK já está instalado"
        return 0
    fi
    return 1
}

setup_sdkman() {
    if check_sdkman_installed; then
        return
    fi
    log_info "Configurando SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk selfupdate force
    sdk update
}

setup_node() {
    if check_node_installed; then
        return
    fi
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
    if check_ruby_installed; then
        return
    fi
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

    # Atualizar o RubyGems primeiro
    gem update --system
    
    # Instalar as dependências necessárias
    gem install json -v 2.6.1
    gem install optparse -v 0.2.0
    gem install base64 -v 0.1.1
    gem install nkf -v 0.1.1
    gem install rake -v 13.0.6
    gem install mutex_m -v 0.1.1
    
    # Instalar bundler após as dependências
    gem install bundler -v 2.5.9

    if [ -f "Gemfile" ]; then
        # Limpar cache do bundler
        rm -rf $HOME/.bundle
        rm -rf .bundle
        rm -rf vendor/bundle
        
        # Instalar dependências do Gemfile
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

create_build_files() {
    yarn install
    npx expo prebuild
    node optmize-build.js || { log_error "Falha ao otimizar build"; }
}

clean_build_files() {
    log_info "Reiniciando build..."
    if [ ! -f "package.json" ]; then
        log_error "Arquivo package.json não encontrado. Certifique-se de estar no diretório correto."
        exit 1
    fi

    rm -rf node_modules android ios yarn.lock .expo
}

setup_android_sdk() {
    if check_android_sdk_installed; then
        return
    fi
    log_info "Instalando Android SDK..."
    
    mkdir -p "$HOME/Android/Sdk"
    export ANDROID_HOME="$HOME/Android/Sdk"
    
    local CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
    local CMDLINE_TOOLS_ZIP="cmdline-tools.zip"
    
    cd "$ANDROID_HOME"
    curl -o "$CMDLINE_TOOLS_ZIP" "$CMDLINE_TOOLS_URL"
    unzip -q "$CMDLINE_TOOLS_ZIP"
    rm "$CMDLINE_TOOLS_ZIP"
    
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    
    export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    
    yes | sdkmanager --licenses
    
    sdkmanager --install \
        "platform-tools" \
        "platforms;android-33" \
        "build-tools;33.0.0" \
        "extras;android;m2repository" \
        "extras;google;m2repository"
        
    log_info "Android SDK instalado com sucesso em $ANDROID_HOME"
}

build_android() {
    if [ ! -f "package.json" ]; then
        log_error "Arquivo package.json não encontrado. Certifique-se de estar no diretório correto."
        exit 1
    fi

    log_info "Configurando local.properties..."
    echo "sdk.dir=$ANDROID_HOME" > android/local.properties

    clean_build_files

    create_build_files

    chown -R root:root /root/.gradle
    chmod -R 755 /root/.gradle

    if ! command -v fastlane &> /dev/null; then
        log_error "Fastlane não instalado. Execute 'gem install fastlane'"
        exit 1
    fi
    cd android || { log_error "Não foi possível acessar o diretório android"; exit 1; }
    log_info "Iniciando build para ambiente: $1"
    bundle exec fastlane android build_apk || { log_error "Falha no build"; exit 1; }
    log_info "🚀 Build finalizado com sucesso! 🚀"
}

check_build_prerequisites() {
    log_info "Verificando pré-requisitos para build..."
    
    local required_dirs=("android" "node_modules")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            log_error "Diretório '$dir' não encontrado"
            exit 1
        fi
    done
    
    local required_files=("package.json" "app.json")
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            log_error "Arquivo '$file' não encontrado"
            exit 1
        fi
    done
    
    local required_envs=("ANDROID_HOME" "JAVA_HOME")
    for env in "${required_envs[@]}"; do
        if [ -z "${!env}" ]; then
            log_error "Variável de ambiente $env não definida"
            exit 1
        fi
    done
}

main() {
    update_system
    screenfetch_system
    check_build_prerequisites
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
