import 'dart:convert';

import 'package:dart_style/dart_style.dart';
import 'package:jinja/jinja.dart';
import 'package:uuid/uuid.dart';

import 'map_level_schema_to_code.dart';

/// The key where recent directories are stored.
const recentDirectoriesKey = 'map_level_maker_recent_directories';

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

/// The type of JSON data.
typedef JsonType = Map<String, dynamic>;

/// The message to be shown when something is unset.
const unsetMessage = '<Not set>';

/// The message when something can be cleared.
const clearMessage = 'Clear';

/// The title of delete confirmations.
const confirmDeleteTitle = 'Confirm Delete';
