import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  final String value;
  final String label;
  const StatChip({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withOpacity(.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}