import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

/// A widget for selecting a new [value] from a [directory].
class SelectDirectory extends StatelessWidget {
  /// Create an instance.
  const SelectDirectory({
    required this.directory,
    required this.onChanged,
    this.value,
    super.key,
  });

  /// The directory to select a new [value] from.
  final Directory directory;

  /// The current value.
  final Directory? value;

  /// The function to call when [value] changes.
  final ValueChanged<Directory> onChanged;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectItem<Directory>(
        values: directory.listSync().whereType<Directory>().toList(),
        onDone: onChanged,
        getSearchString: (final value) => path.basename(value.path),
        getWidget: (final value) => Text(path.basename(value.path)),
      );
}
