import 'package:flutter/material.dart';

import '../../core/config/constants/services/colors.dart';
import '../../core/config/constants/services/spacing.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? headerPadding;

  const SectionCard({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s14),
    this.headerPadding = const EdgeInsets.only(bottom: AppSpacing.s12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r14),
        border: const BorderSide(color: AppColors.border).toBorder(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title!.isNotEmpty)
            Padding(
              padding: headerPadding!,
              child: Text(
                title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}

// Helper: Border.fromBorderSide(...) cho gọn
extension on BorderSide {
  Border toBorder() => Border.fromBorderSide(this);
}
