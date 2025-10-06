import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/schedule/domain/schedule_models.dart' hide fmtTime;
import '../../../../attendance/domain/class_attendance_summary.dart';

class ScheduleEventCard extends StatelessWidget {
  final ScheduleEvent e;
  final VoidCallback? onTap;
  const ScheduleEventCard({super.key, required this.e, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kindBg(e.kind),
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: kindBorder(e.kind), width: 4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: kindBorder(e.kind))),
                const SizedBox(height: 4),
                if (e.levelTag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(.7), borderRadius: BorderRadius.circular(99)),
                    child: Text(e.levelTag!, style: theme.textTheme.labelMedium),
                  ),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.schedule, size: 16),
                  const SizedBox(width: 6),
                  Text('${fmtTime(e.start)} - ${fmtTime(e.end)}', style: theme.textTheme.bodySmall),
                ]),
                if (e.room != null) ...[
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.room_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text(e.room!, style: theme.textTheme.bodySmall),
                  ]),
                ],
                if (e.students != null) ...[
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.groups_2_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text('${e.students} học viên'),
                  ]),
                ],
              ]),
            ),
            Text(fmtTime(e.start), style: theme.textTheme.titleSmall?.copyWith(color: theme.hintColor)),
          ]),
        ]),
      ),
    );
  }
}