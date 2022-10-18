// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchema _$MapLevelSchemaFromJson(Map<String, dynamic> json) =>
    MapLevelSchema(
      name: json['name'] as String? ?? 'Untitled Map',
      maxX: json['maxX'] as int? ?? 100,
      maxY: json['maxY'] as int? ?? 100,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MapLevelSchemaToJson(MapLevelSchema instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'maxX': instance.maxX,
      'maxY': instance.maxY,
    };
