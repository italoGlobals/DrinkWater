#!/bin/bash
#!/bin/bash
if [ "$1" = "aab" ]; then
    mv app/build/outputs/bundle/release/app-release.aab $WORKSPACE/DrinkWater.aab
else
    mv app/build/outputs/apk/release/app-release.apk $WORKSPACE/DrinkWater.apk
fi 
