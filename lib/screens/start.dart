import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/game_provider.dart';
import 'package:memory_nutration/providers/global_provider.dart';
import 'package:memory_nutration/screens/rules.dart';
import 'package:memory_nutration/widgets/settings.dart';
import 'package:memory_nutration/widgets/size_settings.dart';

import '../models/player.dart';
import '../providers/player_provider.dart';
import 'game.dart';

class StartScreen extends ConsumerStatefulWidget {
  static String routeName = '/';
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      ref.read(gameProvider.notifier).initDesk();
      if (ref.read(playersProvider).isEmpty) {
        ref.read(playersProvider.notifier).addPlayer();
        ref.read(playersProvider.notifier).addPlayer();
      }
    });
    super.initState();
  }

  final _form = GlobalKey<FormState>();

  _startGame() {
    _form.currentState!.validate();
    _form.currentState!.save();
    Navigator.of(context).pushNamed(GameScreen.routeName);
  }

  _rules() {
    ref.read(globalProvider.notifier).setHints(true);
    Navigator.of(context).pushNamed(RulesScreen.routeName);
  }

  addPlayer() {
    ref.read(playersProvider.notifier).addPlayer();
  }

  removePlayer(int index) {
    ref.read(playersProvider.notifier).removePlayer(index);
  }

  getPlayerRow(int index, List<Player> players, double width) {
    String playground = ref.watch(globalProvider).playground;
    if (players.length > index && index >= 0) {
      Player player = players[index];
      return SizedBox(
        width: width,
        height: width,
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                image: DecorationImage(
                    image:
                        AssetImage('assets/img/$playground/${player.name}.jpg'),
                    fit: BoxFit.contain)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    onPressed:
                        players.length > 1 ? () => removePlayer(index) : null,
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Color(0xFF04946d),
                      size: 30,
                    )),
              ],
            ),
          ),
        ),
      );
    }
  }

  openPlaygroundDrawer() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            color: Colors.transparent,
            height: 220,
            padding: EdgeInsets.all(10),
            child: const SettingsWidget());
      },
    );
  }

  openSizeDrawer(String playground) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            color: Colors.transparent,
            height: 220,
            padding: const EdgeInsets.all(10),
            child: SizeSettingsWidget(
              playground: playground,
            ));
      },
    );
  }

  getPlayerRows(List<Player> players) {
    double width = MediaQuery.of(context).size.width / 2 - 40;
    if (width > 140) {
      width = 140;
    }
    List<Widget> result = [];
    players.asMap().forEach((index, _) {
      result.add(getPlayerRow(index, players, width));
    });
    if (players.length < 4) {
      result.add(GestureDetector(
        onTap: () => addPlayer(),
        child: SizedBox(
          width: width,
          height: width,
          child: const Card(
            color: Color.fromRGBO(255, 255, 255, 0.7),
            child: Icon(
              Icons.add_circle_outline,
              color: Color(0xFF04946d),
              size: 70,
            ),
          ),
        ),
      ));
    }
    return result;
  }

  getPlaygroundButton(String playground) {
    return SizedBox(
      width: 120,
      height: 120,
      child: GestureDetector(
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/$playground/playground.jpg'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [getCaption(playground)],
            ),
          ),
        ),
        onTap: () => openPlaygroundDrawer(),
      ),
    );
  }

  getSizeButton(int size, String playground) {
    return SizedBox(
      width: 120,
      height: 120,
      child: GestureDetector(
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/$playground/cards$size.png'),
                    fit: BoxFit.contain)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [getCaption('$size x $size')],
            ),
          ),
        ),
        onTap: () => openSizeDrawer(playground),
      ),
    );
  }

  getCaption(String text) {
    return Card(
      color: const Color.fromRGBO(255, 255, 255, 0.8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 24,
                color: const Color(0xFF04946d),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int size = ref.watch(gameProvider).size;
    String playground = ref.watch(globalProvider).playground;
    var players = ref.watch(playersProvider);
    bool canStart = players.isNotEmpty;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.small(
              onPressed: () => _rules(),
              child: const Icon(Icons.question_mark),
            ),
            FloatingActionButton.extended(
              onPressed: canStart ? () => _startGame() : null,
              label: const Text('START!'),
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/$playground/main.jpg'),
                        fit: BoxFit.cover)),
                child: Column(children: [
                  Opacity(
                    opacity: 0.8,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                          image: DecorationImage(
                              image: AssetImage('assets/img/logo.png'),
                              fit: BoxFit.contain)),
                      width: 180,
                      height: 180,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(children: [
                    getCaption('Players'),
                    Wrap(
                      children: getPlayerRows(players),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 4),
                      color: const Color.fromRGBO(255, 255, 255, 0.4),
                      child: Column(
                        children: [
                          getCaption('Settings'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              getPlaygroundButton(playground),
                              getSizeButton(size, playground)
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
