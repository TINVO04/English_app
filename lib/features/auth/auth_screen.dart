import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/bg_data.dart';
import '../../home/home_screen.dart';
import '../../utils/text_utils.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  bool _isSignUp = false; // false = Login, true = Register
  bool _obscure = true;
  bool _busy = false;

  int selectedIndex = 0;
  bool showOption = false;

  final _auth = AuthService();
  static const int defaultRoleId = 6; // Cách 1: hardcode vai trò hợp lệ

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _fullName.dispose();
    super.dispose();
  }

  void _show(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      if (_isSignUp) {
        // Đăng ký
        final res = await _auth.signUp(
          email: _email.text.trim(),
          password: _password.text.trim(),
          fullName: _fullName.text.trim().isEmpty ? null : _fullName.text.trim(),
        );

        if (res.user != null) {
          // Insert vào public.nguoi_dung
          final uid = Supabase.instance.client.auth.currentUser?.id;
          if (uid != null) {
            final payload = {
              'user_id': uid,
              'ten_nguoi_dung': _email.text.trim().split('@').first,
              'mat_khau_ma_hoa': 'supabase_managed',
              'ho_va_ten': _fullName.text.trim().isEmpty
                  ? _email.text.trim().split('@').first
                  : _fullName.text.trim(),
              'email': _email.text.trim(),
              'vai_tro_id': defaultRoleId,
              'da_kich_hoat': true,
            };
            await Supabase.instance.client.from('nguoi_dung').insert(payload);
          }
          _show('Tạo tài khoản thành công');
          setState(() => _isSignUp = false); // quay về login
        }
      } else {
        // Đăng nhập
        await _auth.signIn(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
        if (!mounted) return;
        _show('Đăng nhập thành công');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on AuthException catch (e) {
      _show(e.message);
    } on PostgrestException catch (e) {
      _show(e.message);
    } catch (_) {
      _show('Có lỗi xảy ra, thử lại sau.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: showOption
                  ? ListView.builder(
                shrinkWrap: true,
                itemCount: bgList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: selectedIndex == index
                          ? Colors.white
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(bgList[index]),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : const SizedBox(),
            ),
            const SizedBox(width: 20),
            showOption
                ? GestureDetector(
              onTap: () => setState(() => showOption = false),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            )
                : GestureDetector(
              onTap: () => setState(() => showOption = true),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(bgList[selectedIndex]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgList[selectedIndex]),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 420,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Center(
                        child: TextUtil(
                          text: _isSignUp ? "Register" : "Login",
                          weight: true,
                          size: 30,
                        ),
                      ),
                      const Spacer(),

                      // Full name (chỉ hiện ở Register)
                      if (_isSignUp) ...[
                        TextUtil(text: "Full name"),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                            border:
                            Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextFormField(
                            controller: _fullName,
                            style: const TextStyle(color: Colors.white, height: 1.1),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.person, color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email
                      TextUtil(text: "Email"),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white)),
                        ),
                        child: TextFormField(
                          controller: _email,
                          style: const TextStyle(color: Colors.white, height: 1.1),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Nhập email';
                            }
                            final ok = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$')
                                .hasMatch(v.trim());
                            if (!ok) return 'Email không hợp lệ';
                            return null;
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.mail, color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Password
                      TextUtil(text: "Password"),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white)),
                        ),
                        child: TextFormField(
                          controller: _password,
                          style: const TextStyle(color: Colors.white, height: 1.1),
                          obscureText: _obscure,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Nhập mật khẩu';
                            if (v.length < 6) return 'Ít nhất 6 ký tự';
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Remember (để nguyên UI)
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextUtil(
                              text:
                              "Remember Me , FORGET PASSWORD", // chỉ UI, chưa xử lý
                              size: 12,
                              weight: true,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),

                      // Submit button
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _busy ? null : _onSubmit,
                          child: _busy
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Text(
                            _isSignUp ? 'Create Account' : 'Log In',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Toggle Login <-> Register
                      Center(
                        child: GestureDetector(
                          onTap: () => setState(() => _isSignUp = !_isSignUp),
                          child: TextUtil(
                            text: _isSignUp
                                ? "Already have an account? LOGIN"
                                : "Don't have an account? REGISTER",
                            size: 12,
                            weight: true,
                          ),
                        ),
                      ),
                      const Spacer(),
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
}
