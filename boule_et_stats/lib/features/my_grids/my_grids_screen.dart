import 'package:flutter/material.dart';

import '../_shared/jalon_placeholder.dart';

// Coquille — implémentation complète prévue au Jalon 5 (US-M1..M4, RG-M1).
class MyGridsScreen extends StatelessWidget {
  const MyGridsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JalonPlaceholder(
      title: 'Mes grilles',
      jalon: 'J5 — Mes grilles',
      details: 'Sauvegarde (max 3) + palmarès virtuel.',
    );
  }
}
