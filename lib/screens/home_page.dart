import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../src/json/map_level_schema.dart';
import 'edit_map_level_schema.dart';

/// The home page for the application.
class HomePage extends ConsumerWidget {
  /// Create an instance.
  const HomePage({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final maps = ref.watch(mapsProvider).toList();
    return SimpleScaffold(
      title: 'Map Levels',
      body: maps.isEmpty
          ? const CenterText(
              text: 'There are no maps to show.',
              autofocus: true,
            )
          : BuiltSearchableListView(
              items: maps,
              builder: (final context, final index) {
                final map = maps[index];
                return SearchableListTile(
                  searchString: map.name,
                  child: PushWidgetListTile(
                    title: map.name,
                    builder: (final context) => EditMapLevelSchema(id: map.id),
                    autofocus: index == 0,
                    subtitle: '${map.maxX} x ${map.maxY}',
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MapLevelSchema().save();
          ref.refresh(mapsProvider);
        },
        tooltip: 'Create Map',
        child: addIcon,
      ),
    );
  }
}
