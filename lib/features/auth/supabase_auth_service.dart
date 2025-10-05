import 'package:supabase_flutter/supabase_flutter.dart';

/// Cấu hình của bạn (đã khởi tạo trong main.dart)
final supa = Supabase.instance.client;

/// Model gọn cho người dùng (bản ghi trong bảng public.nguoi_dung)
class NguoiDung {
  final String uid; // PK uuid
  final String? authUid; // uuid từ auth.users
  final String hoVaTen;
  final String? email;
  final String? soDienThoai;
  final String? diaChi;
  final String vaiTroUid;
  final bool daKichHoat;

  NguoiDung({
    required this.uid,
    required this.hoVaTen,
    required this.vaiTroUid,
    this.authUid,
    this.email,
    this.soDienThoai,
    this.diaChi,
    this.daKichHoat = true,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> j) => NguoiDung(
        uid: j['uid'] as String,
        authUid: j['auth_uid'] as String?,
        hoVaTen: j['ho_va_ten'] as String,
        email: j['email'] as String?,
        soDienThoai: j['so_dien_thoai'] as String?,
        diaChi: j['dia_chi'] as String?,
        vaiTroUid: j['vai_tro_uid'] as String,
        daKichHoat: j['da_kich_hoat'] as bool? ?? true,
      );
}

class SupabaseAuthService {
  /// ========== AUTH CORE ==========
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String hoVaTen,
    required String vaiTroUid, // tham chiếu public.vai_tro(uid)
    String? soDienThoai,
    String? diaChi,
    bool requireEmailConfirmation = false,
  }) async {
    // 1) Đăng ký với Supabase Auth
    final res = await supa.auth.signUp(
      email: email,
      password: password,
      // metadata nếu muốn (không bắt buộc)
      data: {
        'full_name': hoVaTen,
        'role_uid': vaiTroUid,
      },
      emailRedirectTo: requireEmailConfirmation ? null : null,
    );

    // 2) Upsert bản ghi vào bảng public.nguoi_dung
    // Lưu ý: trong schema của bạn, cột `mat_khau_ma_hoa` đang NOT NULL.
    // Nếu dùng Supabase Auth thì mật khẩu không lưu ở đây -> nên:
    //  - cách A (khuyến nghị): cho phép NULL cho cột này trong DB, hoặc
    //  - cách B: ghi một chuỗi placeholder.
    final user = res.user;
    if (user != null) {
      await ensureNguoiDungRow(
        authUid: user.id,
        hoVaTen: hoVaTen,
        email: email,
        soDienThoai: soDienThoai,
        diaChi: diaChi,
        vaiTroUid: vaiTroUid,
      );
    }
    return res;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supa.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() => supa.auth.signOut();

  User? get currentUser => supa.auth.currentUser;

  /// ========== NGƯỜI DÙNG (public.nguoi_dung) ==========
  /// Tạo/đồng bộ row cho user hiện tại (id từ auth.users)
  Future<void> ensureNguoiDungRow({
    required String authUid,
    required String hoVaTen,
    required String email,
    required String vaiTroUid,
    String? soDienThoai,
    String? diaChi,
  }) async {
    // Kiểm tra đã có row nào cho userId chưa
    final exist = await supa
        .from('nguoi_dung')
        .select('uid')
        .eq('auth_uid', authUid)
        .maybeSingle();

    if (exist != null) {
      // update nhẹ các trường có thể đổi
      await supa.from('nguoi_dung').update({
        'ho_va_ten': hoVaTen,
        'email': email,
        'so_dien_thoai': soDienThoai,
        'dia_chi': diaChi,
        'vai_tro_uid': vaiTroUid,
        'thoi_gian_cap_nhat': DateTime.now().toIso8601String(),
      }).eq('uid', exist['uid']);
      return;
    }

    // insert mới
    await supa.from('nguoi_dung').insert({
      'auth_uid': authUid,
      'ho_va_ten': hoVaTen,
      'email': email,
      'so_dien_thoai': soDienThoai,
      'dia_chi': diaChi,
      'vai_tro_uid': vaiTroUid,
      'da_kich_hoat': true,
    });
  }

  /// Lấy thông tin `nguoi_dung` theo user hiện tại
  Future<NguoiDung?> getMyNguoiDung() async {
    final uid = currentUser?.id;
    if (uid == null) return null;
    final row = await supa
        .from('nguoi_dung')
        .select('*')
        .eq('auth_uid', uid)
        .maybeSingle();
    if (row == null) return null;
    return NguoiDung.fromJson(row);
  }

  /// Cập nhật hồ sơ người dùng (own row)
  Future<void> updateMyNguoiDung({
    String? hoVaTen,
    String? soDienThoai,
    String? diaChi,
    String? vaiTroUid,
  }) async {
    final uid = currentUser?.id;
    if (uid == null) throw Exception('Chưa đăng nhập');
    final data = <String, dynamic>{
      if (hoVaTen != null) 'ho_va_ten': hoVaTen,
      if (soDienThoai != null) 'so_dien_thoai': soDienThoai,
      if (diaChi != null) 'dia_chi': diaChi,
      if (vaiTroUid != null) 'vai_tro_uid': vaiTroUid,
      'thoi_gian_cap_nhat': DateTime.now().toIso8601String(),
    };
    await supa.from('nguoi_dung').update(data).eq('auth_uid', uid);
  }

  /// Lấy danh sách vai trò để hiển thị Dropdown khi đăng ký
  Future<List<Map<String, dynamic>>> fetchRoles() async {
    return await supa.from('vai_tro').select('*').order('ten');
  }
}
