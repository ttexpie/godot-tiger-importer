![](./addons/tiger_importer/godottiger.svg)

# Godot Tiger Importer
This is an addon for [Godot](https://godotengine.org/) for importing sprite data files from [Tiger](https://github.com/agersant/tiger) for animations.

## What is [Tiger](https://github.com/agersant/tiger)?
Tiger is a middleman program to help game developers bridge the gap between sprite animation and game engine. Although programs like [Aseprite](https://www.aseprite.org/) can create custom spritesheet and animation data, but this requires you to keep everything in one file or make a custom script.

## How to Use
1. Install addon.
2. Enable plugin in project settings.
3. Export files to project using `godot_json.template` in export settings.
4. Go to the Tiger Importer tab and import the files.
5. Select a Sprite2D node and AnimationPlayer Node.
6. Click "Generate Animations" and your animations will appear in the AnimationPlayer library.

This importer plugin will automatically create new animations for you as well as update them on newer imports.

## Issues
This plugin is new and some things might not work. Please open an issue if you have any problems. Also, Tiger has many features, but this plugin does not. Here are some features missing:

- Supports only Sprite2D
- Can only use template given from addon
- Hitboxes/Tags not supported

## Credits
Majority of code is based on the [Aseprite Importer plugin](https://github.com/AtkinTC/aseprite_importer) so thanks to hectorid and AtkinTC for the source code.
