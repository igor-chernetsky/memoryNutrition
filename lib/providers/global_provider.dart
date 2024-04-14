import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/main.dart';
import '../models/game.dart';

class GlobalNotifier extends StateNotifier<GameSettings> {
  final Ref ref;
  GlobalNotifier(this.ref) : super(GameSettings());

  void initSettings(GameSettings settings) {
    state = settings;
  }

  void toggleHints() {
    state = GameSettings(
        isHitnsShown: !state.isHitnsShown,
        id: state.id,
        playground: state.playground);
    dbHelper.update(state);
  }

  void setHints(bool value) {
    state = GameSettings(
        isHitnsShown: value, id: state.id, playground: state.playground);
    dbHelper.update(state);
  }

  void setPlayground(String pg) {
    state = GameSettings(
        isHitnsShown: state.isHitnsShown, id: state.id, playground: pg);
    state = GameSettings(playground: pg);
    dbHelper.update(state);
  }
}

final globalProvider = StateNotifierProvider<GlobalNotifier, GameSettings>(
    (ref) => GlobalNotifier(ref));
