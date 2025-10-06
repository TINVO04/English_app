import 'package:flutter/material.dart';
/// Lớp học (tóm tắt) dùng cho màn "My Classes"
/// Dữ liệu này có thể map từ các bảng: lop_hoc, lich_hoc, phong,
/// dang_ky, diem_danh, diem, khoa_hoc.
class TeacherClassSummary {
  final String id; // lop_hoc.uid
  final String title; // ví dụ: "Intermediate English - Group B"
  final String levelTag; // ví dụ: "Intermediate", "Advanced"
  final bool isActive; // lop_hoc.trang_thai in ('mo','dang_dien_ra')
  final List<int> weekdays; // DateTime.monday..sunday - từ lich_hoc
  final TimeOfDay start; // lich_hoc.gio_bat_dau
  final TimeOfDay end; // lich_hoc.gio_ket_thuc
  final String room; // phong.so_phong
  final int students; // COUNT(dang_ky WHERE trang_thai='da_dang_ky')
  final int capacity; // lop_hoc.so_luong_toi_da
  final double courseProgress; // 0..1 – có thể suy từ (today - ngày_bắt_đầu)/(ngày_kết_thúc - ngày_bắt_đầu)
  final double attendanceRate; // 0..1 – AVG(co_mat)
  final double averageGrade; // 0..1 – TB(điểm/10)

  const TeacherClassSummary({
    required this.id,
    required this.title,
    required this.levelTag,
    required this.isActive,
    required this.weekdays,
    required this.start,
    required this.end,
    required this.room,
    required this.students,
    required this.capacity,
    required this.courseProgress,
    required this.attendanceRate,
    required this.averageGrade,
  });
}

String _weekdayShort(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'T2';
    case DateTime.tuesday:
      return 'T3';
    case DateTime.wednesday:
      return 'T4';
    case DateTime.thursday:
      return 'T5';
    case DateTime.friday:
      return 'T6';
    case DateTime.saturday:
      return 'T7';
    case DateTime.sunday:
      return 'CN';
  }
  return '';
}

String formatSchedule(List<int> weekdays, TimeOfDay start, TimeOfDay end) {
  final days = weekdays.map(_weekdayShort).join(', ');
  String fmt(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
  return '$days ${fmt(start)} - ${fmt(end)}';
}

