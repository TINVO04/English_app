import 'package:flutter/material.dart';

import '../../../core/config/constants/services/colors.dart';
import '../../../core/config/constants/services/spacing.dart';

class OverviewStatCard extends StatelessWidget {
  final IconData icon;     // icon hiển thị
  final String value;      // VD: "3", "42", "4.8"
  final String label;      // VD: "Số lớp hôm nay"
  final Color accent;      // VD: AppColors.accentBlue

  const OverviewStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });

  Color _pastel(Color c, [double t = .85]) => Color.lerp(c, Colors.white, t)!;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor.clamp(1.0, 1.15);

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Container(
        constraints: const BoxConstraints(minHeight: 110),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r14),
          border: const BorderSide(color: AppColors.border).toBorder(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon tròn: nền nhạt từ accent + icon màu đậm
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _pastel(accent, .85),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(height: AppSpacing.s8),

            // Giá trị
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: AppSpacing.s4),

            // Nhãn
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.2,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// helper cho Border
extension on BorderSide {
  Border toBorder() => Border.fromBorderSide(this);
}
