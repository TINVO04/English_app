import 'package:supabase_flutter/supabase_flutter.dart';

/// Cấu hình của bạn (đã khởi tạo trong main.dart)
final supa = Supabase.instance.client;

/// Model gọn cho người dùng (bản ghi trong bảng public.nguoi_dung)
class NguoiDung {
  final int ma;                // PK int
  final String? userId;        // uuid từ auth.users
  final String tenNguoiDung;   // unique
  final String? hoVaTen;
  final String? email;
  final String? soDienThoai;
  final String? diaChi;
  final int vaiTroId;

  NguoiDung({
    required this.ma,
    required this.tenNguoiDung,
    required this.vaiTroId,
    this.userId,
    this.hoVaTen,
    this.email,
    this.soDienThoai,
    this.diaChi,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> j) => NguoiDung(
    ma: j['ma'] as int,
    userId: j['user_id'] as String?,
    tenNguoiDung: j['ten_nguoi_dung'] as String,
    hoVaTen: j['ho_va_ten'] as String?,
    email: j['email'] as String?,
    soDienThoai: j['so_dien_thoai'] as String?,
    diaChi: j['dia_chi'] as String?,
    vaiTroId: j['vai_tro_id'] as int,
  );
}

class SupabaseAuthService {
  /// ========== AUTH CORE ==========
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String tenNguoiDung, // unique theo schema
    required String hoVaTen,
    required int vaiTroId,        // tham chiếu public.vai_tro(id)
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
        'username': tenNguoiDung,
        'role_id': vaiTroId,
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
        userId: user.id,
        tenNguoiDung: tenNguoiDung,
        hoVaTen: hoVaTen,
        email: email,
        soDienThoai: soDienThoai,
        diaChi: diaChi,
        vaiTroId: vaiTroId,
        matKhauMaHoaPlaceholder: 'supabase_managed', // placeholder
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
    required String userId,
    required String tenNguoiDung,
    required String hoVaTen,
    required String email,
    required int vaiTroId,
    String? soDienThoai,
    String? diaChi,
    String matKhauMaHoaPlaceholder = 'supabase_managed',
  }) async {
    // Kiểm tra đã có row nào cho userId chưa
    final exist = await supa
        .from('nguoi_dung')
        .select('ma')
        .eq('user_id', userId)
        .maybeSingle();

    if (exist != null) {
      // update nhẹ các trường có thể đổi
      await supa.from('nguoi_dung').update({
        'ten_nguoi_dung': tenNguoiDung,
        'ho_va_ten': hoVaTen,
        'email': email,
        'so_dien_thoai': soDienThoai,
        'dia_chi': diaChi,
        'vai_tro_id': vaiTroId,
        'thoi_gian_cap_nhat': DateTime.now().toIso8601String(),
      }).eq('ma', exist['ma']);
      return;
    }

    // insert mới
    await supa.from('nguoi_dung').insert({
      'user_id': userId,
      'ten_nguoi_dung': tenNguoiDung,
      'mat_khau_ma_hoa': matKhauMaHoaPlaceholder, // do cột đang NOT NULL
      'ho_va_ten': hoVaTen,
      'email': email,
      'so_dien_thoai': soDienThoai,
      'dia_chi': diaChi,
      'vai_tro_id': vaiTroId,
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
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null) return null;
    return NguoiDung.fromJson(row);
  }

  /// Cập nhật hồ sơ người dùng (own row)
  Future<void> updateMyNguoiDung({
    String? tenNguoiDung,
    String? hoVaTen,
    String? soDienThoai,
    String? diaChi,
    int? vaiTroId,
  }) async {
    final uid = currentUser?.id;
    if (uid == null) throw Exception('Chưa đăng nhập');
    final data = <String, dynamic>{
      if (tenNguoiDung != null) 'ten_nguoi_dung': tenNguoiDung,
      if (hoVaTen != null) 'ho_va_ten': hoVaTen,
      if (soDienThoai != null) 'so_dien_thoai': soDienThoai,
      if (diaChi != null) 'dia_chi': diaChi,
      if (vaiTroId != null) 'vai_tro_id': vaiTroId,
      'thoi_gian_cap_nhat': DateTime.now().toIso8601String(),
    };
    await supa.from('nguoi_dung').update(data).eq('user_id', uid);
  }

  /// Lấy danh sách vai trò để hiển thị Dropdown khi đăng ký
  Future<List<Map<String, dynamic>>> fetchRoles() async {
    return await supa.from('vai_tro').select('*').order('id');
  }
}
