import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/auth_screen.dart';
import '../features/teacher/attendance/domain/presentation/widgets/pages/attendance_tracking_page.dart';
import '../features/teacher/attendance/domain/presentation/widgets/pages/teacher_take_attendance_page.dart';
import '../features/teacher/presentation/pages/teacher_home_page.dart';
import 'package:my_app/features/teacher/classes/presentation/pages/teacher_classes_page.dart';

import '../features/teacher/schedule/domain/presentation/pages/teacher_schedule_page.dart';
import '../features/teacher/students/domain/presentation/widgets/pages/teacher_students_page.dart';


/// Tên route sử dụng trong toàn app
class AppRoutes {
  static const String auth = '/auth';
  static const String teacherHome = '/teacher-home';
  static const teacherClasses = '/teacher-classes';
  static const teacherStudents = '/teacher-students';
  static const teacherAttendanceTracking = '/attendance-tracking';
  static const teacherTakeAttendance = '/teacher-take-attendance';
  static const teacherSchedule = '/teacher-schedule';
}

/// AppRouter cung cấp onGenerateRoute mà App đang gọi
class AppRouter {
  AppRouter();

  /// Khai báo bảng routes
  Map<String, WidgetBuilder> get routes => {
    AppRoutes.auth: (_) => const LoginScreen(),
    AppRoutes.teacherHome: (_) => const TeacherHomeScreen(),
    AppRoutes.teacherClasses: (_) => const TeacherClassesPage(),
    AppRoutes.teacherStudents: (_) => const TeacherStudentsPage(),
    AppRoutes.teacherAttendanceTracking: (_) => const AttendanceTrackingPage(),
    AppRoutes.teacherTakeAttendance: (_) => const TeacherTakeAttendancePage(classId: 'lop-001'),
    AppRoutes.teacherSchedule: (_) => const TeacherSchedulePage(),

  };

  /// Dùng trong MaterialApp.onGenerateRoute
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name] ?? routes[AppRoutes.auth]!;
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
