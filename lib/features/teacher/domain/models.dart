class TeacherHomeSummary {
  final int classesToday;
  final int totalStudents;
  final double rating;
  final List<TodayClassItem> todayClasses;
  final List<ActivityItem> recentActivity;

  TeacherHomeSummary({
    required this.classesToday,
    required this.totalStudents,
    required this.rating,
    required this.todayClasses,
    required this.recentActivity,
  });
}

class TodayClassItem {
  final String id;
  final String courseName; // tên lớp
  final String room;       // số phòng
  final DateTime start;
  final DateTime end;
  final int studentCount;

  TodayClassItem({
    required this.id,
    required this.courseName,
    required this.room,
    required this.start,
    required this.end,
    required this.studentCount,
  });
}

class ActivityItem {
  final String message;
  final DateTime at;

  ActivityItem({required this.message, required this.at});
}
