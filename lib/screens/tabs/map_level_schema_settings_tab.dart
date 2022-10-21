import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/double_coordinates_list_tile.dart';
import '../../widgets/int_coordinates_list_tile.dart';
import '../../widgets/music_schema_list_tile.dart';
import '../../widgets/reverb_list_tile.dart';
import '../../widgets/sound_list_tile.dart';

/// The settings tab.
class MapLevelSchemaSettingsTab extends ConsumerWidget {
  /// Create an instance.
  const MapLevelSchemaSettingsTab({
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
    return ListView(
      children: [
        TextListTile(
          value: level.className,
          onChanged: (final value) {
            level.className = value;
            saveLevel(ref: ref, id: id);
          },
          header: 'Class Name',
          autofocus: true,
          validator: (final value) => validateClassName(value: value),
        ),
        TextListTile(
          value: level.name,
          onChanged: (final value) {
            level.name = value;
            saveLevel(ref: ref, id: id);
          },
          header: 'Name',
          validator: (final value) => validateNonEmptyValue(value: value),
        ),
        SoundListTile(
          directory: projectContext.footstepsDirectory,
          sound: level.defaultFootstepSound,
          onChanged: (final value) {
            level.defaultFootstepSound = value;
            saveLevel(ref: ref, id: id);
          },
          title: 'Default Footstep Sound',
        ),
        SoundListTile(
          directory: projectContext.wallsDirectory,
          sound: level.wallSound,
          onChanged: (final value) {
            level.wallSound = value;
            saveLevel(ref: ref, id: id);
          },
          title: 'Wall Sound',
        ),
        MusicSchemaListTile(
          music: level.music,
          onChanged: (final value) {
            level.music = value;
            saveLevel(ref: ref, id: id);
          },
        ),
        ReverbListTile(
          id: id,
        ),
        IntCoordinatesListTile(
          coordinates: level.maxSize,
          onChanged: (final value) {
            level.maxSize = value;
            saveLevel(ref: ref, id: id);
          },
          title: 'Size',
          minX: 1,
          minY: 1,
        ),
        DoubleCoordinatesListTile(
          coordinates: level.coordinates,
          onChanged: (final value) {
            level.coordinates = value;
            saveLevel(ref: ref, id: id);
          },
          minX: 0.0,
          minY: 0.0,
          maxX: level.maxX - 1,
          maxY: level.maxY - 1,
          title: 'Initial Coordinates',
        ),
        DoubleListTile(
          value: level.heading,
          onChanged: (final value) {
            level.heading = value;
            saveLevel(ref: ref, id: id);
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
            saveLevel(ref: ref, id: id);
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
            saveLevel(ref: ref, id: id);
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
            saveLevel(ref: ref, id: id);
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
            saveLevel(ref: ref, id: id);
          },
          title: 'Move Distance',
          modifier: 0.5,
          subtitle: '${level.moveDistance.toStringAsFixed(2)} tiles',
        ),
        IntListTile(
          value: level.sonarDistanceMultiplier,
          onChanged: (final value) {
            level.sonarDistanceMultiplier = value;
            saveLevel(ref: ref, id: id);
          },
          title: 'Sonar Distance Multiplier',
        )
      ],
    );
  }
}
