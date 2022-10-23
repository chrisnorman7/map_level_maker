import 'dart:convert';

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../providers/map_level_schema_argument.dart';
import '../../providers/providers.dart';
import '../../src/json/map_level_schema_random_sound.dart';
import '../../util.dart';
import '../../widgets/play_sound_semantics.dart';
import '../edit_map_level_schema_random_sound.dart';

/// The random sounds tab.
class MapLevelSchemaRandomSoundsTab extends ConsumerStatefulWidget {
  /// Create an instance.
  const MapLevelSchemaRandomSoundsTab({
    required this.id,
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// Create state for this widget.
  @override
  MapLevelSchemaRandomSoundsTabState createState() =>
      MapLevelSchemaRandomSoundsTabState();
}

/// State for [MapLevelSchemaRandomSoundsTab].
class MapLevelSchemaRandomSoundsTabState
    extends ConsumerState<MapLevelSchemaRandomSoundsTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final random = ref.watch(randomProvider);
    final projectContext = ref.watch(projectContextProvider);
    final level = ref.watch(mapLevelSchemaProvider.call(widget.id));
    final randomSounds = level.randomSounds;
    final Widget child;
    if (randomSounds.isEmpty) {
      child = const CenterText(
        text: 'There are no random sounds to show.',
        autofocus: true,
      );
    } else {
      child = BuiltSearchableListView(
        items: randomSounds,
        builder: (final context, final index) {
          final randomSound = randomSounds[index];
          final maxGain = random.nextDouble() * randomSound.maxGain;
          return SearchableListTile(
            searchString: randomSound.sound,
            child: PlaySoundSemantics(
              directory: projectContext.randomSoundsDirectory,
              sound: randomSound.sound,
              gain: randomSound.minGain + maxGain,
              child: Builder(
                builder: (final context) => CallbackShortcuts(
                  bindings: {
                    deleteShortcut: () {
                      PlaySoundSemantics.of(context)?.stop();
                      confirm(
                        context: context,
                        message: 'Are you sure you want to delete this random '
                            'sound?',
                        title: confirmDeleteTitle,
                        yesCallback: () {
                          Navigator.pop(context);
                          level.randomSounds.removeWhere(
                            (final element) => element.id == randomSound.id,
                          );
                          saveLevel(ref: ref, id: widget.id);
                        },
                      );
                    }
                  },
                  child: Builder(
                    builder: (final context) => PushWidgetListTile(
                      title: randomSound.sound,
                      builder: (final builderContext) {
                        PlaySoundSemantics.of(context)?.stop();
                        return EditMapLevelSchemaRandomSound(
                          argument: MapLevelSchemaArgument(
                            mapLevelId: widget.id,
                            valueId: randomSound.id,
                          ),
                        );
                      },
                      autofocus: index == 0,
                      subtitle: '${randomSound.minInterval} ms -- '
                          '${randomSound.maxInterval} ms',
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
              projectContext.getClipboard<MapLevelSchemaRandomSound>(ref: ref);
          if (value != null) {
            final json = jsonDecode(jsonEncode(value)) as JsonType;
            json['id'] = newId();
            final randomSound = MapLevelSchemaRandomSound.fromJson(json);
            level.randomSounds.add(randomSound);
            projectContext.saveLevel(level);
            setState(() {});
          }
        }
      },
      child: child,
    );
  }
}
