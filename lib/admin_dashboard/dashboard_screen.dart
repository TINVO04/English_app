import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại Home
          },
        ),
        title: const Text(
          "Báo cáo & Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                today,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Thẻ thống kê ---
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard("Tổng học viên", "487", "+12 so với tháng trước", Colors.blueAccent),
                _buildStatCard("Số giáo viên", "18", "+2 so với tháng trước", Colors.green),
                _buildStatCard("Lớp học hoạt động", "32", "+5 so với tháng trước", Colors.orange),
                _buildStatCard("Doanh thu tháng này", "1.2M VNĐ", "+15% so với tháng trước", Colors.purple),
              ],
            ),

            const SizedBox(height: 25),
            const Text("Lớp học hôm nay", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildClassCard("English B1-01", "Ms. Sarah", "08:00 - 10:00", "P101", 25),
            _buildClassCard("IELTS Prep-02", "Mr. John", "10:30 - 12:30", "P102", 20),
            _buildClassCard("Business English", "Ms. Emily", "14:00 - 16:00", "P201", 19),
            _buildClassCard("TOEIC Advanced", "Mr. David", "18:30 - 20:30", "P103", 22),

            const SizedBox(height: 25),
            const Text("Nhắc nhở học phí", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPaymentReminder("Nguyễn Văn A", "English B1", "2,500,000 VNĐ", "15/10/2025", Colors.orange),
            _buildPaymentReminder("Trần Thị B", "IELTS Prep", "3,200,000 VNĐ", "18/10/2025", Colors.red),
            _buildPaymentReminder("Lê Văn C", "TOEIC", "2,800,000 VNĐ", "20/10/2025", Colors.orange),
          ],
        ),
      ),
    );
  }

  // --- Widget con: Thẻ thống kê ---
  Widget _buildStatCard(String title, String value, String subtitle, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // --- Widget con: Lớp học ---
  Widget _buildClassCard(String name, String teacher, String time, String room, int students) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.class_, color: Colors.blueAccent),
        title: Text(name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        subtitle: Text("$teacher • $time • $room", style: const TextStyle(color: Colors.black54)),
        trailing: Text("$students HV", style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  // --- Widget con: Nhắc học phí ---
  Widget _buildPaymentReminder(String name, String course, String amount, String date, Color color) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.payment, color: Colors.blueAccent),
        title: Text(name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        subtitle: Text(course, style: const TextStyle(color: Colors.black54)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
