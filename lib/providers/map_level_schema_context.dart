import '../src/json/map_level_schema.dart';

/// Holds a [level] and a [value].
class MapLevelSchemaContext<T> {
  /// Create an instance.
  const MapLevelSchemaContext({
    required this.level,
    required this.value,
  });

  /// The level to use.
  final MapLevelSchema level;

  /// The value to use.
  final T value;
}
