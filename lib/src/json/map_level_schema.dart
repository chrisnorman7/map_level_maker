import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/sound.dart';

import '../../util.dart';
import 'map_level_feature_schema.dart';

part 'map_level_schema.g.dart';

/// A schema which can be used to generate map level classes.
@JsonSerializable()
class MapLevelSchema {
  /// Create an instance.
  MapLevelSchema({
    final String? id,
    this.name = 'Untitled Map',
    this.maxX = 100,
    this.maxY = 100,
    this.x = 0.0,
    this.y = 0.0,
    this.heading = 0.0,
    this.turnInterval = 20,
    this.turnAmount = 5,
    this.moveInterval = 500,
    this.moveDistance = 1.0,
    this.defaultFootstepSound,
    this.wallSound,
    this.sonarDistanceMultiplier = 75,
    this.reverbPreset,
    this.music,
    final List<MapLevelFeatureSchema>? features,
  })  : id = id ?? newId(),
        features = features ?? [];

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

  /// Get the max size of this map.
  @JsonKey(ignore: true)
  Point<int> get maxSize => Point(maxX, maxY);

  /// Set the max size.
  set maxSize(final Point<int> value) {
    maxX = value.x;
    maxY = value.y;
  }

  /// The initial x coordinate of the player on this map.
  double x;

  /// The initial y coordinate of the player on this map.
  double y;

  /// Get the coordinates of this map.
  @JsonKey(ignore: true)
  Point<double> get coordinates => Point(x, y);

  /// Set the coordinates of this map.
  set coordinates(final Point<double> value) {
    x = value.x;
    y = value.y;
  }

  /// The initial heading of the player in this map.
  double heading;

  /// How often the player can turn.
  int turnInterval;

  /// How many degrees the player turns each tick.
  int turnAmount;

  /// How fast the player can move.
  int moveInterval;

  /// How far the player moves each tick.
  double moveDistance;

  /// The default footstep sound.
  String? defaultFootstepSound;

  /// The wall sound.
  String? wallSound;

  /// The sonar distance multiplier.
  int sonarDistanceMultiplier;

  /// The reverb preset to use.
  ReverbPreset? reverbPreset;

  /// The music to use.
  String? music;

  /// The features of this map.
  final List<MapLevelFeatureSchema> features;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaToJson(this);
}
