import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/select_function.dart';
import '../src/json/map_level_schema_function.dart';

/// A widget for displaying the given [function].
class FunctionListTile extends StatelessWidget {
  /// Create an instance.
  const FunctionListTile({
    required this.functions,
    required this.function,
    required this.onChanged,
    this.autofocus = false,
    this.title = 'Function',
    super.key,
  });

  /// The functions to choose from.
  final List<MapLevelSchemaFunction?> functions;

  /// The current function.
  final MapLevelSchemaFunction? function;

  /// The function to call when [function] changes.
  final ValueChanged<MapLevelSchemaFunction?> onChanged;

  /// Whether this list should be autofocused.
  final bool autofocus;

  /// The title of this list tile.
  final String title;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final value = function;
    return PushWidgetListTile(
      title: title,
      builder: (final context) => SelectFunction(
        functions: functions,
        function: function,
        onChanged: onChanged,
      ),
      autofocus: autofocus,
      subtitle:
          value == null ? unsetMessage : '${value.name}: ${value.comment}',
    );
  }
}
