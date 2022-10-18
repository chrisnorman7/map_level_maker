import 'dart:convert';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../src/json/map_level_feature_schema.dart';
import '../src/json/map_level_schema.dart';
import '../src/json/project.dart';
import 'map_level_schema_argument.dart';
import 'schema_context.dart';

/// Provide an sdl instance.
final sdlProvider = Provider((final ref) => Sdl());

/// Provides a synthizer instance.
final synthizerProvider = Provider((final ref) => Synthizer());

/// Provide a synthizer context.
final synthizerContextProvider = Provider((final ref) {
  final synthizer = ref.watch(synthizerProvider);
  return synthizer.createContext();
});

/// Provide a random number generator.
final randomProvider = Provider((final ref) => Random());

/// Provide a buffer cache.
final bufferCacheProvider = Provider(
  (final ref) {
    final synthizer = ref.watch(synthizerProvider);
    final random = ref.watch(randomProvider);
    return BufferCache(
      synthizer: synthizer,
      maxSize: 1.gb,
      random: random,
    );
  },
);

/// Provide a game.
final gameProvider = Provider(
  (final ref) => Game(
    title: 'Map Level Maker',
    sdl: ref.watch(sdlProvider),
    soundBackend: SynthizerSoundBackend(
      context: ref.watch(synthizerContextProvider),
      bufferCache: ref.watch(bufferCacheProvider),
    ),
  ),
);

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
final mapLevelSchemaProvider =
    Provider.family<SchemaContext<MapLevelSchema>, String>(
  (final ref, final id) {
    final project = ref.watch(projectProvider);
    final map =
        project.mapLevels.firstWhere((final element) => element.id == id);
    return SchemaContext(project: project, value: map);
  },
);

/// Provide a single feature.
final mapLevelFeatureSchemaProvider = Provider.family<
    SchemaContext<MapLevelFeatureSchema>, MapLevelSchemaArgument>(
  (final ref, final argument) {
    final mapLevelSchemaContext =
        ref.watch(mapLevelSchemaProvider.call(argument.mapLevelId));
    return SchemaContext(
      project: mapLevelSchemaContext.project,
      value: mapLevelSchemaContext.value.features
          .firstWhere((final element) => element.id == argument.valueId),
    );
  },
);
