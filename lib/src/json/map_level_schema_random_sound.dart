import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';

part 'map_level_schema_random_sound.g.dart';

/// A random sound.
@JsonSerializable()
class MapLevelSchemaRandomSound {
  /// Create an instance.
  MapLevelSchemaRandomSound({
    required this.sound,
    required this.maxX,
    required this.maxY,
    this.minX = 0.0,
    this.minY = 0.0,
    this.minGain = 0.5,
    this.maxGain = 1.0,
    this.minInterval = 5000,
    this.maxInterval = 15000,
    final String? id,
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory MapLevelSchemaRandomSound.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaRandomSoundFromJson(json);

  /// The ID of this random sound.
  final String id;

  /// The sound to play.
  String sound;

  /// The minimum x coordinate.
  double minX;

  /// The minimum y coordinate.
  double minY;

  /// The minimum coordinates.
  @JsonKey(ignore: true)
  Point<double> get minCoordinates => Point(minX, minY);

  /// Set the minimum coordinates.
  set minCoordinates(final Point<double> value) {
    minX = value.x;
    minY = value.y;
  }

  /// The maximum x coordinate.
  double maxX;

  /// The maximum y coordinate.
  double maxY;

  /// The maximum coordinates.
  @JsonKey(ignore: true)
  Point<double> get maxCoordinates => Point(maxX, maxY);

  /// Set the maximum coordinates.
  set maxCoordinates(final Point<double> value) {
    maxX = value.x;
    maxY = value.y;
  }

  /// The minimum gain.
  double minGain;

  /// The maximum gain.
  double maxGain;

  /// The minimum interval.
  int minInterval;

  /// The maximum interval.
  int maxInterval;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaRandomSoundToJson(this);
}
