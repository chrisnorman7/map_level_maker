import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jinja/jinja.dart';

import '../constants.dart';
import '../providers/project_context.dart';
import '../providers/providers.dart';
import '../src/json/map_level_schema.dart';
import '../util.dart';
import 'edit_map_level_schema.dart';
import 'system_information_screen.dart';

/// The project home page.
class HomePage extends ConsumerStatefulWidget {
  /// Create an instance.
  const HomePage({
    super.key,
  });

  /// Create state for this widget.
  @override
  HomePageState createState() => HomePageState();
}

/// State for [HomePage].
class HomePageState extends ConsumerState<HomePage> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextProvider);
    final maps = ref.watch(mapsProvider)
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => newMapLevelSchema(context: context, ref: ref),
        SingleActivator(
          LogicalKeyboardKey.keyB,
          control: useControlKey,
          meta: useMetaKey,
        ): () => buildMaps(
              context: context,
              projectContext: projectContext,
              levels: maps,
            ),
        SingleActivator(
          LogicalKeyboardKey.keyI,
          control: useControlKey,
          meta: useMetaKey,
          shift: true,
        ): () => pushWidget(
              context: context,
              builder: (final context) => const SystemInformationScreen(),
            ),
        closeProjectShortcut: () => Navigator.pop(context)
      },
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () => pushWidget(
              context: context,
              builder: (final context) => const SystemInformationScreen(),
            ),
            child: const Icon(
              Icons.info,
              semanticLabel: 'System Information',
            ),
          ),
          ElevatedButton(
            onPressed: () => buildMaps(
              context: context,
              projectContext: projectContext,
              levels: maps,
            ),
            child: const Icon(
              Icons.build,
              semanticLabel: 'Build Levels',
            ),
          )
        ],
        title: 'Map Levels',
        body: maps.isEmpty
            ? const CenterText(
                text: 'There are no maps to show.',
                autofocus: true,
              )
            : BuiltSearchableListView(
                items: maps,
                builder: (final context, final index) {
                  final map = maps[index];
                  return SearchableListTile(
                    searchString: map.name,
                    child: CallbackShortcuts(
                      bindings: {
                        deleteShortcut: () => confirm(
                              context: context,
                              message: 'Are you sure you want to delete the '
                                  '${map.name} map?',
                              title: confirmDeleteTitle,
                              yesCallback: () {
                                Navigator.pop(context);
                                final jsonFile =
                                    projectContext.getLevelJsonFile(
                                  map,
                                );
                                final dartFile =
                                    projectContext.getLevelDartFile(
                                  map,
                                );
                                if (jsonFile.existsSync()) {
                                  jsonFile.deleteSync();
                                }
                                if (dartFile.existsSync()) {
                                  dartFile.deleteSync();
                                }
                                ref.invalidate(mapsProvider);
                              },
                            )
                      },
                      child: PushWidgetListTile(
                        title: map.name,
                        builder: (final context) =>
                            EditMapLevelSchema(id: map.id),
                        autofocus: index == 0,
                        subtitle: '${map.maxX} x ${map.maxY}',
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => newMapLevelSchema(context: context, ref: ref),
          tooltip: 'Create Map',
          child: addIcon,
        ),
      ),
    );
  }

  /// Create a new map.
  void newMapLevelSchema({
    required final BuildContext context,
    required final WidgetRef ref,
  }) {
    final level = MapLevelSchema();
    ref.watch(projectContextProvider).saveLevel(level);
    ref.invalidate(mapsProvider);
    pushWidget(
      context: context,
      builder: (final context) => EditMapLevelSchema(id: level.id),
    );
  }

  /// Build all the maps we can find.
  void buildMaps({
    required final BuildContext context,
    required final ProjectContext projectContext,
    required final List<MapLevelSchema> levels,
  }) {
    final started = DateTime.now().millisecondsSinceEpoch;
    var i = 0;
    for (final level in levels) {
      try {
        mapLevelSchemaToDart(projectContext: projectContext, level: level);
        i++;
      } on FormatterException catch (e, s) {
        pushWidget(
          context: context,
          builder: (final context) => ErrorScreen(error: e, stackTrace: s),
        );
        break;
      } on TemplateError catch (e, s) {
        pushWidget(
          context: context,
          builder: (final context) => ErrorScreen(error: e, stackTrace: s),
        );
        break;
      }
    }
    if (i == 0) {
      return;
    }
    final ended = DateTime.now().millisecondsSinceEpoch;
    final duration = ended - started;
    final seconds = (duration / 1000).toStringAsFixed(2);
    final levelsLabel = i == 1 ? 'map' : 'maps';
    showMessage(
      context: context,
      message: 'Generated $i $levelsLabel in $seconds seconds.',
    );
  }
}
