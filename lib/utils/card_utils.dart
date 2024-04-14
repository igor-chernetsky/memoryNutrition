import 'package:flutter/material.dart';
import 'package:memory_nutration/models/game.dart';

import '../models/card.dart';

List<PlayCard> shaffleDeck(int size) {
  List<Side> sides = [];
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      sides.add(Side(color: x, version: y));
      sides.add(Side(color: x, version: y));
    }
  }
  List<PlayCard> result = [];
  sides = _shaffleSides(sides);
  for (int index = 0; index < sides.length; index += 2) {
    result.add(PlayCard(front: sides[index], back: sides[index + 1]));
  }
  return result;
}

List<Side> _shaffleSides(List<Side> sides) {
  bool isShaffled = false;
  while (!isShaffled) {
    sides.shuffle();
    isShaffled = true;
    for (int index = 0; index < sides.length; index += 2) {
      if (sides[index].color == sides[index + 1].color &&
          sides[index].version == sides[index + 1].version) {
        isShaffled = false;
      }
    }
  }
  return sides;
}

List<int> shaffleRewards(int size) {
  List<int> result = List.filled(size * 4, 1);
  int maxSize = (size / 2).ceil();
  int scoreIndex = 0;
  for (int i = size; i > 1; i--) {
    for (int counter = 0; counter < maxSize; counter++) {
      result[scoreIndex] = i;
      scoreIndex++;
    }
    maxSize++;
  }

  result.shuffle();

  return result;
}

DeckCollection deckWood = DeckCollection(colors: [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange
], pictures: [
  'assets/img/wood/o1.png',
  'assets/img/wood/o2.png',
  'assets/img/wood/o3.png',
  'assets/img/wood/o4.png',
]);

DeckCollection deckSea = DeckCollection(colors: [
  Colors.cyan,
  Colors.orange,
  Colors.red,
  Colors.green
], pictures: [
  'assets/img/sea/o1.png',
  'assets/img/sea/o2.png',
  'assets/img/sea/o3.png',
  'assets/img/sea/o4.png',
]);

DeckCollection deckCrown = DeckCollection(colors: [
  Colors.orange,
  Colors.blue,
  Colors.red,
  Colors.purple
], pictures: [
  'assets/img/crown/o1.png',
  'assets/img/crown/o2.png',
  'assets/img/crown/o3.png',
  'assets/img/crown/o4.png',
]);

getDeck(String playground) {
  switch (playground) {
    case 'sea':
      return deckSea;
    case 'crown':
      return deckCrown;
    default:
      return deckWood;
  }
}

DeckCard getCardByIndex(int colorIndex, int pictureIndex, String playground) {
  DeckCollection deck = getDeck(playground);
  return DeckCard(
      color: deck.colors[colorIndex], picture: deck.pictures[pictureIndex]);
}

// where position 1 - top, 2 - right, 3 - bottom, 4 - left
List<int?> getRewardsByPosition(int position, Game game) {
  if (game.rewards == null) {
    return [];
  }
  List<int?> result = game.rewards!
      .getRange(game.size * position, game.size * position + game.size)
      .toList();
  return result;
}

List<int> getCardIndexByPosition(int position, int size) {
  List<int> result = [];
  if (position < size) {
    for (int i = 0; i < size; i++) {
      result.add(i * size + position);
    }
  } else if (position < 2 * size) {
    for (int i = 0; i < size; i++) {
      result.add(i + (position - size) * size);
    }
    result = result.reversed.toList();
  } else if (position < 3 * size) {
    for (int i = 0; i < size; i++) {
      result.add(i * size + position - 2 * size);
    }
    result = result.reversed.toList();
  } else {
    for (int i = 0; i < size; i++) {
      result.add(i + (position - (3 * size)) * size);
    }
  }
  return result;
}
