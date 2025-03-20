FROM node:18-alpine

RUN apk update && apk add --no-cache \
  bash \
  openjdk8 \
  curl \
  unzip \
  git \
  wget

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip -d /android-sdk && \
    rm commandlinetools-linux-9477386_latest.zip

RUN mkdir -p /android-sdk/cmdline-tools/latest && \
    mv /android-sdk/cmdline-tools/* /android-sdk/cmdline-tools/latest/ || true

ENV ANDROID_HOME="/android-sdk"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

RUN yes | sdkmanager --licenses || true

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

EXPOSE 5173

CMD ["npm", "run", "android:build"]
