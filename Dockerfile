FROM --platform=linux/amd64 node:18-alpine

ENV ANDROID_HOME=/root/Android/Sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin
ENV NODE_ENV=production

USER root

RUN apk update && \
    apk add --no-cache unzip curl bash git openjdk17 python3 make g++ libc6-compat gcompat && \
    mkdir -p $ANDROID_HOME

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d $ANDROID_HOME && \
    mv $ANDROID_HOME/cmdline-tools $ANDROID_HOME/latest && \
    mkdir -p $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/latest $ANDROID_HOME/cmdline-tools/latest

RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --update && \
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "ndk;26.1.10909125" && \
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

RUN npm install -g react-native-cli && \
    npm install -g hermes-engine

ENV PATH=$PATH:/app/node_modules/.bin

WORKDIR /app

COPY package.json ./
RUN yarn install

COPY . .

EXPOSE 5173

CMD ["yarn", "android:build"]
