#!/bin/bash
if [ "$1" = "aab" ]; then
    fastlane android build_aab
else
    fastlane android build_apk
fi 