FROM node:18-alpine

RUN apk update && apk add --no-cache \
  bash \
  openjdk17 \
  curl \
  unzip \
  git

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV ANDROID_HOME="/android-sdk"
ENV PATH="$PATH:$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

RUN mkdir -p $ANDROID_HOME/cmdline-tools \
  && curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -o android-commandline-tools.zip \
  && unzip android-commandline-tools.zip -d $ANDROID_HOME/cmdline-tools/ \
  && rm android-commandline-tools.zip

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

EXPOSE 5173

CMD ["npm", "run", "android:build"]
