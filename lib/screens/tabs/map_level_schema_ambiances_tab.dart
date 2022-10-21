import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../constants.dart';
import '../../providers/map_level_schema_argument.dart';
import '../../providers/providers.dart';
import '../../util.dart';
import '../../widgets/play_sound_semantics.dart';
import '../edit_map_level_schema_ambiance.dart';

/// The ambiances tab.
class MapLevelSchemaAmbiancesTab extends ConsumerWidget {
  /// Create an instance.
  const MapLevelSchemaAmbiancesTab({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final ambiances = level.ambiances;
    if (ambiances.isEmpty) {
      return const CenterText(
        text: 'There are no ambiances to show.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: ambiances,
      builder: (final context, final index) {
        final ambiance = ambiances[index];
        return SearchableListTile(
          searchString: ambiance.sound.sound,
          child: CallbackShortcuts(
            bindings: {
              deleteShortcut: () => confirm(
                    context: context,
                    message: 'Are you sure you want to delete this ambiance?',
                    title: confirmDeleteTitle,
                    yesCallback: () {
                      level.ambiances.removeWhere(
                        (final element) => element.id == ambiance.id,
                      );
                      saveLevel(ref: ref, id: id);
                    },
                  )
            },
            child: PlaySoundSemantics(
              sound: ambiance.sound.sound,
              directory: ambiancesDirectory,
              gain: ambiance.sound.gain,
              looping: true,
              child: Builder(
                builder: (final context) {
                  final coordinates = ambiance.coordinates;
                  return PushWidgetListTile(
                    title: path.basenameWithoutExtension(ambiance.sound.sound),
                    builder: (final builderContext) {
                      PlaySoundSemantics.of(context)?.stop();
                      return EditMapLevelSchemaAmbiance(
                        argument: MapLevelSchemaArgument(
                          mapLevelId: id,
                          valueId: ambiance.id,
                        ),
                      );
                    },
                    autofocus: index == 0,
                    subtitle: coordinates == null
                        ? unsetMessage
                        : '${coordinates.x}, ${coordinates.y}',
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
