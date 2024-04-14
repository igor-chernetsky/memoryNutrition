import 'package:flutter/material.dart';

class Side {
  int color;
  int version;
  Side({required this.color, required this.version});
}

class PlayCard {
  Side front;
  Side back;
  bool isFront;
  PlayCard({required this.front, required this.back, this.isFront = true});
}

class DeckCollection {
  List<Color> colors;
  List<String> pictures;
  DeckCollection({required this.colors, required this.pictures});
}

class DeckCard {
  Color color;
  String picture;
  DeckCard({required this.color, required this.picture});
}
