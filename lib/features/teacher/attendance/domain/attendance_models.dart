import 'package:flutter/material.dart';

enum AttendanceStatus { present, absent, late, excused }

class AttendanceHeaderInfo {
  final String classTitle; // ví dụ: Tiếng Anh Trung Cấp - Nhóm B
  final String teacherName;
  final TimeOfDay start; // từ lich_hoc.gio_bat_dau
  final TimeOfDay end;   // từ lich_hoc.gio_ket_thuc
  final String room;     // phong.so_phong
  const AttendanceHeaderInfo({
    required this.classTitle,
    required this.teacherName,
    required this.start,
    required this.end,
    required this.room,
  });
}

class StudentAttendance {
  final String id; // hoc_vien.uid / dang_ky.uid
  final String fullName; // nguoi_dung.ho_va_ten
  final DateTime? arrivedAt; // thời điểm đến lớp (mock)
  final String? note; // ghi chú (mock: "Traffic"...)
  AttendanceStatus status; // present | absent | late | excused

  StudentAttendance({
    required this.id,
    required this.fullName,
    required this.arrivedAt,
    required this.note,
    required this.status,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}

String fmtT(TimeOfDay t) {
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String fmtDT(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
