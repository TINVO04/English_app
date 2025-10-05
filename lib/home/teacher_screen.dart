import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Tất cả';

  final List<String> _statusFilters = [
    'Tất cả',
    'Đang làm việc',
    'Tạm nghỉ',
    'Thử việc',
  ];

  final List<Map<String, dynamic>> _teacherProfiles = [
    {
      'id': 'GV001',
      'name': 'Nguyễn Minh Anh',
      'degree': 'Thạc sĩ Giảng dạy tiếng Anh - University of Leeds',
      'phone': '0901 234 567',
      'email': 'minhanh.nguyen@edulink.vn',
      'specialties': ['IELTS Speaking', 'Academic Writing'],
      'experience': 8,
      'status': 'Đang làm việc',
      'weeklyHours': 24,
      'classCount': 3,
      'salary': 32.5,
      'hireDate': '15/02/2019',
      'lastUpdate': '20/10/2024',
      'score': 4.8,
      'avatarColor': const Color(0xFF4F46E5),
      'classes': <Map<String, String>>[
        {
          'name': 'IELTS Intensive K14',
          'slot': 'Thứ 2 - Thứ 4 | 18:00 - 20:00',
          'room': 'Phòng 402',
        },
        {
          'name': 'Academic Writing K08',
          'slot': 'Thứ 6 | 19:00 - 21:00',
          'room': 'Phòng 305',
        },
      ],
    },
    {
      'id': 'GV002',
      'name': 'Trần Gia Huy',
      'degree': 'CELTA - Cambridge Assessment & TESOL',
      'phone': '0903 456 789',
      'email': 'gia.huy@edulink.vn',
      'specialties': ['TOEIC', 'Business Communication'],
      'experience': 6,
      'status': 'Đang làm việc',
      'weeklyHours': 26,
      'classCount': 4,
      'salary': 28.0,
      'hireDate': '01/07/2020',
      'lastUpdate': '18/10/2024',
      'score': 4.6,
      'avatarColor': const Color(0xFF0EA5E9),
      'classes': <Map<String, String>>[
        {
          'name': 'TOEIC Foundation K21',
          'slot': 'Thứ 3 - Thứ 5 | 18:30 - 20:30',
          'room': 'Phòng 207',
        },
        {
          'name': 'Business English K05',
          'slot': 'Thứ 7 | 09:00 - 11:30',
          'room': 'Phòng 102',
        },
        {
          'name': 'Coaching 1:1',
          'slot': 'Thứ 5 | 14:00 - 16:00',
          'room': 'Meeting Room',
        },
      ],
    },
    {
      'id': 'GV003',
      'name': 'Phạm Thảo Linh',
      'degree': 'Thạc sĩ Ngôn ngữ học ứng dụng - Monash University',
      'phone': '0904 789 123',
      'email': 'thaolinh.pham@edulink.vn',
      'specialties': ['English for Kids', 'Pronunciation'],
      'experience': 5,
      'status': 'Thử việc',
      'weeklyHours': 18,
      'classCount': 2,
      'salary': 18.5,
      'hireDate': '05/08/2024',
      'lastUpdate': '19/10/2024',
      'score': 4.4,
      'avatarColor': const Color(0xFFF97316),
      'classes': <Map<String, String>>[
        {
          'name': 'Kids Explorer K03',
          'slot': 'Thứ 3 - Thứ 5 | 17:00 - 18:30',
          'room': 'Phòng 106',
        },
        {
          'name': 'Pronunciation Clinic',
          'slot': 'Chủ nhật | 10:00 - 12:00',
          'room': 'Phòng Studio',
        },
      ],
    },
    {
      'id': 'GV004',
      'name': 'Lê Quang Khải',
      'degree': 'TESOL - Arizona State University',
      'phone': '0908 555 777',
      'email': 'quangkhai.le@edulink.vn',
      'specialties': ['IELTS Reading', 'Academic Vocabulary'],
      'experience': 10,
      'status': 'Đang làm việc',
      'weeklyHours': 22,
      'classCount': 3,
      'salary': 30.0,
      'hireDate': '10/03/2017',
      'lastUpdate': '22/10/2024',
      'score': 4.9,
      'avatarColor': const Color(0xFF22C55E),
      'classes': <Map<String, String>>[
        {
          'name': 'IELTS Advanced K11',
          'slot': 'Thứ 2 - Thứ 4 | 19:00 - 21:00',
          'room': 'Phòng 409',
        },
        {
          'name': 'Từ vựng học thuật',
          'slot': 'Thứ 7 | 13:30 - 15:30',
          'room': 'Phòng 210',
        },
      ],
    },
    {
      'id': 'GV005',
      'name': 'Võ Hoài Phương',
      'degree': 'Giảng viên chính quy - Đại học Sư phạm TP.HCM',
      'phone': '0909 112 334',
      'email': 'hoaiphuong.vo@edulink.vn',
      'specialties': ['Communication', 'English Grammar'],
      'experience': 7,
      'status': 'Tạm nghỉ',
      'weeklyHours': 0,
      'classCount': 0,
      'salary': 0,
      'hireDate': '20/09/2018',
      'lastUpdate': '12/10/2024',
      'score': 4.2,
      'avatarColor': const Color(0xFF6366F1),
      'classes': const <Map<String, String>>[],
    },
  ];

  final List<Map<String, String>> _weeklySchedule = [
    {
      'course': 'IELTS Intensive K14',
      'teacher': 'Nguyễn Minh Anh',
      'time': 'Thứ 2 | 21/10 | 18:00 - 20:00',
      'room': 'Phòng 402',
      'status': 'Đang diễn ra',
    },
    {
      'course': 'Business English K05',
      'teacher': 'Trần Gia Huy',
      'time': 'Thứ 7 | 26/10 | 09:00 - 11:30',
      'room': 'Phòng 102',
      'status': 'Chuẩn bị mở',
    },
    {
      'course': 'Kids Explorer K03',
      'teacher': 'Phạm Thảo Linh',
      'time': 'Thứ 5 | 24/10 | 17:00 - 18:30',
      'room': 'Phòng 106',
      'status': 'Cần hỗ trợ trợ giảng',
    },
  ];

  final List<Map<String, String>> _alerts = [
    {
      'title': 'Giảng viên tạm nghỉ',
      'description':
          'Võ Hoài Phương đã xin tạm nghỉ đến 30/10. Cần phân bổ lớp Grammar căn cứ bảng lịch.',
      'type': 'warning',
    },
    {
      'title': 'Bổ sung chứng chỉ',
      'description':
          'Phạm Thảo Linh cần cập nhật chứng chỉ TESOL để hoàn thiện hồ sơ thử việc.',
      'type': 'info',
    },
    {
      'title': 'Cảnh báo lịch dạy dày',
      'description':
          'Trần Gia Huy đang đảm nhận 26 giờ/tuần và 4 lớp. Cân nhắc giảm tải hoặc hỗ trợ trợ giảng.',
      'type': 'alert',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTeachers = _teacherProfiles.where((teacher) {
      final matchesStatus =
          _selectedStatus == 'Tất cả' || teacher['status'] == _selectedStatus;
      return matchesStatus && _matchesSearch(teacher);
    }).toList();

    final totalTeachers = _teacherProfiles.length;
    final activeTeachers =
        _teacherProfiles.where((t) => t['status'] == 'Đang làm việc').length;
    final onLeaveTeachers =
        _teacherProfiles.where((t) => t['status'] == 'Tạm nghỉ').length;
    final totalClasses =
        _teacherProfiles.fold<int>(0, (sum, t) => sum + (t['classCount'] as int));
    final totalHours = _teacherProfiles.fold<int>(
        0, (sum, t) => sum + (t['weeklyHours'] as int));
    final avgScore = _teacherProfiles.isEmpty
        ? 0
        : _teacherProfiles
                .fold<double>(0, (sum, t) => sum + (t['score'] as double)) /
            _teacherProfiles.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quản lý giảng viên',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Theo dõi hồ sơ, lịch dạy và năng lực đào tạo',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.cloudArrowDown, color: Color(0xFF4F46E5)),
            tooltip: 'Xuất báo cáo giảng viên',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4F46E5),
        icon: const FaIcon(FontAwesomeIcons.userPlus),
        label: const Text('Thêm giảng viên'),
        onPressed: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewSection(
                totalTeachers: totalTeachers,
                activeTeachers: activeTeachers,
                onLeaveTeachers: onLeaveTeachers,
                totalClasses: totalClasses,
                totalHours: totalHours,
                avgScore: avgScore,
              ),
              const SizedBox(height: 20),
              _buildSearchAndFilter(),
              const SizedBox(height: 20),
              _buildActionShortcuts(),
              const SizedBox(height: 20),
              _buildTeacherList(filteredTeachers),
              const SizedBox(height: 20),
              _buildScheduleSection(),
              const SizedBox(height: 20),
              _buildAlertSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection({
    required int totalTeachers,
    required int activeTeachers,
    required int onLeaveTeachers,
    required int totalClasses,
    required int totalHours,
    required double avgScore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tổng quan đội ngũ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildStatCard(
              color: const Color(0xFF4F46E5),
              icon: FontAwesomeIcons.userGroup,
              label: 'Tổng giảng viên',
              value: totalTeachers.toString(),
              subtitle: '$activeTeachers đang hoạt động',
            ),
            _buildStatCard(
              color: const Color(0xFF0EA5E9),
              icon: FontAwesomeIcons.bookOpenReader,
              label: 'Lớp đang phụ trách',
              value: totalClasses.toString(),
              subtitle: '$totalHours giờ dạy/tuần',
            ),
            _buildStatCard(
              color: const Color(0xFF22C55E),
              icon: FontAwesomeIcons.star,
              label: 'Mức độ hài lòng',
              value: '${avgScore.toStringAsFixed(1)}/5',
              subtitle: 'Dựa trên phản hồi học viên',
            ),
            _buildStatCard(
              color: const Color(0xFFF97316),
              icon: FontAwesomeIcons.userClock,
              label: 'Tạm nghỉ & thử việc',
              value: '${onLeaveTeachers + _countProbation()} GV',
              subtitle: '$onLeaveTeachers tạm nghỉ · ${_countProbation()} thử việc',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required Color color,
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            offset: const Offset(0, 12),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: FaIcon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo tên, mã hoặc chuyên môn...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.sliders, color: Colors.white, size: 18),
                tooltip: 'Bộ lọc nâng cao',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _statusFilters
              .map(
                (status) => ChoiceChip(
                  label: Text(status),
                  labelStyle: TextStyle(
                    color: _selectedStatus == status ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  selected: _selectedStatus == status,
                  onSelected: (_) => setState(() => _selectedStatus = status),
                  selectedColor: const Color(0xFF4F46E5),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: _selectedStatus == status
                          ? const Color(0xFF4F46E5)
                          : const Color(0xFFE0E7FF),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionShortcuts() {
    final shortcuts = [
      {
        'icon': FontAwesomeIcons.calendarCheck,
        'label': 'Xếp lịch dạy',
        'color': const Color(0xFF6366F1),
      },
      {
        'icon': FontAwesomeIcons.solidFileLines,
        'label': 'Quy chế & hợp đồng',
        'color': const Color(0xFFEC4899),
      },
      {
        'icon': FontAwesomeIcons.userShield,
        'label': 'Quyền truy cập LMS',
        'color': const Color(0xFF14B8A6),
      },
      {
        'icon': FontAwesomeIcons.chartSimple,
        'label': 'Đánh giá định kỳ',
        'color': const Color(0xFFF97316),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tác vụ nhanh',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: shortcuts
                .map(
                  (item) => Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (item['color'] as Color).withOpacity(0.18),
                          offset: const Offset(0, 12),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: FaIcon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Thiết lập dựa trên dữ liệu bảng `giao_vien`, `lop_hoc`, `yeu_cau_khoa_hoc`. ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherList(List<Map<String, dynamic>> teachers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hồ sơ giảng viên',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              '${teachers.length} kết quả',
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...teachers.map(_buildTeacherCard),
      ],
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    final color = teacher['avatarColor'] as Color;
    final status = teacher['status'] as String;
    final classes = teacher['classes'] as List<Map<String, String>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            offset: Offset(0, 16),
            blurRadius: 32,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: color.withOpacity(0.15),
                  child: FaIcon(
                    FontAwesomeIcons.userGraduate,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              teacher['name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _buildStatusChip(status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${teacher['id']} • ${teacher['degree']}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (teacher['specialties'] as List<String>)
                            .map(
                              (skill) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  skill,
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoPill(
                  icon: FontAwesomeIcons.phone,
                  label: teacher['phone'] as String,
                ),
                const SizedBox(width: 12),
                _buildInfoPill(
                  icon: FontAwesomeIcons.envelope,
                  label: teacher['email'] as String,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    icon: FontAwesomeIcons.briefcase,
                    title: 'Kinh nghiệm',
                    value: '${teacher['experience']} năm',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    icon: FontAwesomeIcons.coins,
                    title: 'Thu nhập dự kiến',
                    value: teacher['salary'] == 0
                        ? 'Đang cập nhật'
                        : '${(teacher['salary'] as double).toStringAsFixed(1)} triệu',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    icon: FontAwesomeIcons.clock,
                    title: 'Tải giảng dạy',
                    value: '${teacher['weeklyHours']}h/tuần · ${teacher['classCount']} lớp',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.calendarDay, size: 16, color: Color(0xFF4F46E5)),
                      const SizedBox(width: 8),
                      Text(
                        'Lịch lớp đang phụ trách (${classes.length})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (classes.isEmpty)
                    const Text(
                      'Giảng viên đang tạm nghỉ. Kiểm tra bảng `lop_hoc` để phân bổ lớp mới.',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    )
                  else
                    Column(
                      children: classes
                          .map(
                            (cls) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.chalkboardUser,
                                        size: 16,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cls['name']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          cls['slot']!,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          cls['room']!,
                                          style: const TextStyle(
                                            color: Color(0xFF4F46E5),
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hồ sơ cập nhật: ${teacher['lastUpdate']}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12.5),
                ),
                Row(
                  children: [
                    Text(
                      'Điểm đánh giá: ${(teacher['score'] as double).toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: Color(0xFFF97316),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const FaIcon(FontAwesomeIcons.solidStar, color: Color(0xFFF97316), size: 14),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4F46E5),
                    side: const BorderSide(color: Color(0xFF4F46E5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 14),
                  label: const Text('Cập nhật hồ sơ'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.solidCircleInfo, size: 14),
                  label: const Text('Chi tiết đào tạo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, size: 16, color: const Color(0xFF4F46E5)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E7FF)),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 14, color: const Color(0xFF4F46E5)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lịch giảng dạy trong tuần',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ..._weeklySchedule.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0E7FF)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.calendarDays, color: Color(0xFF4F46E5), size: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['course']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['time']!,
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['teacher']} • ${item['room']}',
                        style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildScheduleBadge(item['status']!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cảnh báo & gợi ý điều phối',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ..._alerts.map(
          (alert) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _alertBackground(alert['type']!),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _alertBorder(alert['type']!)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: FaIcon(
                      _alertIcon(alert['type']!),
                      color: _alertColor(alert['type']!),
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _alertColor(alert['type']!),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert['description']!,
                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleBadge(String status) {
    Color color;
    switch (status) {
      case 'Đang diễn ra':
        color = const Color(0xFF22C55E);
        break;
      case 'Chuẩn bị mở':
        color = const Color(0xFF0EA5E9);
        break;
      default:
        color = const Color(0xFFF97316);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Đang làm việc':
        return const Color(0xFF22C55E);
      case 'Tạm nghỉ':
        return const Color(0xFFF97316);
      case 'Thử việc':
        return const Color(0xFF0EA5E9);
      default:
        return Colors.grey;
    }
  }

  int _countProbation() =>
      _teacherProfiles.where((t) => t['status'] == 'Thử việc').length;

  bool _matchesSearch(Map<String, dynamic> teacher) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return true;

    final searchPool = [
      teacher['id'],
      teacher['name'],
      teacher['email'],
      teacher['phone'],
      teacher['degree'],
      ...(teacher['specialties'] as List<String>),
    ];

    return searchPool.any((element) =>
        element.toString().toLowerCase().contains(query));
  }

  IconData _alertIcon(String type) {
    switch (type) {
      case 'warning':
        return FontAwesomeIcons.triangleExclamation;
      case 'alert':
        return FontAwesomeIcons.circleExclamation;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Color _alertColor(String type) {
    switch (type) {
      case 'warning':
        return const Color(0xFFF97316);
      case 'alert':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF2563EB);
    }
  }

  Color _alertBackground(String type) => _alertColor(type).withOpacity(0.08);

  Color _alertBorder(String type) => _alertColor(type).withOpacity(0.4);
}
