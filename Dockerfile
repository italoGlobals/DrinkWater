# Use a base image with Node.js
FROM node:18

# Install OpenJDK
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV ANDROID_HOME /opt/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Android SDK
RUN mkdir -p ${ANDROID_HOME} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O android-sdk.zip && \
    unzip android-sdk.zip -d ${ANDROID_HOME} && \
    rm android-sdk.zip

# Install Android SDK components
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the application
COPY . .

# Build command (will be executed when container is run)
CMD ["cd", "android", "&&", "./gradlew", "assembleRelease"] 