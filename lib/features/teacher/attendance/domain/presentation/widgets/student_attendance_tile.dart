import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/attendance_models.dart';
import 'attendance_action_bar.dart';
import 'status_chip.dart';

class StudentAttendanceTile extends StatelessWidget {
  final StudentAttendance data;
  final ValueChanged<AttendanceStatus> onChanged;
  const StudentAttendanceTile({super.key, required this.data, required this.onChanged});

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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, child: Text(data.initials, style: const TextStyle(fontWeight: FontWeight.w700))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(data.fullName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  if (data.arrivedAt != null)
                    Text(
                      'Đến lúc: ${fmtDT(data.arrivedAt!)}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (data.note != null)
                    Text(
                      'Ghi chú: ${data.note!}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                ]),
              ),

              StatusChip(data.status),
            ],
          ),
          const SizedBox(height: 12),
          AttendanceActionBar(value: data.status, onChanged: onChanged),
        ],
      ),
    );
  }
}
