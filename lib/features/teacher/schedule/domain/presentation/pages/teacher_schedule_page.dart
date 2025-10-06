import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/schedule/domain/schedule_models.dart';
import '../../data/teacher_schedule_repository.dart';
import '../widgets/schedule_event_card.dart';

class TeacherSchedulePage extends StatefulWidget {
  const TeacherSchedulePage({super.key});
  @override
  State<TeacherSchedulePage> createState() => _TeacherSchedulePageState();
}

class _TeacherSchedulePageState extends State<TeacherSchedulePage> with SingleTickerProviderStateMixin {
  final repo = TeacherScheduleRepository();
  late final TabController _tabCtrl;
  DateTime anchor = DateTime.now();

  late Future<DaySchedule> _dailyFuture;
  late Future<(List<WeekDaySummary>, WeekAggregate)> _weeklyFuture;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() { if (mounted) setState(() {}); });
    _dailyFuture = repo.fetchDaily('teacher-uid-demo', anchor);
    _weeklyFuture = repo.fetchWeekly('teacher-uid-demo', anchor);
  }
  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _shift(int delta) {
    setState(() {
      if (_tabCtrl.index == 0) { // tab 0: Theo ngày
        anchor = anchor.add(Duration(days: delta));
        _dailyFuture = repo.fetchDaily('teacher-uid-demo', anchor);
      } else {                    // tab 1: Theo tuần
        anchor = anchor.add(Duration(days: 7 * delta));
        _weeklyFuture = repo.fetchWeekly('teacher-uid-demo', anchor);
      }
    });
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
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Lịch dạy của tôi'),
            Text(fmtHeaderDate(anchor), style: theme.textTheme.bodySmall),
          ],
        ),
      ),

      body: Column(children: [
        // Segmented control Daily / Weekly
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withOpacity(.5)),
            ),
            child: TabBar(
              controller: _tabCtrl,
              indicator: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.1), // 👈 hiệu ứng giống Classes
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: theme.colorScheme.onSurface,
              tabs: const [
                Tab(text: 'Theo ngày'),  // 🇻🇳
                Tab(text: 'Theo tuần'),  // 🇻🇳
              ],
            ),
          ),
        ),

        // Date navigator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            _navBtn(Icons.chevron_left, () => _shift(-1)),
            const Spacer(),
            Text(
              _tabCtrl.index == 0 ? fmtDateFull(anchor) : 'Tuần của ${fmtDateFull(anchor)}',
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            _navBtn(Icons.chevron_right, () => _shift(1)),
          ]),
        ),

        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _DailyList(future: _dailyFuture),
              _WeeklyList(future: _weeklyFuture),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) => IconButton.filledTonal(
    onPressed: onTap,
    icon: Icon(icon),
  );
}

// ---------------- Daily list ----------------
class _DailyList extends StatelessWidget {
  final Future<DaySchedule> future;
  const _DailyList({required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DaySchedule>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snap.data!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text('Lịch hôm nay', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            for (final e in data.events) ScheduleEventCard(e: e),
          ],
        );
      },
    );
  }
}

// ---------------- Weekly list ----------------
class _WeeklyList extends StatelessWidget {
  final Future<(List<WeekDaySummary>, WeekAggregate)> future;
  const _WeeklyList({required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(List<WeekDaySummary>, WeekAggregate)>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final (days, agg) = snap.data!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text('Tuần này', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            for (final d in days) _WeekDayTile(d: d),
            const SizedBox(height: 16),
            _WeekSummary(agg: agg),
          ],
        );
      },
    );
  }
}

class _WeekDayTile extends StatelessWidget {
  final WeekDaySummary d;
  const _WeekDayTile({required this.d});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRest = d.classesCount == 0;
    final weekdayName = ['Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy','Chủ Nhật'][d.date.weekday - 1];    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(.4)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(weekdayName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            if (!isRest)
              Text('${fmtTime(d.spanStart)} - ${fmtTime(d.spanEnd)}', style: theme.textTheme.bodySmall)
            else
              Text('Nghỉ', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isRest ? Colors.grey.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(isRest ? 'Không có lớp' : d.classesCount.toString()),
            const SizedBox(width: 4),
            Text('lớp', style: theme.textTheme.bodySmall),
          ]),
        )
      ]),
    );
  }
}

class _WeekSummary extends StatelessWidget {
  final WeekAggregate agg;
  const _WeekSummary({required this.agg});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget cell(String value, String label) => Column(children: [
      Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text(label, style: theme.textTheme.bodySmall),
    ]);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Tổng kết tuần', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          cell('${agg.totalClasses}', 'Tổng buổi'),
          cell('${agg.teachingHours}', 'Giờ giảng'),
          cell('${agg.totalStudents}', 'Tổng học viên'),
        ]),
      ]),
    );
  }
}