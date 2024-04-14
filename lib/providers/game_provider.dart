import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/models/card.dart';
import 'package:memory_nutration/providers/player_provider.dart';

import '../models/game.dart';
import '../utils/card_utils.dart';

class GameNotifier extends StateNotifier<Game> {
  final Ref ref;
  GameNotifier(this.ref) : super(Game(size: 3, guesses: []));

  void initDesk() {
    List<PlayCard> deck = shaffleDeck(state.size);
    List<int?> rewards = shaffleRewards(state.size);
    var newState =
        Game(size: state.size, playground: deck, rewards: rewards, guesses: []);
    state = newState;
  }

  Game changeSize(int size) {
    List<PlayCard> deck = shaffleDeck(size);
    List<int?> rewards = shaffleRewards(size);
    var newState =
        Game(size: size, playground: deck, rewards: rewards, guesses: []);
    state = newState;
    initDesk();
    return newState;
  }

  void guess(bool isColor, int variant, List<int> cardIndexs) {
    _changeCloseState(true);
    Future.delayed(const Duration(milliseconds: 220), () {
      filpCard(cardIndexs);
      Future.delayed(const Duration(milliseconds: 220), () {
        _guessing(isColor, variant, cardIndexs);
      });
    });
  }

  void filpCard(List<int> cardIndexs) {
    var newState = _getClonedState();
    int cardIndex = cardIndexs[state.guessIndex];
    PlayCard card = PlayCard(
        back: newState.playground![cardIndex].back,
        front: newState.playground![cardIndex].front,
        isFront: !newState.playground![cardIndex].isFront);
    newState.playground![cardIndex] = card;
    newState.guesses.add(cardIndex);
    newState.isClosing = false;
    state = newState;
  }

  void _guessing(bool isColor, int variant, List<int> cardIndexs) {
    var newState = _getClonedState();
    int cardIndex = cardIndexs[state.guessIndex];
    var card = newState.playground![cardIndex];
    Side side = card.isFront ? card.front : card.back;
    newState.isClosing = null;
    if ((isColor && side.color == variant) ||
        (!isColor && side.version == variant)) {
      newState.gameState = GameState.success;
      if (newState.size - 1 == newState.guessIndex) {
        newState.guesses = [];
        int? rewardPosition = ref
            .read(playersProvider.notifier)
            .changeAmount(newState.currentPlayerIndex, newState.rewards!);
        if (rewardPosition != null && newState.rewards != null) {
          List<int?> rewards = [];
          for (int index = 0; index < newState.rewards!.length; index++) {
            rewards
                .add(index == rewardPosition ? null : newState.rewards![index]);
          }

          newState.rewards = rewards;
          newState.guessIndex = 0;
        }
      } else {
        newState.guessIndex = newState.guessIndex + 1;
      }
    } else {
      newState.gameState = GameState.error;
    }
    state = newState;
  }

  Game _getClonedState() {
    var playground = state.playground == null ? null : [...state.playground!];
    return Game(
        currentPlayerIndex: state.currentPlayerIndex,
        size: state.size,
        rewards: state.rewards,
        guessIndex: state.guessIndex,
        guesses: state.guesses,
        playground: playground,
        isClosing: state.isClosing);
  }

  void _changeCloseState(bool? isClosing) {
    var newState = _getClonedState();
    newState.isClosing = isClosing;
    state = newState;
  }

  void _resetGuesses(Game st) {
    if (st.guesses.isNotEmpty) {
      for (var index in st.guesses) {
        st.playground![index].isFront = !st.playground![index].isFront;
      }
      st.guesses = [];
    }
  }

  void nextPlayer() {
    var playground = [...state.playground!];
    int playersCount = ref.read(playersProvider).length;
    int playerIndex = state.currentPlayerIndex == playersCount - 1
        ? 0
        : state.currentPlayerIndex + 1;

    var newState = Game(
        currentPlayerIndex: playerIndex,
        size: state.size,
        rewards: state.rewards,
        guessIndex: 0,
        guesses: state.guesses,
        playground: playground);
    _resetGuesses(newState);
    state = newState;
  }
}

final gameProvider =
    StateNotifierProvider<GameNotifier, Game>((ref) => GameNotifier(ref));
