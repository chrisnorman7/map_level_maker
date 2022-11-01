import 'dart:convert';

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../providers/map_level_schema_argument.dart';
import '../../providers/providers.dart';
import '../../src/json/map_level_schema_terrain.dart';
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
    final projectContext = ref.watch(projectContextProvider);
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final terrains = level.terrains
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    final Widget child;
    if (terrains.isEmpty) {
      child = const CenterText(
        text: 'There are no terrains to show.',
        autofocus: true,
      );
    } else {
      child = BuiltSearchableListView(
        items: terrains,
        builder: (final context, final index) {
          final terrain = terrains[index];
          final start = terrain.start;
          final end = terrain.end;
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
                    ),
                copyShortcut: () {
                  projectContext.setClipboard(ref: ref, value: terrain);
                }
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
                subtitle: '(${start.x}, ${start.y}) to (${end.x}, ${end.y})',
              ),
            ),
          );
        },
      );
    }
    return CallbackShortcuts(
      bindings: {
        pasteShortcut: () {
          final value = projectContext.getClipboard<MapLevelSchemaTerrain>(
            ref: ref,
          );
          if (value != null) {
            final json = jsonDecode(jsonEncode(value)) as JsonType;
            json['id'] = newId();
            final terrain = MapLevelSchemaTerrain.fromJson(json);
            level.terrains.add(terrain);
            projectContext.saveLevel(level);
            setState(() {});
          }
        }
      },
      child: child,
    );
  }
}
