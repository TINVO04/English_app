import 'package:flutter/material.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../domain/teacher_class.dart';
import 'stat_chip.dart';

class TeacherClassCard extends StatelessWidget {
  final TeacherClassSummary data;
  final VoidCallback? onTap;
  const TeacherClassCard({super.key, required this.data, this.onTap});

  Color _statusColor(BuildContext context) => data.isActive
      ? Colors.green.shade600
      : Colors.grey.shade600;

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
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Text(
            data.title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(label: data.levelTag, bg: Colors.amber.shade100, fg: Colors.brown.shade800),
              _Pill(label: data.isActive ? 'Đang học' : 'Đã hoàn thành', bg: Colors.green.shade100, fg: _statusColor(context)),
            ],
          ),
          const SizedBox(height: 12),

          // Info rows
          _IconText(icon: Icons.access_time, text: formatSchedule(data.weekdays, data.start, data.end)),
          const SizedBox(height: 6),
          _IconText(icon: Icons.location_on_outlined, text: data.room),
          const SizedBox(height: 6),
          _IconText(icon: Icons.group_outlined, text: '${data.students}/${data.capacity} học viên'),

          const SizedBox(height: 12),
          // Progress
          Row(
            children: [
              Text('Tiến độ khóa học', style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text('${(data.courseProgress * 100).round()}%', style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(minHeight: 6, value: data.courseProgress),
          ),

          const SizedBox(height: 12),
          // Two stat chips
          Row(
            children: [
              Expanded(child: StatChip(value: '${(data.attendanceRate * 100).round()}%', label: 'Điểm danh')),
              const SizedBox(width: 12),
              Expanded(child: StatChip(value: '${(data.averageGrade * 100).round()}%', label: 'Điểm trung bình')),
            ],
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(text: 'Xem chi tiết', onPressed: (){}),
            ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconText({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: theme.hintColor),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Pill({required this.label, required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}