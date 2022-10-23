// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema_terrain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchemaTerrain _$MapLevelSchemaTerrainFromJson(
        Map<String, dynamic> json) =>
    MapLevelSchemaTerrain(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Untitled Terrain',
      startX: json['startX'] as int? ?? 0,
      startY: json['startY'] as int? ?? 0,
      endX: json['endX'] as int? ?? 0,
      endY: json['endY'] as int? ?? 0,
      footstepSound: json['footstepSound'] as String?,
      onActivateFunctionId: json['onActivateFunctionId'] as String?,
      onActivateFunctionName: json['onActivateFunctionName'] as String?,
      isConst: json['isConst'] as bool? ?? true,
    )
      ..onEnterFunctionId = json['onEnterFunctionId'] as String?
      ..onEnterFunctionName = json['onEnterFunctionName'] as String?
      ..onExitFunctionId = json['onExitFunctionId'] as String?
      ..onExitFunctionName = json['onExitFunctionName'] as String?;

Map<String, dynamic> _$MapLevelSchemaTerrainToJson(
        MapLevelSchemaTerrain instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startX': instance.startX,
      'startY': instance.startY,
      'endX': instance.endX,
      'endY': instance.endY,
      'footstepSound': instance.footstepSound,
      'onActivateFunctionId': instance.onActivateFunctionId,
      'onActivateFunctionName': instance.onActivateFunctionName,
      'onEnterFunctionId': instance.onEnterFunctionId,
      'onEnterFunctionName': instance.onEnterFunctionName,
      'onExitFunctionId': instance.onExitFunctionId,
      'onExitFunctionName': instance.onExitFunctionName,
      'isConst': instance.isConst,
    };
