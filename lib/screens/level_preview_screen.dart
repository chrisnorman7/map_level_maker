import 'dart:async';
import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziggurat/levels.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../providers/providers.dart';
import '../src/json/map_level_schema.dart';
import '../src/json/map_level_schema_terrain.dart';
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
  /// The timer to use for ticking the level.
  late final Timer timer;

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
    timer = Timer.periodic(const Duration(milliseconds: 16), (final timer) {
      _level?.tick(16);
    });
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextProvider);
    final game = ref.watch(gameProvider)
      ..setListenerOrientation(0.0)
      ..setListenerPosition(
        coordinates.x.toDouble(),
        coordinates.y.toDouble(),
        0.0,
      );
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
                directory: projectContext.ambiancesDirectory,
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
                  directory: projectContext.ambiancesDirectory,
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
                  directory: projectContext.musicDirectory,
                  sound: music.sound,
                ),
                gain: music.gain,
              ),
        randomSounds: widget.levelSchema.randomSounds
            .map<RandomSound>(
              (final e) => RandomSound(
                sound: getAssetReference(
                  directory: projectContext.randomSoundsDirectory,
                  sound: e.sound,
                ),
                minCoordinates: e.minCoordinates,
                maxCoordinates: e.maxCoordinates,
                minInterval: e.minInterval,
                maxInterval: e.maxInterval,
                minGain: e.minGain,
                maxGain: e.maxGain,
              ),
            )
            .toList(),
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
                        directory: projectContext.wallsDirectory,
                        sound: sound,
                      ),
                    );
                  }
                } else {
                  coordinates = value;
                  final footstepSound = getTerrain()?.footstepSound ??
                      widget.levelSchema.defaultFootstepSound;
                  if (footstepSound != null) {
                    final assetReference = getAssetReference(
                      directory: projectContext.footstepsDirectory,
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
              title: const Text('Current Terrain'),
              subtitle: Text(getTerrain()?.name ?? '<None>'),
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
    timer.cancel();
  }

  /// Get the terrain at the current [coordinates].
  MapLevelSchemaTerrain? getTerrain() {
    for (final terrain in widget.levelSchema.terrains) {
      if (coordinates.x >= terrain.startX &&
          coordinates.y >= terrain.startY &&
          coordinates.x <= terrain.endX &&
          coordinates.y <= terrain.endY) {
        return terrain;
      }
    }
    return null;
  }
}
