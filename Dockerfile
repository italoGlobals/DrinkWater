FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl unzip git zip build-essential \
    libssl-dev \
    libffi-dev \
    ruby-full \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s "https://get.sdkman.io" | bash

ENV SDKMAN_DIR="/root/.sdkman"
RUN bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh && sdk install java 17.0.8-tem"

RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
ENV NVM_DIR="/root/.nvm"
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 22 && nvm use 22"

RUN gem install fastlane -NV

RUN mkdir -p /opt/android-sdk && \
    curl -fsSL "https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip" -o /opt/cmdline-tools.zip && \
    unzip /opt/cmdline-tools.zip -d /opt/android-sdk && \
    mv /opt/android-sdk/cmdline-tools /opt/android-sdk/tools && \
    rm /opt/cmdline-tools.zip

ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}"

RUN yes | sdkmanager --licenses || true

WORKDIR /app

EXPOSE 8081

CMD ["/bin/bash"]
