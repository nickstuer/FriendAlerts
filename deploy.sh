#!/bin/bash

sourceFile=$(find . -maxdepth 1 -name "*.toc" -not -name "*_*")
addonName="Unknown"
addonNameRegexPattern="## Title: ([A-Za-z]+)"

while IFS= read -r line1; do
    # Extract addon name
    if [[ "$line1" =~ $addonNameRegexPattern ]]; then
        addonName=${BASH_REMATCH[1]}
    fi

done < $sourceFile

# Retail WoW
echo "Deploying $addonName"

ADDON_PATH="/Applications/World of Warcraft/_retail_/Interface/AddOns/${addonName}"
ADDON_PATH_WINDOWS="C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\\${addonName}"

if [ "$OSTYPE" == "msys" ]; then
    ADDON_PATH="$ADDON_PATH_WINDOWS"
fi
echo "Using path: $ADDON_PATH"

rm -vrf "$ADDON_PATH" | echo "$(wc -l) files deleted"
mkdir -p "$ADDON_PATH"

find . -maxdepth 1 \( -type f -o -type d \) -not -path "./.github*" -not -path "./.git*" -not -path "./dist*" -not -path "." -exec cp -R {} "${ADDON_PATH}/" \;

echo "Successfully deployed to $ADDON_PATH"

sed -i.bak 's/@project-version@/v0.0.0/g' "$ADDON_PATH"/*.toc
echo "Updated version in .toc file"