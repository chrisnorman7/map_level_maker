import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../widgets/play_sound_semantics.dart';

/// A project to select a sound.
class SelectSound extends StatelessWidget {
  /// Create an instance.
  const SelectSound({
    required this.directory,
    required this.onDone,
    this.currentSound,
    this.nullable = true,
    super.key,
  });

  /// The directory to select a sound from.
  final Directory directory;

  /// The function to call with the new value.
  final ValueChanged<String?> onDone;

  /// The current sound.
  final String? currentSound;

  /// Whether the resulting sound can be `null`.
  final bool nullable;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final sounds = directory.listSync();
    final currentValue = currentSound == null
        ? null
        : sounds.firstWhere(
            (final element) => path.basename(element.path) == currentSound,
          );
    return SelectItem(
      values: [if (nullable) null, ...sounds],
      onDone: (final value) => onDone(
        value == null ? null : path.basename(value.path),
      ),
      getSearchString: (final value) => value == null
          ? clearMessage
          : path.basenameWithoutExtension(value.path),
      getWidget: (final value) => value == null
          ? const Text(clearMessage)
          : PlaySoundSemantics(
              directory: directory,
              sound: path.basename(value.path),
              child: Text(path.basenameWithoutExtension(value.path)),
            ),
      title: 'Select Sound',
      value: currentValue,
    );
  }
}
