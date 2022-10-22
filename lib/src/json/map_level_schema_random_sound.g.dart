// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema_random_sound.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchemaRandomSound _$MapLevelSchemaRandomSoundFromJson(
        Map<String, dynamic> json) =>
    MapLevelSchemaRandomSound(
      sound: json['sound'] as String,
      maxX: (json['maxX'] as num).toDouble(),
      maxY: (json['maxY'] as num).toDouble(),
      minX: (json['minX'] as num?)?.toDouble() ?? 0.0,
      minY: (json['minY'] as num?)?.toDouble() ?? 0.0,
      minGain: (json['minGain'] as num?)?.toDouble() ?? 0.5,
      maxGain: (json['maxGain'] as num?)?.toDouble() ?? 1.0,
      minInterval: json['minInterval'] as int? ?? 5000,
      maxInterval: json['maxInterval'] as int? ?? 15000,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MapLevelSchemaRandomSoundToJson(
        MapLevelSchemaRandomSound instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sound': instance.sound,
      'minX': instance.minX,
      'minY': instance.minY,
      'maxX': instance.maxX,
      'maxY': instance.maxY,
      'minGain': instance.minGain,
      'maxGain': instance.maxGain,
      'minInterval': instance.minInterval,
      'maxInterval': instance.maxInterval,
    };
