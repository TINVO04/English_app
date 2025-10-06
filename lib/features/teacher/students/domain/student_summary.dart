import 'package:flutter/material.dart';

class StudentSummary {
  final String id; // hoc_vien.uid
  final String fullName; // nguoi_dung.ho_va_ten
  final String classTitle; // lop_hoc / khoa_hoc
  final String statusTag; // "Xuất sắc" | "Cần hỗ trợ" | "Ổn định" ...
  final bool trendUp; // hiển thị mũi tên xu hướng
  final double grade; // 0..1 – TB(điểm)/10
  final double attendance; // 0..1 – AVG(co_mat)
  final double courseProgress; // 0..1

  const StudentSummary({
    required this.id,
    required this.fullName,
    required this.classTitle,
    required this.statusTag,
    required this.trendUp,
    required this.grade,
    required this.attendance,
    required this.courseProgress,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}

// Helper formatters
String pct(double v) => '${(v * 100).round()}%';
