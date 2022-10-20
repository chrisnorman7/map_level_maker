import 'package:backstreets_widgets/screens.dart';
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
              directory: earconsDirectory,
              sound: item.earcon,
              onChanged: (final value) {
                item.earcon = value;
                save(ref);
              },
              title: 'Earcon',
            ),
            SoundListTile(
              directory: descriptionsDirectory,
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
              directory: ambiancesDirectory,
              title: 'Ambiance',
            ),
            IntCoordinatesListTile(
              coordinates: item.coordinates,
              onChanged: (final value) {
                item.coordinates = value;
                save(ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Save the level.
  void save(final WidgetRef ref) {
    ref.watch(mapLevelSchemaProvider.call(argument.mapLevelId)).save();
    ref
      ..refresh(mapLevelSchemaProvider.call(argument.mapLevelId))
      ..refresh(mapLevelSchemaItemProvider.call(argument));
  }
}
