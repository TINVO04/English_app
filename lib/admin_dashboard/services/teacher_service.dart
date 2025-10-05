import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherService {
  TeacherService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Teacher>> fetchTeachers() async {
    final response = await _client
        .from('giao_vien')
        .select(
          'uid, ma_nguoi_dung, ten, trinh_do, tuoi, so_dien_thoai, luong, ngay_cap_nhat, nguoi_dung(ho_va_ten, email, so_dien_thoai)',
        )
        .order('ngay_cap_nhat', ascending: false);

    final data = response as List<dynamic>;
    return data
        .map((row) => Teacher.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<Teacher> createTeacher({
    required String maNguoiDung,
    required String ten,
    required String trinhDo,
    required int tuoi,
    required double luong,
    String? soDienThoai,
  }) async {
    final payload = <String, dynamic>{
      'ma_nguoi_dung': maNguoiDung,
      'ten': ten,
      'trinh_do': trinhDo,
      'tuoi': tuoi,
      'so_dien_thoai': soDienThoai,
      'luong': luong,
      'ngay_cap_nhat': DateTime.now().toIso8601String(),
    };

    final result = await _client
        .from('giao_vien')
        .insert(payload)
        .select(
          'uid, ma_nguoi_dung, ten, trinh_do, tuoi, so_dien_thoai, luong, ngay_cap_nhat, nguoi_dung(ho_va_ten, email, so_dien_thoai)',
        )
        .single();

    return Teacher.fromJson(result as Map<String, dynamic>);
  }

  Future<Teacher> updateTeacher({
    required String uid,
    required String maNguoiDung,
    required String ten,
    required String trinhDo,
    required int tuoi,
    required double luong,
    String? soDienThoai,
  }) async {
    final payload = <String, dynamic>{
      'ma_nguoi_dung': maNguoiDung,
      'ten': ten,
      'trinh_do': trinhDo,
      'tuoi': tuoi,
      'so_dien_thoai': soDienThoai,
      'luong': luong,
      'ngay_cap_nhat': DateTime.now().toIso8601String(),
    };

    final result = await _client
        .from('giao_vien')
        .update(payload)
        .eq('uid', uid)
        .select(
          'uid, ma_nguoi_dung, ten, trinh_do, tuoi, so_dien_thoai, luong, ngay_cap_nhat, nguoi_dung(ho_va_ten, email, so_dien_thoai)',
        )
        .single();

    return Teacher.fromJson(result as Map<String, dynamic>);
  }

  Future<void> deleteTeacher(String uid) async {
    await _client.from('giao_vien').delete().eq('uid', uid);
  }

  Future<List<TeacherAccountOption>> fetchTeacherAccounts() async {
    final roleRow = await _client
        .from('vai_tro')
        .select('uid')
        .eq('ma', 'giao_vien')
        .maybeSingle();

    if (roleRow == null || roleRow['uid'] == null) {
      return [];
    }

    final data = await _client
        .from('nguoi_dung')
        .select('uid, ho_va_ten, email, so_dien_thoai')
        .eq('vai_tro_uid', roleRow['uid'])
        .order('ho_va_ten', ascending: true);

    final list = data as List<dynamic>;
    return list
        .map((row) => TeacherAccountOption.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}

class Teacher {
  Teacher({
    required this.uid,
    required this.maNguoiDung,
    required this.ten,
    required this.trinhDo,
    required this.tuoi,
    required this.luong,
    this.soDienThoai,
    this.ngayCapNhat,
    this.accountHoVaTen,
    this.accountEmail,
    this.accountSoDienThoai,
  });

  final String uid;
  final String maNguoiDung;
  final String ten;
  final String trinhDo;
  final int tuoi;
  final double luong;
  final String? soDienThoai;
  final DateTime? ngayCapNhat;
  final String? accountHoVaTen;
  final String? accountEmail;
  final String? accountSoDienThoai;

  String get hoVaTenHienThi => accountHoVaTen?.isNotEmpty == true ? accountHoVaTen! : ten;

  String? get soDienThoaiHienThi => soDienThoai?.isNotEmpty == true
      ? soDienThoai
      : accountSoDienThoai?.isNotEmpty == true
          ? accountSoDienThoai
          : null;

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final account = json['nguoi_dung'] as Map<String, dynamic>?;
    return Teacher(
      uid: json['uid'] as String,
      maNguoiDung: json['ma_nguoi_dung'] as String,
      ten: json['ten'] as String? ?? account?['ho_va_ten'] as String? ?? 'Chưa cập nhật',
      trinhDo: json['trinh_do'] as String? ?? 'Chưa rõ',
      tuoi: (json['tuoi'] as num?)?.toInt() ?? 0,
      luong: (json['luong'] as num?)?.toDouble() ?? 0,
      soDienThoai: json['so_dien_thoai'] as String?,
      ngayCapNhat: json['ngay_cap_nhat'] != null
          ? DateTime.tryParse(json['ngay_cap_nhat'] as String)
          : null,
      accountHoVaTen: account?['ho_va_ten'] as String?,
      accountEmail: account?['email'] as String?,
      accountSoDienThoai: account?['so_dien_thoai'] as String?,
    );
  }

}

class TeacherAccountOption {
  const TeacherAccountOption({
    required this.uid,
    this.hoVaTen,
    this.email,
    this.soDienThoai,
  });

  final String uid;
  final String? hoVaTen;
  final String? email;
  final String? soDienThoai;

  String get displayLabel {
    final parts = <String>[
      if (hoVaTen != null && hoVaTen!.isNotEmpty) hoVaTen!,
      if (email != null && email!.isNotEmpty) email!,
    ];
    return parts.isEmpty ? uid : parts.join(' • ');
  }

  factory TeacherAccountOption.fromJson(Map<String, dynamic> json) {
    return TeacherAccountOption(
      uid: json['uid'] as String,
      hoVaTen: json['ho_va_ten'] as String?,
      email: json['email'] as String?,
      soDienThoai: json['so_dien_thoai'] as String?,
    );
  }
}
