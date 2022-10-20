import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../new_menu_item_context.dart';
import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../src/json/map_level_schema_feature.dart';
import '../src/json/map_level_schema_function.dart';
import '../src/json/map_level_schema_item.dart';
import '../widgets/double_coordinates_list_tile.dart';
import '../widgets/int_coordinates_list_tile.dart';
import '../widgets/music_schema_list_tile.dart';
import '../widgets/play_sound_semantics.dart';
import '../widgets/sound_list_tile.dart';
import 'edit_map_level_schema_feature.dart';
import 'edit_map_level_schema_function.dart';
import 'edit_map_level_schema_item.dart';

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
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final features = level.features;
    final functions = level.functions;
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: 'Settings',
            icon: settingsIcon,
            builder: (final context) => CallbackShortcuts(
              bindings: {
                newShortcut: () => newMenu(context: context, ref: ref)
              },
              child: getSettingsPage(ref: ref),
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
            title: 'Features',
            icon: Text('${features.length}'),
            builder: (final context) => CallbackShortcuts(
              bindings: {
                newShortcut: () => newFeature(context: context, ref: ref)
              },
              child: getFeaturesPage(ref: ref),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => newFeature(context: context, ref: ref),
              tooltip: 'Create Feature',
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
              child: getItemsTab(ref: ref),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => newItem(context: context, ref: ref),
              tooltip: 'New Item',
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
              child: getFunctionsTab(ref: ref),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => newFunction(context: context, ref: ref),
              tooltip: 'New Function',
              child: addIcon,
            ),
          )
        ],
      ),
    );
  }

  /// Get the settings tab.
  Widget getSettingsPage({
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    return ListView(
      children: [
        TextListTile(
          value: level.name,
          onChanged: (final value) {
            level.name = value;
            save(ref);
          },
          header: 'Name',
          autofocus: true,
        ),
        SoundListTile(
          directory: footstepsDirectory,
          sound: level.defaultFootstepSound,
          onChanged: (final value) {
            level.defaultFootstepSound = value;
            save(ref);
          },
          title: 'Default Footstep Sound',
        ),
        SoundListTile(
          directory: wallsDirectory,
          sound: level.wallSound,
          onChanged: (final value) {
            level.wallSound = value;
            save(ref);
          },
          title: 'Wall Sound',
        ),
        MusicSchemaListTile(
          music: level.music,
          onChanged: (final value) {
            level.music = value;
            save(ref);
          },
        ),
        IntCoordinatesListTile(
          coordinates: level.maxSize,
          onChanged: (final value) {
            level.maxSize = value;
            save(ref);
          },
          title: 'Size',
          minX: 1,
          minY: 1,
        ),
        DoubleCoordinatesListTile(
          coordinates: level.coordinates,
          onChanged: (final value) {
            level.coordinates = value;
            save(ref);
          },
          minX: 0.0,
          minY: 0.0,
          maxX: level.maxX - 1,
          maxY: level.maxY - 1,
        ),
        DoubleListTile(
          value: level.heading,
          onChanged: (final value) {
            level.heading = value;
            save(ref);
          },
          title: 'Initial Heading',
          min: 0.0,
          max: 359.0,
          modifier: 5.0,
          subtitle: '${level.heading} °',
        ),
        IntListTile(
          value: level.turnInterval,
          onChanged: (final value) {
            level.turnInterval = value;
            save(ref);
          },
          title: 'Turn Interval',
          min: 1,
          modifier: 10,
          subtitle: '${level.turnInterval} ms',
        ),
        IntListTile(
          value: level.turnAmount,
          onChanged: (final value) {
            level.turnAmount = value;
            save(ref);
          },
          title: 'Turn Amount',
          max: 359,
          modifier: 5,
          subtitle: '${level.turnAmount} °',
        ),
        IntListTile(
          value: level.moveInterval,
          onChanged: (final value) {
            level.moveInterval = value;
            save(ref);
          },
          title: 'Move Interval',
          min: 1,
          modifier: 10,
          subtitle: '${level.moveInterval} ms',
        ),
        DoubleListTile(
          value: level.moveDistance,
          onChanged: (final value) {
            level.moveDistance = value;
            save(ref);
          },
          title: 'Move Distance',
          modifier: 0.5,
          subtitle: '${level.moveDistance.toStringAsFixed(2)} tiles',
        ),
        IntListTile(
          value: level.sonarDistanceMultiplier,
          onChanged: (final value) {
            level.sonarDistanceMultiplier = value;
            save(ref);
          },
          title: 'Sonar Distance Multiplier',
        )
      ],
    );
  }

  /// Get the features tab.
  Widget getFeaturesPage({
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final features = level.features
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    if (features.isEmpty) {
      return const CenterText(
        text: 'There are no features to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: features,
      builder: (final context, final index) {
        final feature = features[index];
        return SearchableListTile(
          searchString: feature.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () => confirm(
                    context: context,
                    message:
                        'Are you sure you want to delete the ${feature.name} '
                        'feature?',
                    title: confirmDeleteTitle,
                    yesCallback: () {
                      Navigator.pop(context);
                      level.features.removeWhere(
                        (final element) => element.id == feature.id,
                      );
                      save(ref);
                    },
                  )
            },
            child: PushWidgetListTile(
              title: feature.name,
              builder: (final context) => EditMapLevelSchemaFeature(
                mapLevelSchemaArgument: MapLevelSchemaArgument(
                  mapLevelId: level.id,
                  valueId: feature.id,
                ),
              ),
              autofocus: index == 0,
            ),
          ),
        );
      },
    );
  }

  /// Get the items tab.
  Widget getItemsTab({
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final items = level.items
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    if (items.isEmpty) {
      return const CenterText(
        text: 'There are no items to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: items,
      builder: (final context, final index) {
        final item = items[index];
        return SearchableListTile(
          searchString: item.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () => confirm(
                    context: context,
                    message: 'Are you sure you want to delete the ${item.name} '
                        'item?',
                    title: confirmDeleteTitle,
                    yesCallback: () {
                      Navigator.pop(context);
                      level.items.removeWhere(
                        (final element) => element.id == item.id,
                      );
                      save(ref);
                    },
                  )
            },
            child: PlaySoundSemantics(
              directory: ambiancesDirectory,
              sound: item.ambiance?.sound,
              gain: item.ambiance?.gain ?? 0.7,
              looping: true,
              child: Builder(
                builder: (final context) => PushWidgetListTile(
                  title: item.name,
                  builder: (final builderContext) {
                    PlaySoundSemantics.of(context)?.stop();
                    return EditMapLevelSchemaItem(
                      argument: MapLevelSchemaArgument(
                        mapLevelId: id,
                        valueId: item.id,
                      ),
                    );
                  },
                  autofocus: index == 0,
                  subtitle: item.descriptionText,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Get the functions tab.
  Widget getFunctionsTab({
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final functions = level.functions
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    if (functions.isEmpty) {
      return const CenterText(
        text: 'There are no functions to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: functions,
      builder: (final context, final index) {
        final function = functions[index];
        return SearchableListTile(
          searchString: function.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () {
                for (final feature in level.features) {
                  for (final id in [feature.onActivateId]) {
                    if (id == function.id) {
                      showMessage(
                        context: context,
                        message: 'This function is being used by the '
                            '${feature.name} feature.',
                      );
                      return;
                    }
                  }
                }
                confirm(
                  context: context,
                  message:
                      'Are you sure you want to delete the ${function.name} '
                      'function?',
                  yesCallback: () {
                    Navigator.pop(context);
                    level.functions.removeWhere(
                      (final element) => element.id == function.id,
                    );
                    save(ref);
                  },
                );
              }
            },
            child: PushWidgetListTile(
              title: function.name,
              builder: (final context) => EditMapLevelSchemaFunction(
                argument: MapLevelSchemaArgument(
                  mapLevelId: id,
                  valueId: function.id,
                ),
              ),
              autofocus: index == 0,
              subtitle: function.comment,
            ),
          ),
        );
      },
    );
  }

  /// Save the project.
  void save(final WidgetRef ref) {
    final provider = mapLevelSchemaProvider.call(id);
    ref.watch(provider).save();
    ref
      ..refresh(provider)
      ..refresh(mapsProvider);
  }

  /// Show a "new" menu.
  void newMenu({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final items = [
      NewMenuItemContext(
        title: 'Feature',
        shortcut: LogicalKeyboardKey.keyF,
        onPressed: () => newFeature(context: context, ref: ref),
      ),
      NewMenuItemContext(
        title: 'Item',
        shortcut: LogicalKeyboardKey.keyI,
        onPressed: () => newItem(context: context, ref: ref),
      ),
      NewMenuItemContext(
        title: 'Function',
        shortcut: LogicalKeyboardKey.keyM,
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

  /// Create a new feature.
  void newFeature({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final feature = MapLevelSchemaFeature();
    level.features.add(feature);
    save(ref);
    pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaFeature(
        mapLevelSchemaArgument: MapLevelSchemaArgument(
          mapLevelId: id,
          valueId: feature.id,
        ),
      ),
    );
  }

  /// Create a new item.
  void newItem({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final item = MapLevelSchemaItem();
    level.items.add(item);
    save(ref);
    pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchemaItem(
        argument: MapLevelSchemaArgument(
          mapLevelId: level.id,
          valueId: item.id,
        ),
      ),
    );
  }

  /// Create a new function.
  void newFunction({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final function = MapLevelSchemaFunction();
    level.functions.add(function);
    save(ref);
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
}
