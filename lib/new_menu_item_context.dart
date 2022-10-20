import 'package:flutter/services.dart';

/// A class to hold context about a "new" menu item.
class NewMenuItemContext {
  /// Create an instance.
  const NewMenuItemContext({
    required this.title,
    required this.shortcut,
    required this.onPressed,
  });

  /// The thing that will be created by this menu.
  final String title;

  /// The key to use to activate this menu.
  final LogicalKeyboardKey shortcut;

  /// The function to call to create the item.
  final VoidCallback onPressed;
}
