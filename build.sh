#! /bin/bash

rm -f ./build/*

mods=("ruler-mod" "get-a-cab-mod")
mkdir -p build

for mod in "${mods[@]}"
do
    v=$(jq -r '.version' "$mod/info.json")
    archive=./build/${mod}_$v.zip
    zip -r $archive $mod
done

cp ./build/* ~/.factorio/mods
