import 'package:flutter/material.dart';
import '../../core/config/constants/services/spacing.dart';

class Pill extends StatelessWidget {
  final String text;
  final bool bold;
  final Color? textColor;
  final Color? bg; // nếu null -> xám rất nhạt

  const Pill({
    super.key,
    required this.text,
    this.bold = false,
    this.textColor,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color baseText = textColor ?? const Color(0xFF111827);
    final Color baseBg = bg ?? const Color(0xFFF8FAFC);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: baseBg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          color: baseText,
        ),
      ),
    );
  }
}
