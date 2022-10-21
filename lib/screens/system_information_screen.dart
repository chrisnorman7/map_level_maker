import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// A screen to show system information from the [Platform] object.
class SystemInformationScreen extends ConsumerWidget {
  /// Create an instance.
  const SystemInformationScreen({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextStateNotifier);
    return Cancel(
      child: SimpleScaffold(
        title: 'System Information',
        body: ListView(
          children: [
            CopyListTile(
              title: 'Dart Version',
              subtitle: Platform.version,
              autofocus: true,
            ),
            CopyListTile(title: 'Executable', subtitle: Platform.executable),
            CopyListTile(
              title: 'OS Name',
              subtitle: Platform.operatingSystem,
            ),
            CopyListTile(
              title: 'OS Version',
              subtitle: Platform.operatingSystemVersion,
            ),
            CopyListTile(
              title: 'Resolved Executable',
              subtitle: Platform.resolvedExecutable,
            ),
            CopyListTile(
              title: 'Number of Processors',
              subtitle: Platform.numberOfProcessors.toString(),
            ),
            CopyListTile(
              title: 'Script Path',
              subtitle: Platform.script.toFilePath(
                windows: Platform.isWindows,
              ),
            ),
            if (projectContext != null) ...[
              CopyListTile(
                title: 'LoadedProject',
                subtitle: projectContext.name,
              ),
              CopyListTile(
                title: 'Maps Directory',
                subtitle: projectContext.mapsDirectory.path,
              ),
              CopyListTile(
                title: 'Sounds Directory',
                subtitle: projectContext.soundsDirectory.path,
              )
            ]
          ],
        ),
      ),
    );
  }
}
