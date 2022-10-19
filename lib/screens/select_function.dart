import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../src/json/map_level_schema_function.dart';

/// Allow the selection of a new [function].
class SelectFunction extends StatelessWidget {
  /// Create an instance.
  const SelectFunction({
    required this.functions,
    required this.function,
    required this.onChanged,
    super.key,
  });

  /// The functions to select from.
  final List<MapLevelSchemaFunction?> functions;

  /// The function to call with the new value.
  final ValueChanged<MapLevelSchemaFunction?> onChanged;

  /// The current function.
  final MapLevelSchemaFunction? function;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectItem(
        values: functions,
        onDone: onChanged,
        getSearchString: (final value) =>
            value == null ? clearMessage : value.name,
        getWidget: (final value) => Text(
          value == null ? clearMessage : '${value.name}: ${value.comment}',
        ),
        title: 'Select Function',
        value: function,
      );
}
