// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema_ambiance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchemaAmbiance _$MapLevelSchemaAmbianceFromJson(
        Map<String, dynamic> json) =>
    MapLevelSchemaAmbiance(
      sound: MusicSchema.fromJson(json['sound'] as Map<String, dynamic>),
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MapLevelSchemaAmbianceToJson(
        MapLevelSchemaAmbiance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sound': instance.sound,
      'x': instance.x,
      'y': instance.y,
    };
