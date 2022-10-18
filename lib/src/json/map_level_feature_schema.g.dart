// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_feature_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelFeatureSchema _$MapLevelFeatureSchemaFromJson(
        Map<String, dynamic> json) =>
    MapLevelFeatureSchema(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Untitled Feature',
      startX: json['startX'] as int? ?? 0,
      startY: json['startY'] as int? ?? 0,
      endX: json['endX'] as int? ?? 0,
      endY: json['endY'] as int? ?? 0,
      footstepSound: json['footstepSound'] as String?,
    );

Map<String, dynamic> _$MapLevelFeatureSchemaToJson(
        MapLevelFeatureSchema instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startX': instance.startX,
      'startY': instance.startY,
      'endX': instance.endX,
      'endY': instance.endY,
      'footstepSound': instance.footstepSound,
    };
