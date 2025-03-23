FROM node:18-alpine

ENV ANDROID_HOME=/root/Android/Sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin

USER root

RUN apk update && \
    apk add --no-cache unzip curl bash git openjdk17

WORKDIR /app

COPY package.json ./
RUN yarn install

COPY . .

EXPOSE 5173

CMD ["yarn", "android:build"]
FROM node:18-alpine

ENV ANDROID_HOME /root/Android/Sdk
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin

USER root

RUN apk update && \
    apk add --no-cache unzip curl bash git openjdk17

WORKDIR /app

COPY package.json ./
RUN yarn install

COPY . .

EXPOSE 5173

CMD ["yarn", "android:build"]
