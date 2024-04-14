import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/game_provider.dart';
import 'package:memory_nutration/providers/global_provider.dart';
import 'package:memory_nutration/providers/player_provider.dart';

import '../models/card.dart';
import '../models/game.dart';
import '../utils/card_utils.dart';
import 'shake_card.dart';

class CardDesk extends ConsumerStatefulWidget {
  const CardDesk({super.key});

  @override
  ConsumerState<CardDesk> createState() => _CardDeskState();
}

class _CardDeskState extends ConsumerState<CardDesk> {
  Widget setRow(Game game, int startIndex, List<int>? cards) {
    var playground = game.playground!;
    String pg = ref.watch(globalProvider).playground;
    Color statusColor = Colors.amber;
    if (game.gameState == GameState.success) {
      statusColor = Colors.green;
    } else if (game.gameState == GameState.error) {
      statusColor = Colors.red;
    }
    double width = MediaQuery.of(context).size.width / (game.size + 2) - 10;
    double height = MediaQuery.of(context).size.height / (game.size + 2) - 80;
    if (width > height) {
      width = height;
    }
    if (width > 120) {
      width = 120;
    }
    List<Widget> rows = [];
    for (var i = 0; i < game.size; i++) {
      int index = startIndex + i;
      Side side = playground[index].isFront
          ? playground[index].front
          : playground[index].back;
      DeckCard card = getCardByIndex(side.color, side.version, pg);
      rows.add(SizedBox(
        width: width,
        height: width,
        child: Center(
          child: AnimatedBlock(
            isRotating: true,
            isFlip: game.isClosing,
            isActive: cards != null && cards[game.guessIndex] == index,
            child: Container(
              width: width,
              height: width,
              child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: card.color,
                  child: Image.asset(
                    card.picture,
                  )),
            ),
          ),
        ),
      ));
    }
    return Row(
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    var game = ref.watch(gameProvider);
    var player = ref.watch(playersProvider)[game.currentPlayerIndex];
    List<int>? playersCards = player.positon == null
        ? null
        : getCardIndexByPosition(player.positon!, game.size);
    List<Widget> columns = [];

    for (var i = 0; i < game.size; i++) {
      columns.add(setRow(game, i * game.size, playersCards));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: columns,
    );
  }
}
