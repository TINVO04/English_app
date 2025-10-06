import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/students/domain/data/teacher_students_repository.dart';
import 'package:my_app/features/teacher/students/domain/presentation/widgets/student_card.dart';
import 'package:my_app/features/teacher/students/domain/student_summary.dart';

class TeacherStudentsPage extends StatefulWidget {
  const TeacherStudentsPage({super.key});
  @override
  State<TeacherStudentsPage> createState() => _TeacherStudentsPageState();
}

class _TeacherStudentsPageState extends State<TeacherStudentsPage> with SingleTickerProviderStateMixin {
  final repo = TeacherStudentsRepository();
  late Future<List<StudentSummary>> _future;

  String _query = '';
  String _selectedClass = 'Tất cả lớp';

  @override
  void initState() {
    super.initState();
    _future = repo.fetchForTeacher('teacher-uid-demo');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).maybePop()),
        title: const Text('Học viên của tôi'),
      ),
      body: FutureBuilder<List<StudentSummary>>(
        future: _future,
        builder: (context, snap) {
          final loading = snap.connectionState != ConnectionState.done;
          final all = snap.data ?? const <StudentSummary>[];

          // Lọc theo tên & lớp
          final classes = ['Tất cả lớp', ...{for (final s in all) s.classTitle}];
          final byClass = _selectedClass == 'Tất cả lớp' ? all : all.where((s) => s.classTitle == _selectedClass).toList();
          final filtered = _query.isEmpty
              ? byClass
              : byClass.where((s) => s.fullName.toLowerCase().contains(_query.toLowerCase())).toList();

          // Thống kê đầu trang
          final excellentCount = all.where((e) => e.statusTag == 'Xuất sắc').length;
          final needHelpCount = all.where((e) => e.statusTag == 'Cần hỗ trợ').length;
          final avgGrade = all.isEmpty
              ? 0.0
              : all.map((e) => e.grade).reduce((a, b) => a + b) / all.length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    _TopBox(value: excellentCount.toString(), label: 'Xuất sắc'),
                    const SizedBox(width: 12),
                    _TopBox(value: needHelpCount.toString(), label: 'Cần hỗ trợ'),
                    const SizedBox(width: 12),
                    _TopBox(value: pct(avgGrade), label: 'Điểm TB'),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm học viên…',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    isDense: true,
                  ),
                ),
              ),

              // Class filter chips (scroll ngang)
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: classes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final label = classes[i];
                    final selected = label == _selectedClass;
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedClass = label),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => StudentCard(
                    data: filtered[i],
                    onTap: () {},
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopBox extends StatelessWidget {
  final String value;
  final String label;
  const _TopBox({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}