import 'package:boule_et_stats/core/games.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EuroMillions — règles §4.3', () {
    final g = gameOf(GameKey.euromillions);
    expect(g.mainCount, 5);
    expect(g.mainMax, 50);
    expect(g.bonusCount, 2);
    expect(g.bonusMax, 12);
    expect(g.bonusStyle, BonusStyle.star);
  });

  test('Loto — règles §4.3', () {
    final g = gameOf(GameKey.loto);
    expect(g.mainCount, 5);
    expect(g.mainMax, 49);
    expect(g.bonusCount, 1);
    expect(g.bonusMax, 10);
    expect(g.bonusStyle, BonusStyle.chance);
  });
}
