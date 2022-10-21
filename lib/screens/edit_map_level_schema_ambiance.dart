import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../widgets/double_coordinates_list_tile.dart';
import '../widgets/music_schema_list_tile.dart';

/// A widget to edit a map level ambiance.
class EditMapLevelSchemaAmbiance extends ConsumerWidget {
  /// Create an instance.
  const EditMapLevelSchemaAmbiance({
    required this.argument,
    super.key,
  });

  /// The argument to use.
  final MapLevelSchemaArgument argument;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ambianceContext = ref.watch(
      mapLevelSchemaAmbianceProvider.call(argument),
    );
    final ambiance = ambianceContext.value;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Ambiance',
        body: ListView(
          children: [
            MusicSchemaListTile(
              music: ambiance.sound,
              onChanged: (final value) {
                ambiance.sound = value!;
                save(ref);
              },
              autofocus: true,
              directory: ambiancesDirectory,
              nullable: false,
              title: 'Ambiance',
            ),
            Builder(
              builder: (final context) {
                final coordinates = ambiance.coordinates;
                if (coordinates == null) {
                  return ListTile(
                    title: const Text('Coordinates'),
                    subtitle: const Text(unsetMessage),
                    onTap: () {
                      ambiance.coordinates = const Point(0.0, 0.0);
                      save(ref);
                    },
                  );
                }
                return CallbackShortcuts(
                  bindings: {
                    deleteShortcut: () {
                      ambiance.coordinates = null;
                      save(ref);
                    }
                  },
                  child: DoubleCoordinatesListTile(
                    coordinates: coordinates,
                    onChanged: (final value) {
                      ambiance.coordinates = value;
                      save(ref);
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  /// Save the level.
  void save(final WidgetRef ref) {
    ref.watch(mapLevelSchemaProvider.call(argument.mapLevelId)).save();
    ref
      ..invalidate(mapLevelSchemaProvider.call(argument.mapLevelId))
      ..invalidate(mapLevelSchemaAmbianceProvider.call(argument));
  }
}
