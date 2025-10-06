import 'package:flutter/material.dart';

import '../teacher_class.dart';

class TeacherClassesRepository {
  Future<List<TeacherClassSummary>> fetchForTeacher(String teacherId) async {
    // Giả lập độ trễ
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      TeacherClassSummary(
        id: 'lop-001',
        title: 'Tiếng Anh Trung Cấp - Nhóm B',
        levelTag: 'Trung cấp',
        isActive: true,
        weekdays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
        start: TimeOfDay(hour: 14, minute: 0),
        end: TimeOfDay(hour: 15, minute: 30),
        room: 'Phòng 201',
        students: 12,
        capacity: 15,
        courseProgress: 0.65,
        attendanceRate: 0.88,
        averageGrade: 0.84,
      ),
      TeacherClassSummary(
        id: 'lop-002',
        title: 'Tiếng Anh Thương Mại - Nâng Cao',
        levelTag: 'Nâng cao',
        isActive: true,
        weekdays: [DateTime.tuesday, DateTime.thursday],
        start: TimeOfDay(hour: 16, minute: 0),
        end: TimeOfDay(hour: 17, minute: 30),
        room: 'Phòng 301',
        students: 8,
        capacity: 10,
        courseProgress: 0.42,
        attendanceRate: 0.90,
        averageGrade: 0.79,
      ),
      TeacherClassSummary(
        id: 'lop-003',
        title: 'Luyện thi IELTS - Nhóm A',
        levelTag: 'Trung cấp',
        isActive: false, // Completed
        weekdays: [DateTime.tuesday, DateTime.friday],
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 10, minute: 30),
        room: 'Phòng 105',
        students: 17,
        capacity: 18,
        courseProgress: 1.0,
        attendanceRate: 0.91,
        averageGrade: 0.86,
      ),
    ];
  }
}
