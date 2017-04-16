# Notepad++ x64 Plugins list

This is the list Notepad++ Plugin Manager uses for the x64 plugins.  x86 (32 bit) plugins are managed via the [admin system](https://npppm.bruderste.in)

## Why are the lists managed differently?

We're working on a new admin system (come and [help](https://github.com/bruderstein/npppm3/issues)) that supports editing x64 plugins (and a lot of other improvements), but until that is ready, we have this git managed XML list and JSON file for the validations for the x64 plugin list.

## How do I add a plugin?

Create a PR that adds the plugin description to [plugins/plugins64.xml](plugins/plugins64.xml). 

The following is a template:

```xml
<plugin name="My Plugin">
  <x64Version>1.4.4</x64Version>
  <description>Description of the plugin that appears in the list</description>
  <author>Your name / email / handle / whatever you're willing to provide</author>
  <latestUpdate>Details of the latest update, shown when a plugin update is notified</latestUpdate>
  <install>
    <x64>
      <download>https://github.com/me/myplugin/releases/download/v1.4.4/MyPlugin-x64.zip</download>
      <copy from="myplugin.dll" to="$PLUGINDIR$" validate="true" />
      <copy from="lib\*.*" to="$PLUGINDIR$\myplugin\lib" recursive="true" />
    </x64>
  </install>
</plugin>
```

The install steps are run in the order they are listed, so this install will:
1. download the zip file (it *must* be a zip file) and extract it to a temporary directory. 
2. Copy the the `myplugin.dll` extracted from the zip to the Notepad++ plugin directory, and validate it's md5 (see later)
3. Copy all of the files from the `lib` directory in the zip, recursively, to the `myplugin\lib` directory under the Notepad++ plugin directory. Directories that do not already exist will be created.

It can be easier to copy the basic structure from the 32 bit entry and make the necessary modifications. To do that, just download the x86 plugin list: https://nppxml.bruderste.in/pm/xml/plugins.zip and find the entry in the `PluginManagerPlugins.xml` file.

Things to change:
1. Remove the `<unicodeVersion>` and `<ansiVersion>`
2. Add an `<x64Version>` tag with the version of your x64 plugin
3. Change the download URL if you don't bundle all variants in one zip file


