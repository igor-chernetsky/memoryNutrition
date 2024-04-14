import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/data/database_helper.dart';
import 'package:memory_nutration/models/game.dart';
import 'package:memory_nutration/providers/global_provider.dart';
import 'package:memory_nutration/screens/game.dart';
import 'package:memory_nutration/screens/results.dart';
import 'package:memory_nutration/screens/rules.dart';
import 'package:memory_nutration/screens/start.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(
    const ProviderScope(child: CardRaceApp()),
  );
}

class CardRaceApp extends ConsumerWidget {
  const CardRaceApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dbHelper.queryRowById('global').then((setting) {
      if (setting == null) {
        dbHelper.insert(GameSettings(id: 'global', isHitnsShown: true));
      } else {
        ref.read(globalProvider.notifier).initSettings(setting);
      }
    });

    return MaterialApp(
      title: 'Memory NUTration',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(
          primary: Color(0xFF04946d),
          seedColor: Color(0xFF04946d),
          background: Color(0xFFf2f2f2),
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: StartScreen.routeName,
      routes: {
        StartScreen.routeName: (context) => const StartScreen(),
        GameScreen.routeName: (context) => const GameScreen(),
        ResultsScreen.routeName: (context) => const ResultsScreen(),
        RulesScreen.routeName: (context) => const RulesScreen(),
      },
    );
  }
}
