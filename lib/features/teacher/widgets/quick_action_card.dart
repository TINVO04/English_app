import 'package:flutter/material.dart';
import 'package:my_app/shared/widgets/app_button.dart';

import '../../../core/config/constants/services/colors.dart';
import '../../../core/config/constants/services/spacing.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onPressed;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor.clamp(1.0, 1.15);

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Container(
        constraints: const BoxConstraints(minHeight: 168),
        padding: const EdgeInsets.all(AppSpacing.s14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: const BorderSide(color: AppColors.border).toBorder(),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ô icon đậm + icon trắng
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: AppSpacing.s10),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                height: 1.25,
              ),
            ),

            const Spacer(),
            AppButton.primary(
              text: 'Mở',
              onPressed: onPressed,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper
extension on BorderSide {
  Border toBorder() => Border.fromBorderSide(this);
}
