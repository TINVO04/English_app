import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/class_attendance_summary.dart';
import 'package:my_app/shared/widgets/app_button.dart';

class ClassAttendanceCard extends StatelessWidget {
  final ClassAttendanceSummary data;
  final VoidCallback onTap; // bấm nút Take/Update Attendance
  const ClassAttendanceCard({super.key, required this.data, required this.onTap});

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
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(data.classTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('${data.teacherName} • ${data.room}', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text('${fmtTime(data.start)} - ${fmtTime(data.end)}', style: theme.textTheme.bodySmall),
                ]),
              ),
              _PresentBadge(rate: data.presentRate),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(value: data.total.toString(), label: 'Tổng'),
              _StatItem(value: data.present.toString(), label: 'Có mặt', color: Colors.green.shade700),
              _StatItem(value: data.absent.toString(), label: 'Vắng', color: Colors.red.shade700),
              _StatItem(value: data.late.toString(), label: 'Đi muộn', color: Colors.orange.shade700),
            ],
          ),

          const SizedBox(height: 12),
          data.hasAttendance
              ? OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cập nhật điểm danh'),
          )
              : AppButton.primary(text: 'Điểm danh', onPressed: onTap),
        ],
      ),
    );
  }
}

class _PresentBadge extends StatelessWidget {
  final double rate;
  const _PresentBadge({required this.rate});
  @override
  Widget build(BuildContext context) {
    final pct = (rate * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(99)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$pct% ', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w800)),
        Text('Có mặt', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value; final String label; final Color? color;
  const _StatItem({required this.value, required this.label, this.color});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      Text(value, style: theme.textTheme.titleLarge?.copyWith(color: color ?? theme.colorScheme.onBackground, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: theme.textTheme.bodySmall),
    ]);
  }
}
