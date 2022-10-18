import '../src/json/project.dart';

/// A context to hold a [project], and a [value].
class SchemaContext<T> {
  /// Create an instance.
  const SchemaContext({
    required this.project,
    required this.value,
  });

  /// The project to use.
  final Project project;

  /// The map level to use.
  final T value;
}
