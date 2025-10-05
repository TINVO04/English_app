import 'package:flutter/material.dart';
import 'package:my_app/home/class_screen.dart';
import 'package:my_app/home/room_screen.dart';
import 'package:my_app/home/teacher_screen.dart';
import 'package:my_app/home/tuition_screen.dart';
import 'student_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> _features = const [
    {"title": "Quản lý học viên", "icon": Icons.school, "color": Colors.blue},
    {"title": "Quản lý giảng viên", "icon": Icons.person, "color": Colors.green},
    {"title": "Quản lý lớp học & môn học", "icon": Icons.class_, "color": Colors.orange},
    {"title": "Quản lý phòng học", "icon": Icons.meeting_room, "color": Colors.purple},
    {"title": "Quản lý học phí & công nợ", "icon": Icons.payment, "color": Colors.redAccent},
    {"title": "Quản lý chứng chỉ", "icon": Icons.card_membership, "color": Colors.teal},
    {"title": "Báo cáo & Dashboard", "icon": Icons.bar_chart, "color": Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Hệ thống quản lý Trung tâm Ngoại ngữ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final feature = _features[index];
            return _buildFeatureCard(context, feature);
          },
        ),
      ),
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
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: feature["color"].withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: feature["color"].withOpacity(0.15),
                  child: Icon(feature["icon"], size: 36, color: feature["color"]),
                ),
                const SizedBox(height: 12),
                Text(
                  feature["title"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
