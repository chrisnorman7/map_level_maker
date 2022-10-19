import 'package:json_annotation/json_annotation.dart';

part 'music_schema.g.dart';

/// Represents some music.
@JsonSerializable()
class MusicSchema {
  /// Create an instance.
  MusicSchema({
    required this.sound,
    this.gain = 0.5,
  });

  /// Create an instance from a JSON object.
  factory MusicSchema.fromJson(final Map<String, dynamic> json) =>
      _$MusicSchemaFromJson(json);

  /// The sound to use.
  String sound;

  /// The gain of the music.
  double gain;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MusicSchemaToJson(this);
}
