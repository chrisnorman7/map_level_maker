import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart';

import 'constants.dart';
import 'map_level_schema_to_code.dart';
import 'src/json/map_level_schema.dart';

/// Generate a new ID.
String newId() => uuid.v4();

/// Write the given [level] to the appropriate Dart file.
void mapLevelSchemaToDart(final MapLevelSchema level) {
  final template = jinja.fromString(
    mapLevelSchemaTemplate,
    path: level.jsonFilename,
  );
  for (final feature in level.features) {
    feature.onActivateFunctionName =
        level.findFunction(feature.onActivateFunctionId)?.name;
  }
  final json = level.toJson();
  final data = indentedJsonEncoder.convert(json);
  final map = jsonDecode(data) as JsonType;
  final source = template.render(map);
  final code = codeFormatter.format(source);
  level.dartFile.writeAsStringSync(code);
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
