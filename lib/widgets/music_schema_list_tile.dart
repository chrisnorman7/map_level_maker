import 'dart:io';
import 'dart:math';

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../screens/select_sound.dart';
import '../src/json/music_schema.dart';
import 'play_sound_semantics.dart';

/// A widget for editing the given [music].
class MusicSchemaListTile extends StatelessWidget {
  /// Create an instance.
  const MusicSchemaListTile({
    required this.music,
    required this.onChanged,
    this.directory,
    this.title = 'Music',
    this.nullable = true,
    this.autofocus = false,
    this.gainAdjust = 0.05,
    super.key,
  });

  /// The music to edit.
  final MusicSchema? music;

  /// The function to call when the [music] changes.
  final ValueChanged<MusicSchema?> onChanged;

  /// The directory where music files are stored.
  final Directory? directory;

  /// The title of the list tile.
  final String title;

  /// Whether or not the music is nullable.
  final bool nullable;

  /// Whether or not the list tile should be autofocused.
  final bool autofocus;

  /// How much to adjust the gain by with shortcuts.
  final double gainAdjust;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final d = directory ?? musicDirectory;
    final schema = music;
    if (schema == null) {
      return PushWidgetListTile(
        title: title,
        builder: (final context) => SelectSound(
          directory: d,
          onDone: (final value) {
            if (value == null) {
              onChanged(null);
            } else {
              onChanged(MusicSchema(sound: value));
            }
          },
          nullable: nullable,
        ),
        autofocus: autofocus,
        subtitle: unsetMessage,
      );
    }
    final subtitle =
        path.basenameWithoutExtension(schema.sound).replaceAll('_', ' ');
    return CallbackShortcuts(
      bindings: {
        moveUpShortcut: () {
          final i = min(500, (schema.gain * 100).round() + (gainAdjust * 100));
          onChanged(MusicSchema(sound: schema.sound, gain: i / 100));
        },
        moveDownShortcut: () {
          final adjust = gainAdjust * 100;
          final i = max(
            adjust,
            (schema.gain * 100).round() - adjust,
          );
          onChanged(MusicSchema(sound: schema.sound, gain: i / 100));
        }
      },
      child: PlaySoundSemantics(
        sound: schema.sound,
        directory: d,
        gain: schema.gain,
        looping: true,
        child: Builder(
          builder: (final builderContext) => PushWidgetListTile(
            title: title,
            builder: (final context) {
              PlaySoundSemantics.of(builderContext)?.stop();
              return SelectSound(
                directory: d,
                onDone: (final value) {
                  if (value == null) {
                    onChanged(null);
                  } else {
                    onChanged(
                      MusicSchema(sound: value, gain: schema.gain),
                    );
                  }
                },
                currentSound: schema.sound,
                nullable: nullable,
              );
            },
            autofocus: autofocus,
            subtitle: '$subtitle (${schema.gain})',
          ),
        ),
      ),
    );
  }
}
