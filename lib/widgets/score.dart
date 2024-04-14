import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/game_provider.dart';
import 'package:memory_nutration/providers/global_provider.dart';
import 'package:memory_nutration/providers/player_provider.dart';
import 'package:memory_nutration/utils/card_utils.dart';

import '../models/game.dart';
import '../models/player.dart';

class ScorePanel extends ConsumerWidget {
  const ScorePanel({super.key});

  getOptions(bool isColor, Game game, double width, String playground) {
    List<Widget> items = [];
    if (isColor) {
      for (int i = 0; i < game.size; i++) {
        items.add(SizedBox(
            width: width,
            height: width,
            child: Card(color: getDeck(playground).colors[i])));
      }
    } else {
      for (int i = 0; i < game.size; i++) {
        items.add(SizedBox(
            width: width,
            height: width,
            child: Card(
              color: Colors.grey,
              child: Image.asset(getDeck(playground).pictures[i]),
            )));
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items,
    );
  }

  getRewards(List<int> rewards, double width, double blockWidth) {
    List<Widget> items = [];
    double margin = (blockWidth - 40) / rewards.length;
    for (int index = 0; index < rewards.length; index++) {
      items.add(Container(
        margin: EdgeInsets.only(top: margin * index),
        width: width,
        height: width,
        child: const Card(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              side: BorderSide(color: Colors.deepOrange)),
        ),
      ));
    }
    return Stack(
      children: items,
    );
  }

  List<Widget> getPlayersBlocks(
      List<Player> players, Game game, double width, String playground) {
    List<Widget> items = [];
    double increment = 20;
    double decrement = 20 / players.length;

    for (int index = 0; index < players.length; index++) {
      bool isCurrent = game.currentPlayerIndex == index;
      var player = players[index];
      double blockWidth = isCurrent ? width + increment : width - decrement;
      double itemWidth = (blockWidth - 10) / game.size;
      items.add(Row(
        children: [
          SizedBox(
            height: blockWidth,
            width: blockWidth,
            child: Opacity(
              opacity: isCurrent ? 1 : 0.6,
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0)),
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/img/$playground/${player.name}.jpg'),
                          fit: BoxFit.contain)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getOptions(player.isColor, game, itemWidth, playground),
                      getRewards(player.score, itemWidth, width)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String playground = ref.watch(globalProvider).playground;
    List<Player> players = ref.watch(playersProvider);
    Game game = ref.watch(gameProvider);
    double width = MediaQuery.of(context).size.width / players.length - 10;
    if (width > 120) {
      width = 120;
    }

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/$playground/top.jpg'),
              fit: BoxFit.cover)),
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getPlayersBlocks(players, game, width, playground),
      ),
    );
  }
}
