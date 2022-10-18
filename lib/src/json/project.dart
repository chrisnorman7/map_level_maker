import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../constants.dart';
import 'map_level_schema.dart';

part 'project.g.dart';

const _indentedJsonEncoder = JsonEncoder.withIndent('  ');

/// A project which holds a list of [mapLevels].
@JsonSerializable()
class Project {
  /// Create an instance.
  const Project({required this.mapLevels});

  /// Create an instance from a JSON object.
  factory Project.fromJson(final Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// The maps which have been created.
  final List<MapLevelSchema> mapLevels;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  /// Save this project.
  void save() {
    final json = toJson();
    final data = _indentedJsonEncoder.convert(json);
    projectFile.writeAsStringSync(data);
  }
}
