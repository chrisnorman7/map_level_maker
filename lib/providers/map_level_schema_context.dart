import '../src/json/map_level_schema.dart';
import '../src/json/project.dart';

/// A context to hold a [project], and a [mapLevelSchema].
class MapLevelSchemaContext {
  /// Create an instance.
  const MapLevelSchemaContext({
    required this.project,
    required this.mapLevelSchema,
  });

  /// The project to use.
  final Project project;

  /// The map level to use.
  final MapLevelSchema mapLevelSchema;
}
