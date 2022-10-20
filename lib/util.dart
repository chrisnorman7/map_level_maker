import 'dart:convert';

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
