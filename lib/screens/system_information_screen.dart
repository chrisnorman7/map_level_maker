import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

/// A screen to show system information from the [Platform] object.
class SystemInformationScreen extends StatelessWidget {
  /// Create an instance.
  const SystemInformationScreen({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Cancel(
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
                subtitle:
                    Platform.script.toFilePath(windows: Platform.isWindows),
              ),
            ],
          ),
        ),
      );
}
