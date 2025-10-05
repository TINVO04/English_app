import 'package:flutter/material.dart';

class ClassScreen extends StatelessWidget {
  const ClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      {
        "id": "LH001",
        "name": "English B1-01",
        "teacher": "Ms. Sarah Johnson",
        "room": "P101",
        "students": "25/30",
        "schedule": "Thứ 2, 4, 6 - 08:00-10:00",
        "status": "Đang học",
      },
      {
        "id": "LH002",
        "name": "IELTS Prep-02",
        "teacher": "Mr. John Smith",
        "room": "P102",
        "students": "20/25",
        "schedule": "Thứ 3, 5, 7 - 14:00-16:00",
        "status": "Đang học",
      },
      {
        "id": "LH003",
        "name": "Business English",
        "teacher": "Ms. Emily Davis",
        "room": "P201",
        "students": "18/20",
        "schedule": "Thứ 2, 4 - 19:00-21:00",
        "status": "Đang học",
      },
      {
        "id": "LH004",
        "name": "TOEIC Advanced",
        "teacher": "Mr. David Wilson",
        "room": "P203",
        "students": "22/25",
        "schedule": "Thứ 7, CN - 09:00-11:00",
        "status": "Đang học",
      },
      {
        "id": "LH005",
        "name": "English A2-03",
        "teacher": "Ms. Lisa Anderson",
        "room": "P104",
        "students": "02/25",
        "schedule": "Thứ 4, 6 - 10:30-12:30",
        "status": "Sắp khai giảng",
      },
      {
        "id": "LH006",
        "name": "English B2-01",
        "teacher": "Ms. Sarah Johnson",
        "room": "P105",
        "students": "28/30",
        "schedule": "Thứ 3, 5 - 18:30-20:30",
        "status": "Đã kết thúc",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quản lý lớp học",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Tạo lớp học mới"),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Danh sách lớp học",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "🔍 Tìm kiếm lớp học...",
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

              // Danh sách lớp học
              Expanded(
                child: ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final c = classes[index];
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
                              "${c['id']} - ${c['name']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Giáo viên: ${c['teacher']}"),
                            Text("Phòng học: ${c['room']}"),
                            Text("Sĩ số: ${c['students']}"),
                            Text("Lịch học: ${c['schedule']}"),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  c['status']!,
                                  style: TextStyle(
                                    color: _getStatusColor(c['status']!),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Đang học":
        return Colors.green;
      case "Sắp khai giảng":
        return Colors.orange;
      case "Đã kết thúc":
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}
