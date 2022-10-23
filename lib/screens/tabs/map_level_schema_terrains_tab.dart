import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../providers/map_level_schema_argument.dart';
import '../../providers/providers.dart';
import '../../util.dart';
import '../edit_map_level_schema_terrain.dart';

/// The terrains tab.
class MapLevelSchemaTerrainsTab extends ConsumerStatefulWidget {
  /// Create an instance.
  const MapLevelSchemaTerrainsTab({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Create state for this widget.
  @override
  MapLevelSchemaTerrainsTabState createState() =>
      MapLevelSchemaTerrainsTabState();
}

/// State for [MapLevelSchemaTerrainsTab].
class MapLevelSchemaTerrainsTabState
    extends ConsumerState<MapLevelSchemaTerrainsTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final terrains = level.terrains
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    if (terrains.isEmpty) {
      return const CenterText(
        text: 'There are no terrains to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: terrains,
      builder: (final context, final index) {
        final terrain = terrains[index];
        return SearchableListTile(
          searchString: terrain.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () => confirm(
                    context: context,
                    message:
                        'Are you sure you want to delete the ${terrain.name} '
                        'terrain?',
                    title: confirmDeleteTitle,
                    yesCallback: () {
                      Navigator.pop(context);
                      level.terrains.removeWhere(
                        (final element) => element.id == terrain.id,
                      );
                      saveLevel(ref: ref, id: widget.id);
                    },
                  )
            },
            child: PushWidgetListTile(
              title: terrain.name,
              autofocus: index == 0,
              builder: (final context) => EditMapLevelSchemaTerrain(
                mapLevelSchemaArgument: MapLevelSchemaArgument(
                  mapLevelId: widget.id,
                  valueId: terrain.id,
                ),
              ),
              onSetState: () => setState(() {}),
            ),
          ),
        );
      },
    );
  }
}
