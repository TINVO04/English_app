import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/attendance_models.dart';


class StatusChip extends StatelessWidget {
  final AttendanceStatus status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    late Color bg; late Color fg; late IconData? icon;
    switch (status) {
      case AttendanceStatus.present:
        bg = Colors.green.shade100; fg = Colors.green.shade700; icon = Icons.check_circle_outline;
        break;
      case AttendanceStatus.absent:
        bg = Colors.red.shade100; fg = Colors.red.shade700; icon = Icons.cancel_outlined;
        break;
      case AttendanceStatus.late:
        bg = Colors.orange.shade100; fg = Colors.orange.shade700; icon = Icons.access_time;
        break;
      case AttendanceStatus.excused:
        bg = Colors.blueGrey.shade100; fg = Colors.blueGrey.shade700; icon = Icons.event_busy;
        break;
    }
    final label = switch (status) {
      AttendanceStatus.present => 'Có mặt',
      AttendanceStatus.absent => 'Vắng',
      AttendanceStatus.late => 'Đi muộn',
      AttendanceStatus.excused => 'Xin phép',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) Icon(icon, size: 16, color: fg),
        if (icon != null) const SizedBox(width: 6),
        Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
