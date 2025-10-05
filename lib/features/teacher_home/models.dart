import 'package:flutter/material.dart';

class TeacherOverviewStat {
  const TeacherOverviewStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class QuickActionItem {
  const QuickActionItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
}

class TeacherClassSession {
  const TeacherClassSession({
    required this.courseName,
    required this.level,
    required this.time,
    required this.room,
    required this.status,
    this.students,
  });

  final String courseName;
  final String level;
  final String time;
  final String room;
  final String status;
  final int? students;
}

class UpcomingTask {
  const UpcomingTask({
    required this.title,
    required this.dueDate,
    required this.note,
    required this.color,
  });

  final String title;
  final String dueDate;
  final String note;
  final Color color;
}

class RecentActivity {
  const RecentActivity({
    required this.content,
    required this.timeAgo,
    required this.icon,
    required this.color,
  });

  final String content;
  final String timeAgo;
  final IconData icon;
  final Color color;
}

class TeacherHomeData {
  TeacherHomeData()
      : overviewStats = const [
          TeacherOverviewStat(
            label: 'Lớp đang dạy',
            value: '3',
            icon: Icons.class_,
            color: Color(0xFF4F46E5),
          ),
          TeacherOverviewStat(
            label: 'Học viên phụ trách',
            value: '42',
            icon: Icons.people_alt_rounded,
            color: Color(0xFF16A34A),
          ),
          TeacherOverviewStat(
            label: 'Tỷ lệ đánh giá',
            value: '4.8',
            icon: Icons.star_rounded,
            color: Color(0xFFF97316),
          ),
        ],
        quickActions = [
          QuickActionItem(
            title: 'Lớp học của tôi',
            description: 'Quản lý và cập nhật tiến độ lớp',
            icon: Icons.menu_book_rounded,
            color: const Color(0xFF6366F1),
          ),
          QuickActionItem(
            title: 'Học viên',
            description: 'Theo dõi tình trạng từng học viên',
            icon: Icons.group_rounded,
            color: const Color(0xFF0EA5E9),
          ),
          QuickActionItem(
            title: 'Điểm danh',
            description: 'Ghi nhận chuyên cần theo buổi',
            icon: Icons.fact_check_rounded,
            color: const Color(0xFFF59E0B),
          ),
          QuickActionItem(
            title: 'Lịch giảng dạy',
            description: 'Xem toàn bộ lịch dạy trong tuần',
            icon: Icons.calendar_month_rounded,
            color: const Color(0xFF10B981),
          ),
        ],
        todayClasses = const [
          TeacherClassSession(
            courseName: 'Tiếng Anh Doanh Nghiệp',
            level: 'Nhóm B',
            time: '09:00 - 10:30',
            room: 'Phòng 201',
            status: 'sắp diễn ra',
            students: 12,
          ),
          TeacherClassSession(
            courseName: 'IELTS Chiến Lược',
            level: 'Nhóm A',
            time: '13:30 - 15:30',
            room: 'Phòng 305',
            status: 'đang học',
            students: 16,
          ),
          TeacherClassSession(
            courseName: 'Giao Tiếp Chuyên Nghiệp',
            level: 'Cấp độ Trung Cấp',
            time: '18:00 - 19:30',
            room: 'Studio 02',
            status: 'chuẩn bị',
            students: 10,
          ),
        ],
        upcomingTasks = const [
          UpcomingTask(
            title: 'Chuẩn bị giáo án cho lớp Doanh nghiệp',
            dueDate: 'Hạn: hôm nay - 15:30',
            note: 'Hoàn thiện slide và bài tập thực hành',
            color: Color(0xFF6366F1),
          ),
          UpcomingTask(
            title: 'Chấm bài tập IELTS - Nhóm A',
            dueDate: 'Hạn: ngày mai',
            note: 'Cần phản hồi chi tiết cho từng học viên',
            color: Color(0xFFF97316),
          ),
          UpcomingTask(
            title: 'Cập nhật báo cáo chuyên cần tuần 6',
            dueDate: 'Hạn: Thứ Sáu',
            note: 'Đối chiếu với ngưỡng điểm danh lớp',
            color: Color(0xFF0EA5E9),
          ),
        ],
        recentActivities = const [
          RecentActivity(
            content: '12 học viên hoàn thành bài tập Unit 3',
            timeAgo: '30 phút trước',
            icon: Icons.assignment_turned_in_rounded,
            color: Color(0xFF6366F1),
          ),
          RecentActivity(
            content: 'Nguyễn Minh Anh được nâng cấp độ Intermediate',
            timeAgo: '2 giờ trước',
            icon: Icons.trending_up_rounded,
            color: Color(0xFF10B981),
          ),
          RecentActivity(
            content: 'Điểm danh lớp IELTS Nhóm A đã hoàn tất',
            timeAgo: 'Hôm qua',
            icon: Icons.fact_check_rounded,
            color: Color(0xFFF59E0B),
          ),
          RecentActivity(
            content: 'Phản hồi mới từ học viên: 4.9/5',
            timeAgo: '2 ngày trước',
            icon: Icons.feedback_rounded,
            color: Color(0xFF0EA5E9),
          ),
        ];

  final List<TeacherOverviewStat> overviewStats;
  final List<QuickActionItem> quickActions;
  final List<TeacherClassSession> todayClasses;
  final List<UpcomingTask> upcomingTasks;
  final List<RecentActivity> recentActivities;
}
