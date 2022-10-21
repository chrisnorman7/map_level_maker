import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'project_context.dart';

/// The notifier which holds a project context.
class ProjectContextNotifier extends StateNotifier<ProjectContext?> {
  /// Create an instance.
  ProjectContextNotifier() : super(null);

  /// Get the project context.
  ProjectContext? get projectContext => state;

  /// Set the project context.
  set projectContext(final ProjectContext? value) {
    state = value;
  }
}
