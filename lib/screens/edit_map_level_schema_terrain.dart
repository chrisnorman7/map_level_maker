import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../widgets/function_list_tile.dart';
import '../widgets/int_coordinates_list_tile.dart';
import '../widgets/sound_list_tile.dart';

/// A widget to edit a map terrain.
class EditMapLevelSchemaTerrain extends ConsumerWidget {
  /// Create an instance.
  const EditMapLevelSchemaTerrain({
    required this.mapLevelSchemaArgument,
    super.key,
  });

  /// The argument to use.
  final MapLevelSchemaArgument mapLevelSchemaArgument;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextProvider);
    final terrainContext = ref.watch(
      mapLevelSchemaTerrainProvider.call(mapLevelSchemaArgument),
    );
    final level = terrainContext.level;
    final terrain = terrainContext.value;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Map Terrain',
        body: ListView(
          children: [
            TextListTile(
              value: terrain.name,
              onChanged: (final value) {
                terrain.name = value;
                save(ref);
              },
              header: 'Name',
              autofocus: true,
            ),
            SoundListTile(
              directory: projectContext.footstepsDirectory,
              sound: terrain.footstepSound,
              onChanged: (final value) {
                terrain.footstepSound = value;
                save(ref);
              },
              title: 'Footstep Sound',
            ),
            FunctionListTile(
              functions: [null, ...level.functions],
              function: level.findFunction(terrain.onActivateFunctionId),
              onChanged: (final value) {
                terrain.onActivateFunctionId = value?.id;
                save(ref);
              },
              title: 'On Activate Function',
            ),
            IntCoordinatesListTile(
              coordinates: terrain.start,
              onChanged: (final value) {
                terrain.start = value;
                save(ref);
              },
              minX: 0,
              minY: 0,
              maxX: terrain.endX,
              maxY: terrain.endY,
              title: 'Start Coordinates',
            ),
            IntCoordinatesListTile(
              coordinates: terrain.end,
              onChanged: (final value) {
                terrain.end = value;
                save(ref);
              },
              minX: terrain.startX,
              minY: terrain.startY,
              maxX: level.maxX - 1,
              maxY: level.maxY - 1,
              title: 'End Coordinates',
            ),
          ],
        ),
      ),
    );
  }

  /// Save the project.
  void save(final WidgetRef ref) {
    final provider = mapLevelSchemaProvider.call(
      mapLevelSchemaArgument.mapLevelId,
    );
    final level = ref.watch(provider);
    ref.watch(projectContextProvider).saveLevel(level);
    ref
      ..invalidate(provider)
      ..invalidate(mapLevelSchemaTerrainProvider.call(mapLevelSchemaArgument));
  }
}
