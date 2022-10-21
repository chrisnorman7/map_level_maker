import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziggurat/sound.dart';

import '../constants.dart';
import '../providers/providers.dart';
import '../screens/edit_reverb_preset_reference.dart';

/// A widget for showing the reverb of the level with the given [id].
class ReverbListTile extends ConsumerWidget {
  /// Create an instance.
  const ReverbListTile({
    required this.id,
    this.autofocus = false,
    this.title = 'Reverb',
    super.key,
  });

  /// The ID of the level to use.
  final String id;

  /// The title of the widget.
  final String title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final level = ref.watch(mapLevelSchemaProvider.call(id));
    final reverbPreset = level.reverbPreset;
    if (reverbPreset == null) {
      return ListTile(
        autofocus: autofocus,
        title: Text(title),
        subtitle: const Text(unsetMessage),
        onTap: () {
          level.reverbPreset = ReverbPreset(name: level.name);
          save(ref);
        },
      );
    }
    return CallbackShortcuts(
      bindings: {
        deleteShortcut: () => confirm(
              context: context,
              message: 'Are you sure you want to clear the reverb?',
              title: confirmDeleteTitle,
              yesCallback: () {
                Navigator.pop(context);
                level.reverbPreset = null;
                save(ref);
              },
            )
      },
      child: PushWidgetListTile(
        title: title,
        builder: (final context) => EditReverbPresetReference(
          game: ref.watch(gameProvider),
          level: level,
        ),
        autofocus: autofocus,
        subtitle: 'Set',
      ),
    );
  }

  /// Save the level.
  void save(final WidgetRef ref) {
    ref.watch(mapLevelSchemaProvider.call(id)).save();
    ref.refresh(mapLevelSchemaProvider.call(id));
  }
}
