import 'dart:io';

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../screens/select_sound.dart';
import '../util.dart';
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
    AssetReference? assetReference;
    try {
      assetReference = value == null
          ? null
          : getAssetReference(directory: directory, sound: value);
      // ignore: avoid_catching_errors
    } on StateError {
      assetReference = null;
    }
    final String subtitle;
    if (value == null) {
      subtitle = unsetMessage;
    } else if (assetReference == null) {
      subtitle = '!! INVALID SOUND !!';
    } else {
      subtitle = path.basename(value);
    }
    return CallbackShortcuts(
      bindings: {
        SingleActivator(
          LogicalKeyboardKey.keyC,
          control: useControlKey,
          meta: useMetaKey,
        ): () => setClipboardText(path.join(directory.path, value))
      },
      child: PlaySoundSemantics(
        directory: directory,
        sound: assetReference == null ? null : value,
        gain: gain,
        looping: looping,
        child: Builder(
          builder: (final builderContext) => PushWidgetListTile(
            title: title,
            builder: (final context) {
              PlaySoundSemantics.of(builderContext)?.stop();
              return SelectSound(
                directory: directory,
                onDone: onChanged,
                currentSound: sound,
                nullable: nullable,
              );
            },
            autofocus: autofocus,
            subtitle: subtitle,
          ),
        ),
      ),
    );
  }
}
