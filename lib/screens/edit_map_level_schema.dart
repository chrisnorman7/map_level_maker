import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../src/json/map_level_feature_schema.dart';
import '../src/json/map_level_schema.dart';
import '../widgets/double_coordinates_list_tile.dart';
import '../widgets/int_coordinates_list_tile.dart';
import '../widgets/music_schema_list_tile.dart';
import '../widgets/sound_list_tile.dart';
import 'edit_map_level_feature_schema.dart';

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
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: 'Settings',
            icon: settingsIcon,
            builder: (final context) => getSettingsPage(
              ref: ref,
              level: level,
            ),
          ),
          TabbedScaffoldTab(
            title: 'Features',
            icon: Text('${features.length}'),
            builder: (final context) => getFeaturesPage(
              ref: ref,
              level: level,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final feature = MapLevelFeatureSchema();
                level.features.add(feature);
                save(ref);
                pushWidget(
                  context: context,
                  builder: (final context) => EditMapLevelFeatureSchema(
                    mapLevelSchemaArgument: MapLevelSchemaArgument(
                      mapLevelId: level.id,
                      valueId: feature.id,
                    ),
                  ),
                );
              },
              tooltip: 'Create Feature',
              child: addIcon,
            ),
          )
        ],
      ),
    );
  }

  /// Get the settings page.
  Widget getSettingsPage({
    required final WidgetRef ref,
    required final MapLevelSchema level,
  }) =>
      ListView(
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

  /// Get the features page.
  Widget getFeaturesPage({
    required final WidgetRef ref,
    required final MapLevelSchema level,
  }) {
    final features = level.features;
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
                      level.save();
                      ref.refresh(mapLevelSchemaProvider.call(id));
                    },
                  )
            },
            child: PushWidgetListTile(
              title: feature.name,
              builder: (final context) => EditMapLevelFeatureSchema(
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

  /// Save the project.
  void save(final WidgetRef ref) {
    final provider = mapLevelSchemaProvider.call(id);
    ref.watch(provider).save();
    ref
      ..refresh(provider)
      ..refresh(mapsProvider);
  }
}
