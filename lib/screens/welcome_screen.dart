import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../providers/project_context.dart';
import '../providers/providers.dart';
import '../util.dart';
import 'home_page.dart';

/// The shortcut key for opening an existing project.
final openProjectShortcut = SingleActivator(
  LogicalKeyboardKey.keyO,
  control: useControlKey,
  meta: useMetaKey,
);

/// The screen to show when the app first loads.
class WelcomeScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const WelcomeScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

/// State for [WelcomeScreen].
class WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(sharedPreferencesProvider);
    return CallbackShortcuts(
      bindings: {openProjectShortcut: openProject},
      child: provider.when(
        data: getBody,
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body of the widget.
  Widget getBody(final SharedPreferences sharedPreferences) {
    final directories =
        (sharedPreferences.getStringList(recentDirectoriesKey) ?? [])
            .map<Directory>(
              Directory.new,
            )
            .where((final element) => element.existsSync())
            .toList();
    final tiles = [
      ListTile(
        autofocus: directories.isEmpty,
        title: const Text('Open Project'),
        subtitle: Text(singleActivatorToString(openProjectShortcut)),
        onTap: openProject,
      )
    ];
    return SimpleScaffold(
      title: 'Projects',
      body: ListView.builder(
        itemBuilder: (final context, final index) {
          if (index < tiles.length) {
            return tiles[index];
          }
          final directory = directories[index - tiles.length];
          return ListTile(
            autofocus: index == tiles.length,
            title: Text(path.basename(directory.path)),
            subtitle: Text(directory.path),
            onTap: () => loadProject(directory),
          );
        },
        itemCount: tiles.length + directories.length,
      ),
    );
  }

  /// Open a project.
  Future<void> openProject() async {
    final directoryName = await FilePicker.platform
        .getDirectoryPath(dialogTitle: 'Open Project Directory');
    if (directoryName == null) {
      return;
    }
    return loadProject(Directory(directoryName));
  }

  /// Load a project.
  Future<void> loadProject(final Directory directory) async {
    final projectContext = ProjectContext(directory: directory);
    ref.watch(projectContextStateNotifier.notifier).projectContext =
        projectContext;
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final recentDirectories = {directory.path}
      ..addAll(prefs.getStringList(recentDirectoriesKey) ?? []);
    final l = recentDirectories.toList(growable: true);
    while (l.length > 20) {
      l.removeLast();
    }
    await prefs.setStringList(recentDirectoriesKey, l);
    await pushWidget(
      context: context,
      builder: (final context) => const HomePage(),
    );
    setState(() {
      ref.read(projectContextStateNotifier.notifier).projectContext = null;
    });
  }
}
