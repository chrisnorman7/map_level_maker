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
class MapLevelSchemaAmbiancesTab extends ConsumerStatefulWidget {
  /// Create an instance.
  const MapLevelSchemaAmbiancesTab({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Create state for this widget.
  @override
  MapLevelSchemaAmbiancesTabState createState() =>
      MapLevelSchemaAmbiancesTabState();
}

/// State for [MapLevelSchemaAmbiancesTab].
class MapLevelSchemaAmbiancesTabState
    extends ConsumerState<MapLevelSchemaAmbiancesTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextProvider);
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final ambiances = level.ambiances
      ..sort(
        (final a, final b) =>
            a.sound.sound.toLowerCase().compareTo(b.sound.sound.toLowerCase()),
      );
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
          child: PlaySoundSemantics(
            sound: ambiance.sound.sound,
            directory: projectContext.ambiancesDirectory,
            gain: ambiance.sound.gain,
            looping: true,
            child: Builder(
              builder: (final context) => CallbackShortcuts(
                bindings: {
                  deleteShortcut: () {
                    PlaySoundSemantics.of(context)?.stop();
                    confirm(
                      context: context,
                      message: 'Are you sure you want to delete this ambiance?',
                      title: confirmDeleteTitle,
                      yesCallback: () {
                        level.ambiances.removeWhere(
                          (final element) => element.id == ambiance.id,
                        );
                        saveLevel(ref: ref, id: widget.id);
                      },
                    );
                  }
                },
                child: Builder(
                  builder: (final context) {
                    final coordinates = ambiance.coordinates;
                    return PushWidgetListTile(
                      title:
                          path.basenameWithoutExtension(ambiance.sound.sound),
                      builder: (final builderContext) {
                        PlaySoundSemantics.of(context)?.stop();
                        return EditMapLevelSchemaAmbiance(
                          argument: MapLevelSchemaArgument(
                            mapLevelId: widget.id,
                            valueId: ambiance.id,
                          ),
                        );
                      },
                      autofocus: index == 0,
                      subtitle: coordinates == null
                          ? unsetMessage
                          : '${coordinates.x}, ${coordinates.y}',
                      onSetState: () => setState(() {}),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
