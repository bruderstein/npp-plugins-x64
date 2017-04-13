#!/bin/bash

xmllint --noblanks plugins/plugins64.xml > PluginManagerPlugins.xml
zip plugins64.zip PluginManagerPlugins.xml
md5sum PluginManagerPlugins.xml | sed -E -e 's/^([0-9a-f]+)\s.*$/\1/' | tr -d '\n' > plugins64.md5.txt



