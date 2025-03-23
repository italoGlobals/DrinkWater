FROM node:18-alpine

ENV ANDROID_HOME /root/Android/Sdk
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
ENV ANDROID_BUILD_TOOLS_VERSION 30.0.3
ENV ANDROID_VERSION 30
ENV ANDROID_CMAKE_VERSION 3.10.2.4988404
ENV ANDROID_NDK_VERSION 21.4.7075529
ENV PATH $ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

USER root

RUN apk update && \
    apk add --no-cache unzip curl bash git openjdk17-jdk && \
    mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip && \
    yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME && \
    sdkmanager --update --sdk_root=$ANDROID_HOME && \
    sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "sources;android-${ANDROID_VERSION}" \
    "cmake;${ANDROID_CMAKE_VERSION}" \
    "platform-tools" \
    "ndk;${ANDROID_NDK_VERSION}" \
    "extras;android;m2repository" \
    "extras;google;m2repository" && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN npm install -g eas-cli

WORKDIR /app

COPY package.json ./
RUN yarn install

COPY . .

EXPOSE 5173

CMD ["yarn", "android:build"]
