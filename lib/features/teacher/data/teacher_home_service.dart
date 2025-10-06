
import '../domain/models.dart';

class TeacherHomeService {
  Future<TeacherHomeSummary> loadSummary() async {
    await Future.delayed(const Duration(milliseconds: 400)); // giả lập loading
    final now = DateTime.now();

    final todayClasses = <TodayClassItem>[
      TodayClassItem(
        id: 'c1',
        courseName: 'Tiếng Anh Trung cấp - Nhóm B',
        room: '201',
        start: DateTime(now.year, now.month, now.day, 14, 0),
        end: DateTime(now.year, now.month, now.day, 15, 30),
        studentCount: 12,
      ),
      TodayClassItem(
        id: 'c2',
        courseName: 'Tiếng Anh Thương mại - Nâng cao',
        room: '301',
        start: DateTime(now.year, now.month, now.day, 16, 0),
        end: DateTime(now.year, now.month, now.day, 17, 30),
        studentCount: 10,
      ),
      TodayClassItem(
        id: 'c3',
        courseName: 'Nhóm A',
        room: '201',
        start: DateTime(now.year, now.month, now.day, 18, 0),
        end: DateTime(now.year, now.month, now.day, 19, 30),
        studentCount: 15,
      ),
    ];

    final recent = <ActivityItem>[
      ActivityItem(
        message: '15 học viên đã nộp bài tập Unit 3',
        at: now.subtract(const Duration(hours: 2)),
      ),
      ActivityItem(
        message: 'Sarah Johnson đã hoàn thành trình độ Elementary',
        at: now.subtract(const Duration(hours: 4)),
      ),
      ActivityItem(
        message: 'Đã ghi nhận điểm danh cho Tiếng Anh Trung cấp - Nhóm B',
        at: now.subtract(const Duration(days: 1)),
      ),
      ActivityItem(
        message: 'Có phản hồi mới của học viên (4.9/5)',
        at: now.subtract(const Duration(days: 2)),
      ),
    ];

    return TeacherHomeSummary(
      classesToday: todayClasses.length,
      totalStudents: 42,
      rating: 4.8,
      todayClasses: todayClasses,
      recentActivity: recent,
    );
  }
}
