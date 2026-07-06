import 'package:flutter/material.dart';

import '../_shared/jalon_placeholder.dart';

// Coquille — implémentation complète prévue au Jalon 3 (US-S1..S5, RG-S1..S4).
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JalonPlaceholder(
      title: 'Stats',
      jalon: 'J3 — Stats',
      details: 'Chauds / Froids / Tous, filtres de période (RG-S1/S2).',
    );
  }
}
