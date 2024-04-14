import 'package:memory_nutration/models/card.dart';

class Game {
  int size;
  List<PlayCard>? playground;
  List<int?>? rewards;
  List<int> guesses;
  int currentPlayerIndex;
  int guessIndex;
  bool? isClosing;
  GameState gameState = GameState.process;

  Game(
      {this.size = 3,
      this.guessIndex = 0,
      required this.guesses,
      this.rewards,
      this.playground,
      this.isClosing,
      this.currentPlayerIndex = 0});
}

enum GameState { success, error, process }

class GameSettings {
  String id;
  bool isHitnsShown;
  String playground;
  GameSettings(
      {this.id = '', this.isHitnsShown = true, this.playground = 'wood'});
}
