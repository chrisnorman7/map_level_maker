import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../screens/select_directory.dart';
import '../screens/select_sound.dart';
import '../util.dart';
import 'play_sound_semantics.dart';

/// A widget to select a sound and directory.
class FullSoundListTile extends StatelessWidget {
  /// Create an instance.
  const FullSoundListTile({
    required this.value,
    required this.onChanged,
    this.autofocus = false,
    this.title = 'Sound',
    super.key,
  });

  /// The current sound.
  final FileSystemEntity? value;

  /// The function to call when [value] changes.
  final ValueChanged<FileSystemEntity?> onChanged;

  /// The title for this list tile.
  final String title;

  /// Whether or not the list tile should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final currentValue = value;
    return PlaySoundSemantics(
      directory: currentValue?.parent ?? soundsDirectory,
      sound: currentValue == null ? null : path.basename(currentValue.path),
      child: PushWidgetListTile(
        title: title,
        builder: (final context) {
          final currentValue = value;
          if (currentValue == null) {
            return SelectDirectory(
              directory: soundsDirectory,
              onChanged: (final directory) => pushWidget(
                context: context,
                builder: (final context) => SelectSound(
                  directory: directory,
                  onDone: (final soundPath) {
                    final newValue = path.relative(
                      path.join(directory.path, soundPath),
                      from: soundsDirectory.path,
                    );
                    onChanged(
                      getFileSystemEntity(
                        path.join(soundsDirectory.path, newValue),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.backspace): () {
                  Navigator.of(context).pop();
                  pushWidget(
                    context: context,
                    builder: (final context) => SelectDirectory(
                      directory: soundsDirectory,
                      onChanged: (final directory) => pushWidget(
                        context: context,
                        builder: (final context) => SelectSound(
                          directory: directory,
                          onDone: (final soundPath) {
                            final newValue = path.relative(
                              path.join(directory.path, soundPath),
                              from: soundsDirectory.path,
                            );
                            onChanged(
                              getFileSystemEntity(
                                path.join(soundsDirectory.path, newValue),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
              child: SelectSound(
                directory: currentValue.parent,
                onDone: (final soundPath) {
                  if (soundPath == null) {
                    onChanged(null);
                  } else {
                    final newValue = path.relative(
                      path.join(currentValue.parent.path, soundPath),
                      from: soundsDirectory.path,
                    );
                    onChanged(getFileSystemEntity(newValue));
                  }
                },
                currentSound: path.basename(currentValue.path),
              ),
            );
          }
        },
        autofocus: autofocus,
        subtitle: currentValue == null
            ? unsetMessage
            : path.relative(currentValue.path, from: soundsDirectory.path),
      ),
    );
  }
}
