import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../providers/map_level_schema_argument.dart';
import '../../providers/providers.dart';
import '../../util.dart';
import '../edit_map_level_schema_feature.dart';

/// The features tab.
class MapLevelSchemaFeaturesTab extends ConsumerWidget {
  /// Create an instance.
  const MapLevelSchemaFeaturesTab({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final features = level.features
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    if (features.isEmpty) {
      return const CenterText(
        text: 'There are no features to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: features,
      builder: (final context, final index) {
        final feature = features[index];
        return SearchableListTile(
          searchString: feature.name,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () => confirm(
                    context: context,
                    message:
                        'Are you sure you want to delete the ${feature.name} '
                        'feature?',
                    title: confirmDeleteTitle,
                    yesCallback: () {
                      Navigator.pop(context);
                      level.features.removeWhere(
                        (final element) => element.id == feature.id,
                      );
                      saveLevel(ref: ref, id: id);
                    },
                  )
            },
            child: PushWidgetListTile(
              title: feature.name,
              builder: (final context) => EditMapLevelSchemaFeature(
                mapLevelSchemaArgument: MapLevelSchemaArgument(
                  mapLevelId: id,
                  valueId: feature.id,
                ),
              ),
              autofocus: index == 0,
            ),
          ),
        );
      },
    );
  }
}
