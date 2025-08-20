
import 'package:flutter/material.dart';
import 'package:youtube/pages/admin/admin_dashboard_page.dart';
import 'package:youtube/pages/admin/auth_page.dart';
import 'package:youtube/pages/home_page.dart';
import 'package:youtube/screens/about_screen.dart';
import 'package:youtube/screens/home_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube/screens/order_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://klpvwvmjdyyxyqtlfchz.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtscHZ3dm1qZHl5eHlxdGxmY2h6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzOTg4NzgsImV4cCI6MjA2OTk3NDg3OH0.ATvqx7kQqqJTvGK90TEjRPdaAL2TcIq6J88vR9E4VJU",
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

        // --- INI ADALAH LOGIKA BARU YANG LEBIH AMAN UNTUK HALAMAN PESAN ---
        '/order': (context) => const HomePage(child: OrderScreen()),
        // ----------------------------------------------------------------

        // Rute untuk admin
        '/admin_login': (context) => const AuthPage(),
        '/admin_dashboard': (context) => const AdminDashboardPage(),
      },
    );
  }
}