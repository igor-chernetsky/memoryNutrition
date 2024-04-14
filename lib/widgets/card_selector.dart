import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/global_provider.dart';
import 'package:memory_nutration/widgets/shake_card.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../utils/card_utils.dart';

class CardSelector extends ConsumerWidget {
  CardSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String playground = ref.watch(globalProvider).playground;
    Game game = ref.watch(gameProvider);
    Player player = ref.watch(playersProvider)[game.currentPlayerIndex];
    double width = MediaQuery.of(context).size.width / game.size - 10;
    if (width > 120) {
      width = 120;
    }
    bool disabled = player.positon == null || game.gameState == GameState.error;

    List<Widget> items = [];

    for (int i = 0; i < game.size; i++) {
      items.add(SizedBox(
        width: width,
        height: width,
        child: GestureDetector(
          onTap: disabled
              ? null
              : () {
                  var cardIndexs =
                      getCardIndexByPosition(player.positon!, game.size);
                  ref
                      .read(gameProvider.notifier)
                      .guess(player.isColor, i, cardIndexs);
                },
          child: AnimatedBlock(
            isActive: !disabled,
            isRotating: true,
            child: Card(
              clipBehavior: Clip.antiAlias,
              color:
                  player.isColor ? getDeck(playground).colors[i] : Colors.grey,
              child: player.isColor
                  ? null
                  : Image.asset(
                      getDeck(playground).pictures[i],
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),
      ));
    }
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/$playground/main.jpg'),
              fit: BoxFit.cover)),
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/$playground/top.jpg'),
                  fit: BoxFit.cover)),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items,
          ),
        ),
      ),
    );
  }
}
