FROM node:18-alpine

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile
RUN yarn global add expo-cli
RUN yarn android:build

COPY . .

# Expose port 19000 for Expo DevServer
# Expose port 19001 for Metro Bundler
# Expose port 19002 for Expo Developer Tools
EXPOSE 19000 19001 19002

CMD ["cd", "android", "&&", "./gradlew", "assembleRelease"]
