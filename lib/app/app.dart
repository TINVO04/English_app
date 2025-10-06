import 'package:flutter/material.dart';
import 'app_router.dart';
import 'app_theme.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QL Trung Tâm',
      // Theme tối giản (giữ đúng cảm giác UI bạn đang dùng)
      theme: AppTheme.light(),
      // Mặc định mở màn đăng nhập; màn khác điều hướng bằng Navigator.pushNamed
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: AppRoutes.auth,
    );
  }
}
