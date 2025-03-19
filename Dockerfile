FROM node:18-alpine

WORKDIR /app

COPY package.json yarn.lock ./

RUN apk add --no-cache bash gradle openjdk11

RUN yarn install --frozen-lockfile
RUN yarn global add expo-cli

COPY . .

# Expose port 19000 para Expo DevServer
# Expose port 19001 para Metro Bundler
# Expose port 19002 para Expo Developer Tools
EXPOSE 19000 19001 19002

RUN npx expo prebuild

CMD cd android && ./gradlew assembleRelease
