import 'package:flutter/material.dart';

import '../student_summary.dart';

class TeacherStudentsRepository {
  Future<List<StudentSummary>> fetchForTeacher(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      StudentSummary(
        id: 'hv-001',
        fullName: 'Nguyễn Minh Anh',
        classTitle: 'Tiếng Anh Trung Cấp - Nhóm B',
        statusTag: 'Xuất sắc',
        trendUp: true,
        grade: 0.88,
        attendance: 0.95,
        courseProgress: 0.85,
      ),
      StudentSummary(
        id: 'hv-002',
        fullName: 'Trần Quốc Bảo',
        classTitle: 'Tiếng Anh Thương Mại - Nâng Cao',
        statusTag: 'Xuất sắc',
        trendUp: true,
        grade: 0.94,
        attendance: 0.98,
        courseProgress: 0.92,
      ),
      StudentSummary(
        id: 'hv-003',
        fullName: 'Phạm Thu Giang',
        classTitle: 'Tiếng Anh Trung Cấp - Nhóm B',
        statusTag: 'Cần hỗ trợ',
        trendUp: false,
        grade: 0.62,
        attendance: 0.74,
        courseProgress: 0.56,
      ),
      StudentSummary(
        id: 'hv-004',
        fullName: 'Lê Hải Nam',
        classTitle: 'Tiếng Anh Thương Mại - Nâng Cao',
        statusTag: 'Ổn định',
        trendUp: true,
        grade: 0.78,
        attendance: 0.88,
        courseProgress: 0.63,
      ),
      StudentSummary(
        id: 'hv-005',
        fullName: 'Đặng Khánh Vy',
        classTitle: 'Luyện thi IELTS - Nhóm A',
        statusTag: 'Xuất sắc',
        trendUp: true,
        grade: 0.91,
        attendance: 0.93,
        courseProgress: 0.71,
      ),
      StudentSummary(
        id: 'hv-006',
        fullName: 'Bùi Đức Long',
        classTitle: 'Tiếng Anh Trung Cấp - Nhóm B',
        statusTag: 'Cần hỗ trợ',
        trendUp: false,
        grade: 0.58,
        attendance: 0.69,
        courseProgress: 0.47,
      ),
    ];
  }
}
