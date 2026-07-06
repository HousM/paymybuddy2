import 'package:flutter/material.dart';

import '../_shared/jalon_placeholder.dart';

// Coquille — implémentation complète prévue au Jalon 2 (US-T1..T4).
class DrawsScreen extends StatelessWidget {
  const DrawsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JalonPlaceholder(
      title: 'Tirages',
      jalon: 'J2 — Données',
      details: 'Dernier tirage, historique paginé, recherche par numéro.',
    );
  }
}
