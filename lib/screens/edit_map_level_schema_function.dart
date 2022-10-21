import 'package:backstreets_widgets/screens/simple_scaffold.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/map_level_schema_argument.dart';
import '../providers/providers.dart';
import '../validators.dart';

/// A widget for editing a map level schema function.
class EditMapLevelSchemaFunction extends ConsumerWidget {
  /// Create an instance.
  const EditMapLevelSchemaFunction({
    required this.argument,
    super.key,
  });

  /// The argument to use.
  final MapLevelSchemaArgument argument;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final function =
        ref.watch(mapLevelSchemaFunctionProvider.call(argument)).value;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Function',
        body: ListView(
          children: [
            TextListTile(
              value: function.name,
              onChanged: (final value) {
                function.name = value;
                save(ref: ref);
              },
              header: 'Name',
              autofocus: true,
              validator: (final value) => validateFunctionName(value: value),
            ),
            TextListTile(
              value: function.comment,
              onChanged: (final value) {
                function.comment = value;
                save(ref: ref);
              },
              header: 'Comment',
              title: 'Comment',
              validator: (final value) => validateNonEmptyValue(value: value),
            )
          ],
        ),
      ),
    );
  }

  /// Save the level.
  void save({
    required final WidgetRef ref,
  }) {
    final provider = mapLevelSchemaProvider.call(argument.mapLevelId);
    final level = ref.watch(provider);
    ref.watch(projectContextProvider).saveLevel(level);
    ref
      ..invalidate(provider)
      ..invalidate(mapLevelSchemaFunctionProvider.call(argument));
  }
}
