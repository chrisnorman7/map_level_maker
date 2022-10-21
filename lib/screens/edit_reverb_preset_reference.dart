import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../providers/providers.dart';
import '../src/json/map_level_schema.dart';
import '../util.dart';
import '../widgets/full_sound_list_tile.dart';

/// The setting for a [ReverbPreset] instance.
class ReverbSetting {
  /// Create an instance.
  const ReverbSetting({
    required this.name,
    required this.defaultValue,
    required this.min,
    required this.max,
    this.modify = 0.1,
  });

  /// The name of this setting.
  final String name;

  /// The default value for this setting.
  final double defaultValue;

  /// The minimum value for this setting.
  final double min;

  /// The maximum value for this setting.
  final double max;

  /// How much this setting should be modified with the plus and minus keys.
  final double modify;
}

const _meanFreePathSetting = ReverbSetting(
  name: 'The mean free path of the simulated environment',
  defaultValue: 0.1,
  min: 0.0,
  max: 0.5,
  modify: 0.01,
);
const _t60Setting = ReverbSetting(
  name: 'T60',
  defaultValue: 0.3,
  min: 0.0,
  max: 100.0,
  modify: 1.0,
);
const _lateReflectionsLfRolloffSetting = ReverbSetting(
  name: 'Multiplicative factor on T60 for the low frequency band',
  defaultValue: 1.0,
  min: 0.0,
  max: 2.0,
);
const _lateReflectionsLfReferenceSetting = ReverbSetting(
  name: 'Where the low band of the feedback equalizer ends',
  defaultValue: 200.0,
  min: 0.0,
  max: 22050.0,
  modify: 1000.0,
);
const _lateReflectionsHfRolloffSetting = ReverbSetting(
  name: 'Multiplicative factor on T60 for the high frequency band',
  defaultValue: 0.5,
  min: 0.0,
  max: 2.0,
);
const _lateReflectionsHfReferenceSetting = ReverbSetting(
  name: 'Where the high band of the equalizer starts',
  defaultValue: 500.0,
  min: 0.0,
  max: 22050.0,
  modify: 1000.0,
);
const _lateReflectionsDiffusionSetting = ReverbSetting(
  name: 'Controls the diffusion of the late reflections as a percent',
  defaultValue: 1.0,
  min: 0.0,
  max: 1.0,
);
const _lateReflectionsModulationDepthSetting = ReverbSetting(
  name: 'Depth of the modulation of the delay lines on the feedback path in '
      'seconds',
  defaultValue: 0.01,
  min: 0.0,
  max: 0.3,
);
const _lateReflectionsModulationFrequencySetting = ReverbSetting(
  name: 'Frequency of the modulation of the delay lines int he feedback paths',
  defaultValue: 0.5,
  min: 0.01,
  max: 100.0,
  modify: 5.0,
);
const _lateReflectionsDelaySetting = ReverbSetting(
  name: 'The delay of the late reflections relative to the input in seconds',
  defaultValue: 0.03,
  min: 0.0,
  max: 0.5,
  modify: 0.001,
);
const _gainSetting = ReverbSetting(
  name: 'Gain',
  defaultValue: 0.7,
  min: 0.0,
  max: 5.0,
  modify: 0.25,
);

/// A widget to edit the reverb preset of the given [level].
class EditReverbPresetReference extends ConsumerStatefulWidget {
  /// Create an instance.
  const EditReverbPresetReference({
    required this.game,
    required this.level,
    super.key,
  });

  /// The game to use.
  final Game game;

  /// The level whose reverb preset will be edited.
  final MapLevelSchema level;

  /// Create state for this widget.
  @override
  EditReverbPresetReferenceState createState() =>
      EditReverbPresetReferenceState();
}

/// State for [EditReverbPresetReference].
class EditReverbPresetReferenceState
    extends ConsumerState<EditReverbPresetReference> {
  Sound? _sound;

  /// The sound channel to use.
  late SoundChannel channel;

  /// The reverb to use.
  late BackendReverb reverb;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    final game = widget.game;
    reverb = game.createReverb(const ReverbPreset(name: 'Default Reverb'));
    channel = game.createSoundChannel()..addReverb(reverb: reverb);
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextProvider);
    final level = widget.level;
    final testPath = level.reverbTestSound;
    final testEntity = testPath == null
        ? null
        : getFileSystemEntity(
            path.join(projectContext.soundsDirectory.path, testPath),
          );
    final preset = level.reverbPreset!;
    final tiles = [
      FullSoundListTile(
        value: testEntity,
        onChanged: (final value) {
          level.reverbTestSound = value == null
              ? null
              : path.relative(
                  value.path,
                  from: projectContext.soundsDirectory.path,
                );
          save();
        },
        autofocus: true,
      ),
      getSettingTile(
        context: context,
        value: preset.gain,
        setting: _gainSetting,
        onDone: (final value) => setReverbValue(gain: value),
      ),
      getSettingTile(
        context: context,
        value: preset.meanFreePath,
        setting: _meanFreePathSetting,
        onDone: (final value) => setReverbValue(meanFreePath: value),
      ),
      getSettingTile(
        context: context,
        value: preset.t60,
        setting: _t60Setting,
        onDone: (final value) => setReverbValue(t60: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsLfRolloff,
        setting: _lateReflectionsLfRolloffSetting,
        onDone: (final value) =>
            setReverbValue(lateReflectionsLfRolloff: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsLfReference,
        setting: _lateReflectionsLfReferenceSetting,
        onDone: (final value) =>
            setReverbValue(lateReflectionsLfReference: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsHfRolloff,
        setting: _lateReflectionsHfRolloffSetting,
        onDone: (final value) =>
            setReverbValue(lateReflectionsHfRolloff: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsHfReference,
        setting: _lateReflectionsHfReferenceSetting,
        onDone: (final value) =>
            setReverbValue(lateReflectionsHfReference: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsDiffusion,
        setting: _lateReflectionsDiffusionSetting,
        onDone: (final value) =>
            setReverbValue(lateReflectionsDiffusion: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsModulationDepth,
        setting: _lateReflectionsModulationDepthSetting,
        onDone: (final value) =>
            setReverbValue(lateReflectionsModulationDepth: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsModulationFrequency,
        setting: _lateReflectionsModulationFrequencySetting,
        onDone: (final value) =>
            setReverbValue(lateReflectionsModulationFrequency: value),
      ),
      getSettingTile(
        context: context,
        value: preset.lateReflectionsDelay,
        setting: _lateReflectionsDelaySetting,
        onDone: (final value) => setReverbValue(lateReflectionsDelay: value),
      )
    ];
    return CallbackShortcuts(
      bindings: {
        SingleActivator(LogicalKeyboardKey.keyP, control: useControlKey):
            playPause
      },
      child: Cancel(
        child: SimpleScaffold(
          title: 'Reverb Editor',
          body: ListView.builder(
            itemBuilder: (final context, final index) => tiles[index],
            itemCount: tiles.length,
          ),
        ),
      ),
    );
  }

  /// Play or pause the test sound.
  void playPause() {
    if (_sound == null) {
      play();
    } else {
      stop();
    }
    setState(() {});
  }

  /// Get a list tile for the given setting.
  Widget getSettingTile({
    required final BuildContext context,
    required final double value,
    required final ReverbSetting setting,
    required final ValueChanged<double> onDone,
  }) =>
      CallbackShortcuts(
        bindings: {deleteShortcut: () => onDone(setting.defaultValue)},
        child: DoubleListTile(
          value: value,
          onChanged: onDone,
          title: setting.name,
          min: setting.min,
          max: setting.max,
          modifier: setting.modify,
        ),
      );

  /// Set a reverb value.
  void setReverbValue({
    final double? gain,
    final double? lateReflectionsDelay,
    final double? lateReflectionsDiffusion,
    final double? lateReflectionsHfReference,
    final double? lateReflectionsHfRolloff,
    final double? lateReflectionsLfReference,
    final double? lateReflectionsLfRolloff,
    final double? lateReflectionsModulationDepth,
    final double? lateReflectionsModulationFrequency,
    final double? meanFreePath,
    final double? t60,
  }) {
    final level = widget.level;
    final oldPreset = level.reverbPreset!;
    level.reverbPreset = ReverbPreset(
      name: level.name,
      gain: gain ?? oldPreset.gain,
      lateReflectionsDelay:
          lateReflectionsDelay ?? oldPreset.lateReflectionsDelay,
      lateReflectionsDiffusion:
          lateReflectionsDiffusion ?? oldPreset.lateReflectionsDiffusion,
      lateReflectionsHfReference:
          lateReflectionsHfReference ?? oldPreset.lateReflectionsHfReference,
      lateReflectionsHfRolloff:
          lateReflectionsHfRolloff ?? oldPreset.lateReflectionsHfRolloff,
      lateReflectionsLfReference:
          lateReflectionsLfReference ?? oldPreset.lateReflectionsLfReference,
      lateReflectionsLfRolloff:
          lateReflectionsLfRolloff ?? oldPreset.lateReflectionsLfRolloff,
      lateReflectionsModulationDepth: lateReflectionsModulationDepth ??
          oldPreset.lateReflectionsModulationDepth,
      lateReflectionsModulationFrequency: lateReflectionsModulationFrequency ??
          oldPreset.lateReflectionsModulationFrequency,
      meanFreePath: meanFreePath ?? oldPreset.meanFreePath,
      t60: t60 ?? oldPreset.t60,
    );
    save();
    if (_sound != null) {
      play();
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    stop();
    channel.destroy();
    reverb.destroy();
  }

  /// Stop the sound playing.
  void stop() {
    _sound?.destroy();
    _sound = null;
  }

  /// Play the test sound.
  void play() {
    final projectContext = ref.watch(projectContextProvider);
    final level = widget.level;
    final preset = level.reverbPreset!;
    final sound = level.reverbTestSound;
    stop();
    if (sound != null) {
      // We use a file here, even though the path might be a directory.
      final file = File(
        path.join(projectContext.soundsDirectory.path, sound),
      );
      final directory = file.parent;
      reverb.setPreset(preset);
      _sound?.destroy();
      _sound = channel.playSound(
        assetReference: getAssetReference(
          directory: directory,
          sound: path.basename(file.path),
        ),
        keepAlive: true,
        looping: true,
      );
    }
  }

  /// Save the level.
  void save() {
    final projectContext = ref.watch(projectContextProvider);
    setState(
      () => projectContext.saveLevel(widget.level),
    );
  }
}
