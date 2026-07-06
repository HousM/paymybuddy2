import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/games.dart';
import '../core/providers.dart';
import '../core/theme.dart';

class GameSwitcher extends ConsumerWidget {
  const GameSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedGameProvider);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scene,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: GameKey.values.map((k) {
          final spec = gameOf(k);
          final active = k == selected;
          return Expanded(
            child: Semantics(
              button: true,
              selected: active,
              label: 'Choisir ${spec.label}',
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.chip),
                onTap: () => ref.read(selectedGameProvider.notifier).state = k,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? AppColors.bleu : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    spec.label,
                    style: TextStyle(
                      color: active ? Colors.white : AppColors.muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
