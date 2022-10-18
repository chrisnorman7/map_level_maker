import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/sound.dart' as ziggurat_sound;
import 'package:ziggurat/ziggurat.dart';

import '../providers/providers.dart';

/// A widget that will play the given [sound].
class PlaySoundSemantics extends ConsumerStatefulWidget {
  /// Create an instance.
  const PlaySoundSemantics({
    required this.sound,
    required this.directory,
    required this.child,
    this.gain = 0.7,
    this.looping = false,
    super.key,
  });

  /// Get the state of the nearest instance.
  static PlaySoundSemanticsState? of(final BuildContext context) =>
      context.findAncestorStateOfType<PlaySoundSemanticsState>();

  /// The sound to play.
  final String? sound;

  /// The directory to find the sound in.
  final Directory directory;

  /// The widget below this one in the tree.
  final Widget child;

  /// The gain of this sound.
  final double gain;

  /// Whether or not the resulting sound should loop.
  final bool looping;

  /// Create state for this widget.
  @override
  PlaySoundSemanticsState createState() => PlaySoundSemanticsState();
}

/// State for [PlaySoundSemantics].
class PlaySoundSemanticsState extends ConsumerState<PlaySoundSemantics> {
  ziggurat_sound.Sound? _sound;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Semantics(
        onDidGainAccessibilityFocus: () => play(ref),
        onDidLoseAccessibilityFocus: stop,
        child: widget.child,
      );

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    stop();
  }

  /// Play the sound.
  void play(final WidgetRef ref) {
    var location = widget.sound;
    if (location == null) {
      return;
    } else {
      location = path.join(widget.directory.path, location);
    }
    final AssetType type;
    final directory = Directory(location);
    if (File(location).existsSync()) {
      type = AssetType.file;
    } else if (directory.existsSync()) {
      if (directory.listSync().whereType<File>().isEmpty) {
        return;
      }
      type = AssetType.collection;
    } else {
      return;
    }
    final game = ref.watch(gameProvider);
    _sound = game.interfaceSounds.playSound(
      assetReference: AssetReference(
        location,
        type,
      ),
      gain: widget.gain,
      keepAlive: true,
      looping: widget.looping,
    );
  }

  /// Stop the sound from playing.
  void stop() {
    _sound?.destroy();
    _sound = null;
  }
}
