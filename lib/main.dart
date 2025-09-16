import 'package:flutter/material.dart';
import 'widgets/home.dart'; // Import halaman utama siswa
import 'models/siswa.dart'; // Import model siswa

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // biar tulisan "debug" ilang
      title: 'Daftar Siswa Digital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: HomeScreens(), // Ganti ke halaman siswa
    );
  }
}
