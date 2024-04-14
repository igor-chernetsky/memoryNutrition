import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/models/game.dart';
import 'package:memory_nutration/providers/game_provider.dart';
import 'package:memory_nutration/providers/global_provider.dart';
import 'package:memory_nutration/screens/results.dart';
import 'package:memory_nutration/screens/rules.dart';
import 'package:memory_nutration/widgets/hint.dart';
import 'package:memory_nutration/widgets/separator.dart';

import '../providers/player_provider.dart';
import '../widgets/card_desk.dart';
import '../widgets/card_selector.dart';
import '../widgets/rewards_cards.dart';
import '../widgets/score.dart';

class GameScreen extends ConsumerStatefulWidget {
  static String routeName = '/game';
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  _rules() {
    ref.read(globalProvider.notifier).setHints(true);
    Navigator.of(context).pushNamed(RulesScreen.routeName);
  }

  _getFloatingButtons(game) {
    List<Widget> rowChildren = [
      FloatingActionButton.small(
        onPressed: () => _rules(),
        child: const Icon(Icons.question_mark),
      ),
    ];

    if (game.gameState == GameState.error) {
      rowChildren.add(FloatingActionButton.extended(
        onPressed: () => ref.read(gameProvider.notifier).nextPlayer(),
        label: const Text('Next'),
        icon: const Icon(Icons.arrow_forward),
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String playground = ref.watch(globalProvider).playground;
    bool isHintShown = ref.watch(globalProvider).isHitnsShown;
    var game = ref.watch(gameProvider);
    if (game.rewards!.indexWhere((element) => element != null) == -1) {
      Future.delayed(
          const Duration(milliseconds: 100),
          () => Navigator.of(context)
              .pushReplacementNamed(ResultsScreen.routeName));
    }
    var player = ref.watch(playersProvider)[game.currentPlayerIndex];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getFloatingButtons(game),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ScorePanel(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/img/$playground/main.jpg'),
                      fit: BoxFit.cover)),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Separator(
                        playground: playground,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RewardCards(position: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RewardCards(position: 3),
                              CardDesk(),
                              RewardCards(position: 1),
                            ],
                          ),
                          RewardCards(position: 2),
                        ],
                      ),
                      Separator(
                        playground: playground,
                      ),
                    ],
                  ),
                  if (isHintShown && player.positon == null)
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: HintBlock(
                        text:
                            'Select a reward card, to get it you\'ll need to guess all flipsides in the line',
                      ),
                    ),
                  if (isHintShown &&
                      player.positon != null &&
                      game.gameState != GameState.error)
                    Positioned(
                      bottom: 30,
                      left: 10,
                      right: 10,
                      child: HintBlock(
                          text:
                              'Guess flipside ${player.isColor ? 'color' : 'image'} for an active card'),
                    ),
                  if (isHintShown &&
                      player.positon != null &&
                      game.gameState == GameState.error)
                    Positioned(
                      bottom: 30,
                      left: 10,
                      right: 10,
                      child:
                          HintBlock(text: 'Pass the turn to the next player'),
                    ),
                ],
              ),
            ),
          ),
          CardSelector(),
        ],
      ),
    );
  }
}
