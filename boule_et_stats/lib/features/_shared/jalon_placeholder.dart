import 'package:flutter/material.dart';

class JalonPlaceholder extends StatelessWidget {
  const JalonPlaceholder({
    super.key,
    required this.title,
    required this.jalon,
    required this.details,
  });

  final String title;
  final String jalon;
  final String details;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.titleLarge),
          const SizedBox(height: 8),
          Text('À implémenter — $jalon', style: t.bodySmall),
          const SizedBox(height: 4),
          Text(details, style: t.bodyMedium),
        ],
      ),
    );
  }
}
