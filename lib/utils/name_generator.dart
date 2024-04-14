import 'dart:math';

final _random = Random();

getRandomInt() {
  Random r = Random();
  return r.nextInt(3) + 1;
}

getRandomBoolean() {
  Random r = Random();
  return r.nextDouble() <= 0.5;
}
