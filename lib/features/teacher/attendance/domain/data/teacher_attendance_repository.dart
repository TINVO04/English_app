import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/attendance_models.dart';

class TeacherAttendanceRepository {
  Future<AttendanceHeaderInfo> fetchHeader(String classId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const AttendanceHeaderInfo(
      classTitle: 'Tiếng Anh Trung Cấp - Nhóm B',
      teacherName: 'Emily Chen',
      start: TimeOfDay(hour: 14, minute: 0),
      end: TimeOfDay(hour: 15, minute: 30),
      room: 'Phòng 201',
    );
  }

  Future<List<StudentAttendance>> fetchStudents(String classId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return [
      StudentAttendance(
        id: 'hv-001',
        fullName: 'Sarah Johnson',
        arrivedAt: DateTime(now.year, now.month, now.day, 10, 46),
        note: null,
        status: AttendanceStatus.present,
      ),
      StudentAttendance(
        id: 'hv-002',
        fullName: 'Michael Chen',
        arrivedAt: DateTime(now.year, now.month, now.day, 14, 2),
        note: null,
        status: AttendanceStatus.present,
      ),
      StudentAttendance(
        id: 'hv-003',
        fullName: 'Emma Rodriguez',
        arrivedAt: DateTime(now.year, now.month, now.day, 14, 15),
        note: 'Tắc đường',
        status: AttendanceStatus.late,
      ),
      StudentAttendance(
        id: 'hv-004',
        fullName: 'Nguyễn Minh Anh',
        arrivedAt: null,
        note: null,
        status: AttendanceStatus.absent,
      ),
      StudentAttendance(
        id: 'hv-005',
        fullName: 'Trần Quốc Bảo',
        arrivedAt: null,
        note: 'Xin phép nghỉ',
        status: AttendanceStatus.excused,
      ),
    ];
  }
  Future<void> saveAttendance(String classId, DateTime date, List<StudentAttendance> items) async {
    // TODO: gọi Supabase ở đây khi nối thật
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
