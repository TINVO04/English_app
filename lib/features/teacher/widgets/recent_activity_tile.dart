import 'package:flutter/material.dart';

import '../../../core/config/constants/services/spacing.dart';

class RecentActivityTile extends StatelessWidget {
  final String text;
  final DateTime timestamp;

  const RecentActivityTile({
    super.key,
    required this.text,
    required this.timestamp,
  });

  String _timeAgoVi(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor.clamp(1.0, 1.2);
    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
        child: Row(
          children: [
            const Icon(Icons.fiber_manual_record,
                size: 8, color: Color(0xFF9CA3AF)),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF111827)),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Text(
              _timeAgoVi(timestamp),
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }
}
