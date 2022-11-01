import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../util.dart';
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
    final value = currentSound;
    final sounds = directory.listSync();
    AssetReference? assetReference;
    FileSystemEntity? currentValue;
    try {
      assetReference = value == null
          ? null
          : getAssetReference(directory: directory, sound: value);
      currentValue = value == null || assetReference == null
          ? null
          : sounds.firstWhere(
              (final element) => path.basename(element.path) == currentSound,
            );
      // ignore: avoid_catching_errors
    } on StateError {
      assetReference = null;
      currentValue = null;
    }
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
