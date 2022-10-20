import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';

part 'map_level_schema_function.g.dart';

/// A function in a map level.
@JsonSerializable()
class MapLevelSchemaFunction {
  /// Create an instance.
  MapLevelSchemaFunction({
    this.name = 'myFunction',
    this.comment = 'A function which needs a proper comment.',
    final String? id,
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory MapLevelSchemaFunction.fromJson(final Map<String, dynamic> json) =>
      _$MapLevelSchemaFunctionFromJson(json);

  /// The ID of this this function.
  final String id;

  /// The name of this function.
  String name;

  /// The comment for this function.
  String comment;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MapLevelSchemaFunctionToJson(this);
}
