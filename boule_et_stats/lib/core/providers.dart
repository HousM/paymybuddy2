import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'games.dart';

// SFD §6 : "un sélecteur de jeu (segmented control Loto / EuroMillions) est
// présent en haut de chaque écran et conserve son état global."
// Persistance disque déférée au jalon 6 (sync & réglages) ; ici l'état survit
// à la durée de vie de l'app.
final selectedGameProvider = StateProvider<GameKey>((ref) => GameKey.euromillions);

final selectedTabProvider = StateProvider<int>((ref) => 0);
