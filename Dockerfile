FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache \
    openjdk17 \
    curl \
    unzip \
    bash

RUN npm install -g expo-cli

COPY . .

RUN yarn install

RUN curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -o android-tools.zip && \
    mkdir -p /opt/android && \
    unzip android-tools.zip -d /opt/android && \
    rm android-tools.zip && \
    yes | /opt/android/cmdline-tools/bin/sdkmanager --sdk_root=/opt/android --licenses && \
    /opt/android/cmdline-tools/bin/sdkmanager --sdk_root=/opt/android "platform-tools" "platforms;android-33" "build-tools;33.0.2"

ENV ANDROID_HOME="/opt/android"
ENV PATH="${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/bin:${PATH}"

RUN expo prebuild --platform android
WORKDIR /app/android
RUN chmod +x gradlew
RUN ./gradlew assembleRelease
