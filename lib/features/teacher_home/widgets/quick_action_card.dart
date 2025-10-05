import 'package:flutter/material.dart';

import '../models.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.action});

  final QuickActionItem action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: action.onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: action.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: action.color.withOpacity(0.15)),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(action.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              action.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              action.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF4B5563),
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
