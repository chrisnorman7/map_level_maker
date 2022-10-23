# map_level_maker

Generate `MapLevel` class code that will work with the [ziggurat_simple_maps](https://pub.dev/packages/ziggurat_simple_maps) package.

## Getting Started

- Launch the program.
- Select the folder where your project has been created. This should be the directory where your `pubspec.yaml` file is located.
- Create maps.
- From the maps list, click the "Build Levels" button, or press CTRL/CMD+B to build all maps.
- From a map editor, click the "Generate Code" button, or press CTRL/CMD+B` to generate the code for a single map.

## Usage Tips

### Clipboard

There is a clipboard, which will work when pressing CTRL/CMD+C on any map, terrain, item, ambiance, random sound, or function.

You can paste what you have copied with CTRL/CMD+V. Multiple things can be stored in the clipboard, so you could for example copy a terrain and a function, then paste them both into the relevant tabs of another map.

## Shortcut Keys

There are some unadvertised shortcut keys which you can use.

- On a sound list item (excluding musics), you can press CTRL/CMD+C to copy the full path of the current sound.
- When configuring numbers, you can use ALT/OPT with the arrow keys to modify the value(s).
- When configuring coordinates and sizes, you can use CTRL/CMD+C to copy the value as pure Dart.
- CTRL/CMD+N is a "New Item" shortcut. The kind of new "item" which is created depends on the context. In the "Settings" page of the map editor, a menu is shown, where single letters create the displayed items.
- Anywhere in the tabbed interface of the map editor, CTRL/CMD+B generates code for the current map.
- In the maps list, CTRL/CMD+B generates code for all maps.
- In the maps list, CTRL/CMD+SHIFT+I shows system information.
- From the system information view, pressing enter or space, or clicking on any of the list items copies the contents of that list tile to your clipboard.
- Pressing CTRL/CMD+C on any map, or entry in the various lists in the map editor copies that item to the app's clipboard.
- Pressing CTRL/CMD+V in the maps list or in any of the tabs of the map editor (excluding settings) pastes any item which was previously copied with CTRL/CMD+C.
- CTRL/CMD+W from the maps list closes the current project, allowing you to open a new one.
