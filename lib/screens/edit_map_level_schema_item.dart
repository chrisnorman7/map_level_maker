import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../widgets/int_coordinates_list_tile.dart';
import '../widgets/music_schema_list_tile.dart';
import '../widgets/sound_list_tile.dart';

/// Edit the item with the given [argument].
class EditMapLevelSchemaItem extends ConsumerWidget {
  /// Create an instance.
  const EditMapLevelSchemaItem({
    required this.argument,
    super.key,
  });

  /// The argument to use.
  final MapLevelSchemaArgument argument;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextProvider);
    final itemContext = ref.watch(mapLevelSchemaItemProvider.call(argument));
    final item = itemContext.value;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Item',
        body: ListView(
          children: [
            TextListTile(
              value: item.name,
              onChanged: (final value) {
                item.name = value;
                save(ref);
              },
              header: 'Name',
              autofocus: true,
            ),
            TextListTile(
              value: item.descriptionText,
              onChanged: (final value) {
                item.descriptionText = value;
                save(ref);
              },
              header: 'Description Text',
            ),
            SoundListTile(
              directory: projectContext.earconsDirectory,
              sound: item.earcon,
              onChanged: (final value) {
                item.earcon = value;
                save(ref);
              },
              title: 'Earcon',
            ),
            SoundListTile(
              directory: projectContext.descriptionsDirectory,
              sound: item.descriptionSound,
              onChanged: (final value) {
                item.descriptionSound = value;
                save(ref);
              },
              title: 'Description Sound',
            ),
            MusicSchemaListTile(
              music: item.ambiance,
              onChanged: (final value) {
                item.ambiance = value;
                save(ref);
              },
              directory: projectContext.ambiancesDirectory,
              title: 'Ambiance',
            ),
            Builder(
              builder: (final context) {
                final coordinates = item.coordinates;
                if (coordinates == null) {
                  return ListTile(
                    title: const Text('Coordinates'),
                    subtitle: const Text(unsetMessage),
                    onTap: () {
                      item.coordinates = const Point(0, 0);
                      save(ref);
                    },
                  );
                }
                return CallbackShortcuts(
                  bindings: {
                    deleteShortcut: () {
                      item.coordinates = null;
                      save(ref);
                    }
                  },
                  child: IntCoordinatesListTile(
                    coordinates: coordinates,
                    onChanged: (final value) {
                      item.coordinates = value;
                      save(ref);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Save the level.
  void save(final WidgetRef ref) {
    final provider = mapLevelSchemaProvider.call(argument.mapLevelId);
    final level = ref.watch(provider);
    ref.watch(projectContextProvider).saveLevel(level);
    ref
      ..invalidate(provider)
      ..invalidate(mapLevelSchemaItemProvider.call(argument));
  }
}
