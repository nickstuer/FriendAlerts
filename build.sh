#!/bin/bash

FILENAME=$"FriendAlerts-v2.0.0.zip"

#####
BUILD_DIRECTORY=$"${PWD}/dist"

rm -vrf "$BUILD_DIRECTORY" | echo "$(wc -l) files deleted"
mkdir -p "$BUILD_DIRECTORY"
mkdir -p $"${BUILD_DIRECTORY}/temp"
mkdir -p $"${BUILD_DIRECTORY}/temp/FriendAlerts"

cp -R "src/Media" "${BUILD_DIRECTORY}/temp/FriendAlerts/Media";
cp -R "src/Settings" "${BUILD_DIRECTORY}/temp/FriendAlerts/Options";
cp -R "src/Core" "${BUILD_DIRECTORY}/temp/FriendAlerts/Core";
cp -R "src/Main.lua" "${BUILD_DIRECTORY}/temp/FriendAlerts/Main.lua";
cp -R "src/FriendAlerts.toc" "${BUILD_DIRECTORY}/temp/FriendAlerts/FriendAlerts.toc";
cp -R "README.md" "${BUILD_DIRECTORY}/temp/FriendAlerts/README.md";

if [ "$OSTYPE" == "msys" ]; then
    (cd dist/temp && "C:\Program Files\Git\bin\zip.exe" -r $"../${FILENAME}" .)
else
    (cd dist/temp && "zip" -r $"../${FILENAME}" .) # This would work if just added zip to path in windows
fi

