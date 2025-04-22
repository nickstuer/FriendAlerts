#!/bin/bash

ADDON_PATH="C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\FriendAlerts"

rm -vrf "$ADDON_PATH" | echo "$(wc -l) files deleted"
mkdir -p "$ADDON_PATH"

cp -R "src\Media" "${ADDON_PATH}\Media";
cp -R "src\Options" "${ADDON_PATH}\Options";
cp -R "src\Main.lua" "${ADDON_PATH}\Main.lua";
cp -R "src\FriendAlerts.toc" "${ADDON_PATH}\FriendAlerts.toc";
cp -R "README.md" "${ADDON_PATH}\README.md";

echo "Successfully deployed FriendAlerts to $ADDON_PATH"