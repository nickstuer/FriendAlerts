#!/bin/bash

FILENAME=$"FriendAlerts-v1.0.1.zip"

#####
BUILD_DIRECTORY=$"${PWD}/dist"

rm -vrf "$BUILD_DIRECTORY" | echo "$(wc -l) files deleted"
mkdir -p "$BUILD_DIRECTORY"

cp -R "src\Media" "${BUILD_DIRECTORY}\Media";
cp -R "src\Options" "${BUILD_DIRECTORY}\Options";
cp -R "src\Main.lua" "${BUILD_DIRECTORY}\Main.lua";
cp -R "src\FriendAlerts.toc" "${BUILD_DIRECTORY}\FriendAlerts.toc";
cp -R "README.md" "${BUILD_DIRECTORY}\README.md";

(cd dist && "C:\Program Files\Git\bin\zip.exe" -r $"../${FILENAME}" .)
