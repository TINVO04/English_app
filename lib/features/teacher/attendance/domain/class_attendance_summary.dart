import 'package:flutter/material.dart';

class ClassAttendanceSummary {
  final String classId; // lop_hoc.uid
  final String classTitle; // ví dụ: Tiếng Anh Trung Cấp - Nhóm B
  final String teacherName; // giao_vien.ten (hoặc nguoi_dung.ho_va_ten)
  final String room; // phong.so_phong
  final TimeOfDay start;
  final TimeOfDay end;
  final int total; // tổng sĩ số (COUNT(dang_ky WHERE trang_thai='da_dang_ky'))
  final int present;
  final int absent;
  final int late;
  final bool hasAttendance; // đã điểm danh ngày chọn hay chưa

  const ClassAttendanceSummary({
    required this.classId,
    required this.classTitle,
    required this.teacherName,
    required this.room,
    required this.start,
    required this.end,
    required this.total,
    required this.present,
    required this.absent,
    required this.late,
    required this.hasAttendance,
  });

  double get presentRate => total == 0 ? 0.0 : present / total;
}

String fmtTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
String fmtDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
