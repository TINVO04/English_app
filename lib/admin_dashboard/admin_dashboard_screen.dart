import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'class_screen.dart';
import 'dashboard_screen.dart';
import 'room_screen.dart';
import 'student_screen.dart';
import 'teacher_screen.dart';
import 'tuition_screen.dart';

enum _AdminMenuAction { profile, settings, logout }

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const List<Map<String, dynamic>> _features = [
    {
      "title": "Quản lý học viên",
      "icon": Icons.school,
      "color": Colors.blue,
      "description": "Thêm mới, phân lớp và theo dõi tiến độ học tập."
    },
    {
      "title": "Quản lý giảng viên",
      "icon": Icons.person,
      "color": Colors.green,
      "description": "Quản trị hồ sơ, lịch dạy và hợp đồng giảng viên."
    },
    {
      "title": "Quản lý lớp học & môn học",
      "icon": Icons.class_,
      "color": Colors.orange,
      "description": "Tạo khóa học, mở lớp và xếp phòng học linh hoạt."
    },
    {
      "title": "Quản lý phòng học",
      "icon": Icons.meeting_room,
      "color": Colors.purple,
      "description": "Kiểm soát cơ sở vật chất, lịch sử dụng phòng học."
    },
    {
      "title": "Quản lý học phí & công nợ",
      "icon": Icons.payment,
      "color": Colors.redAccent,
      "description": "Theo dõi hóa đơn, thanh toán và nhắc công nợ."
    },
    {
      "title": "Quản lý chứng chỉ",
      "icon": Icons.card_membership,
      "color": Colors.teal,
      "description": "Xuất chứng chỉ và lưu trữ thông tin cấp phát."
    },
    {
      "title": "Báo cáo & Dashboard",
      "icon": Icons.bar_chart,
      "color": Colors.indigo,
      "description": "Tổng hợp số liệu doanh thu, lớp học và điểm danh."
    },
  ];

  static const List<Map<String, dynamic>> _quickStats = [
    {
      "label": "Học viên đang theo học",
      "value": "1.284",
      "icon": Icons.groups,
      "trend": "+8% so với tháng trước",
      "color": Color(0xFF4F8BFF),
    },
    {
      "label": "Giảng viên hoạt động",
      "value": "42",
      "icon": Icons.person_pin_circle,
      "trend": "+3 giảng viên mới",
      "color": Color(0xFF3BC67D),
    },
    {
      "label": "Lớp đang mở",
      "value": "28",
      "icon": Icons.meeting_room,
      "trend": "12 lớp khai giảng trong tuần",
      "color": Color(0xFFFFA63A),
    },
    {
      "label": "Tổng doanh thu",
      "value": "415 triệu",
      "icon": Icons.payments,
      "trend": "+12% so với quý trước",
      "color": Color(0xFF6C63FF),
    },
  ];

  static const List<Map<String, String>> _upcomingEvents = [
    {
      "title": "Hạn chót thu học phí khóa IELTS tháng 11",
      "date": "25/11/2024",
      "tag": "Học phí",
    },
    {
      "title": "Kiểm tra đầu vào học viên mới",
      "date": "27/11/2024",
      "tag": "Tuyển sinh",
    },
    {
      "title": "Báo cáo doanh thu quý IV",
      "date": "02/12/2024",
      "tag": "Báo cáo",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.space_dashboard, color: Colors.indigo),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Bảng điều khiển trung tâm",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Tổng quan quản trị Trung tâm Ngoại ngữ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: "Tìm kiếm",
            icon: const Icon(Icons.search, color: Colors.black87),
          ),
          const SizedBox(width: 4),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                tooltip: "Thông báo",
                icon: const Icon(Icons.notifications_none, color: Colors.black87),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          _buildAccountMenu(context),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final crossAxisCount = isWide ? 3 : (constraints.maxWidth > 650 ? 2 : 1);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(context, isWide),
                const SizedBox(height: 20),
                _buildQuickStats(isWide),
                const SizedBox(height: 24),
                Text(
                  "Chức năng quản trị",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  itemCount: _features.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isWide ? 1.3 : 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final feature = _features[index];
                    return _buildFeatureCard(context, feature);
                  },
                ),
                const SizedBox(height: 28),
                _buildUpcomingEvents(context, isWide),
              ],
            ),
          );
        },
      ),
    );
  }

  PopupMenuButton<_AdminMenuAction> _buildAccountMenu(BuildContext context) {
    return PopupMenuButton<_AdminMenuAction>(
      tooltip: "Tài khoản quản trị",
      offset: const Offset(0, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) => _handleMenuSelection(context, value),
      itemBuilder: (context) => [
        PopupMenuItem<_AdminMenuAction>(
          value: _AdminMenuAction.profile,
          child: Row(
            children: const [
              Icon(Icons.badge, color: Colors.indigo),
              SizedBox(width: 12),
              Text("Hồ sơ cá nhân"),
            ],
          ),
        ),
        PopupMenuItem<_AdminMenuAction>(
          value: _AdminMenuAction.settings,
          child: Row(
            children: const [
              Icon(Icons.settings, color: Colors.indigo),
              SizedBox(width: 12),
              Text("Thiết lập hệ thống"),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<_AdminMenuAction>(
          value: _AdminMenuAction.logout,
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 12),
              Text("Đăng xuất"),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF6C63FF).withOpacity(0.12),
            child: const Icon(Icons.person_outline, color: Color(0xFF6C63FF)),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Admin Center",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Quản trị viên",
                style: TextStyle(color: Colors.black54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
        ],
      ),
    );
  }

  Future<void> _handleMenuSelection(
    BuildContext context,
    _AdminMenuAction value,
  ) async {
    switch (value) {
      case _AdminMenuAction.profile:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tính năng hồ sơ đang được phát triển."),
          ),
        );
        break;
      case _AdminMenuAction.settings:
        showModalBottomSheet<void>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Thiết lập hệ thống",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.palette_outlined),
                    title: Text("Giao diện & chủ đề"),
                    subtitle: Text("Quản lý màu sắc, logo và thương hiệu"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.security_outlined),
                    title: Text("Bảo mật & phân quyền"),
                    subtitle: Text("Cấu hình vai trò, quyền truy cập"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.notifications_active_outlined),
                    title: Text("Thông báo & nhắc việc"),
                    subtitle: Text("Thiết lập kênh gửi thông báo"),
                  ),
                ],
              ),
            );
          },
        );
        break;
      case _AdminMenuAction.logout:
        await Supabase.instance.client.auth.signOut();
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
        break;
    }
  }

  Widget _buildWelcomeHeader(BuildContext context, bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F8BFF), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.admin_panel_settings, size: 38, color: Colors.white),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Chào mừng, Quản trị viên!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Theo dõi hoạt động tổng quan của trung tâm, quản lý học viên, lớp học, phòng học, chứng chỉ và báo cáo từ một nơi duy nhất.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (isWide)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4F55F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.addchart, size: 20),
                  label: const Text(
                    "Tạo báo cáo nhanh",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          if (!isWide) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4F55F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () {},
                icon: const Icon(Icons.addchart, size: 20),
                label: const Text(
                  "Tạo báo cáo nhanh",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildQuickStats(bool isWide) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _quickStats.map((stat) {
        final Color color = stat["color"] as Color;
        return Container(
          width: isWide ? 220 : double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(stat["icon"] as IconData, color: color, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    stat["value"] as String,
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                stat["label"] as String,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                stat["trend"] as String,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> feature) {
    return GestureDetector(
      onTap: () {
        // ✅ Điều hướng đến các màn hình tương ứng
        switch (feature["title"]) {
          case "Quản lý học viên":
            Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentScreen()));
            break;

          case "Quản lý giảng viên":
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherScreen()));
            break;

          case "Quản lý lớp học & môn học":
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassScreen()));
            break;

          case "Quản lý phòng học":
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomScreen()));
            break;

          case "Quản lý học phí & công nợ":
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TuitionScreen()));
            break;

          case "Báo cáo & Dashboard":
            Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
            break;

          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Tính năng '${feature['title']}' đang phát triển"),
                behavior: SnackBarBehavior.floating,
                backgroundColor: feature["color"],
              ),
            );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: feature["color"].withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: feature["color"].withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(feature["icon"] as IconData, size: 28, color: feature["color"] as Color),
              ),
              const SizedBox(height: 18),
              Text(
                feature["title"] as String,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  feature["description"] as String,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "Quản lý ngay",
                    style: TextStyle(
                      color: feature["color"] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 18, color: feature["color"] as Color),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, bool isWide) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 18, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.upcoming, color: Color(0xFF6C63FF)),
                SizedBox(width: 10),
                Text(
                  "Lịch & nhắc việc quan trọng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._upcomingEvents.map((event) {
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FB),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.event_note, color: Color(0xFF6C63FF)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event["title"]!,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  event["tag"]!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6C63FF),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                event["date"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz, color: Colors.black45),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
