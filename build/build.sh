#!/bin/bash

if ! [ -x "$(command -v xmllint)" ]; then
  echo 'Error: xmllint is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v zip)" ]; then
  echo 'Error: zip is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v md5sum)" ]; then
  echo 'Error: md5sum is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

xmllint --noblanks plugins/plugins64.xml > PluginManagerPlugins.xml
zip plugins64.zip PluginManagerPlugins.xml
md5sum PluginManagerPlugins.xml | sed -E -e 's/^([0-9a-f]+)\s.*$/\1/' | tr -d '\n' > plugins64.md5.txt
jq '. | map(.) | add | keys | reduce .[] as $item ({}; .[$item] = "ok")' plugins/validate.json > validate64.json



