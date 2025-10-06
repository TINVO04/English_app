import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/app/app_router.dart';
import 'package:my_app/features/teacher/domain/models.dart';
import 'package:my_app/features/teacher/widgets/recent_activity_tile.dart';
import 'package:my_app/features/teacher/widgets/task_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/constants/services/colors.dart';
import '../../../../core/config/constants/services/spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/home_header.dart';
import '../../../../shared/widgets/pill.dart';
import '../../data/teacher_home_service.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/today_class_card.dart';



class TeacherHomeScreen extends StatefulWidget {
  static const routeName = '/teacher-home';
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  late final TeacherHomeService _service;
  late Future<TeacherHomeSummary> _future;

  @override
  void initState() {
    super.initState();
    _service = TeacherHomeService();
    _future = _service.loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width > 420 ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: FutureBuilder<TeacherHomeSummary>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return _ErrorState(
                message: snap.error.toString(),
                onRetry: () => setState(() => _future = _service.loadSummary()),
              );
            }
            final data = snap.data!;
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(pad, 12, pad, 8),
                    child: const _Header(),
                  ),
                ),

                // Top stats (3 cards)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: Insets.section,
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.calendar_today_outlined,
                            value: '${data.classesToday}',
                            label: 'Số lớp hôm nay',
                            accent: AppColors.accentBlue, // xanh dương
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.people_outline,
                            value: '${data.totalStudents}',
                            label: 'Tổng học viên',
                            accent: AppColors.accentGreen, // xanh lá
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.workspace_premium_outlined,
                            value: data.rating.toStringAsFixed(1),
                            label: 'Đánh giá',
                            accent: const Color(0xFFF59E0B), // vàng/cam
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Actions title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: Insets.section,
                    child: Text('Tác vụ nhanh',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Quick Actions grid (fixed height items to avoid overflow)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: Insets.section,
                    child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 168, // chiều cao ổn định như ảnh
                      ),
                      children: [
                        QuickActionCard(
                          icon: Icons.menu_book_rounded,
                          title: 'Lớp của tôi',
                          subtitle: 'Quản lý lớp học',
                          accent: AppColors.accentBlue,
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.teacherClasses),
                        ),
                        QuickActionCard(
                          icon: Icons.people_outline,
                          title: 'Học viên của tôi',
                          subtitle: 'Xem tiến độ học viên',
                          accent: AppColors.accentGreen,
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.teacherStudents),
                        ),
                        QuickActionCard(
                          icon: Icons.fact_check_outlined,
                          title: 'Điểm danh',
                          subtitle: 'Ghi nhận chuyên cần',
                          accent: AppColors.accentPurple,
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.teacherAttendanceTracking),
                        ),
                        QuickActionCard(
                          icon: Icons.event_note_outlined,
                          title: 'Lịch dạy của tôi',
                          subtitle: 'Xem thời khoá biểu',
                          accent: AppColors.accentOrange,
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.teacherSchedule),
                        ),
                      ],
                    ),
                  ),
                ),

                // Today's Classes (card container + list + button)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: Insets.section,
                    child: SectionCard(
                      title: 'Các lớp hôm nay',
                      child: Column(
                        children: [
                          for (final c in data.todayClasses) ...[
                            TodayClassCard(item: c),
                            const SizedBox(height: AppSpacing.s12),
                          ],
                          AppButton.outlined(
                            text: 'Xem toàn bộ lịch',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Upcoming Tasks
                SliverToBoxAdapter(
                  child: Padding(
                    padding: Insets.section,
                    child: SectionCard(
                      title: 'Nhiệm vụ sắp tới',
                      child: Column(
                        children: [
                          const TaskCard(
                            color: Colors.red,
                            title: 'Chuẩn bị tài liệu cho lớp Tiếng Anh Thương mại',
                            subtitle: 'Hạn: Hôm nay 15:30',
                          ),
                          const SizedBox(height: AppSpacing.s10),
                          const TaskCard(
                            color: Colors.amber,
                            title: 'Chấm bài tập Unit 3',
                            subtitle: 'Hạn: Ngày mai',
                          ),
                          const SizedBox(height: AppSpacing.s10),
                          const TaskCard(
                            color: Colors.orange,
                            title: 'Nộp báo cáo tiến độ tháng',
                            subtitle: 'Hạn: 15/02',
                          ),
                          const SizedBox(height: AppSpacing.s12),
                          AppButton.outlined(
                            text: 'Xem tất cả nhiệm vụ',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                // Recent Activity
                SliverToBoxAdapter(
                  child: Padding(
                    padding: Insets.section,
                    child: SectionCard(
                      title: 'Hoạt động gần đây',
                      child: Column(
                        children: [
                          for (final a in data.recentActivity) ...[
                            RecentActivityTile(text: a.message, timestamp: a.at),
                            const SizedBox(height: AppSpacing.s8),
                          ],
                          if (data.recentActivity.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
                              child: Text('Chưa có hoạt động gần đây'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}

/// ===================== WIDGETS =====================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Supabase.instance.client.auth.currentUser;
    final name = Supabase.instance.client.auth.currentUser?.email?.split('@').first ?? 'Giáo viên';

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFE8F0FF),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'E',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3B82F6),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Xin Chào, ${_capitalize(name)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: const Color(0xFF111827),
                  )),
              Text(
                'Sẵn sàng cho lớp hôm nay chứ?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF374151),
            size: 24,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: Color(0xFF374151),
            size: 24,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color accent; // màu icon

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });

  // pha màu nhạt từ accent (t ≈ 0.85 -> rất nhạt)
  Color _pastel(Color c, [double t = .85]) => Color.lerp(c, Colors.white, t)!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor > 1.1 ? 1.1 : media.textScaleFactor;

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Container(
        constraints: const BoxConstraints(minHeight: 110),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // nền nhạt hơn icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _pastel(accent, .85), // nền icon = accent pha trắng
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 22), // icon màu đậm
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: const Color(0xFF6B7280),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor.clamp(1.0, 1.15); // chống overflow

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ô icon đậm + icon trắng (rounded square)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),

              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
                  height: 1.25,
                ),
              ),

              const Spacer(),

              // Nút “Open” full width, bo tròn
              AppButton.primary(
                text: 'Mở',
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.teacherClasses),
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _ClassRow extends StatelessWidget {
  final TodayClassItem item;
  const _ClassRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = '${DateFormat('HH:mm', 'vi_VN').format(item.start)} - '
        '${DateFormat('HH:mm', 'vi_VN').format(item.end)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F7),           // xám nhạt như mẫu
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng đầu: tiêu đề + 2 pill bên phải
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề 2 dòng tối đa
              Expanded(
                child: Text(
                  item.courseName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Pill bên phải, canh cuối
              Wrap(
                spacing: AppSpacing.s8,
                runSpacing: AppSpacing.s6,
                children: const [
                  Pill(text: 'sắp diễn ra'),
                  Pill(text: 'Điểm danh', bold: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Dòng thời gian + phòng (xám)
          Text(
            '$time · Room ${item.room}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),

          // Số học viên
          Text(
            '${item.studentCount} học viên',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}


class _Pill extends StatelessWidget {
  final String text;
  final bool bold;
  const _Pill({required this.text, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAction = text.toLowerCase().contains('attendance');
    // màu nền rất nhạt khác nhau nhẹ giữa 2 pill như mẫu
    final bg = isAction ? Colors.white : const Color(0xFFF8FAFC);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),   // outline mảnh
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }
}


class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 0,
            offset: Offset(0, 2),
            color: Color(0x11000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final double bgOpacity;

  const _TaskTile({
    required this.color,
    required this.title,
    required this.subtitle,
    this.bgOpacity = .1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,                       // full-width trong card
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(bgOpacity),      // nền pastel
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // vạch màu bên trái chạy suốt chiều cao
            Positioned.fill(
              left: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // nội dung
            Padding(
              padding: const EdgeInsets.only(left: 12), // chừa chỗ cho vạch màu
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ActivityLine extends StatelessWidget {
  final String text;
  final String timeAgo;

  const _ActivityLine({required this.text, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record,
              size: 8, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            timeAgo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _OutlineButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
