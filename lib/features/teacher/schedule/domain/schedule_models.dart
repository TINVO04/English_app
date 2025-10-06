import 'package:flutter/material.dart';

/// Loại sự kiện trong lịch dạy
enum EventKind { classSession, prep, breakTime, meeting }

/// Sự kiện / buổi trong ngày
class ScheduleEvent {
  final String id;
  final EventKind kind;
  final String title;           // Tên lớp / buổi
  final String? levelTag;       // Ví dụ: Trung cấp / Nâng cao (nếu là lớp)
  final TimeOfDay start;
  final TimeOfDay end;
  final String? room;           // Phòng nếu có
  final int? students;          // Sĩ số nếu có

  const ScheduleEvent({
    required this.id,
    required this.kind,
    required this.title,
    this.levelTag,
    required this.start,
    required this.end,
    this.room,
    this.students,
  });

  Duration get duration =>
      Duration(hours: end.hour - start.hour, minutes: end.minute - start.minute);
}

/// Lịch theo ngày
class DaySchedule {
  final DateTime date;
  final List<ScheduleEvent> events; // đã sắp xếp theo giờ
  const DaySchedule({required this.date, required this.events});
}

/// Tóm tắt 1 ngày trong tuần
class WeekDaySummary {
  final DateTime date;     // từng ngày trong tuần
  final int classesCount;  // số lớp trong ngày
  final TimeOfDay spanStart; // giờ bắt đầu trong ngày
  final TimeOfDay spanEnd;   // giờ kết thúc trong ngày
  const WeekDaySummary({
    required this.date,
    required this.classesCount,
    required this.spanStart,
    required this.spanEnd,
  });
}

/// Tổng hợp theo tuần
class WeekAggregate {
  final int totalClasses;      // tổng số buổi
  final double teachingHours;  // tổng giờ giảng (ví dụ 19.5 giờ)
  final int totalStudents;     // tổng học viên phục vụ
  const WeekAggregate({
    required this.totalClasses,
    required this.teachingHours,
    required this.totalStudents,
  });
}

/// Định dạng giờ: HH:mm
String fmtTime(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// Định dạng ngày rút gọn cho tiêu đề nhỏ: "Thứ Ba, 07/10"
String fmtDateFull(DateTime d) {
  const weekdaysVN = [
    'Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy','Chủ Nhật'
  ];
  final dow = weekdaysVN[d.weekday - 1];
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  return '$dow, $dd/$mm';
}

/// Định dạng ngày dài ở AppBar: "Thứ Ba, ngày 07 tháng 10, năm 2025"
String fmtHeaderDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString();
  return '$dd/$mm/$yyyy'; // -> 07/10/2025
}


/// Màu nền theo loại sự kiện
Color kindBg(EventKind k) => switch (k) {
  EventKind.prep         => const Color(0xFFFFF3E0), // cam nhạt
  EventKind.classSession => const Color(0xFFEAF1FF), // xanh dương nhạt
  EventKind.breakTime    => const Color(0xFFE8F5E9), // xanh lá nhạt
  EventKind.meeting      => const Color(0xFFF3E5F5), // tím nhạt
};

/// Màu viền theo loại sự kiện
Color kindBorder(EventKind k) => switch (k) {
  EventKind.prep         => const Color(0xFFFFA726),
  EventKind.classSession => const Color(0xFF3B82F6),
  EventKind.breakTime    => const Color(0xFF22C55E),
  EventKind.meeting      => const Color(0xFF8B5CF6),
};
