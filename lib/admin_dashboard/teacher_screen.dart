import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'services/teacher_service.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final TeacherService _service = TeacherService();
  final TextEditingController _searchController = TextEditingController();
  final NumberFormat _currencyFormatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

  bool _isLoading = false;
  String? _errorMessage;
  String? _processingTeacherId;
  List<Teacher> _teachers = [];
  List<Teacher> _filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadTeachers();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final teachers = await _service.fetchTeachers();
      if (!mounted) return;
      setState(() {
        _teachers = teachers;
        _filteredTeachers = _filterTeachers(teachers, _searchController.text);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = _errorText(error, fallback: 'Không thể tải danh sách giáo viên.');
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredTeachers = _filterTeachers(_teachers, _searchController.text);
    });
  }

  List<Teacher> _filterTeachers(List<Teacher> source, String keyword) {
    final query = keyword.trim().toLowerCase();
    if (query.isEmpty) {
      return List<Teacher>.from(source);
    }

    return source.where((teacher) {
      final buffer = StringBuffer()
        ..write(teacher.ten)
        ..write(' ')
        ..write(teacher.hoVaTenHienThi)
        ..write(' ')
        ..write(teacher.trinhDo)
        ..write(' ')
        ..write(teacher.maNguoiDung)
        ..write(' ')
        ..write(teacher.accountEmail ?? '')
        ..write(' ')
        ..write(teacher.soDienThoaiHienThi ?? '');
      return buffer.toString().toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _openCreateTeacher() async {
    final teacher = await showModalBottomSheet<Teacher>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TeacherFormSheet(service: _service),
    );

    if (teacher != null && mounted) {
      setState(() {
        _teachers.removeWhere((element) => element.uid == teacher.uid);
        _teachers.insert(0, teacher);
        _filteredTeachers = _filterTeachers(_teachers, _searchController.text);
      });
      _showSnackBar('Thêm giáo viên thành công.');
    }
  }

  Future<void> _openEditTeacher(Teacher teacher) async {
    final updatedTeacher = await showModalBottomSheet<Teacher>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TeacherFormSheet(
        service: _service,
        teacher: teacher,
      ),
    );

    if (updatedTeacher != null && mounted) {
      setState(() {
        final index = _teachers.indexWhere((element) => element.uid == updatedTeacher.uid);
        if (index >= 0) {
          _teachers[index] = updatedTeacher;
        } else {
          _teachers.insert(0, updatedTeacher);
        }
        _filteredTeachers = _filterTeachers(_teachers, _searchController.text);
      });
      _showSnackBar('Cập nhật thông tin giáo viên thành công.');
    }
  }

  Future<void> _deleteTeacher(Teacher teacher) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xóa giáo viên'),
        content: Text(
          'Bạn có chắc chắn muốn xóa giảng viên "${teacher.hoVaTenHienThi}" khỏi hệ thống?\nThao tác này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    setState(() => _processingTeacherId = teacher.uid);
    try {
      await _service.deleteTeacher(teacher.uid);
      if (!mounted) return;
      setState(() {
        _teachers.removeWhere((element) => element.uid == teacher.uid);
        _filteredTeachers = _filterTeachers(_teachers, _searchController.text);
        _processingTeacherId = null;
      });
      _showSnackBar('Đã xóa giáo viên khỏi hệ thống.');
    } catch (error) {
      if (!mounted) return;
      setState(() => _processingTeacherId = null);
      _showSnackBar(_errorText(error, fallback: 'Xóa giáo viên thất bại. Vui lòng thử lại.'));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _errorText(Object error, {required String fallback}) {
    if (error is PostgrestException && error.message.isNotEmpty) {
      return error.message;
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Quản lý giáo viên',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/admin'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: _openCreateTeacher,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Thêm giáo viên'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryCard(totalTeachers: _teachers.length),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo tên, trình độ, email hoặc số điện thoại...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          tooltip: 'Xóa tìm kiếm',
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildTeacherList(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherList(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 46, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _loadTeachers,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTeachers,
      child: _filteredTeachers.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              children: [
                const SizedBox(height: 80),
                Icon(Icons.co_present_outlined, size: 64, color: Colors.blueGrey.shade200),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy giáo viên phù hợp.',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Hãy thử thay đổi từ khóa tìm kiếm hoặc thêm giáo viên mới.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                if (_searchController.text.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Xóa từ khóa'),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: _filteredTeachers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final teacher = _filteredTeachers[index];
                return _TeacherCard(
                  teacher: teacher,
                  currencyFormatter: _currencyFormatter,
                  dateFormatter: _dateFormatter,
                  isProcessing: _processingTeacherId == teacher.uid,
                  onEdit: () => _openEditTeacher(teacher),
                  onDelete: () => _deleteTeacher(teacher),
                );
              },
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.totalTeachers});

  final int totalTeachers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.school_outlined, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giảng viên trong hệ thống',
                  style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalTeachers người',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_outward, color: Colors.white70),
        ],
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({
    required this.teacher,
    required this.currencyFormatter,
    required this.dateFormatter,
    required this.onEdit,
    required this.onDelete,
    required this.isProcessing,
  });

  final Teacher teacher;
  final NumberFormat currencyFormatter;
  final DateFormat dateFormatter;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = teacher.hoVaTenHienThi.trim();
    final avatarLabel = displayName.isNotEmpty
        ? displayName.substring(0, 1).toUpperCase()
        : '?';
    final salary = currencyFormatter.format(teacher.luong);
    final updatedAt = teacher.ngayCapNhat != null
        ? dateFormatter.format(teacher.ngayCapNhat!.toLocal())
        : null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                  child: Text(
                    avatarLabel,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.hoVaTenHienThi,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        teacher.trinhDo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isProcessing)
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                else
                  _CardMenu(
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _InfoBadge(
                  icon: Icons.cake_outlined,
                  label: 'Độ tuổi',
                  value: teacher.tuoi > 0 ? '${teacher.tuoi} tuổi' : 'Chưa rõ',
                ),
                _InfoBadge(
                  icon: Icons.payments_outlined,
                  label: 'Mức lương',
                  value: salary,
                ),
                _InfoBadge(
                  icon: Icons.phone_outlined,
                  label: 'Điện thoại',
                  value: teacher.soDienThoaiHienThi ?? 'Chưa cập nhật',
                ),
                _InfoBadge(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: teacher.accountEmail ?? 'Chưa cập nhật',
                ),
              ],
            ),
            if (updatedAt != null) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Cập nhật lần cuối: $updatedAt',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _CardMenu extends StatelessWidget {
  const _CardMenu({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      tooltip: 'Tùy chọn',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('Chỉnh sửa'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          textStyle: TextStyle(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: theme.colorScheme.error),
              const SizedBox(width: 12),
              const Text('Xóa giáo viên'),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_horiz),
    );
  }
}

class _TeacherFormSheet extends StatefulWidget {
  const _TeacherFormSheet({required this.service, this.teacher});

  final TeacherService service;
  final Teacher? teacher;

  @override
  State<_TeacherFormSheet> createState() => _TeacherFormSheetState();
}

class _TeacherFormSheetState extends State<_TeacherFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _levelController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneController;
  late final TextEditingController _salaryController;
  late final Future<List<TeacherAccountOption>> _accountsFuture;
  String? _selectedAccountId;
  bool _submitting = false;

  bool get _isEditing => widget.teacher != null;

  @override
  void initState() {
    super.initState();
    final teacher = widget.teacher;
    _nameController = TextEditingController(text: teacher?.ten ?? '');
    _levelController = TextEditingController(text: teacher?.trinhDo ?? '');
    _ageController =
        TextEditingController(text: teacher != null && teacher.tuoi > 0 ? teacher.tuoi.toString() : '');
    _phoneController = TextEditingController(text: teacher?.soDienThoai ?? teacher?.soDienThoaiHienThi ?? '');
    _salaryController = TextEditingController(
      text: teacher != null && teacher.luong > 0 ? teacher.luong.toStringAsFixed(0) : '',
    );
    _selectedAccountId = teacher?.maNguoiDung;
    _accountsFuture = widget.service.fetchTeacherAccounts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Text(
                        _isEditing ? 'Cập nhật thông tin giảng viên' : 'Thêm giảng viên mới',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEditing
                            ? 'Điều chỉnh thông tin chi tiết cho giảng viên trong hệ thống.'
                            : 'Nhập đầy đủ thông tin để thêm giảng viên mới.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      FutureBuilder<List<TeacherAccountOption>>(
                        future: _accountsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final options = snapshot.data ?? [];
                          final items = List<TeacherAccountOption>.from(options);
                          if (widget.teacher != null &&
                              widget.teacher!.maNguoiDung.isNotEmpty &&
                              items.indexWhere((e) => e.uid == widget.teacher!.maNguoiDung) == -1) {
                            items.add(
                              TeacherAccountOption(
                                uid: widget.teacher!.maNguoiDung,
                                hoVaTen: widget.teacher!.hoVaTenHienThi,
                                email: widget.teacher!.accountEmail,
                                soDienThoai: widget.teacher!.soDienThoaiHienThi,
                              ),
                            );
                          }

                          if (items.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline, color: Colors.orange, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Chưa có tài khoản nào thuộc vai trò giáo viên. Hãy tạo tài khoản trước khi thêm giảng viên.',
                                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.orange.shade900),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: _selectedAccountId,
                            decoration: InputDecoration(
                              labelText: 'Tài khoản giáo viên',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              prefixIcon: const Icon(Icons.account_circle_outlined),
                            ),
                            items: items
                                .map(
                                  (option) => DropdownMenuItem<String>(
                                    value: option.uid,
                                    child: Text(option.displayLabel),
                                  ),
                                )
                                .toList(),
                            onChanged: _submitting
                                ? null
                                : (value) {
                                    setState(() => _selectedAccountId = value);
                                  },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn tài khoản giáo viên.';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Tên hiển thị',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Tên giáo viên không được để trống.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _levelController,
                        decoration: InputDecoration(
                          labelText: 'Chuyên môn / Trình độ',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          prefixIcon: const Icon(Icons.workspace_premium_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập chuyên môn của giáo viên.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Tuổi',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          prefixIcon: const Icon(Icons.cake_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập độ tuổi.';
                          }
                          final age = int.tryParse(value.trim());
                          if (age == null || age < 18) {
                            return 'Tuổi giáo viên phải từ 18 trở lên.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _salaryController,
                        decoration: InputDecoration(
                          labelText: 'Mức lương (VNĐ)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          prefixIcon: const Icon(Icons.payments_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập mức lương.';
                          }
                          final salary = _parseSalary(value);
                          if (salary == null || salary <= 0) {
                            return 'Mức lương phải lớn hơn 0.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Số điện thoại (tùy chọn)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (cleaned.length < 9 || cleaned.length > 15) {
                            return 'Số điện thoại không hợp lệ.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _submitting ? null : () => Navigator.of(context).pop(),
                              child: const Text('Hủy'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _submitting ? null : _submit,
                              icon: _submitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.save_outlined),
                              label: Text(_isEditing ? 'Lưu thay đổi' : 'Thêm giáo viên'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    if (_selectedAccountId == null || _selectedAccountId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn tài khoản giáo viên.')),
      );
      return;
    }

    final tuoi = int.parse(_ageController.text.trim());
    final luong = _parseSalary(_salaryController.text.trim()) ?? 0;
    final soDienThoai = _phoneController.text.trim().isEmpty
        ? null
        : _phoneController.text.trim();

    setState(() => _submitting = true);
    try {
      final teacher = widget.teacher == null
          ? await widget.service.createTeacher(
              maNguoiDung: _selectedAccountId!,
              ten: _nameController.text.trim(),
              trinhDo: _levelController.text.trim(),
              tuoi: tuoi,
              luong: luong,
              soDienThoai: soDienThoai,
            )
          : await widget.service.updateTeacher(
              uid: widget.teacher!.uid,
              maNguoiDung: _selectedAccountId!,
              ten: _nameController.text.trim(),
              trinhDo: _levelController.text.trim(),
              tuoi: tuoi,
              luong: luong,
              soDienThoai: soDienThoai,
            );
      if (!mounted) return;
      Navigator.of(context).pop(teacher);
    } on PostgrestException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.isEmpty ? 'Đã xảy ra lỗi với Supabase.' : error.message)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu thông tin: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  double? _parseSalary(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) {
      return null;
    }
    return double.tryParse(cleaned);
  }
}
