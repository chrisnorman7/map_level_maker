// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchemaItem _$MapLevelSchemaItemFromJson(Map<String, dynamic> json) =>
    MapLevelSchemaItem(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Untitled Item',
      x: json['x'] as int? ?? 0,
      y: json['y'] as int? ?? 0,
      ambiance: json['ambiance'] == null
          ? null
          : MusicSchema.fromJson(json['ambiance'] as Map<String, dynamic>),
      earcon: json['earcon'] as String?,
      descriptionSound: json['descriptionSound'] as String?,
      descriptionText:
          json['descriptionText'] as String? ?? 'An item with no description.',
      watchable: json['watchable'] as bool? ?? true,
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
      'watchable': instance.watchable,
    };
