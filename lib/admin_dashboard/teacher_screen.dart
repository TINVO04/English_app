import 'package:flutter/material.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teachers = [
      {
        "id": "GV001",
        "name": "Ms. Sarah Johnson",
        "phone": "0901111111",
        "email": "sarah.johnson@educenter.com",
        "specialty": "English Grammar, IELTS Speaking",
        "experience": "8 năm",
        "schedule": "25h/tuần\n2 lớp",
        "status": "Đang làm việc",
        "date": "15/10/2020"
      },
      {
        "id": "GV002",
        "name": "Mr. John Smith",
        "phone": "0902222222",
        "email": "john.smith@educenter.com",
        "specialty": "IELTS Writing, Academic English",
        "experience": "12 năm",
        "schedule": "28h/tuần\n2 lớp",
        "status": "Đang làm việc",
        "date": "18/07/2018"
      },
      {
        "id": "GV003",
        "name": "Ms. Emily Davis",
        "phone": "0903333333",
        "email": "emily.davis@educenter.com",
        "specialty": "Business English, Conversation",
        "experience": "5 năm",
        "schedule": "22h/tuần\n2 lớp",
        "status": "Đang làm việc",
        "date": "13/03/2022"
      },
      {
        "id": "GV004",
        "name": "Mr. David Wilson",
        "phone": "0904444444",
        "email": "david.wilson@educenter.com",
        "specialty": "TOEIC, English Grammar",
        "experience": "7 năm",
        "schedule": "24h/tuần\n2 lớp",
        "status": "Đang làm việc",
        "date": "16/09/2021"
      },
      {
        "id": "GV005",
        "name": "Ms. Lisa Anderson",
        "phone": "0905555555",
        "email": "lisa.anderson@educenter.com",
        "specialty": "English for Kids, Elementary English",
        "experience": "6 năm",
        "schedule": "0h/tuần\n0 lớp",
        "status": "Tạm nghỉ",
        "date": "15/09/2021"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quản lý giáo viên",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // Quay lại Home
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/admin');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Thêm giáo viên"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),

      // ✅ Dùng SingleChildScrollView tránh tràn màn hình
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Danh sách giáo viên",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: "🔍 Tìm kiếm giáo viên...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Không cần Expanded, vì đã dùng ScrollView
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final t = teachers[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${t['id']} - ${t['name']}",
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text("📞 ${t['phone']} | ✉️ ${t['email']}"),
                            Text("Chuyên môn: ${t['specialty']}"),
                            Text("Kinh nghiệm: ${t['experience']}"),
                            Text("Lịch dạy: ${t['schedule']}"),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t['status']!,
                                  style: TextStyle(
                                    color: _getStatusColor(t['status']!),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blueAccent),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Đang làm việc":
        return Colors.green;
      case "Tạm nghỉ":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
