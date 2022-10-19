// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicSchema _$MusicSchemaFromJson(Map<String, dynamic> json) => MusicSchema(
      sound: json['sound'] as String,
      gain: (json['gain'] as num?)?.toDouble() ?? 0.5,
    );

Map<String, dynamic> _$MusicSchemaToJson(MusicSchema instance) =>
    <String, dynamic>{
      'sound': instance.sound,
      'gain': instance.gain,
    };
