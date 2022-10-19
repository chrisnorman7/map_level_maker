import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/providers.dart';
import 'screens/home_page.dart';

void main() => runApp(const MyApp());

/// The top-level app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) => ProviderScope(
        child: MaterialApp(
          title: 'Map Level Maker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const _HomePage(),
        ),
      );
}

/// The pretend home page to use.
class _HomePage extends ConsumerStatefulWidget {
  /// Create an instance.
  const _HomePage();

  /// Create state for this widget.
  @override
  _HomePageState createState() => _HomePageState();
}

/// State for [_HomePage].
class _HomePageState extends ConsumerState<_HomePage> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) => const HomePage();

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    ref.watch(synthizerContextProvider).destroy();
    ref.watch(synthizerProvider).shutdown();
    ref.watch(sdlProvider).quit();
  }
}
