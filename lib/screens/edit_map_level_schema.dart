import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jinja/jinja.dart';
import 'package:path/path.dart' as path;

import '../new_menu_item_context.dart';
import '../providers/map_level_schema_argument.dart';
import '../providers/project_context.dart';
import '../providers/providers.dart';
import '../src/json/map_level_schema.dart';
import '../src/json/map_level_schema_ambiance.dart';
import '../src/json/map_level_schema_function.dart';
import '../src/json/map_level_schema_item.dart';
import '../src/json/map_level_schema_random_sound.dart';
import '../src/json/map_level_schema_terrain.dart';
import '../src/json/music_schema.dart';
import '../util.dart';
import 'edit_map_level_schema_ambiance.dart';
import 'edit_map_level_schema_function.dart';
import 'edit_map_level_schema_item.dart';
import 'edit_map_level_schema_random_sound.dart';
import 'edit_map_level_schema_terrain.dart';
import 'level_preview_screen.dart';
import 'tabs/map_level_schema_ambiances_tab.dart';
import 'tabs/map_level_schema_functions_tab.dart';
import 'tabs/map_level_schema_items_tab.dart';
import 'tabs/map_level_schema_random_sounds_tab.dart';
import 'tabs/map_level_schema_settings_tab.dart';
import 'tabs/map_level_schema_terrains_tab.dart';

/// A widget to edit the map with the given [id].
class EditMapLevelSchema extends ConsumerStatefulWidget {
  /// Create an instance.
  const EditMapLevelSchema({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Create state for this widget.
  @override
  EditMapLevelSchemaState createState() => EditMapLevelSchemaState();
}

/// State for [EditMapLevelSchema].
class EditMapLevelSchemaState extends ConsumerState<EditMapLevelSchema> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextProvider);
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final terrains = level.terrains;
    final randomSounds = level.randomSounds;
    final functions = level.functions;
    return Cancel(
      child: CallbackShortcuts(
        bindings: {
          SingleActivator(
            LogicalKeyboardKey.keyB,
            control: useControlKey,
            meta: useMetaKey,
          ): () => generateLevelCode(
                context: context,
                projectContext: projectContext,
                level: level,
              ),
          SingleActivator(
            LogicalKeyboardKey.keyP,
            control: useControlKey,
            meta: useMetaKey,
          ): () => previewLevel(context: context, level: level)
        },
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: 'Settings',
              icon: settingsIcon,
              actions: [
                ElevatedButton(
                  onPressed: () => previewLevel(context: context, level: level),
                  child: const Icon(
                    Icons.preview,
                    semanticLabel: 'Preview Level',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => generateLevelCode(
                    context: context,
                    projectContext: projectContext,
                    level: level,
                  ),
                  child: const Icon(
                    Icons.build,
                    semanticLabel: 'Generate Code',
                  ),
                )
              ],
              builder: (final context) => CallbackShortcuts(
                bindings: {newShortcut: () => newMenu(context: context)},
                child: MapLevelSchemaSettingsTab(id: widget.id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newMenu(context: context),
                tooltip: 'New...',
                child: const Icon(
                  Icons.new_label,
                  semanticLabel: 'New...',
                ),
              ),
            ),
            TabbedScaffoldTab(
              title: 'Terrains',
              icon: Text('${terrains.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {newShortcut: () => newTerrain(context: context)},
                child: MapLevelSchemaTerrainsTab(id: widget.id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newTerrain(context: context),
                tooltip: 'New Terrain',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Items',
              icon: Text('${level.items.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {newShortcut: () => newItem(context: context)},
                child: MapLevelSchemaItemsTab(id: widget.id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newItem(context: context),
                tooltip: 'New Item',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Ambiances',
              icon: Text('${level.ambiances.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {newShortcut: () => newAmbiance(context: context)},
                child: MapLevelSchemaAmbiancesTab(id: widget.id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newAmbiance(context: context),
                tooltip: 'New Ambiance',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Random Sounds',
              icon: Text('${randomSounds.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {newShortcut: () => newRandomSound(context: context)},
                child: MapLevelSchemaRandomSoundsTab(id: widget.id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newRandomSound(context: context),
                tooltip: 'New Random Sound',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Functions',
              icon: Text('${functions.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {newShortcut: () => newFunction(context: context)},
                child: MapLevelSchemaFunctionsTab(id: widget.id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newFunction(context: context),
                tooltip: 'New Function',
                child: addIcon,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Show a "new" menu.
  Future<void> newMenu({
    required final BuildContext context,
  }) async {
    final items = [
      NewMenuItemContext(
        title: 'Terrain',
        shortcut: LogicalKeyboardKey.keyT,
        onPressed: () => newTerrain(context: context),
      ),
      NewMenuItemContext(
        title: 'Item',
        shortcut: LogicalKeyboardKey.keyI,
        onPressed: () => newItem(context: context),
      ),
      NewMenuItemContext(
        title: 'Ambiance',
        shortcut: LogicalKeyboardKey.keyA,
        onPressed: () => newAmbiance(context: context),
      ),
      NewMenuItemContext(
        title: 'Random Sound',
        shortcut: LogicalKeyboardKey.keyR,
        onPressed: () => newRandomSound(context: context),
      ),
      NewMenuItemContext(
        title: 'Function',
        shortcut: LogicalKeyboardKey.keyF,
        onPressed: () => newFunction(context: context),
      )
    ];
    await pushWidget(
      context: context,
      builder: (final context) => Cancel(
        child: CallbackShortcuts(
          bindings: {
            for (final item in items)
              SingleActivator(item.shortcut): () {
                Navigator.pop(context);
                item.onPressed();
              }
          },
          child: SimpleScaffold(
            title: 'New Menu',
            body: ListView.builder(
              itemBuilder: (final context, final index) {
                final item = items[index];
                return ListTile(
                  autofocus: index == 0,
                  title: Text(item.title),
                  subtitle: Text(item.shortcut.keyLabel),
                  onTap: () {
                    Navigator.pop(context);
                    item.onPressed();
                  },
                );
              },
              itemCount: items.length,
            ),
          ),
        ),
      ),
    );
    setState(() {});
  }

  /// Create a new terrain.
  Future<void> newTerrain({
    required final BuildContext context,
  }) async {
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final terrain = MapLevelSchemaTerrain();
    level.terrains.add(terrain);
    saveLevel(ref: ref, id: widget.id);
    await pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaTerrain(
        mapLevelSchemaArgument: MapLevelSchemaArgument(
          mapLevelId: widget.id,
          valueId: terrain.id,
        ),
      ),
    );
    setState(() {});
  }

  /// Create a new item.
  Future<void> newItem({
    required final BuildContext context,
  }) async {
    final projectContext = ref.watch(projectContextProvider);
    final possibleEarcons = projectContext.earconsDirectory.listSync();
    if (possibleEarcons.isEmpty) {
      return showMessage(
        context: context,
        message: 'There are no earcons to use.',
      );
    }
    final possibleDescriptions =
        projectContext.descriptionsDirectory.listSync();
    if (possibleDescriptions.isEmpty) {
      return showMessage(
        context: context,
        message: 'There are no description sounds to use.',
      );
    }
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final item = MapLevelSchemaItem(
      earcon: path.basename(possibleEarcons.first.path),
      descriptionSound: path.basename(possibleDescriptions.first.path),
    );
    level.items.add(item);
    saveLevel(ref: ref, id: widget.id);
    await pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaItem(
        argument: MapLevelSchemaArgument(
          mapLevelId: widget.id,
          valueId: item.id,
        ),
      ),
    );
    setState(() {});
  }

  /// Create a new ambiance.
  Future<void> newAmbiance({
    required final BuildContext context,
  }) async {
    final ambiancesDirectory =
        ref.watch(projectContextProvider).ambiancesDirectory;
    final possibleAmbiances = ambiancesDirectory.listSync();
    if (possibleAmbiances.isEmpty) {
      return showMessage(
        context: context,
        message: 'There are no ambiances to use.',
      );
    } else {
      final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
      final ambiance = MapLevelSchemaAmbiance(
        sound: MusicSchema(
          sound: path.basename(possibleAmbiances.first.path),
        ),
      );
      level.ambiances.add(ambiance);
      saveLevel(ref: ref, id: widget.id);
      await pushWidget(
        context: context,
        builder: (final context) => EditMapLevelSchemaAmbiance(
          argument: MapLevelSchemaArgument(
            mapLevelId: widget.id,
            valueId: ambiance.id,
          ),
        ),
      );
      setState(() {});
    }
  }

  /// Create a new random sound.
  Future<void> newRandomSound({
    required final BuildContext context,
  }) async {
    final projectContext = ref.watch(projectContextProvider);
    final possibleRandomSounds =
        projectContext.randomSoundsDirectory.listSync();
    if (possibleRandomSounds.isEmpty) {
      return showMessage(
        context: context,
        message: 'There are no random sounds to use.',
      );
    } else {
      final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
      final randomSound = MapLevelSchemaRandomSound(
        sound: path.basename(possibleRandomSounds.first.path),
        maxX: level.maxX.toDouble(),
        maxY: level.maxY.toDouble(),
      );
      level.randomSounds.add(randomSound);
      saveLevel(ref: ref, id: widget.id);
      await pushWidget(
        context: context,
        builder: (final context) => EditMapLevelSchemaRandomSound(
          argument: MapLevelSchemaArgument(
            mapLevelId: widget.id,
            valueId: randomSound.id,
          ),
        ),
      );
      setState(() {});
    }
  }

  /// Create a new function.
  Future<void> newFunction({
    required final BuildContext context,
  }) async {
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final function = MapLevelSchemaFunction();
    level.functions.add(function);
    saveLevel(ref: ref, id: widget.id);
    await pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaFunction(
        argument: MapLevelSchemaArgument(
          mapLevelId: widget.id,
          valueId: function.id,
        ),
      ),
    );
    setState(() {});
  }

  /// Show an error.
  Future<void> showError({
    required final BuildContext context,
    required final Object e,
    required final StackTrace? s,
  }) =>
      pushWidget(
        context: context,
        builder: (final context) => Cancel(
          child: ErrorScreen(
            error: e,
            stackTrace: s,
          ),
        ),
      );

  /// Generate code from the given [level].
  void generateLevelCode({
    required final BuildContext context,
    required final ProjectContext projectContext,
    required final MapLevelSchema level,
  }) {
    try {
      final dartFile = projectContext.getLevelDartFile(level);
      mapLevelSchemaToDart(projectContext: projectContext, level: level);
      showMessage(
        context: context,
        message: 'Code written to ${dartFile.path}.',
      );
    } on TemplateError catch (e, s) {
      showError(context: context, e: e, s: s);
    } on FormatterException catch (e, s) {
      showError(context: context, e: e, s: s);
    }
  }

  /// Preview the given [level].
  Future<void> previewLevel({
    required final BuildContext context,
    required final MapLevelSchema level,
  }) =>
      pushWidget(
        context: context,
        builder: (final context) => LevelPreviewScreen(levelSchema: level),
      );
}
