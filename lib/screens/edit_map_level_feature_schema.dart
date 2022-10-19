import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../widgets/int_coordinates_list_tile.dart';

/// A widget to edit a feature.
class EditMapLevelFeatureSchema extends ConsumerWidget {
  /// Create an instance.
  const EditMapLevelFeatureSchema({
    required this.mapLevelSchemaArgument,
    super.key,
  });

  /// The argument to use.
  final MapLevelSchemaArgument mapLevelSchemaArgument;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final featureContext = ref.watch(
      mapLevelFeatureSchemaProvider.call(mapLevelSchemaArgument),
    );
    final level = featureContext.level;
    final feature = featureContext.value;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Map Feature',
        body: ListView(
          children: [
            TextListTile(
              value: feature.name,
              onChanged: (final value) {
                feature.name = value;
                save(ref);
              },
              header: 'Name',
              autofocus: true,
            ),
            IntCoordinatesListTile(
              coordinates: feature.start,
              onChanged: (final value) {
                feature.start = value;
                save(ref);
              },
              minX: 0,
              minY: 0,
              maxX: feature.endX,
              maxY: feature.endY,
              title: 'Start Coordinates',
            ),
            IntCoordinatesListTile(
              coordinates: feature.end,
              onChanged: (final value) {
                feature.end = value;
                save(ref);
              },
              minX: feature.startX,
              minY: feature.startY,
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
    final provider =
        mapLevelSchemaProvider.call(mapLevelSchemaArgument.mapLevelId);
    ref.watch(provider).save();
    ref
      ..refresh(mapLevelFeatureSchemaProvider.call(mapLevelSchemaArgument))
      ..refresh(provider);
  }
}
