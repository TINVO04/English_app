import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      {
        "id": "HV001",
        "name": "Nguyễn Văn An",
        "phone": "0901234567",
        "email": "an.van@email.com",
        "class": "English B1-01",
        "level": "B1",
        "status": "Đang học",
        "tuition": "2.500.000 / 2.500.000 VNĐ",
        "tuitionStatus": "Đã đóng",
        "date": "15/12/2025"
      },
      {
        "id": "HV002",
        "name": "Trần Thị Bình",
        "phone": "0907654321",
        "email": "thi.binh@email.com",
        "class": "IELTS Prep-02",
        "level": "IELTS",
        "status": "Đang học",
        "tuition": "1.600.000 / 3.200.000 VNĐ",
        "tuitionStatus": "Chờ đóng",
        "date": "12/02/2025"
      },
      {
        "id": "HV003",
        "name": "Lê Văn Cường",
        "phone": "0912345678",
        "email": "van.cuong@email.com",
        "class": "TOEIC Advanced",
        "level": "TOEIC",
        "status": "Đang học",
        "tuition": "1.400.000 / 2.800.000 VNĐ",
        "tuitionStatus": "Quá hạn",
        "date": "01/03/2025"
      },
      {
        "id": "HV004",
        "name": "Phạm Thị Dung",
        "phone": "0932456789",
        "email": "thi.dung@email.com",
        "class": "English A2-03",
        "level": "A2",
        "status": "Đang học",
        "tuition": "2.200.000 / 2.200.000 VNĐ",
        "tuitionStatus": "Đã đóng",
        "date": "13/03/2025"
      },
      {
        "id": "HV005",
        "name": "Hoàng Văn Em",
        "phone": "0934567890",
        "email": "van.em@email.com",
        "class": "Business English",
        "level": "Business",
        "status": "Đã tốt nghiệp",
        "tuition": "3.500.000 / 3.500.000 VNĐ",
        "tuitionStatus": "Đã đóng",
        "date": "15/11/2024"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quản lý học viên",
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
              label: const Text("Thêm học viên"),
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Danh sách học viên",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: "🔍 Tìm kiếm học viên...",
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách học viên
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final s = students[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text("${s['id']} - ${s['name']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${s['class']} (${s['level']})"),
                          Text("Trạng thái: ${s['status']}"),
                          Text("Học phí: ${s['tuition']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s['tuitionStatus'] as String,
                            style: TextStyle(
                              color: _getTuitionColor(s['tuitionStatus'] as String),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(icon: Icon(Icons.edit, color: Colors.blueAccent), onPressed: () {}),
                          IconButton(icon: Icon(Icons.delete, color: Colors.redAccent), onPressed: () {}),
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
    );
  }

  Color _getTuitionColor(String status) {
    switch (status) {
      case "Đã đóng":
        return Colors.green;
      case "Chờ đóng":
        return Colors.orange;
      case "Quá hạn":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
