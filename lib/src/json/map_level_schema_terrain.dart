import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';

part 'map_level_schema_terrain.g.dart';

/// A terrain in a map level schema.
@JsonSerializable()
class MapLevelSchemaTerrain {
  /// Create an instance.
  MapLevelSchemaTerrain({
    final String? id,
    this.name = 'Untitled Terrain',
    this.startX = 0,
    this.startY = 0,
    this.endX = 0,
    this.endY = 0,
    this.footstepSound,
    this.onActivateFunctionId,
    this.onActivateFunctionName,
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory MapLevelSchemaTerrain.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaTerrainFromJson(json);

  /// The ID of this terrain.
  final String id;

  /// The name of this terrain.
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

  /// The function to call when activating this terrain.
  String? onActivateFunctionId;

  /// The name of the function represented by [onActivateFunctionId].
  ///
  /// This value is set by the [mapLevelSchemaToDart] function.
  String? onActivateFunctionName;

  /// The function to call when entering this terrain.
  String? onEnterFunctionId;

  /// The name of the function represented by [onEnterFunctionId].
  ///
  /// This value is set by the [mapLevelSchemaToDart] function.
  String? onEnterFunctionName;

  /// The function to call when exiting this terrain.
  String? onExitFunctionId;

  /// The name of the function represented by [onExitFunctionId].
  ///
  /// This value is set by the [mapLevelSchemaToDart] function.
  String? onExitFunctionName;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaTerrainToJson(this);
}
