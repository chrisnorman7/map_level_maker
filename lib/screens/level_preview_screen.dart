import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziggurat/levels.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../providers/providers.dart';
import '../src/json/map_level_schema.dart';
import '../src/json/map_level_schema_feature.dart';
import '../util.dart';
import '../widgets/int_coordinates_list_tile.dart';

/// A widget to preview the given [levelSchema].
class LevelPreviewScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const LevelPreviewScreen({
    required this.levelSchema,
    super.key,
  });

  /// The level schema to use.
  final MapLevelSchema levelSchema;

  /// Create state for this widget.
  @override
  LevelPreviewScreenState createState() => LevelPreviewScreenState();
}

/// State for [LevelPreviewScreen].
class LevelPreviewScreenState extends ConsumerState<LevelPreviewScreen> {
  /// The level to use.
  Level? _level;

  /// The current coordinates.
  late Point<int> coordinates;

  /// The heading of the player.
  late int heading;
  BackendReverb? _reverb;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    coordinates = const Point(0, 0);
    heading = 0;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final game = ref.watch(gameProvider);
    var level = _level;
    if (level == null) {
      final reverb = _reverb;
      final music = widget.levelSchema.music;
      final reverbPreset = widget.levelSchema.reverbPreset;
      if (reverb == null && reverbPreset != null) {
        final r = game.createReverb(reverbPreset);
        game
          ..interfaceSounds.addReverb(reverb: r)
          ..ambianceSounds.addReverb(reverb: r);
        _reverb = r;
      }
      level = Level(
        game: game,
        ambiances: [
          ...widget.levelSchema.ambiances.map<Ambiance>(
            (final e) => Ambiance(
              sound: getAssetReference(
                directory: ambiancesDirectory,
                sound: e.sound.sound,
              ),
              position: e.coordinates,
              gain: e.sound.gain,
            ),
          ),
          ...widget.levelSchema.items
              .where((final element) => element.ambiance != null)
              .map<Ambiance>(
            (final e) {
              final ambiance = e.ambiance!;
              return Ambiance(
                sound: getAssetReference(
                  directory: ambiancesDirectory,
                  sound: ambiance.sound,
                ),
                gain: ambiance.gain,
                position: e.coordinates?.toDouble(),
              );
            },
          )
        ],
        music: music == null
            ? null
            : Music(
                sound: getAssetReference(
                  directory: musicDirectory,
                  sound: music.sound,
                ),
                gain: music.gain,
              ),
      );
      _level = level;
      level.onPush();
    }
    return Cancel(
      child: SimpleScaffold(
        title: 'Preview Level',
        body: ListView(
          children: [
            IntCoordinatesListTile(
              coordinates: coordinates,
              onChanged: (final value) {
                if (value == coordinates) {
                  final sound = widget.levelSchema.wallSound;
                  if (sound != null) {
                    game.playSimpleSound(
                      sound: getAssetReference(
                        directory: wallsDirectory,
                        sound: sound,
                      ),
                    );
                  }
                } else {
                  coordinates = value;
                  final footstepSound = getFeature()?.footstepSound ??
                      widget.levelSchema.defaultFootstepSound;
                  if (footstepSound != null) {
                    final assetReference = getAssetReference(
                      directory: footstepsDirectory,
                      sound: footstepSound,
                    );
                    game.playSimpleSound(sound: assetReference);
                  }
                  game.setListenerPosition(
                    value.x.toDouble(),
                    value.y.toDouble(),
                    0.0,
                  );
                  setState(() {});
                }
              },
              autofocus: true,
              maxX: widget.levelSchema.maxX - 1,
              maxY: widget.levelSchema.maxY - 1,
              minX: 0,
              minY: 0,
            ),
            IntListTile(
              value: heading,
              onChanged: (final value) => setState(() {
                heading = value;
                game.setListenerOrientation(heading.toDouble());
              }),
              max: 359,
              min: 0,
              modifier: 5,
              title: 'Heading',
              subtitle: '$heading °',
            ),
            ListTile(
              title: const Text('Current Feature'),
              subtitle: Text(getFeature()?.name ?? '<None>'),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _level?.onPop(0.5);
    _reverb?.destroy();
  }

  /// Get the feature at the current [coordinates].
  MapLevelSchemaFeature? getFeature() {
    for (final feature in widget.levelSchema.features) {
      if (coordinates.x >= feature.startX &&
          coordinates.y >= feature.startY &&
          coordinates.x <= feature.endX &&
          coordinates.y <= feature.endY) {
        return feature;
      }
    }
    return null;
  }
}
