import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  SupabaseClient get _c => Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) =>
      _c.auth.signUp(
        email: email,
        password: password,
        data: {if (fullName != null) 'full_name': fullName},
      );

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) =>
      _c.auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _c.auth.signOut();

  User? get currentUser => _c.auth.currentUser;
}
