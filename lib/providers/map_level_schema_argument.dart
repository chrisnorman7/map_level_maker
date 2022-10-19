/// A class which allows specifying two ID's.
class MapLevelSchemaArgument {
  /// Create an instance.
  const MapLevelSchemaArgument({
    required this.mapLevelId,
    required this.valueId,
  });

  /// The ID of the map level to use.
  final String mapLevelId;

  /// The ID of the thing to request.
  final String valueId;
}
