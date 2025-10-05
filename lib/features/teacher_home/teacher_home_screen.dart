import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models.dart';
import 'widgets/overview_stat_card.dart';
import 'widgets/quick_action_card.dart';
import 'widgets/recent_activity_tile.dart';
import 'widgets/task_card.dart';
import 'widgets/today_class_card.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = TeacherHomeData();
    final now = DateTime.now();
    final greeting = _greetingMessage(now.hour);
    final dateText = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Text(
                              'EC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '$greeting, Emily',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sẵn sàng cho lớp học hôm nay chứ?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                transform: Matrix4.translationValues(0, 24, 0),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: Color(0xFF6366F1)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            dateText,
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '3 lớp hôm nay',
                            style: TextStyle(
                              color: Color(0xFF4338CA),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            sliver: SliverList.list(
              children: [
                Text(
                  'Tổng quan nhanh',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: data.overviewStats.length,
                  itemBuilder: (context, index) => OverviewStatCard(stat: data.overviewStats[index]),
                ),
                const SizedBox(height: 28),
                Text(
                  'Tác vụ nhanh',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: data.quickActions.length,
                  itemBuilder: (context, index) => QuickActionCard(action: data.quickActions[index]),
                ),
                const SizedBox(height: 28),
                _SectionHeader(
                  title: 'Lớp học trong ngày',
                  actionLabel: 'Xem lịch',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ...data.todayClasses.map((session) => TodayClassCard(session: session)),
                const SizedBox(height: 28),
                _SectionHeader(
                  title: 'Công việc sắp tới',
                  actionLabel: 'Xem tất cả',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ...data.upcomingTasks.map((task) => UpcomingTaskCard(task: task)),
                const SizedBox(height: 28),
                _SectionHeader(
                  title: 'Hoạt động gần đây',
                  actionLabel: 'Chi tiết',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ...data.recentActivities.map((activity) => RecentActivityTile(activity: activity)),
                const SizedBox(height: 32),
                _FeedbackBanner(),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _greetingMessage(int hour) {
    if (hour < 11) return 'Chào buổi sáng';
    if (hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF111827),
                fontWeight: FontWeight.w800,
              ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6366F1),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cần hỗ trợ từ học vụ?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Liên hệ bộ phận hỗ trợ để được cập nhật tài liệu, phân bổ lớp mới hoặc điều chỉnh lịch dạy.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E293B),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Liên hệ ngay'),
          )
        ],
      ),
    );
  }
}
