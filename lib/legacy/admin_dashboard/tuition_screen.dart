import 'package:flutter/material.dart';

class TuitionScreen extends StatelessWidget {
  const TuitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      {
        "name": "Nguyễn Văn An",
        "course": "English B1",
        "total": "2.500.000",
        "paid": "2.500.000",
        "remain": "0",
        "dueDate": "10/11/2025",
        "status": "Đã thanh toán"
      },
      {
        "name": "Trần Thị Bình",
        "course": "IELTS Prep",
        "total": "3.200.000",
        "paid": "1.600.000",
        "remain": "1.600.000",
        "dueDate": "15/10/2025",
        "status": "Thanh toán một phần"
      },
      {
        "name": "Lê Văn Cường",
        "course": "TOEIC Advanced",
        "total": "2.800.000",
        "paid": "1.400.000",
        "remain": "1.400.000",
        "dueDate": "30/09/2025",
        "status": "Quá hạn"
      },
      {
        "name": "Phạm Thị Dung",
        "course": "English A2",
        "total": "2.000.000",
        "paid": "2.000.000",
        "remain": "0",
        "dueDate": "01/03/2025",
        "status": "Đã thanh toán"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Quản lý học phí & Công nợ",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.file_download_outlined),
              label: const Text("Xuất báo cáo"),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Ghi nhận thanh toán"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Theo dõi thanh toán và công nợ học viên",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // 🔸 Thống kê tổng quan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Doanh thu tháng", "7.7M VND", "+1.2%",
                      Icons.monetization_on, Colors.green),
                  _buildStatCard(
                      "Công nợ", "6.5M VND", "3 học viên", Icons.warning_amber,
                      Colors.orange),
                  _buildStatCard(
                      "Quá hạn", "1", "Cần xử lý", Icons.error, Colors.redAccent),
                  _buildStatCard("Đã thanh toán", "2", "Hoàn thành",
                      Icons.check_circle, Colors.blueAccent),
                ],
              ),

              const SizedBox(height: 20),

              // 🔸 Tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Danh sách học phí",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(
                            width: 220,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "🔍 Tìm kiếm học viên...",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔸 Bảng danh sách học viên
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Học viên")),
                          DataColumn(label: Text("Khóa học")),
                          DataColumn(label: Text("Tổng học phí")),
                          DataColumn(label: Text("Đã thanh toán")),
                          DataColumn(label: Text("Còn lại")),
                          DataColumn(label: Text("Hạn thanh toán")),
                          DataColumn(label: Text("Trạng thái")),
                          DataColumn(label: Text("Thao tác")),
                        ],
                        rows: students.map((s) {
                          return DataRow(cells: [
                            DataCell(Text(s['name'] as String)),
                            DataCell(Text(s['course'] as String)),
                            DataCell(Text("${s['total']} VND")),
                            DataCell(Text("${s['paid']} VND",
                                style: const TextStyle(color: Colors.green))),
                            DataCell(Text(
                                "${s['remain']} VND",
                                style: TextStyle(
                                    color: (s['remain'] != "0")
                                        ? Colors.redAccent
                                        : Colors.grey))),
                            DataCell(Text(s['dueDate'] as String)),
                            DataCell(_buildStatusTag(s['status'] as String)),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.remove_red_eye,
                                        color: Colors.grey),
                                    onPressed: () {}),
                                IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {}),
                                IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {}),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            Text(title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case "Đã thanh toán":
        bgColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case "Thanh toán một phần":
        bgColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case "Quá hạn":
        bgColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      default:
        bgColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}
