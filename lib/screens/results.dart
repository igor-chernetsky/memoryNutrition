import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/global_provider.dart';
import 'package:memory_nutration/screens/start.dart';

import '../models/player.dart';
import '../providers/player_provider.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  static String routeName = '/results';
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  _toStart() {
    ref.read(playersProvider.notifier).resetUsers();
    Navigator.of(context).pushReplacementNamed(StartScreen.routeName);
  }

  Widget getCard(int score, String playground) {
    return SizedBox(
      width: 70,
      height: 80,
      child: Card(
          color: Colors.orange,
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/img/$playground/score$score.png',
          )),
    );
  }

  getPlayerRow(
      int index, List<Player> players, double width, String playground) {
    if (players.length > index && index >= 0) {
      Player player = players[index];
      List<int> scores = player.score;
      int placeIndex = index > 2 ? 3 : index + 1;
      int sum = player.score.reduce(
        (value, element) => value + element,
      );
      return Card(
        color: const Color.fromRGBO(255, 255, 255, 0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0)),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/img/$playground/${player.name}.jpg'),
                            fit: BoxFit.contain)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '$sum',
                              style: const TextStyle(
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1.5, -1.5),
                                        color: Colors.black45),
                                  ],
                                  color: Colors.cyan,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: width / 2.5,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/img/$playground/win$placeIndex.png'),
                            fit: BoxFit.contain)),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceAround,
                      children:
                          scores.map((e) => getCard(e, playground)).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  getPlayerRows(List<Player> players, String playground) {
    List<Widget> result = [];
    double width = MediaQuery.of(context).size.width / 4;
    if (width > 120) {
      width = 120;
    }
    players.asMap().forEach((index, _) {
      result.add(getPlayerRow(index, players, width, playground));
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    String playground = ref.watch(globalProvider).playground;
    var players = ref.watch(playersProvider);
    players.sort((a, b) =>
        b.score.reduce((value, element) => value + element) -
        a.score.reduce((value, element) => value + element));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _toStart,
        child: const Icon(Icons.refresh),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/$playground/main.jpg'),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: getPlayerRows(players, playground)),
          ),
        ),
      ),
    );
  }
}
