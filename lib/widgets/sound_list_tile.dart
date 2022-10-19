import 'dart:io';

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../screens/select_sound.dart';
import 'play_sound_semantics.dart';

/// A widget to edit the given [sound].
class SoundListTile extends StatelessWidget {
  /// Create an instance.
  const SoundListTile({
    required this.directory,
    required this.sound,
    required this.onChanged,
    this.title = 'Sound',
    this.gain = 0.7,
    this.looping = false,
    this.nullable = true,
    this.autofocus = false,
    super.key,
  });

  /// The directory where the sound will be stored.
  final Directory directory;

  /// The current sound.
  final String? sound;

  /// The function to call when the [sound] changes.
  final ValueChanged<String?> onChanged;

  /// The title of this list tile.
  final String title;

  /// The gain of this sound.
  final double gain;

  /// Whether or not the resulting sound should loop.
  final bool looping;

  /// Whether or not this sound can be set to `null`.
  final bool nullable;

  /// Whether or not the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final value = sound;
    return CallbackShortcuts(
      bindings: {
        SingleActivator(
          LogicalKeyboardKey.keyC,
          control: useControlKey,
          meta: useMetaKey,
        ): () => setClipboardText(path.join(directory.path, sound))
      },
      child: PlaySoundSemantics(
        directory: directory,
        sound: value,
        gain: gain,
        looping: looping,
        child: PushWidgetListTile(
          title: title,
          builder: (final context) => SelectSound(
            directory: directory,
            onDone: onChanged,
            currentSound: value,
            nullable: nullable,
          ),
          subtitle: value == null
              ? unsetMessage
              : path.basenameWithoutExtension(value).replaceAll('_', ' '),
        ),
      ),
    );
  }
}