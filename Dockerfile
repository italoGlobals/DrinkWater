FROM jenkins/jenkins:lts
USER root

# Instalar Node, Yarn, Fastlane e dependências do Android SDK
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    curl \
    wget \
    unzip \
    git \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn \
    && npm install --global expo-cli \
    && gem install fastlane --no-document \
    && rm -rf /var/lib/apt/lists/*

# Configurar permissões
RUN usermod -aG sudo jenkins

# Configurar caminho do Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin:$PATH"

WORKDIR /app
