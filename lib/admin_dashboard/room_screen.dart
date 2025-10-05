import 'package:flutter/material.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = [
      {
        "name": "Phòng 101",
        "floor": "Tầng 1 - 45 m²",
        "capacity": "30 chỗ",
        "equipment": ["Projector", "Whiteboard"],
        "usage": "10%",
        "status": "Đang sử dụng",
        "class": "English B1-01"
      },
      {
        "name": "Phòng 102",
        "floor": "Tầng 1 - 35 m²",
        "capacity": "25 chỗ",
        "equipment": ["Smart Board", "Air Conditioner"],
        "usage": "7%",
        "status": "Trống",
        "class": "-"
      },
      {
        "name": "Phòng 202",
        "floor": "Tầng 2 - 50 m²",
        "capacity": "30 chỗ",
        "equipment": ["Projector", "Smart TV"],
        "usage": "20%",
        "status": "Đang sử dụng",
        "class": "TOEIC Advanced"
      },
      {
        "name": "Phòng 301",
        "floor": "Tầng 3 - 15 m²",
        "capacity": "15 chỗ",
        "equipment": ["Smart TV", "Board"],
        "usage": "0%",
        "status": "Bảo trì",
        "class": "-"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Quản lý phòng học",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Thêm phòng học"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Cột bên trái
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quản lý phòng học và lịch sử dụng",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey, height: 1.5),
                      ),
                      const SizedBox(height: 16),

                      // 🔸 Các ô thống kê
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard("Tổng phòng", "6", Icons.meeting_room,
                              Colors.blueAccent),
                          _buildStatCard("Đang sử dụng", "3", Icons.play_circle,
                              Colors.green),
                          _buildStatCard("Sẵn sàng", "2", Icons.check_circle,
                              Colors.orange),
                          _buildStatCard("Bảo trì", "1", Icons.warning,
                              Colors.redAccent),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 🔸 Ô tìm kiếm
                      TextField(
                        decoration: InputDecoration(
                          hintText: "🔍 Tìm kiếm phòng học...",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔸 Danh sách phòng học
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          final r = rooms[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['name']! as String,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(r['floor']! as String,
                                      style:
                                      const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 6),
                                  Text("Sức chứa: ${r['capacity']}"),
                                  Text(
                                      "Thiết bị: ${(r['equipment'] as List).join(', ')}"),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tỷ lệ sử dụng: ${r['usage']}"),
                                      Text(
                                        r['status']! as String,
                                        style: TextStyle(
                                          color: _getStatusColor(r['status']! as String),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                  )
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

              const SizedBox(width: 16),

              // 🔹 Cột bên phải: Lịch hôm nay
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Lịch hôm nay",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text("05/10/2025",
                          style: TextStyle(color: Colors.grey)),
                      const Divider(),
                      _buildScheduleItem("08:00-10:00", "P101",
                          "English B1-01", "Ms. Sarah", "25 học viên", "Đang diễn ra"),
                      _buildScheduleItem("10:30-12:30", "P102",
                          "English A2-01", "Ms. Lisa", "20 học viên", "Sắp diễn ra"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            Text(title, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String time, String room, String course,
      String teacher, String students, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          Text("$room • $course"),
          Text("$teacher • $students",
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(status,
              style: TextStyle(
                  color: status == "Đang diễn ra"
                      ? Colors.green
                      : Colors.orangeAccent,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Đang sử dụng":
        return Colors.green;
      case "Trống":
        return Colors.orange;
      case "Bảo trì":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
