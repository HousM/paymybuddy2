import 'package:flutter/material.dart';

import '../_shared/jalon_placeholder.dart';

// Coquille — implémentation complète prévue au Jalon 4 (US-G1..G4, §6.3).
class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JalonPlaceholder(
      title: 'Générateur',
      jalon: 'J4 — Générateur',
      details: '4 stratégies + animation de révélation.',
    );
  }
}
