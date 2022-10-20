import 'dart:convert';
import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:jinja/jinja.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import 'map_level_schema_to_code.dart';

/// The jinjua environment to use.
final jinja = Environment(
  filters: {
    'comment': toComment,
    'asset': toAsset,
    'quote': quoteValue,
  },
);

/// The JSON encoder to use.
const indentedJsonEncoder = JsonEncoder.withIndent('  ');

/// The code formatter to use.
final codeFormatter = DartFormatter();

/// The UUID generator to use.
const uuid = Uuid();

/// The directory where map files will be stored.
///
/// This directory will contain both JSON and class files.
final mapsDirectory = Directory('../lib/src/maps');

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

/// The directory where earcons are stored.
final earconsDirectory = Directory(path.join(soundsDirectory.path, 'earcons'));

/// The directory where descriptions are stored.
final descriptionsDirectory =
    Directory(path.join(soundsDirectory.path, 'descriptions'));

/// The message to be shown when something is unset.
const unsetMessage = '<Not set>';

/// The message when something can be cleared.
const clearMessage = 'Clear';

/// The title of delete confirmations.
const confirmDeleteTitle = 'Confirm Delete';
