import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/class_attendance_summary.dart';

class AttendanceTrackingRepository {
  Future<List<ClassAttendanceSummary>> fetchForTeacherOnDate(String teacherId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return const [
      ClassAttendanceSummary(
        classId: 'lop-001',
        classTitle: 'Tiếng Anh Trung Cấp - Nhóm B',
        teacherName: 'Emily Chen',
        room: 'Phòng 201',
        start: TimeOfDay(hour: 14, minute: 0),
        end: TimeOfDay(hour: 15, minute: 30),
        total: 12,
        present: 10,
        absent: 1,
        late: 1,
        hasAttendance: true,
      ),
      ClassAttendanceSummary(
        classId: 'lop-002',
        classTitle: 'Advanced Conversation',
        teacherName: 'David Miller',
        room: 'Phòng 105',
        start: TimeOfDay(hour: 15, minute: 45),
        end: TimeOfDay(hour: 17, minute: 15),
        total: 8,
        present: 7,
        absent: 1,
        late: 0,
        hasAttendance: true,
      ),
      ClassAttendanceSummary(
        classId: 'lop-003',
        classTitle: 'Tiếng Anh Sơ Cấp - Nhóm A',
        teacherName: 'Lisa Park',
        room: 'Phòng 203',
        start: TimeOfDay(hour: 18, minute: 0),
        end: TimeOfDay(hour: 19, minute: 30),
        total: 15,
        present: 0,
        absent: 0,
        late: 0,
        hasAttendance: false,
      ),
    ];
  }
}