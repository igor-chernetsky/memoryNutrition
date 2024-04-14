import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/player.dart';
import '../utils/name_generator.dart';

class PlayersNotifier extends StateNotifier<List<Player>> {
  List<int> indexes = [1, 2, 3, 4];

  final Ref ref;
  PlayersNotifier(this.ref) : super([]);

  void resetUsers() {
    for (var player in state) {
      player.score = [];
      player.positon = null;
      player.isColor = getRandomBoolean();
    }
  }

  void addPlayer() {
    indexes.shuffle();
    int index = indexes.last;
    indexes.removeLast();

    if (state.length < 4) {
      state = [
        ...state,
        Player(
            name: 'player$index',
            index: index,
            score: [],
            isColor: getRandomBoolean())
      ];
    }
  }

  void setPlayerPosition(int playerIndex, int pos) {
    var newState = [...state];
    Player player = newState[playerIndex];
    Player updatedPlayer = Player(
        name: player.name,
        index: player.index,
        score: player.score,
        isColor: player.isColor,
        positon: pos);
    newState[playerIndex] = updatedPlayer;
    state = newState;
  }

  void removePlayer(int index) {
    indexes.add(state[index].index);
    if (index < state.length) {
      var newState = [...state];
      newState.removeAt(index);
      state = newState;
    }
  }

  int? changeAmount(int index, List<int?> rewards) {
    if (index >= state.length) {
      return null;
    }
    var player = state[index];
    int? previousPosition = player.positon;
    var newState = [...state];
    var newScore = [...player.score, rewards[player.positon!]!];
    Player newPlayer = Player(
        name: player.name,
        index: player.index,
        score: newScore,
        positon: null,
        isColor: player.isColor);

    newState[index] = newPlayer;
    for (var element in newState) {
      if (element.positon == player.positon) element.positon = null;
    }
    for (var element in newState) {
      element.isColor = !element.isColor;
    }
    state = newState;
    return previousPosition;
  }
}

final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>>(
    (ref) => PlayersNotifier(ref));
