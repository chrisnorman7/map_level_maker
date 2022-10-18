import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// The UUID generator to use.
const uuid = Uuid();

/// The file where the project JSON will be stored.
final projectFile = File('../project.json');

/// The type of JSON data.
typedef JsonType = Map<String, dynamic>;

/// The location where sounds are stored.
final soundsDirectory = Directory(path.join('..', 'sounds'));

/// The directory where footsteps are stored.
final footstepsDirectory = Directory(
  path.join(soundsDirectory.path, 'footsteps'),
);

/// The directory where wall sounds are stored.
final wallsDirectory = Directory(path.join(soundsDirectory.path, 'walls'));

/// The directory where music is stored.
final musicDirectory = Directory(path.join(soundsDirectory.path, 'music'));

/// The directory where ambiances are stored.
final ambiancesDirectory = Directory(path.join(soundsDirectory.path, 'amb'));

/// The message to be shown when something is unset.
const unsetMessage = '<Not set>';
