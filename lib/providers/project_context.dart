import 'dart:io';

import 'package:path/path.dart' as path;

/// A class to hold context about a project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.directory,
  });

  /// The directory where the project files reside.
  ///
  /// This should be the same directory as your pubspec.yaml file.
  final Directory directory;

  /// The name of this project.
  String get name => path.basename(directory.path);

  /// The directory where map files will be stored.
  ///
  /// This directory will contain both JSON and class files.
  Directory get mapsDirectory => Directory(
        path.join(directory.path, 'lib/src/maps'),
      );

  /// The location where sounds are stored.
  Directory get soundsDirectory =>
      Directory(path.join(directory.path, 'sounds'));

  /// The directory where footsteps are stored.
  Directory get footstepsDirectory => Directory(
        path.join(soundsDirectory.path, 'footsteps'),
      );

  /// The directory where wall sounds are stored.
  Directory get wallsDirectory =>
      Directory(path.join(soundsDirectory.path, 'walls'));

  /// The directory where music is stored.
  Directory get musicDirectory =>
      Directory(path.join(soundsDirectory.path, 'music'));

  /// The directory where ambiances are stored.
  Directory get ambiancesDirectory =>
      Directory(path.join(soundsDirectory.path, 'amb'));

  /// The directory where earcons are stored.
  Directory get earconsDirectory =>
      Directory(path.join(soundsDirectory.path, 'earcons'));

  /// The directory where descriptions are stored.
  Directory get descriptionsDirectory =>
      Directory(path.join(soundsDirectory.path, 'descriptions'));
}
