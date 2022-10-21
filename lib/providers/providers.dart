import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../src/json/map_level_schema.dart';
import '../src/json/map_level_schema_ambiance.dart';
import '../src/json/map_level_schema_feature.dart';
import '../src/json/map_level_schema_function.dart';
import '../src/json/map_level_schema_item.dart';
import 'map_level_schema_argument.dart';
import 'map_level_schema_context.dart';
import 'project_context.dart';
import 'project_context_notifier.dart';

/// Provide a shared preferences instance.
final sharedPreferencesProvider = FutureProvider(
  (final ref) => SharedPreferences.getInstance(),
);

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
    final synthizerContext = ref.watch(synthizerContextProvider);
    final bufferCache = ref.watch(bufferCacheProvider);
    return Game(
      title: 'Map Level Maker',
      sdl: sdl,
      soundBackend: SynthizerSoundBackend(
        context: synthizerContext,
        bufferCache: bufferCache,
      ),
    )..defaultPannerStrategy = DefaultPannerStrategy.hrtf;
  },
);

/// Provide the maps which form this project.
///
/// If any of the various directories don't exist, they will be created.
final mapsProvider = Provider((final ref) {
  final projectContext = ref.watch(projectContextProvider);
  for (final directory in [
    projectContext.mapsDirectory,
    projectContext.soundsDirectory,
    projectContext.footstepsDirectory,
    projectContext.wallsDirectory,
    projectContext.musicDirectory,
    projectContext.ambiancesDirectory,
    projectContext.earconsDirectory,
    projectContext.descriptionsDirectory,
  ]) {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }
  return projectContext.mapsDirectory
      .listSync()
      .whereType<File>()
      .where((final element) => path.extension(element.path) == '.json')
      .map<MapLevelSchema>((final file) {
    final data = file.readAsStringSync();
    final json = jsonDecode(data) as JsonType;
    return MapLevelSchema.fromJson(json);
  }).toList();
});

/// Provide a single map level schema.
final mapLevelSchemaProvider = Provider.family<MapLevelSchema, String>(
  (final ref, final id) {
    final maps = ref.watch(mapsProvider);
    return maps.firstWhere((final element) => element.id == id);
  },
);

/// Provide a single feature.
final mapLevelSchemaFeatureProvider = Provider.family<
    MapLevelSchemaContext<MapLevelSchemaFeature>, MapLevelSchemaArgument>(
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

/// Provide a single function.
final mapLevelSchemaFunctionProvider = Provider.family<
    MapLevelSchemaContext<MapLevelSchemaFunction>, MapLevelSchemaArgument>(
  (final ref, final arg) {
    final level = ref.watch(mapLevelSchemaProvider.call(arg.mapLevelId));
    return MapLevelSchemaContext(
      level: level,
      value: level.functions
          .firstWhere((final element) => element.id == arg.valueId),
    );
  },
);

/// Provide a single item.
final mapLevelSchemaItemProvider = Provider.family<
    MapLevelSchemaContext<MapLevelSchemaItem>, MapLevelSchemaArgument>(
  (final ref, final arg) {
    final level = ref.watch(mapLevelSchemaProvider.call(arg.mapLevelId));
    final item =
        level.items.firstWhere((final element) => element.id == arg.valueId);
    return MapLevelSchemaContext(level: level, value: item);
  },
);

/// Provide a single ambiance.
final mapLevelSchemaAmbianceProvider = Provider.family<
    MapLevelSchemaContext<MapLevelSchemaAmbiance>, MapLevelSchemaArgument>(
  (final ref, final arg) {
    final level = ref.watch(mapLevelSchemaProvider.call(arg.mapLevelId));
    final ambiance = level.ambiances
        .firstWhere((final element) => element.id == arg.valueId);
    return MapLevelSchemaContext(level: level, value: ambiance);
  },
);

/// Possibly provide a project context.
///
/// If you want a context that is never `null`, consider using the
/// [projectContextProvider].
final projectContextStateNotifier =
    StateNotifierProvider<ProjectContextNotifier, ProjectContext?>(
  (final ref) => ProjectContextNotifier(),
);

/// Provide a project context.
///
/// If no project has been loaded, [StateError] will be thrown.
final projectContextProvider = Provider<ProjectContext>((final ref) {
  final project = ref.watch(projectContextStateNotifier);
  if (project == null) {
    throw StateError('No project has yet been loaded.');
  }
  return project;
});
