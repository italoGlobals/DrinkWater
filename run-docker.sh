#!/bin/bash

docker build --no-cache -t android-builder-sh . && \
docker run --platform linux/amd64 -v $(pwd)/output:/app/output android-builder-sh
