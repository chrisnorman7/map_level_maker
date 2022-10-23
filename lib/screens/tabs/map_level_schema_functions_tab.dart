import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/map_level_schema_argument.dart';
import '../../providers/providers.dart';
import '../../util.dart';
import '../edit_map_level_schema_function.dart';

/// The functions tab.
class MapLevelSchemaFunctionsTab extends ConsumerStatefulWidget {
  /// Create an instance.
  const MapLevelSchemaFunctionsTab({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Create state for this widget.
  @override
  MapLevelSchemaFunctionsTabState createState() =>
      MapLevelSchemaFunctionsTabState();
}

/// State for [MapLevelSchemaFunctionsTab].
class MapLevelSchemaFunctionsTabState
    extends ConsumerState<MapLevelSchemaFunctionsTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final functions = level.functions
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    if (functions.isEmpty) {
      return const CenterText(
        text: 'There are no functions to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: functions,
      builder: (final context, final index) {
        final function = functions[index];
        return SearchableListTile(
          searchString: function.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () {
                for (final terrain in level.terrains) {
                  for (final id in [terrain.onActivateFunctionId]) {
                    if (id == function.id) {
                      showMessage(
                        context: context,
                        message: 'This function is being used by the '
                            '${terrain.name} terrain.',
                      );
                      return;
                    }
                  }
                }
                confirm(
                  context: context,
                  message:
                      'Are you sure you want to delete the ${function.name} '
                      'function?',
                  yesCallback: () {
                    Navigator.pop(context);
                    level.functions.removeWhere(
                      (final element) => element.id == function.id,
                    );
                    saveLevel(ref: ref, id: widget.id);
                  },
                );
              }
            },
            child: PushWidgetListTile(
              title: function.name,
              builder: (final context) => EditMapLevelSchemaFunction(
                argument: MapLevelSchemaArgument(
                  mapLevelId: widget.id,
                  valueId: function.id,
                ),
              ),
              autofocus: index == 0,
              subtitle: function.comment,
              onSetState: () => setState(() {}),
            ),
          ),
        );
      },
    );
  }
}
