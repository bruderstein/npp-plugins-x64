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

The `name` attribute _must_ be exactly the name returned by the plugin's `getName()` function and is case sensitive.

The install steps are run in the order they are listed, so this install will:
1. download the zip file (it *must* be a zip file) and extract it to a temporary directory. 
2. Copy the the `myplugin.dll` extracted from the zip to the Notepad++ plugin directory, and validate it's md5 (see later)
3. Copy all of the files from the `lib` directory in the zip, recursively, to the `myplugin\lib` directory under the Notepad++ plugin directory. Directories that do not already exist will be created.

It can be easier to copy the basic structure from the 32 bit entry and make the necessary modifications. To do that, just download the x86 plugin list: https://nppxml.bruderste.in/pm/xml/plugins.zip and find the entry in the `PluginManagerPlugins.xml` file. For existing plugins in the x86 list from 2017/4/17 see as starting point [plugins/plugins_template.xml](plugins/plugins_template.xml), where 1. and 2. from below is already done.

Things to change:
1. Remove the `<unicodeVersion>` and `<ansiVersion>`
2. Add an `<x64Version>` tag with the version of your x64 plugin
3. Change the download URL to your x64 download path if you don't bundle all variants in one zip file
4. Add the `md5sum`s to [plugins/validate.json](plugins/validate.json) of each file that you're copying (with a `<copy>` tag) with `validate="true"`


## Tag documentation

### `<x64Version>` (optional, but plugin won't be shown if not present)
The version number of the latest x64 version.  If this element is not present, then the plugin will not be shown to x64 users

### `<description>` (mandatory)
 A description of the plugin, which appears in the box below the list

### `<author>` (mandatory)
The authors name (and optionally email address etc), which is also displayed below the list

### `<homepage>`
The home page / web site of the plugin, also displayed in the box below the list

### `<sourceUrl>`
The URL of the source of the plugin

### `<latestUpdate>`
The latest updates the plugin has had. Shown on the notification of an update, and on the updates tab.</li>

### `<stability>`
If included, and not "Good", then the plugin is excluded if the user has "Show Unstable Plugins" disabled.  Shown in the plugin list.

### `<badVersions>`
Contains a list of unstable version numbers, that will always come below the latest version identified in `<x64Version>`. This is rarely used, but if you need to rollback a version, add the newer version here to say that that version is a bad version, and should be treated as a "lesser" version than that in the `<x64Version>` tag.
- `<version number="1.4.5" report="Causes a crash, please rollback to 1.4.4">`
   Attribute `number` identifies the version number as bad, attribute `report` is the status report, which is shown in the updates tab, and the notify window

### `<aliases>`
A list of `<alias>` elements with a `name` attribute, identifying other names this plugin is known by.

If you *change the name* reported by your `getName()` function, place the old names of the plugin in this list.

### `<install>`

This is the set of install steps. Inside the `<install>` tag _must_ be an `<x64>` tag, which identifies the steps as steps for x64 variant installation.

Steps are run in the order in which they are listed in the XML.

The steps that are available at the moment are:

* `<download>`

This downloads from the URL contained within the element. This _must_ be a zip file, and is automatically unzipped to a temporary location.

e.g. `<download>https://github.com/me/myplugin/releases/download/v1.4.4/MyPlugin-x64.zip</download>`

* `<copy>`
This copies files from the temporary unzipped location to a destination directory.  A destination directory must start with a variable, 
either $PLUGINDIR$, $CONFIGDIR$ or $NPPDIR$ which refer to the plugins directory, plugin config directory and the Notepad++ directory
respectively.  Directories that do not exist will automatically be created.  It has the following attributes:

    * `from`
      The `from` attribute can be wildcarded (e.g. `myplugin\*.dll`), and then the `to` attribute _must_ be a directory.

    * `to`
      The `to` attribute specifies a directory to copy the files to. It _must_ start with a variable, which is one of `$PLUGINDIR$`, `$CONFIGDIR$` or `$NPPDIR$`, which refer to the plugins directory, plugin config directory and the Notepad++ directory respectively.

    * `validate`
      If `validate="true"` is included in the copy, then the file's MD5sum is checked against a known list of valid files at the server. That list is maintained in the [validate.json](plugins/validate.json) file. Add any files to be validated there. If the file MD5sum is not listed in the validate.json file, the user will be warned that the file is unknown and should not be copied. They can however copy the file if they would like.

    * `backup`
      If `backup="true"` is included in the copy element, then if the destination file exists, it will be backed up to the same filename with `.backup` appended.  If the backup file exists, it will be backed up to a `.backup2` file, and so on.  This is normally used for config files, such that user's config is not lost, but a "good" / newer / up to date config can be installed.

    * `recursive`
      If the `recursive="true"` attribute is specified, then all files in child directories are copied.

* `<delete>`
This deletes the file or directory. The attribute `file` specifies the file or directory to remove. When `isDirectory="true"` is set, then the directory and all subdirectories are removed. This is most often used in the `remove` section rather than `install`.

* `<run>`
This runs an arbitrary path, optionally with the variables (`$PLUGINDIR$`, `$CONFIGDIR$` and `$NPPDIR$`). 
   * `file` attribute specifies the executable to run (it is run with `ShellExecuteEx` with the verb `open`)
   * `arguments` specify all arguments, and are passed directly to `ShellExecuteEx`
   * `outsideNpp` if `true`, the file is run after Notepad++ has closed (the user is prompted that a restart is necessary)

### `<remove>`
Contains the same structure as `<install>`, but is the steps required when removing the plugin (these are not performed on update, only removal).

Note: You **do not** need to remove the main plugin DLL, that is done automatically. Only use the `<remove>` tag if your plugin installs extra files which can and should be removed if the plugin is uninstalled.

e.g.
```xml
<remove>
  <x64>
    <delete file="$PLUGINDIR$\myplugin" isDirectory="true" />
    <delete file="$CONFIGDIR$\myplugin.sampleconfig" />
  </x64>
</remove>
```

### `<versions>`
A collection of `<version>` elements that identify a version if the DLL does not report a version (or reports an incorrect version). Ideally this should not be used, and the DLL should have the `FileVersion` set correctly to the version of the plugin, but sometimes this is not possible depending on the language used to compile the plugin.

Each `<version>` element contains
    * `number` attribute, which is the correct version number
    * `md5` attribute which is the md5sum of the file
    * `comment` attribute can optionally be included to name the version or the reason why the version is incorrect
    
    
## File Validation

Executable code (DLLs, EXEs etc) should be _validated_, i.e. when the file is copied with the `<copy>` tag, the `validate="true"` attribute should be set. These files must have their `md5sum` listed in the [plugins/validate.json](plugins/validate.json) file - include the changes to that file in your PR.

The format of the file is straightforward, and is best shown with an example:

```json
{
   "Plugin Name": {
      "cafefacefeedface1234567812345678": "filename.dll"
   },
   "Other plugin": {
      "0123456789abcdef0123456789abcdef": "otherfile.dll",
      "fedcba9876543210fedcba9876543210": "lib\\secondfile.dll"
   }
}
```

`md5sum` is a command line utility, and is can be run against a file locally to get the MD5 of the file. A version for windows is available here: http://unxutils.sourceforge.net/ , or if you have `Git Bash` installed, it is included. Simply run `md5sum myplugin.dll` to get the MD5 of the `myplugin.dll` file.
