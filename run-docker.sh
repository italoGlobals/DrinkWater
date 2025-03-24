#!/bin/bash

docker build --no-cache -t drinkwater-android-builder . && \
docker run --platform linux/amd64 -v $(pwd)/output:/app/output drinkwater-android-builder
