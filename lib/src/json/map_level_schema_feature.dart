import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';

part 'map_level_schema_feature.g.dart';

/// A feature in a map level schema.
@JsonSerializable()
class MapLevelSchemaFeature {
  /// Create an instance.
  MapLevelSchemaFeature({
    final String? id,
    this.name = 'Untitled Feature',
    this.startX = 0,
    this.startY = 0,
    this.endX = 0,
    this.endY = 0,
    this.footstepSound,
    this.onActivateId,
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory MapLevelSchemaFeature.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaFeatureFromJson(json);

  /// The ID of this feature.
  final String id;

  /// The name of this feature.
  String name;

  /// The start x coordinate.
  int startX;

  /// The start y coordinate.
  int startY;

  /// The start coordinates.
  @JsonKey(ignore: true)
  Point<int> get start => Point(startX, startY);

  /// Set the [start] coordinates.
  set start(final Point<int> value) {
    startX = value.x;
    startY = value.y;
  }

  /// The end x coordinate.
  int endX;

  /// THe end y coordinate.
  int endY;

  /// Get the end coordinates.
  @JsonKey(ignore: true)
  Point<int> get end => Point(endX, endY);

  /// Set the [end] coordinates.
  set end(final Point<int> value) {
    endX = value.x;
    endY = value.y;
  }

  /// The footstep sound to use.
  String? footstepSound;

  /// The function to call when activating this feature.
  String? onActivateId;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaFeatureToJson(this);
}
