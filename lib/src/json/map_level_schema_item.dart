import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';
import 'music_schema.dart';

part 'map_level_schema_item.g.dart';

/// An item in a map level.
@JsonSerializable()
class MapLevelSchemaItem {
  /// Create an instance.
  MapLevelSchemaItem({
    required this.earcon,
    required this.descriptionSound,
    final String? id,
    this.name = 'Untitled Item',
    this.x,
    this.y,
    this.ambiance,
    this.descriptionText = 'An item with no description.',
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory MapLevelSchemaItem.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaItemFromJson(json);

  /// The ID of this item.
  final String id;

  /// The textual name of this item.
  String name;

  /// The x coordinate.
  int? x;

  /// The y coordinate.
  int? y;

  /// The coordinates of this item.
  @JsonKey(ignore: true)
  Point<int>? get coordinates {
    final cX = x;
    final cY = y;
    if (cX == null || cY == null) {
      return null;
    }
    return Point(cX, cY);
  }

  /// Set the [coordinates].
  set coordinates(final Point<int>? value) {
    x = value?.x;
    y = value?.y;
  }

  /// The ambiance for this item.
  MusicSchema? ambiance;

  /// The earcon to use.
  String earcon;

  /// The description text of this item.
  String descriptionText;

  /// The description sound for this item.
  String descriptionSound;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaItemToJson(this);
}
