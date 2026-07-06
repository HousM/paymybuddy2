// SFD §4.3 — Règles des jeux (constantes)

enum GameKey { euromillions, loto }

class GameSpec {
  final GameKey key;
  final String id;
  final String label;
  final int mainCount;
  final int mainMax;
  final int bonusCount;
  final int bonusMax;
  final String bonusLabel;
  final BonusStyle bonusStyle;
  final String drawDays;

  const GameSpec({
    required this.key,
    required this.id,
    required this.label,
    required this.mainCount,
    required this.mainMax,
    required this.bonusCount,
    required this.bonusMax,
    required this.bonusLabel,
    required this.bonusStyle,
    required this.drawDays,
  });
}

enum BonusStyle { star, chance }

const Map<GameKey, GameSpec> GAMES = {
  GameKey.euromillions: GameSpec(
    key: GameKey.euromillions,
    id: 'euromillions',
    label: 'EuroMillions',
    mainCount: 5,
    mainMax: 50,
    bonusCount: 2,
    bonusMax: 12,
    bonusLabel: 'Étoiles',
    bonusStyle: BonusStyle.star,
    drawDays: 'mardi & vendredi',
  ),
  GameKey.loto: GameSpec(
    key: GameKey.loto,
    id: 'loto',
    label: 'Loto',
    mainCount: 5,
    mainMax: 49,
    bonusCount: 1,
    bonusMax: 10,
    bonusLabel: 'N° Chance',
    bonusStyle: BonusStyle.chance,
    drawDays: 'lundi, mercredi & samedi',
  ),
};

GameSpec gameOf(GameKey k) => GAMES[k]!;
