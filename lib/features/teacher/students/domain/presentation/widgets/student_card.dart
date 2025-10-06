import 'package:flutter/material.dart';
import 'package:my_app/shared/widgets/app_button.dart';
import '../../student_summary.dart';

class StudentCard extends StatelessWidget {
  final StudentSummary data;
  final VoidCallback? onTap;
  const StudentCard({super.key, required this.data, this.onTap});

  Color _tagBg(BuildContext context) {
    switch (data.statusTag) {
      case 'Xuất sắc':
        return Colors.green.shade100;
      case 'Cần hỗ trợ':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _tagFg(BuildContext context) {
    switch (data.statusTag) {
      case 'Xuất sắc':
        return Colors.green.shade700;
      case 'Cần hỗ trợ':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(.4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                child: Text(data.initials, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.fullName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(data.classTitle, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: _tagBg(context), borderRadius: BorderRadius.circular(99)),
                        child: Text(data.statusTag, style: TextStyle(color: _tagFg(context), fontWeight: FontWeight.w600)),
                      ),
                      if (data.trendUp)
                        const Icon(Icons.trending_up, size: 18, color: Colors.green),
                    ]),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(pct(data.courseProgress), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text('Tiến độ', style: theme.textTheme.bodySmall),
                ],
              )
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(value: pct(data.grade), label: 'Điểm TB'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(value: pct(data.attendance), label: 'Điểm danh'),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Text('Tiến độ khóa học', style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text(pct(data.courseProgress), style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(minHeight: 6, value: data.courseProgress),
          ),

          const SizedBox(height: 12),
          AppButton.primary(text: 'Xem chi tiết', onPressed: (){}),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.primary)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}