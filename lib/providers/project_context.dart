import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../src/json/map_level_schema.dart';
import 'providers.dart';

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

  /// The directory where random sounds are stored.
  Directory get randomSoundsDirectory =>
      Directory(path.join(soundsDirectory.path, 'random_sounds'));

  /// Get the Dart file for the given [level].
  File getLevelDartFile(final MapLevelSchema level) =>
      File(path.join(mapsDirectory.path, level.dartFilename));

  /// Get the JSON file for the given [level].
  File getLevelJsonFile(final MapLevelSchema level) =>
      File(path.join(mapsDirectory.path, level.jsonFilename));

  /// Save the given [level].
  void saveLevel(final MapLevelSchema level) {
    final json = level.toJson();
    final data = indentedJsonEncoder.convert(json);
    getLevelJsonFile(level).writeAsStringSync(data);
  }

  /// Set the clipboard data according to the given [value].
  void setClipboard({
    required final WidgetRef ref,
    required final dynamic value,
  }) {
    final clipboard = ref.watch(clipboardProvider);
    clipboard[value.runtimeType] = value;
  }

  /// Get a clipboard value according to [T].
  T? getClipboard<T>({
    required final WidgetRef ref,
    final T? defaultValue,
  }) {
    final clipboard = ref.watch(clipboardProvider);
    return (clipboard[T] as T?) ?? defaultValue;
  }
}
