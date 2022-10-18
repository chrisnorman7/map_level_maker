import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';

part 'map_level_schema.g.dart';

/// A schema which can be used to generate map level classes.
@JsonSerializable()
class MapLevelSchema {
  /// Create an instance.
  MapLevelSchema({
    this.name = 'Untitled Map',
    this.maxX = 100,
    this.maxY = 100,
    final String? id,
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory MapLevelSchema.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaFromJson(json);

  /// The ID of this map.
  final String id;

  /// The name of this map.
  String name;

  /// The max x + 1 of this map.
  int maxX;

  /// The max y + 1 of this map.
  int maxY;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaToJson(this);
}
