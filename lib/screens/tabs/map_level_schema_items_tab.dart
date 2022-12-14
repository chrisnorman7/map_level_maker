import 'dart:convert';

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../providers/map_level_schema_argument.dart';
import '../../providers/providers.dart';
import '../../src/json/map_level_schema_item.dart';
import '../../util.dart';
import '../../widgets/play_sound_semantics.dart';
import '../edit_map_level_schema_item.dart';

/// The items tab.
class MapLevelSchemaItemsTab extends ConsumerStatefulWidget {
  /// Create an instance.
  const MapLevelSchemaItemsTab({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Create state for this widget.
  @override
  MapLevelSchemaItemsTabState createState() => MapLevelSchemaItemsTabState();
}

/// State for [MapLevelSchemaItemsTab].
class MapLevelSchemaItemsTabState
    extends ConsumerState<MapLevelSchemaItemsTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextProvider);
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final items = level.items
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    final Widget child;
    if (items.isEmpty) {
      child = const CenterText(
        text: 'There are no items to show.',
        autofocus: true,
      );
    } else {
      child = BuiltSearchableListView(
        items: items,
        builder: (final context, final index) {
          final item = items[index];
          return SearchableListTile(
            searchString: item.name,
            child: PlaySoundSemantics(
              directory: projectContext.ambiancesDirectory,
              sound: item.ambiance?.sound,
              gain: item.ambiance?.gain ?? 0.7,
              looping: true,
              child: Builder(
                builder: (final context) => CallbackShortcuts(
                  bindings: {
                    copyShortcut: () {
                      projectContext.setClipboard(ref: ref, value: item);
                    },
                    deleteShortcut: () {
                      PlaySoundSemantics.of(context)?.stop();
                      confirm(
                        context: context,
                        message:
                            'Are you sure you want to delete the ${item.name} '
                            'item?',
                        title: confirmDeleteTitle,
                        yesCallback: () {
                          Navigator.pop(context);
                          level.items.removeWhere(
                            (final element) => element.id == item.id,
                          );
                          saveLevel(ref: ref, id: widget.id);
                        },
                      );
                    }
                  },
                  child: Builder(
                    builder: (final context) => PushWidgetListTile(
                      title: item.name,
                      builder: (final builderContext) {
                        PlaySoundSemantics.of(context)?.stop();
                        return EditMapLevelSchemaItem(
                          argument: MapLevelSchemaArgument(
                            mapLevelId: widget.id,
                            valueId: item.id,
                          ),
                        );
                      },
                      autofocus: index == 0,
                      subtitle: item.descriptionText,
                      onSetState: () => setState(() {}),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    return CallbackShortcuts(
      bindings: {
        pasteShortcut: () {
          final value =
              projectContext.getClipboard<MapLevelSchemaItem>(ref: ref);
          if (value != null) {
            final json = jsonDecode(jsonEncode(value)) as JsonType;
            json['id'] = newId();
            final item = MapLevelSchemaItem.fromJson(json);
            level.items.add(item);
            projectContext.saveLevel(level);
            setState(() {});
          }
        }
      },
      child: child,
    );
  }
}
