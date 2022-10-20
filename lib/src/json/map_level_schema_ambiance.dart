import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';
import 'music_schema.dart';

part 'map_level_schema_ambiance.g.dart';

/// An ambiance in a map level.
@JsonSerializable()
class MapLevelSchemaAmbiance {
  /// Create an instance.
  MapLevelSchemaAmbiance({
    required this.sound,
    this.x,
    this.y,
    final String? id,
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory MapLevelSchemaAmbiance.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaAmbianceFromJson(json);

  /// The ID of this ambiance.
  final String id;

  /// The sound which will play for this ambiance.
  MusicSchema sound;

  /// The x coordinate.
  double? x;

  /// The y coordinate.
  double? y;

  /// The coordinates of this ambiance.
  @JsonKey(ignore: true)
  Point<double>? get coordinates {
    final cX = x;
    final cY = y;
    if (cX == null || cY == null) {
      return null;
    }
    return Point(cX, cY);
  }

  /// Set the coordinates.
  set coordinates(final Point<double>? value) {
    if (value == null) {
      x = null;
      y = null;
    } else {
      x = value.x;
      y = value.y;
    }
  }

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaAmbianceToJson(this);
}
