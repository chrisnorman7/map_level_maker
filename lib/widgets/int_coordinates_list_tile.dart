import 'dart:math';

import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

/// A list tile to show the given int [coordinates].
class IntCoordinatesListTile extends StatelessWidget {
  /// Create an instance.
  const IntCoordinatesListTile({
    required this.coordinates,
    required this.onChanged,
    this.title = 'Coordinates',
    this.autofocus = false,
    this.coordinateModifier = 1,
    this.minX,
    this.minY,
    this.maxX,
    this.maxY,
    super.key,
  });

  /// The coordinates to show.
  final Point<int> coordinates;

  /// The function to call when the [coordinates] change.
  final ValueChanged<Point<int>> onChanged;

  /// The title of this list tile.
  final String title;

  /// Whether or not to autofocus.
  final bool autofocus;

  /// How much coordinates should be modified with shortcuts.
  final int coordinateModifier;

  /// The minimum x coordinate.
  final int? minX;

  /// The maximum x coordinate.
  final int? maxX;

  /// The minimum y coordinate.
  final int? minY;

  /// THe maximum y coordinate.
  final int? maxY;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: {
          copyShortcut: () => setClipboardText(
                'const Point(${coordinates.x}, ${coordinates.y})',
              ),
          const SingleActivator(
            LogicalKeyboardKey.arrowLeft,
            alt: true,
          ): () {
            final x = coordinates.x - coordinateModifier;
            onChanged(Point(max(x, minX ?? x), coordinates.y));
          },
          const SingleActivator(
            LogicalKeyboardKey.arrowRight,
            alt: true,
          ): () {
            final x = coordinates.x + coordinateModifier;
            onChanged(Point(min(x, maxX ?? x), coordinates.y));
          },
          const SingleActivator(
            LogicalKeyboardKey.arrowDown,
            alt: true,
          ): () {
            final y = coordinates.y - coordinateModifier;
            onChanged(Point(coordinates.x, max(y, minY ?? y)));
          },
          const SingleActivator(
            LogicalKeyboardKey.arrowUp,
            alt: true,
          ): () {
            final y = coordinates.y + coordinateModifier;
            onChanged(Point(coordinates.x, min(y, maxY ?? y)));
          },
        },
        child: ListTile(
          autofocus: autofocus,
          title: Text(title),
          subtitle: Text('${coordinates.x} x ${coordinates.y}'),
          onTap: () =>
              setClipboardText('Point(${coordinates.x}, ${coordinates.y})'),
        ),
      );
}
