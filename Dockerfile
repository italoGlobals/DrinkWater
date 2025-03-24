FROM node:18-alpine

ENV ANDROID_HOME=/root/Android/Sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin

USER root

RUN apk update && \
    apk add --no-cache unzip curl bash git openjdk17 && \
    mkdir -p $ANDROID_HOME

# Install Android SDK Command-line tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d $ANDROID_HOME && \
    mv $ANDROID_HOME/cmdline-tools $ANDROID_HOME/latest && \
    mkdir -p $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/latest $ANDROID_HOME/cmdline-tools/latest

# Accept licenses
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

# Install required Android SDK components
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --update && \
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "ndk;26.1.10909125"

WORKDIR /app

COPY package.json ./
RUN yarn install

COPY . .

EXPOSE 5173

CMD ["yarn", "android:build"]
