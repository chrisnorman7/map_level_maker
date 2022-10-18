import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

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
    return SelectItem(
      values: sounds,
      onDone: (final value) =>
          onDone(path.basenameWithoutExtension(value.path)),
    );
  }
}
