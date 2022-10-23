import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart';

import 'constants.dart';
import 'map_level_schema_to_code.dart';
import 'providers/project_context.dart';
import 'providers/providers.dart';
import 'src/json/map_level_schema.dart';

/// Generate a new ID.
String newId() => uuid.v4();

/// Write the given [level] to the appropriate Dart file.
void mapLevelSchemaToDart({
  required final ProjectContext projectContext,
  required final MapLevelSchema level,
}) {
  final template = jinja.fromString(
    mapLevelSchemaTemplate,
    path: level.jsonFilename,
  );
  for (final terrain in level.terrains) {
    terrain
      ..onActivateFunctionName =
          level.findFunction(terrain.onActivateFunctionId)?.name
      ..onEnterFunctionName =
          level.findFunction(terrain.onEnterFunctionId)?.name
      ..onExitFunctionName = level.findFunction(terrain.onExitFunctionId)?.name
      ..needsConst = terrain.onActivateFunctionName == null &&
          terrain.onEnterFunctionName == null &&
          terrain.onExitFunctionName == null;
  }
  projectContext.saveLevel(level);
  final json = level.toJson();
  final data = indentedJsonEncoder.convert(json);
  final map = jsonDecode(data) as JsonType;
  final source = template.render(map);
  final code = codeFormatter.format(source);
  projectContext.getLevelDartFile(level).writeAsStringSync(code);
}

/// Get an asset reference from the given [directory].
AssetReference getAssetReference({
  required final Directory directory,
  required final String sound,
}) {
  final f = File(path.join(directory.path, sound));
  final d = Directory(path.join(directory.path, sound));
  if (f.existsSync()) {
    return AssetReference.file(f.path);
  } else if (d.existsSync()) {
    return AssetReference.collection(d.path);
  } else {
    throw StateError('Cannot find "$sound" in ${directory.path}.');
  }
}

/// Get a [File] or [Directory] instance from the provided [path].
///
/// If none exist, throw [StateError].
FileSystemEntity getFileSystemEntity(final String path) {
  final d = Directory(path);
  if (d.existsSync()) {
    return d;
  }
  final f = File(path);
  if (f.existsSync()) {
    return f;
  }
  throw StateError('Not found: $path.');
}

/// Save the level with the given [id].
void saveLevel({
  required final WidgetRef ref,
  required final String id,
}) {
  final provider = mapLevelSchemaProvider.call(id);
  final level = ref.watch(provider);
  ref.watch(projectContextProvider).saveLevel(level);
  ref
    ..invalidate(provider)
    ..invalidate(mapsProvider);
}

/// Return a pretty-printed version of [singleActivator].
String singleActivatorToString(final SingleActivator singleActivator) {
  final keys = <String>[];
  if (singleActivator.control) {
    keys.add('CTRL');
  }
  if (singleActivator.alt) {
    keys.add('ALT');
  }
  if (singleActivator.meta) {
    keys.add('META');
  }
  if (singleActivator.shift) {
    keys.add('SHIFT');
  }
  keys.add(singleActivator.trigger.keyLabel);
  return keys.join('+');
}
