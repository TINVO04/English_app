import 'package:flutter/material.dart';
import '../../domain/data/teacher_classes_repository.dart';
import '../../domain/teacher_class.dart';
import '../widgets/class_card.dart';

class TeacherClassesPage extends StatefulWidget {
  const TeacherClassesPage({super.key});
  @override
  State<TeacherClassesPage> createState() => _TeacherClassesPageState();
}

class _TeacherClassesPageState extends State<TeacherClassesPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final repo = TeacherClassesRepository();
  late Future<List<TeacherClassSummary>> _future;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _future = repo.fetchForTeacher('teacher-uid-demo');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).maybePop()),
        title: const Text('Lớp của tôi'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder<List<TeacherClassSummary>>(
        future: _future,
        builder: (context, snapshot) {
          final loading = snapshot.connectionState != ConnectionState.done;
          final data = snapshot.data ?? const <TeacherClassSummary>[];

          final active = data.where((e) => e.isActive).toList();
          final completed = data.where((e) => !e.isActive).toList();

          final totalStudents = data.fold<int>(0, (sum, e) => sum + e.students);

          return Column(
            children: [
              // Top stats
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    _TopStat(value: active.length.toString(), label: 'Đang học'),
                    const SizedBox(width: 12),
                    _TopStat(value: completed.length.toString(), label: 'Đã hoàn thành'),
                    const SizedBox(width: 12),
                    _TopStat(value: totalStudents.toString(), label: 'Học Viên'),
                  ],
                ),
              ),

              // Segmented tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor.withOpacity(.5)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: theme.colorScheme.onSurface,
                    tabs: const [
                      Tab(text: 'Đang học'),
                      Tab(text: 'Đã hoàn thành'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                  controller: _tabController,
                  children: [
                    _ClassesList(items: active),
                    _ClassesList(items: completed),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopStat extends StatelessWidget {
  final String value;
  final String label;
  const _TopStat({required this.value, required this.label});
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

class _ClassesList extends StatelessWidget {
  final List<TeacherClassSummary> items;
  const _ClassesList({required this.items});
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Chưa có lớp'));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: items.length,
      itemBuilder: (context, i) => TeacherClassCard(
        data: items[i],
        onTap: () {},
      ),
    );
  }
}
