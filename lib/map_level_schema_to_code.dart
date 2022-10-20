import 'package:backstreets_widgets/util.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import 'constants.dart';

/// The template to use for generating maps.
const mapLevelSchemaTemplate = '''
// ignore_for_file: lines_longer_than_80_chars

import 'dart:math';
import 'package:ziggurat/sound.dart';
import '../assets/descriptions.dart';
import '../assets/earcons.dart';
import '../assets/footsteps.dart';
import '../assets/music.dart';
import '../assets/walls.dart';
import '../map_level/map_level.dart';
import '../map_level/map_level_feature.dart';
import '../map_level/map_level_item.dart';

{{ name | comment }} ({{ id }}).
abstract class {{ className }} extends MapLevel {
  /// Create an instance.
  {{ className }}({
    required super.game,
    super.defaultFootstepSound = {{ defaultFootstepSound | asset }},
    super.wallSound = {{ wallSound | asset }},
    {% if music %}
    super.music = const Music(sound: {{ music.sound | asset }}
    {% if music.gain != 0.5 %}
    , gain: {{ music.gain }}
    {% endif %}
    ),
    {% else %}
    // This map has no music.
    {% endif %}
    super.maxX = {{ maxX }},
    super.maxY = {{ maxY }},
    super.coordinates = const Point({{x }}, {{ y }}),
    super.heading = {{ heading }},
    super.turnInterval = {{ turnInterval  }},
    super.turnAmount = {{ turnAmount }},
    super.moveInterval = {{ moveInterval }},
    super.moveDistance = {{ moveDistance }},
    super.sonarDistanceMultiplier = {{ sonarDistanceMultiplier }},
    final List<MapLevelItem>? items,
    final List<MapLevelFeature>? features,
  }) : super(
    items: [
      ... items ?? [],
      {% for item in items %}
      const MapLevelItem(
        name: {{ item.name | quote }},
        coordinates: Point({{ item.x }}, {{ item.y }}),
        earcon: {{ item.earcon | asset }},
        descriptionText: {{ item.descriptionText | quote }},
        descriptionSound: {{ item.descriptionSound | asset }},
        {% if item.ambiance %}
        ambiance: {{ item.ambiance | asset }},
        {% endif %}
      ),
      {% endfor %}
    ],
    features: [
      ...features ?? [],
      {% for feature in features %}
      MapLevelFeature(
        start: const Point({{ feature.startX }}, {{ feature.startY }}),
        end: const Point({{ feature.endX }}, {{ feature.endY }}),
        {% if feature.footstepSound %}
        footstepSound: {{ feature.footstepSound | asset }},
        {% endif %}
        {% if feature.onActivate %}
        onActivate: {{ feature.onActivate.name }},
        {% endif %}
      ),
      {% endfor %}
    ]
  );

  {% for function in functions %}
  {{ function.comment | comment }}
  void {{ function.name }}();
  {% endfor %}
}
''';

/// The function to make the given [value] a comment.
String toComment(final dynamic value) {
  final string = value.toString();
  final lines = string.split('\n');
  final buffer = StringBuffer();
  for (final line in lines) {
    buffer.write('///');
    if (line.isNotEmpty) {
      buffer.writeln(' $line');
    } else {
      buffer.writeln();
    }
  }
  final s = buffer.toString();
  if (s.isEmpty) {
    return '/// $unsetMessage';
  }
  return s.substring(0, s.length - 1);
}

/// Return [value] as a valid asset name.
String toAsset(final dynamic value) => path
    .basenameWithoutExtension(
      value.toString(),
    )
    .camelCase;

/// Return a quote string.
String quoteValue(final dynamic value) => getQuotedString(value.toString());
