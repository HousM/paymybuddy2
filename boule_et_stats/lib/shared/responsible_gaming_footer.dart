// RG-L1 — mention permanente en pied d'écran (SFD §8).

import 'package:flutter/material.dart';

import '../core/theme.dart';

class ResponsibleGamingFooter extends StatelessWidget {
  const ResponsibleGamingFooter({super.key});

  static const String _line1 =
      'Jouer comporte des risques : endettement, isolement, dépendance.';
  static const String _line2 =
      'Pour être aidé, appelez le 09 74 75 13 13 (appel non surtaxé).';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Jeu responsable. $_line1 $_line2',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: _line1),
              const TextSpan(text: '\n'),
              TextSpan(
                text: _line2,
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
