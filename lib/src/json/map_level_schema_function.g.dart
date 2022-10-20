// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_level_schema_function.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLevelSchemaFunction _$MapLevelSchemaFunctionFromJson(
        Map<String, dynamic> json) =>
    MapLevelSchemaFunction(
      name: json['name'] as String? ?? 'myFunction',
      comment: json['comment'] as String? ??
          'A function which needs a proper comment.',
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MapLevelSchemaFunctionToJson(
        MapLevelSchemaFunction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'comment': instance.comment,
    };
