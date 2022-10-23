import 'package:backstreets_widgets/util.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import 'constants.dart';

/// The template to use for generating maps.
const mapLevelSchemaTemplate = '''
// ignore_for_file: lines_longer_than_80_chars, unused_import, avoid_redundant_argument_values
import 'dart:math';
import 'package:ziggurat/sound.dart';
import '../assets/amb.dart';
import '../assets/descriptions.dart';
import '../assets/earcons.dart';
import '../assets/footsteps.dart';
import '../assets/music.dart';
import '../assets/random_sounds.dart';
import '../assets/walls.dart';
import '../map_level/map_level.dart';
import '../map_level/map_level_item.dart';
import '../map_level/map_level_terrain.dart';

{{ name | comment }} ({{ id }}).
abstract class {{ className }} extends MapLevel {
  /// Create an instance.
  {{ className }}({
    required super.game,
    super.defaultFootstepSound
    {% if defaultFootstepSound != null %}
     = {{ defaultFootstepSound | asset }}
     {% endif %},
    super.wallSound {% if wallSound != null %}
    = {{ wallSound | asset }}
    {% endif %},
    {% if music %}
    super.music = const Music(sound: {{ music.sound | asset }},
    gain: {{ music.gain }},
    ),
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
    final List<MapLevelItem> items = const [],
    final List<MapLevelTerrain> terrains = const [],
    final List<Ambiance> levelAmbiances = const [],
    {% if reverbPreset %}
      super.reverbPreset = const ReverbPreset(
        name: {{ name | quote }},
        {% for name, value in reverbPreset %}
          {% if name != 'name' %}
            {{ name }}: {{ value }},
          {% endif %}
        {% endfor %}
      ),
    {% endif %}
    final List<RandomSound> randomSounds = const [],
    super.currentTerrain,
  }) : super(
    items: [
      ...items,
      {% for item in items %}
      const MapLevelItem(
        name: {{ item.name | quote }},
        {% if item.x and item.y %}
        coordinates: Point({{ item.x }}, {{ item.y }}),
        {% endif %}
        earcon: {{ item.earcon | asset }},
        descriptionText: {{ item.descriptionText | quote }},
        descriptionSound: {{ item.descriptionSound | asset }},
        {% if item.ambiance %}
        ambiance: {{ item.ambiance.sound | asset }},
        {% if item.ambiance.gain != 0.5 %}
        ambianceGain: {{ item.ambiance.gain }},
        {% endif %}
        {% endif %}
      ),
      {% endfor %}
    ],
    levelAmbiances: [
      ...levelAmbiances,
      {% for ambiance in ambiances %}
      const Ambiance(
        sound: {{ ambiance.sound.sound | asset }},
        {% if ambiance.sound.gain != 0.5 %}
        gain: {{ ambiance.sound.gain }},
        {% endif %}
        {% if ambiance.x and ambiance.y %}
        position: Point({{ambiance.x }}, {{ ambiance.y }}),
        {% endif %}
      ),
      {% endfor %}
    ],
    randomSounds: [
      ...randomSounds,
      {% for randomSound in randomSounds %}
        const RandomSound(
          sound: {{ randomSound.sound | asset }},
          minCoordinates: Point({{ randomSound.minX }}, {{ randomSound.minY }}),
          maxCoordinates: Point({{ randomSound.maxX }}, {{ randomSound.maxY }}),
          minInterval: {{ randomSound.minInterval }},
          maxInterval: {{ randomSound.maxInterval }},
          minGain: {{ randomSound.minGain }},
          maxGain: {{ randomSound.maxGain }},
        ),
      {% endfor %}
    ],
    terrains: [],
  ) {
    this.terrains.addAll([
      ...terrains,
      {% for terrain in terrains%}
      {% if terrain.needsConst == false %}
      const
      {% endif %}
      MapLevelTerrain(
        start:
        {% if terrain.needsConst %}
        const
        {% endif %}
        Point({{ terrain.startX }}, {{ terrain.startY }}),
        end:
        {% if terrain.needsConst %}
        const
        {% endif %}
        Point({{ terrain.endX }}, {{ terrain.endY }}),
        {% if terrain.footstepSound %}
        footstepSound: {{ terrain.footstepSound | asset }},
        {% endif %}
        {% if terrain.onActivateFunctionName %}
        onActivate: {{ terrain.onActivateFunctionName }},
        {% endif %}
        {% if terrain.onEnterFunctionName %}
        onEnter: {{ terrain.onEnterFunctionName }},
        {% endif %}
        {% if terrain.onExitFunctionName %}
        onExit: {{ terrain.onExitFunctionName }},
        {% endif %}
      ),
    {% endfor %}
    ]);
  }

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
