import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../src/json/map_level_feature_schema.dart';
import '../src/json/map_level_schema.dart';
import 'map_level_schema_argument.dart';
import 'map_level_schema_context.dart';

/// Provide an sdl instance.
final sdlProvider = Provider((final ref) => Sdl());

/// Provides a synthizer instance.
final synthizerProvider = Provider((final ref) => Synthizer()..initialize());

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
  (final ref) {
    final sdl = ref.watch(sdlProvider);
    print(sdl);
    final synthizerContext = ref.watch(synthizerContextProvider);
    print(synthizerContext);
    final bufferCache = ref.watch(bufferCacheProvider);
    print(bufferCache);
    return Game(
      title: 'Map Level Maker',
      sdl: sdl,
      soundBackend: SynthizerSoundBackend(
        context: synthizerContext,
        bufferCache: bufferCache,
      ),
    );
  },
);

/// Provide the maps which form this project.
///
/// If any of the various directories don't exist, they will be created.
final mapsProvider = Provider((final ref) {
  for (final directory in [
    mapsDirectory,
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
  return mapsDirectory
      .listSync()
      .whereType<File>()
      .where((final element) => path.extension(element.path) == '.json')
      .map<MapLevelSchema>((final file) {
    final data = file.readAsStringSync();
    final json = jsonDecode(data) as JsonType;
    return MapLevelSchema.fromJson(json);
  });
});

/// Provide a single map level schema.
final mapLevelSchemaProvider = Provider.family<MapLevelSchema, String>(
  (final ref, final id) {
    final maps = ref.watch(mapsProvider);
    return maps.firstWhere((final element) => element.id == id);
  },
);

/// Provide a single feature.
final mapLevelFeatureSchemaProvider = Provider.family<
    MapLevelSchemaContext<MapLevelFeatureSchema>, MapLevelSchemaArgument>(
  (final ref, final argument) {
    final level = ref.watch(
      mapLevelSchemaProvider.call(argument.mapLevelId),
    );
    return MapLevelSchemaContext(
      level: level,
      value: level.features
          .firstWhere((final element) => element.id == argument.valueId),
    );
  },
);
