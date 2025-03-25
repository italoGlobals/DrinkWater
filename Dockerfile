FROM mobiledevops/android-sdk-image:latest

# Install Node.js and yarn
RUN apt-get update && apt-get install -y \
curl \
&& curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
&& apt-get install -y nodejs \
&& npm install -g yarn

WORKDIR /app
ENV NODE_ENV=production

COPY . .

RUN chmod +x ./docker-entrypoint.sh

CMD ["./docker-entrypoint.sh"]
