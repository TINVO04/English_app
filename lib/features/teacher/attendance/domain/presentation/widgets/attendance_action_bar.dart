import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/attendance_models.dart';

class AttendanceActionBar extends StatelessWidget {
  final AttendanceStatus value;
  final ValueChanged<AttendanceStatus> onChanged;
  const AttendanceActionBar({super.key, required this.value, required this.onChanged});

  Widget _btn(BuildContext context, String label, AttendanceStatus s, {EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10)}) {
    final selected = value == s;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(.2)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChanged(s),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(context, 'Present', AttendanceStatus.present),
        const SizedBox(width: 8),
        _btn(context, 'Absent', AttendanceStatus.absent),
        const SizedBox(width: 8),
        _btn(context, 'Late', AttendanceStatus.late),
        const SizedBox(width: 8),
        _btn(context, 'Excused', AttendanceStatus.excused),
      ],
    );
  }
}
