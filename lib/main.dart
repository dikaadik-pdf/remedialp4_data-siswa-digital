import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://qrpwmbohdxzqkcbybvue.supabase.co', // ganti dengan URL project
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFycHdtYm9oZHh6cWtjYnlidnVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTAxMzEsImV4cCI6MjA3MzU2NjEzMX0.Yc46cV6EKSigAvjSyoWscTrC6LkHA-A84mjWdZOnuyA', // ganti dengan anon/public key project
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Siswa Digital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomeScreens(), // panggil halaman utama
    );
  }
}
