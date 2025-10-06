import 'package:flutter/material.dart';

import '../../../core/config/constants/services/spacing.dart';

class TaskCard extends StatelessWidget {
  final Color color;     // màu trọng tâm (đỏ/vàng/cam)
  final String title;    // tiêu đề nhiệm vụ
  final String subtitle; // hạn / ghi chú

  const TaskCard({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor.clamp(1.0, 1.2);

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s12),
          decoration: BoxDecoration(
            color: color.withOpacity(.1), // nền pastel
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: Stack(
            children: [
              // Vạch màu bên trái chạy suốt chiều cao
              Positioned.fill(
                left: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
