import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/schedule/domain/schedule_models.dart';

class TeacherScheduleRepository {
  // Daily
  Future<DaySchedule> fetchDaily(String teacherId, DateTime day) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final d = DateTime(day.year, day.month, day.day);

    final events = <ScheduleEvent>[
      const ScheduleEvent(
        id: 'prep',
        kind: EventKind.prep,
        title: 'Chuẩn bị bài giảng',
        start: TimeOfDay(hour: 13, minute: 30),
        end: TimeOfDay(hour: 14, minute: 0),
        room: 'Văn phòng',
      ),
      const ScheduleEvent(
        id: 'class-1',
        kind: EventKind.classSession,
        title: 'Tiếng Anh Trung Cấp - Nhóm B',
        levelTag: 'Trung cấp',
        start: TimeOfDay(hour: 14, minute: 0),
        end: TimeOfDay(hour: 15, minute: 30),
        room: 'Phòng 201',
        students: 12,
      ),
      const ScheduleEvent(
        id: 'break',
        kind: EventKind.breakTime,
        title: 'Giải lao',
        start: TimeOfDay(hour: 15, minute: 30),
        end: TimeOfDay(hour: 16, minute: 0),
      ),
      const ScheduleEvent(
        id: 'class-2',
        kind: EventKind.classSession,
        title: 'Tiếng Anh Thương Mại - Nâng Cao',
        levelTag: 'Nâng cao',
        start: TimeOfDay(hour: 16, minute: 0),
        end: TimeOfDay(hour: 17, minute: 30),
        room: 'Phòng 301',
        students: 8,
      ),
      const ScheduleEvent(
        id: 'meet',
        kind: EventKind.meeting,
        title: 'Họp giáo viên',
        start: TimeOfDay(hour: 17, minute: 30),
        end: TimeOfDay(hour: 18, minute: 0),
        room: 'Phòng họp',
      ),
    ];

    return DaySchedule(date: d, events: events);
  }

  // Weekly – đơn giản hoá: trả 7 ngày bắt đầu từ Monday của tuần chứa [day]
  Future<(List<WeekDaySummary>, WeekAggregate)> fetchWeekly(String teacherId, DateTime day) async {
    await Future.delayed(const Duration(milliseconds: 260));
    DateTime monday = day.subtract(Duration(days: (day.weekday + 6) % 7));

    final summaries = <WeekDaySummary>[
      WeekDaySummary(date: monday, classesCount: 3, spanStart: const TimeOfDay(hour: 14, minute: 0), spanEnd: const TimeOfDay(hour: 19, minute: 30)),
      WeekDaySummary(date: monday.add(const Duration(days: 1)), classesCount: 2, spanStart: const TimeOfDay(hour: 16, minute: 0), spanEnd: const TimeOfDay(hour: 19, minute: 0)),
      WeekDaySummary(date: monday.add(const Duration(days: 2)), classesCount: 3, spanStart: const TimeOfDay(hour: 14, minute: 0), spanEnd: const TimeOfDay(hour: 19, minute: 30)),
      WeekDaySummary(date: monday.add(const Duration(days: 3)), classesCount: 2, spanStart: const TimeOfDay(hour: 16, minute: 0), spanEnd: const TimeOfDay(hour: 19, minute: 0)),
      WeekDaySummary(date: monday.add(const Duration(days: 4)), classesCount: 3, spanStart: const TimeOfDay(hour: 14, minute: 0), spanEnd: const TimeOfDay(hour: 19, minute: 30)),
      WeekDaySummary(date: monday.add(const Duration(days: 5)), classesCount: 0, spanStart: const TimeOfDay(hour: 0, minute: 0), spanEnd: const TimeOfDay(hour: 0, minute: 0)),
      WeekDaySummary(date: monday.add(const Duration(days: 6)), classesCount: 0, spanStart: const TimeOfDay(hour: 0, minute: 0), spanEnd: const TimeOfDay(hour: 0, minute: 0)),
    ];

    // Tổng kết tuần – số liệu minh hoạ
    const totalClasses = 13;
    const teachingHours = 19.5; // số giờ giảng (tổng duration các lớp)
    const totalStudents = 37;    // tổng học viên phục vụ tuần đó

    return (summaries, const WeekAggregate(totalClasses: totalClasses, teachingHours: teachingHours, totalStudents: totalStudents));
  }
}