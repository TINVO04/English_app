import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/class_attendance_summary.dart';
import 'package:my_app/features/teacher/attendance/domain/data/attendance_tracking_repository.dart';
import 'package:my_app/features/teacher/attendance/domain/presentation/widgets/class_attendance_card.dart';
import '../pages/teacher_take_attendance_page.dart';

class AttendanceTrackingPage extends StatefulWidget {
  const AttendanceTrackingPage({super.key});
  @override
  State<AttendanceTrackingPage> createState() => _AttendanceTrackingPageState();
}

class _AttendanceTrackingPageState extends State<AttendanceTrackingPage> {
  final repo = AttendanceTrackingRepository();
  DateTime date = DateTime.now();
  late Future<List<ClassAttendanceSummary>> _future;

  @override
  void initState() {
    super.initState();
    _future = repo.fetchForTeacherOnDate('teacher-uid-demo', date);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        date = picked;
        _future = repo.fetchForTeacherOnDate('teacher-uid-demo', date);
      });
    }
  }

  void _openTakeOrUpdate(ClassAttendanceSummary c) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TeacherTakeAttendancePage(classId: c.classId),
        settings: RouteSettings(arguments: {'date': date}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Theo dõi điểm danh'),
            Text(
              'Chọn lớp để điểm danh',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),

      body: FutureBuilder<List<ClassAttendanceSummary>>(
        future: _future,
        builder: (context, snapshot) {
          final loading = snapshot.connectionState != ConnectionState.done;
          final data = snapshot.data ?? const <ClassAttendanceSummary>[];

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              // Date picker tile
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor.withOpacity(.4)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Ngày', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor.withOpacity(.5)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: 8),
                        Text(fmtDate(date), style: theme.textTheme.bodyLarge),
                        const Spacer(),
                        const Icon(Icons.date_range),
                      ]),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 16),
              Text('Lớp hôm nay', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),

              if (loading) const Center(child: Padding(padding: EdgeInsets.only(top: 24), child: CircularProgressIndicator())),
              if (!loading)
                for (final c in data)
                  ClassAttendanceCard(
                    data: c,
                    onTap: () => _openTakeOrUpdate(c),
                  ),
            ],
          );
        },
      ),
    );
  }
}