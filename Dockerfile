FROM node:18-alpine

WORKDIR /app

# Instala dependências do sistema
RUN apk add --no-cache \
    bash \
    git \
    gradle \
    openjdk17 \
    android-tools \
    libc6-compat \
    python3 \
    make \
    cmake \
    curl \
    jq

# Instala o Yarn e EAS CLI
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
RUN yarn global add expo-cli eas-cli

# Copia o código do projeto
COPY . .

# Expo precisa de login para builds na nuvem
RUN eas whoami || echo "Você precisa logar manualmente com 'eas login'"

# Expõe as portas do Expo
EXPOSE 19000 19001 19002

# Gera a build com EAS
# CMD ["eas", "build", "--platform", "android", "--local"]

CMD cd android && ./gradlew assembleRelease
