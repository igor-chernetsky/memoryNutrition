class Player {
  String name;
  bool isColor;
  int index;
  List<int> score;
  int? positon;

  Player(
      {required this.name,
      required this.index,
      this.score = const [],
      this.isColor = true,
      this.positon});
}
