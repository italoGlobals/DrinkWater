FROM node:18-alpine

RUN apk update && apk add --no-cache \
  bash \
  openjdk17 \
  curl \
  unzip \
  git \
  wget

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

RUN mkdir /android-sdk
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && unzip *.zip -d /android-sdk && rm *.zip
ENV ANDROID_HOME="/android-sdk"
ENV PATH="$PATH:$ANDROID_HOME/tools/bin"

RUN yes | sdkmanager "platform-tools"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"
RUN adb version # throws error: adb not found

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

EXPOSE 5173

CMD ["npm", "run", "android:build"]
