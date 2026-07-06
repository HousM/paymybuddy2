# Boule&Stats

Application Flutter — statistiques et suivi des tirages Loto et EuroMillions (France).

Voir `../SFD-boule-et-stats.md` (source de vérité) et `../CLAUDE.md` (conventions).

## État — Jalon 1 (Socle)

- [x] Structure `lib/{core,data,features,shared}`
- [x] Thème (charte §10) + polices Google Fonts
- [x] Constantes `GAMES` (§4.3)
- [x] Schéma drift `Draws` + `MyGrids` (§4.1/4.2)
- [x] Widget `Ball` (main / star / chance, accessible)
- [x] Sélecteur Loto/EM persistant (Riverpod)
- [x] Navigation bottom bar 4 onglets
- [x] `ResponsibleGamingFooter` (RG-L1)
- [x] Tests unitaires sur `Ball` et `GAMES`

Jalons 2 à 7 : non commencés.

## Prérequis

- Flutter stable ≥ 3.19
- Dart SDK ≥ 3.3

## Installation

```bash
cd boule_et_stats
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # génère database.g.dart
```

## Lancement

```bash
flutter run                       # émulateur / appareil connecté
flutter run -d chrome             # dépannage rapide en web
flutter run --release             # profilage démarrage (§9 : < 2,5 s à froid)
```

## Tests & analyse

```bash
flutter analyze
flutter test
```
