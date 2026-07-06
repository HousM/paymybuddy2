import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/theme.dart';
import 'features/draws/draws_screen.dart';
import 'features/generator/generator_screen.dart';
import 'features/my_grids/my_grids_screen.dart';
import 'features/stats/stats_screen.dart';
import 'shared/game_switcher.dart';
import 'shared/responsible_gaming_footer.dart';

class BouleEtStatsApp extends StatelessWidget {
  const BouleEtStatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boule&Stats',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeShell(),
    );
  }
}

class _TabDef {
  const _TabDef(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _tabs = [
  _TabDef('Tirages', Icons.sports_baseball),
  _TabDef('Stats', Icons.bar_chart_rounded),
  _TabDef('Générateur', Icons.casino_rounded),
  _TabDef('Mes grilles', Icons.confirmation_number_rounded),
];

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  Widget _screenFor(int index) {
    switch (index) {
      case 0:
        return const DrawsScreen();
      case 1:
        return const StatsScreen();
      case 2:
        return const GeneratorScreen();
      case 3:
      default:
        return const MyGridsScreen();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(selectedTabProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _screenFor(tab),
                    const ResponsibleGamingFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) => ref.read(selectedTabProvider.notifier).state = i,
        items: [
          for (final t in _tabs)
            BottomNavigationBarItem(icon: Icon(t.icon), label: t.label),
        ],
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppColors.craie,
                  ),
                  children: [
                    TextSpan(text: 'Boule'),
                    TextSpan(text: '&', style: TextStyle(color: AppColors.or)),
                    TextSpan(text: 'Stats'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.scene2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PROTOTYPE',
                  style: TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const GameSwitcher(),
        ],
      ),
    );
  }
}
