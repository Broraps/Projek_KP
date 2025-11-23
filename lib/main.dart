
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube/pages/admin/admin_dashboard_page.dart';
import 'package:youtube/pages/admin/auth_page.dart';
import 'package:youtube/pages/home_page.dart';
import 'package:youtube/screens/about_screen.dart';
import 'package:youtube/screens/home_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube/screens/order_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pangsit Jontor Wadidaw',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(child: HomeScreen()),
        '/about': (context) => const HomePage(child: AboutScreen()),
        '/order': (context) => const HomePage(child: OrderScreen()),
        '/admin_login': (context) => const AuthPage(),
        '/admin_dashboard': (context) => const AdminDashboardPage(),
      },
    );
  }
}