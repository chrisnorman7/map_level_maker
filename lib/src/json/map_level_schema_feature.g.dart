// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema_feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchemaFeature _$MapLevelSchemaFeatureFromJson(
        Map<String, dynamic> json) =>
    MapLevelSchemaFeature(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Untitled Feature',
      startX: json['startX'] as int? ?? 0,
      startY: json['startY'] as int? ?? 0,
      endX: json['endX'] as int? ?? 0,
      endY: json['endY'] as int? ?? 0,
      footstepSound: json['footstepSound'] as String?,
      onActivateId: json['onActivateId'] as String?,
    );

Map<String, dynamic> _$MapLevelSchemaFeatureToJson(
        MapLevelSchemaFeature instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startX': instance.startX,
      'startY': instance.startY,
      'endX': instance.endX,
      'endY': instance.endY,
      'footstepSound': instance.footstepSound,
      'onActivateId': instance.onActivateId,
    };
