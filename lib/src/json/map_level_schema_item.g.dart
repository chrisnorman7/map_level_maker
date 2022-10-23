// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchemaItem _$MapLevelSchemaItemFromJson(Map<String, dynamic> json) =>
    MapLevelSchemaItem(
      earcon: json['earcon'] as String,
      descriptionSound: json['descriptionSound'] as String,
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Untitled Item',
      x: json['x'] as int?,
      y: json['y'] as int?,
      ambiance: json['ambiance'] == null
          ? null
          : MusicSchema.fromJson(json['ambiance'] as Map<String, dynamic>),
      descriptionText:
          json['descriptionText'] as String? ?? 'An item with no description.',
    );

Map<String, dynamic> _$MapLevelSchemaItemToJson(MapLevelSchemaItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
      'ambiance': instance.ambiance,
      'earcon': instance.earcon,
      'descriptionText': instance.descriptionText,
      'descriptionSound': instance.descriptionSound,
    };
