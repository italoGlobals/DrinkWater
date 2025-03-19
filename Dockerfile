FROM node:18

RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME /opt/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${ANDROID_HOME} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O android-sdk.zip && \
    unzip android-sdk.zip -d ${ANDROID_HOME} && \
    rm android-sdk.zip

RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

CMD ["cd", "android", "&&", "./gradlew", "assembleRelease"] 