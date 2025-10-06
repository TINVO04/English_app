import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';
import 'core/config/env.dart';
import 'features/auth/presentation/pages/auth_screen.dart';
import 'features/teacher/presentation/pages/teacher_home_page.dart';
import 'legacy/admin_dashboard/admin_dashboard_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  await initializeDateFormatting('vi_VN', null); // tải dữ liệu locale vi_VN
  Intl.defaultLocale = 'vi_VN';

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/teacher-home': (context) => const TeacherHomeScreen(),
      },
    );
  }
}
