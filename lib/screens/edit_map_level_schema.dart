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
class EditMapLevelSchema extends ConsumerWidget {
  /// Create an instance.
  const EditMapLevelSchema({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextProvider);
    final level = ref.watch(mapLevelSchemaProvider.call(id));
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
                bindings: {
                  newShortcut: () => newMenu(context: context, ref: ref)
                },
                child: MapLevelSchemaSettingsTab(id: id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newMenu(context: context, ref: ref),
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
                bindings: {
                  newShortcut: () => newTerrain(context: context, ref: ref)
                },
                child: MapLevelSchemaTerrainsTab(id: id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newTerrain(context: context, ref: ref),
                tooltip: 'New Terrain',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Items',
              icon: Text('${level.items.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {
                  newShortcut: () => newItem(context: context, ref: ref)
                },
                child: MapLevelSchemaItemsTab(id: id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newItem(context: context, ref: ref),
                tooltip: 'New Item',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Ambiances',
              icon: Text('${level.ambiances.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {
                  newShortcut: () => newAmbiance(context: context, ref: ref)
                },
                child: MapLevelSchemaAmbiancesTab(id: id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newAmbiance(context: context, ref: ref),
                tooltip: 'New Ambiance',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Random Sounds',
              icon: Text('${randomSounds.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {
                  newShortcut: () => newRandomSound(context: context, ref: ref)
                },
                child: MapLevelSchemaRandomSoundsTab(id: id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newRandomSound(context: context, ref: ref),
                tooltip: 'New Random Sound',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Functions',
              icon: Text('${functions.length}'),
              builder: (final context) => CallbackShortcuts(
                bindings: {
                  newShortcut: () => newFunction(context: context, ref: ref)
                },
                child: MapLevelSchemaFunctionsTab(id: id),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => newFunction(context: context, ref: ref),
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
  void newMenu({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final items = [
      NewMenuItemContext(
        title: 'Terrain',
        shortcut: LogicalKeyboardKey.keyT,
        onPressed: () => newTerrain(context: context, ref: ref),
      ),
      NewMenuItemContext(
        title: 'Item',
        shortcut: LogicalKeyboardKey.keyI,
        onPressed: () => newItem(context: context, ref: ref),
      ),
      NewMenuItemContext(
        title: 'Ambiance',
        shortcut: LogicalKeyboardKey.keyA,
        onPressed: () => newAmbiance(context: context, ref: ref),
      ),
      NewMenuItemContext(
        title: 'Random Sound',
        shortcut: LogicalKeyboardKey.keyR,
        onPressed: () => newRandomSound(context: context, ref: ref),
      ),
      NewMenuItemContext(
        title: 'Function',
        shortcut: LogicalKeyboardKey.keyF,
        onPressed: () => newFunction(context: context, ref: ref),
      )
    ];
    pushWidget(
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
  }

  /// Create a new terrain.
  void newTerrain({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final terrain = MapLevelSchemaTerrain();
    level.terrains.add(terrain);
    saveLevel(ref: ref, id: id);
    pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaTerrain(
        mapLevelSchemaArgument: MapLevelSchemaArgument(
          mapLevelId: id,
          valueId: terrain.id,
        ),
      ),
    );
  }

  /// Create a new item.
  void newItem({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final projectContext = ref.watch(projectContextProvider);
    final possibleEarcons = projectContext.earconsDirectory.listSync();
    if (possibleEarcons.isEmpty) {
      showMessage(context: context, message: 'There are no earcons to use.');
    }
    final possibleDescriptions =
        projectContext.descriptionsDirectory.listSync();
    if (possibleDescriptions.isEmpty) {
      showMessage(
        context: context,
        message: 'There are no description sounds to use.',
      );
    }
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final item = MapLevelSchemaItem(
      earcon: path.basename(possibleEarcons.first.path),
      descriptionSound: path.basename(possibleDescriptions.first.path),
    );
    level.items.add(item);
    saveLevel(ref: ref, id: id);
    pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaItem(
        argument: MapLevelSchemaArgument(
          mapLevelId: id,
          valueId: item.id,
        ),
      ),
    );
  }

  /// Create a new ambiance.
  void newAmbiance({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final ambiancesDirectory =
        ref.watch(projectContextProvider).ambiancesDirectory;
    final possibleAmbiances = ambiancesDirectory.listSync();
    if (possibleAmbiances.isEmpty) {
      showMessage(
        context: context,
        message: 'There are no ambiances to use.',
      );
    } else {
      final level = ref.watch(mapLevelSchemaProvider.call(id));
      final ambiance = MapLevelSchemaAmbiance(
        sound: MusicSchema(
          sound: path.basename(possibleAmbiances.first.path),
        ),
      );
      level.ambiances.add(ambiance);
      saveLevel(ref: ref, id: id);
      pushWidget(
        context: context,
        builder: (final context) => EditMapLevelSchemaAmbiance(
          argument: MapLevelSchemaArgument(
            mapLevelId: id,
            valueId: ambiance.id,
          ),
        ),
      );
    }
  }

  /// Create a new random sound.
  void newRandomSound({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final projectContext = ref.watch(projectContextProvider);
    final possibleRandomSounds =
        projectContext.randomSoundsDirectory.listSync();
    if (possibleRandomSounds.isEmpty) {
      showMessage(
        context: context,
        message: 'There are no random sounds to use.',
      );
    } else {
      final level = ref.watch(mapLevelSchemaProvider.call(id));
      final randomSound = MapLevelSchemaRandomSound(
        sound: path.basename(possibleRandomSounds.first.path),
        maxX: level.maxX.toDouble(),
        maxY: level.maxY.toDouble(),
      );
      level.randomSounds.add(randomSound);
      saveLevel(ref: ref, id: id);
      pushWidget(
        context: context,
        builder: (final context) => EditMapLevelSchemaRandomSound(
          argument: MapLevelSchemaArgument(
            mapLevelId: id,
            valueId: randomSound.id,
          ),
        ),
      );
    }
  }

  /// Create a new function.
  void newFunction({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final function = MapLevelSchemaFunction();
    level.functions.add(function);
    saveLevel(ref: ref, id: id);
    pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaFunction(
        argument: MapLevelSchemaArgument(
          mapLevelId: id,
          valueId: function.id,
        ),
      ),
    );
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
