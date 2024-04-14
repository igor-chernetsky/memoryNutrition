import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});
  static String routeName = '/rules';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: const Image(
            image: AssetImage('assets/img/wood/top.jpg'),
            fit: BoxFit.cover,
          ),
          title: const Text(
            'How to play',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          )),
      body: Stack(children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    opacity: 0.6,
                    image: AssetImage('assets/img/wood/main.jpg'),
                    fit: BoxFit.cover)),
            child: const SingleChildScrollView(
              child: Column(children: [
                Text(
                  'Select number of players from 1 to 4 (it\'s better to play with 2 or more players) and click the start button',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/start.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'At the top of the screen you can see list of the players, bigger card shows whos turn is.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/players-types.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'The main playground contains of orange arrow rewards card and flip cards with images. Goal is get as much reward cards as possible.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Text(
                  'The flip cards can have one of 3 images and colors, on the both sides of the card.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/playground.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'To get the reward card player should guess (or remember) the flip sides for all 3 cards in the selected row.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Text(
                  'If player guesses wrong for one of the card, the turn goes to the next player.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/row.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Player have to guess color or type of the flipside of the cards',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/colors.png'),
                ),
                Image(
                  image: AssetImage('assets/img/rules/types.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'What exactly each player should guess is shown next to the player card',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/card-types.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'When all cards from the row is guessed, the player receives the reward card.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Text(
                  'All players who guessed color now should guess type and visa versa.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Text(
                  'All rewards card of the player are shown next to the user card.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/players-cards.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'When all reward cards are taken the game is over, each player check how many nuts were taken from the reward cards.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Image(
                  image: AssetImage('assets/img/rules/result.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Player with the best memory or the luckiest one win!, Have Fun!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ]),
            ))
      ]),
    );
  }
}
