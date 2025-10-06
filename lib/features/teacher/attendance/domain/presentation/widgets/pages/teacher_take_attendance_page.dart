import 'package:flutter/material.dart';
import 'package:my_app/features/teacher/attendance/domain/attendance_models.dart';
import 'package:my_app/features/teacher/attendance/domain/data/teacher_attendance_repository.dart';
import 'package:my_app/features/teacher/attendance/domain/presentation/widgets/student_attendance_tile.dart';
import 'package:my_app/shared/widgets/app_button.dart';

class TeacherTakeAttendancePage extends StatefulWidget {
  final String classId;
  const TeacherTakeAttendancePage({super.key, required this.classId});

  @override
  State<TeacherTakeAttendancePage> createState() => _TeacherTakeAttendancePageState();
}

class _TeacherTakeAttendancePageState extends State<TeacherTakeAttendancePage> {
  final repo = TeacherAttendanceRepository();
  AttendanceHeaderInfo? header;
  List<StudentAttendance> items = [];
  String q = '';

  DateTime? selectedDate;      // <— ngày đang điểm danh (nhận từ arguments)
  bool dirty = false;          // <— có thay đổi?
  bool saving = false;         // <— đang lưu?
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['date'] is DateTime) {
      selectedDate = args['date'] as DateTime;
    }
  }


  Future<void> _load() async {
    final h = await repo.fetchHeader(widget.classId);
    final s = await repo.fetchStudents(widget.classId);
    setState(() { header = h; items = s; });
  }

  void _update(String id, AttendanceStatus s) {
    setState(() {
      final i = items.indexWhere((e) => e.id == id);
      if (i != -1 && items[i].status != s) {
        items[i].status = s;
        dirty = true; // có thay đổi -> bật nút Lưu
      }
    });
  }



  Future<void> _save() async {
    selectedDate ??= DateTime.now();
    setState(() => saving = true);
    try {
      await repo.saveAttendance(widget.classId, selectedDate!, items);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu điểm danh')),
        );
        setState(() => dirty = false);
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final h = header;
    final theme = Theme.of(context);

    // Stats
    int present = items.where((e) => e.status == AttendanceStatus.present).length;
    int absent = items.where((e) => e.status == AttendanceStatus.absent).length;
    int late = items.where((e) => e.status == AttendanceStatus.late).length;

    final list = q.isEmpty
        ? items
        : items.where((e) => e.fullName.toLowerCase().contains(q.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        // Hiển thị tiêu đề + subtitle là tên lớp
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Điểm danh'),
            if (header != null)
              Text(
                header!.classTitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),

      body: h == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(.4)),
                color: theme.colorScheme.surface,
              ),
              child: _HeaderInfoTable(h: h),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(children: [
              _TopStat(value: present.toString(), label: 'Có mặt',  color: Colors.green.shade700),
              const SizedBox(width: 12),
              _TopStat(value: absent.toString(),  label: 'Vắng',    color: Colors.red.shade700),
              const SizedBox(width: 12),
              _TopStat(value: late.toString(),    label: 'Đi muộn', color: Colors.orange.shade700),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              onChanged: (v) => setState(() => q = v),
              decoration: InputDecoration(
                hintText: 'Tìm học viên…',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              // chừa đáy thêm chút để nút thoáng, tôn trọng SafeArea
              padding: EdgeInsets.fromLTRB(
                16, 4, 16,
                MediaQuery.of(context).padding.bottom + 24,
              ),
              itemCount: list.length + 1, // +1 cho nút Lưu ở cuối
              itemBuilder: (context, i) {
                if (i == list.length) {
                  // phần tử CUỐI: nút Save Attendance
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: AppButton.primary(
                      text: 'Save Attendance',
                      onPressed: dirty
                          ? () {
                        // demo: chưa nối API
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Demo: nút Lưu chưa kết nối API.')),
                        );
                        setState(() => dirty = false); // reset để nút mờ lại
                      }
                          : null, // mờ khi chưa thay đổi
                    ),
                  );
                }

                final item = list[i];
                return StudentAttendanceTile(
                  data: item,
                  onChanged: (s) => _update(item.id, s),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderInfoTable extends StatelessWidget {
  final AttendanceHeaderInfo h;
  const _HeaderInfoTable({required this.h});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor);
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);

    TableRow row(String l, String v) => TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(l, style: labelStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              v,
              style: valueStyle,
              softWrap: false,                    // không xuống dòng
              overflow: TextOverflow.ellipsis,    // nếu quá dài thì “…” bên phải
            ),
          ),
        ),
      ],
    );

    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),  // cột nhãn đủ rộng theo nội dung
        1: FlexColumnWidth(),       // cột giá trị co giãn
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        row('Giảng viên:', h.teacherName),
        row('Thời gian:', '${fmtT(h.start)} - ${fmtT(h.end)}'),
        row('Phòng:', h.room),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label; final String value;
  const _InfoLine({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _TopStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _TopStat({required this.value, required this.label, required this.color});

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
            Text(value, style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
