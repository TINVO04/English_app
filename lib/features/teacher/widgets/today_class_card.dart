import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/features/teacher/domain/models.dart';
import 'package:my_app/shared/widgets/pill.dart';

import '../../../core/config/constants/services/colors.dart';
import '../../../core/config/constants/services/spacing.dart';

class TodayClassCard extends StatelessWidget {
  final TodayClassItem item;
  const TodayClassCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor.clamp(1.0, 1.15);
    final time =
        '${DateFormat('HH:mm', 'vi_VN').format(item.start)} - ${DateFormat('HH:mm', 'vi_VN').format(item.end)}';

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s14),
        decoration: BoxDecoration(
          color: AppColors.surfaceGray, // xám nhạt như mẫu
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hàng đầu: tiêu đề + pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.courseName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s6,
                  children: const [
                    Pill(text: 'sắp diễn ra'),
                    Pill(text: 'Điểm danh', bold: true),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),

            Text(
              '$time · Phòng ${item.room}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              '${item.studentCount} học viên',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
