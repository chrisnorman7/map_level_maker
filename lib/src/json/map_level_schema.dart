import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:recase/recase.dart';
import 'package:ziggurat/sound.dart';

import '../../util.dart';
import 'map_level_schema_ambiance.dart';
import 'map_level_schema_feature.dart';
import 'map_level_schema_function.dart';
import 'map_level_schema_item.dart';
import 'map_level_schema_random_sound.dart';
import 'music_schema.dart';

part 'map_level_schema.g.dart';

/// A schema which can be used to generate map level classes.
@JsonSerializable()
class MapLevelSchema {
  /// Create an instance.
  MapLevelSchema({
    final String? id,
    this.className = 'UntitledMapBase',
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
    this.music,
    final List<MapLevelSchemaFeature>? features,
    final List<MapLevelSchemaFunction>? functions,
    final List<MapLevelSchemaItem>? items,
    final List<MapLevelSchemaAmbiance>? ambiances,
    this.reverbPreset,
    this.reverbTestSound,
    final List<MapLevelSchemaRandomSound>? randomSounds,
  })  : id = id ?? newId(),
        features = features ?? [],
        functions = functions ?? [],
        items = items ?? [],
        ambiances = ambiances ?? [],
        randomSounds = randomSounds ?? [];

  /// Create an instance from a JSON object.
  factory MapLevelSchema.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaFromJson(json);

  /// The ID of this map.
  final String id;

  /// The class name of this schema.
  String className;

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

  /// The music to use.
  MusicSchema? music;

  /// The features of this map.
  final List<MapLevelSchemaFeature> features;

  /// The functions for this map.
  final List<MapLevelSchemaFunction> functions;

  /// Returns the function with the given [id] or `null`.
  MapLevelSchemaFunction? findFunction(final String? id) {
    if (id == null) {
      return null;
    }
    for (final function in functions) {
      if (id == function.id) {
        return function;
      }
    }
    return null;
  }

  /// The items on this map.
  final List<MapLevelSchemaItem> items;

  /// The extra ambiances for this level.
  final List<MapLevelSchemaAmbiance> ambiances;

  /// The reverb preset to use.
  ReverbPreset? reverbPreset;

  /// The sound to use to test the [reverbPreset].
  ///
  /// This value will be a path relative to `soundsDirectory`.
  String? reverbTestSound;

  /// The random sounds to play.
  final List<MapLevelSchemaRandomSound> randomSounds;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaToJson(this);

  /// Get the base filename for this instance.
  ///
  /// This value is a snake case representation of [className].
  String get filename => className.snakeCase;

  /// Get the dart filename for this instance.
  String get dartFilename => '$filename.dart';

  /// Get the JSON filename for this instance.
  String get jsonFilename => '$id.json';
}
