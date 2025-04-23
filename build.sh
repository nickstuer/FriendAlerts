#!/bin/bash

FILENAME=$"FriendAlerts-v1.0.1.zip"

#####
BUILD_DIRECTORY=$"${PWD}/dist"

rm -vrf "$BUILD_DIRECTORY" | echo "$(wc -l) files deleted"
mkdir -p "$BUILD_DIRECTORY"
mkdir -p $"${BUILD_DIRECTORY}/temp"

cp -R "src\Media" "${BUILD_DIRECTORY}/temp/Media";
cp -R "src\Options" "${BUILD_DIRECTORY}/temp/Options";
cp -R "src\Main.lua" "${BUILD_DIRECTORY}/temp/Main.lua";
cp -R "src\FriendAlerts.toc" "${BUILD_DIRECTORY}/temp/FriendAlerts.toc";
cp -R "README.md" "${BUILD_DIRECTORY}/temp/README.md";

(cd dist/temp && "C:\Program Files\Git\bin\zip.exe" -r $"../${FILENAME}" .)
