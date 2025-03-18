#!/bin/bash
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
if [ "$1" = "aab" ]; then
    fastlane android build_aab
else
    fastlane android build_apk
fi 