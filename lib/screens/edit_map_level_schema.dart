import 'dart:math';

import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../providers/map_level_schema_context.dart';
import '../widgets/coordinates_list_tile.dart';

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
    final mapLevelSchemaContext = ref.watch(mapLevelSchemaProvider.call(id));
    return TabbedScaffold(
      tabs: [
        TabbedScaffoldTab(
          title: 'Settings',
          icon: settingsIcon,
          builder: (final context) => getSettingsPage(
            ref: ref,
            mapLevelSchemaContext: mapLevelSchemaContext,
          ),
        )
      ],
    );
  }

  /// Get the settings page.
  Widget getSettingsPage({
    required final WidgetRef ref,
    required final MapLevelSchemaContext mapLevelSchemaContext,
  }) {
    final level = mapLevelSchemaContext.mapLevelSchema;
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
        CoordinatesListTile(
          coordinates: Point(level.maxX, level.maxY),
          onChanged: (final value) {
            level
              ..maxX = value.x
              ..maxY = value.y;
            save(ref);
          },
          title: 'Size',
          minX: 1,
          minY: 1,
        )
      ],
    );
  }

  /// Save the project.
  void save(final WidgetRef ref) {
    ref.watch(projectProvider).save();
    ref.refresh(mapLevelSchemaProvider.call(id));
  }
}
