import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';
import 'providers/map_level_schema_context.dart';
import 'src/json/project.dart';

/// Provide the maps which form this project.
///
/// If no maps exist, they will be created.
///
/// If the sounds directories don't exist, they will be created.
final projectProvider = Provider((final ref) {
  final Project project;
  if (projectFile.existsSync()) {
    final data = projectFile.readAsStringSync();
    final json = jsonDecode(data) as JsonType;
    project = Project.fromJson(json);
  } else {
    // ignore: prefer_const_constructors
    project = Project(mapLevels: []);
  }
  for (final directory in [
    soundsDirectory,
    footstepsDirectory,
    wallsDirectory,
    musicDirectory,
    ambiancesDirectory
  ]) {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }
  return project;
});

/// Provide a single map level schema.
final mapLevelSchemaProvider = Provider.family<MapLevelSchemaContext, String>(
  (final ref, final id) {
    final project = ref.watch(projectProvider);
    final map =
        project.mapLevels.firstWhere((final element) => element.id == id);
    return MapLevelSchemaContext(project: project, mapLevelSchema: map);
  },
);
