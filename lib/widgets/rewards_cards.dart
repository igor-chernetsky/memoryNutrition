import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/game_provider.dart';
import 'package:memory_nutration/widgets/shake_card.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../providers/player_provider.dart';
import '../utils/card_utils.dart';

class RewardCards extends ConsumerWidget {
  int position;

  RewardCards({super.key, required this.position});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Game game = ref.watch(gameProvider);
    Player player = ref.watch(playersProvider)[game.currentPlayerIndex];
    double width = MediaQuery.of(context).size.width / (game.size + 2) - 10;
    double height = MediaQuery.of(context).size.height / (game.size + 2) - 80;
    if (width > height) {
      width = height;
    }
    if (width > 120) {
      width = 120;
    }
    List<Widget> items = [];
    List<int?> rewards = getRewardsByPosition(position, game);
    String symbol = '';
    switch (position) {
      case 0:
        symbol = '↓';
        break;
      case 1:
        symbol = '←';
        break;
      case 2:
        symbol = '↑';
        break;
      case 3:
        symbol = '→';
        break;
    }

    for (int index = 0; index < rewards.length; index++) {
      int? reward = rewards[index];
      Color arrowColor = player.positon == null ? Colors.white : Colors.black26;
      bool isCurrent = game.size * position + index == player.positon;
      if (isCurrent) {
        arrowColor = game.gameState == GameState.error
            ? Colors.red
            : game.gameState == GameState.success
                ? Colors.green
                : Colors.yellow;
      }
      items.add(AnimatedBlock(
        isRotating: true,
        isActive: player.positon == null,
        child: SizedBox(
          width: width,
          height: width,
          child: reward != null
              ? GestureDetector(
                  onTap: player.positon == null
                      ? () => ref
                          .read(playersProvider.notifier)
                          .setPlayerPosition(game.currentPlayerIndex,
                              position * game.size + index)
                      : null,
                  child: Card(
                    color: Colors.orange,
                    child: AnimatedBlock(
                      min: 0.7,
                      duration: 700,
                      isActive: player.positon == null,
                      child: Center(
                          child: Text(
                        symbol,
                        style: TextStyle(
                            height: 0.7,
                            fontSize: isCurrent ? 60 : 50,
                            color: arrowColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                )
              : null,
        ),
      ));
    }
    if (position == 0 || position == 2) {
      return Row(
        children: items,
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    return Column(
      children: items,
    );
  }
}
