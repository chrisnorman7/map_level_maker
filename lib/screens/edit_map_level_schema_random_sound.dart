import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../util.dart';
import '../widgets/double_coordinates_list_tile.dart';
import '../widgets/sound_list_tile.dart';

/// A widget for editing a random sound.
class EditMapLevelSchemaRandomSound extends ConsumerWidget {
  /// Create an instance.
  const EditMapLevelSchemaRandomSound({
    required this.argument,
    super.key,
  });

  /// The argument to use.
  final MapLevelSchemaArgument argument;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextProvider);
    final randomSoundContext =
        ref.watch(mapLevelSchemaRandomSoundProvider.call(argument));
    final randomSound = randomSoundContext.value;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Random Sound',
        body: ListView(
          children: [
            SoundListTile(
              directory: projectContext.randomSoundsDirectory,
              sound: randomSound.sound,
              onChanged: (final value) {
                randomSound.sound = value!;
                save(ref);
              },
              autofocus: true,
              nullable: false,
            ),
            DoubleCoordinatesListTile(
              coordinates: randomSound.minCoordinates,
              onChanged: (final value) {
                randomSound.minCoordinates = value;
                save(ref);
              },
              maxX: randomSound.maxX,
              maxY: randomSound.maxY,
              title: 'Minimum Coordinates',
            ),
            DoubleCoordinatesListTile(
              coordinates: randomSound.maxCoordinates,
              onChanged: (final value) {
                randomSound.maxCoordinates = value;
                save(ref);
              },
              minX: randomSound.minX,
              minY: randomSound.minY,
              title: 'Maximum Coordinates',
            ),
            DoubleListTile(
              value: randomSound.minGain,
              onChanged: (final value) {
                randomSound.minGain = value;
                save(ref);
              },
              title: 'Minimum Gain',
              min: 0.01,
              max: randomSound.maxGain,
              modifier: 0.05,
            ),
            DoubleListTile(
              value: randomSound.maxGain,
              onChanged: (final value) {
                randomSound.maxGain = value;
                save(ref);
              },
              title: 'Maximum Gain',
              max: 5.0,
              min: randomSound.minGain,
              modifier: 0.05,
            ),
            IntListTile(
              value: randomSound.minInterval,
              onChanged: (final value) {
                randomSound.minInterval = value;
                save(ref);
              },
              title: 'Minimum Interval',
              min: 10,
              modifier: 100,
              max: randomSound.maxInterval,
              subtitle: '${randomSound.minInterval} ms',
            ),
            IntListTile(
              value: randomSound.maxInterval,
              onChanged: (final value) {
                randomSound.maxInterval = value;
                save(ref);
              },
              title: 'Maximum Interval',
              min: randomSound.minInterval,
              modifier: 100,
              subtitle: '${randomSound.maxInterval} ms',
            )
          ],
        ),
      ),
    );
  }

  /// Save the level.
  void save(final WidgetRef ref) {
    saveLevel(ref: ref, id: argument.mapLevelId);
    ref.invalidate(mapLevelSchemaRandomSoundProvider.call(argument));
  }
}
