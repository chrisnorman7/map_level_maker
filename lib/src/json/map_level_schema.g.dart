// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchema _$MapLevelSchemaFromJson(Map<String, dynamic> json) =>
    MapLevelSchema(
      id: json['id'] as String?,
      className: json['className'] as String? ?? 'UntitledMapBase',
      name: json['name'] as String? ?? 'Untitled Map',
      maxX: json['maxX'] as int? ?? 100,
      maxY: json['maxY'] as int? ?? 100,
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      heading: (json['heading'] as num?)?.toDouble() ?? 0.0,
      turnInterval: json['turnInterval'] as int? ?? 20,
      turnAmount: json['turnAmount'] as int? ?? 5,
      moveInterval: json['moveInterval'] as int? ?? 500,
      moveDistance: (json['moveDistance'] as num?)?.toDouble() ?? 1.0,
      defaultFootstepSound: json['defaultFootstepSound'] as String?,
      wallSound: json['wallSound'] as String?,
      sonarDistanceMultiplier: json['sonarDistanceMultiplier'] as int? ?? 75,
      music: json['music'] == null
          ? null
          : MusicSchema.fromJson(json['music'] as Map<String, dynamic>),
      terrains: (json['terrains'] as List<dynamic>?)
          ?.map(
              (e) => MapLevelSchemaTerrain.fromJson(e as Map<String, dynamic>))
          .toList(),
      functions: (json['functions'] as List<dynamic>?)
          ?.map(
              (e) => MapLevelSchemaFunction.fromJson(e as Map<String, dynamic>))
          .toList(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MapLevelSchemaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      ambiances: (json['ambiances'] as List<dynamic>?)
          ?.map(
              (e) => MapLevelSchemaAmbiance.fromJson(e as Map<String, dynamic>))
          .toList(),
      reverbPreset: json['reverbPreset'] == null
          ? null
          : ReverbPreset.fromJson(json['reverbPreset'] as Map<String, dynamic>),
      reverbTestSound: json['reverbTestSound'] as String?,
      randomSounds: (json['randomSounds'] as List<dynamic>?)
          ?.map((e) =>
              MapLevelSchemaRandomSound.fromJson(e as Map<String, dynamic>))
          .toList(),
      moveRumbleEffect: json['moveRumbleEffect'] == null
          ? null
          : RumbleEffect.fromJson(
              json['moveRumbleEffect'] as Map<String, dynamic>),
      wallRumbleEffect: json['wallRumbleEffect'] == null
          ? null
          : RumbleEffect.fromJson(
              json['wallRumbleEffect'] as Map<String, dynamic>),
      turnRumbleEffect: json['turnRumbleEffect'] == null
          ? null
          : RumbleEffect.fromJson(
              json['turnRumbleEffect'] as Map<String, dynamic>),
      watchRumbleEffect: json['watchRumbleEffect'] == null
          ? null
          : RumbleEffect.fromJson(
              json['watchRumbleEffect'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MapLevelSchemaToJson(MapLevelSchema instance) =>
    <String, dynamic>{
      'id': instance.id,
      'className': instance.className,
      'name': instance.name,
      'maxX': instance.maxX,
      'maxY': instance.maxY,
      'x': instance.x,
      'y': instance.y,
      'heading': instance.heading,
      'turnInterval': instance.turnInterval,
      'turnAmount': instance.turnAmount,
      'moveInterval': instance.moveInterval,
      'moveDistance': instance.moveDistance,
      'defaultFootstepSound': instance.defaultFootstepSound,
      'wallSound': instance.wallSound,
      'sonarDistanceMultiplier': instance.sonarDistanceMultiplier,
      'music': instance.music,
      'terrains': instance.terrains,
      'functions': instance.functions,
      'items': instance.items,
      'ambiances': instance.ambiances,
      'reverbPreset': instance.reverbPreset,
      'reverbTestSound': instance.reverbTestSound,
      'randomSounds': instance.randomSounds,
      'moveRumbleEffect': instance.moveRumbleEffect,
      'wallRumbleEffect': instance.wallRumbleEffect,
      'turnRumbleEffect': instance.turnRumbleEffect,
      'watchRumbleEffect': instance.watchRumbleEffect,
    };
