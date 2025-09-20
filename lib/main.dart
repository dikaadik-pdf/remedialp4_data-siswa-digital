import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project4_remedial/widgets/AddFormSiswa.dart';
import 'package:project4_remedial/widgets/AddDaftarSiswa.dart';

// =================== MAIN ===================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qrpwmbohdxzqkcbybvue.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFycHdtYm9oZHh6cWtjYnlidnVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTAxMzEsImV4cCI6MjA3MzU2NjEzMX0.Yc46cV6EKSigAvjSyoWscTrC6LkHA-A84mjWdZOnuyA',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// =================== SPLASH SCREEN ===================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    // tampil splash 5 detik
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    // langsung masuk HomeScreens
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreens()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Selamat Datang\ndi Input Data Digital\nSMK Negeri Swasta Jakawarna",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== HOMEPAGE DENGAN NAVBAR ===================
class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DaftarSiswaDigitalPage(),
    ListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: const Size(double.infinity, 80),
              painter: NavBarPainter(),
            ),
            // ICON KIRI (Tambah)
            Positioned(
              left: 40,
              bottom: 20,
              child: GestureDetector(
                onTap: () => _onItemTapped(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      size: 28,
                      color: _selectedIndex == 0 ? Colors.white : Colors.black,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            _selectedIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ICON KANAN (Daftar)
            Positioned(
              right: 40,
              bottom: 20,
              child: GestureDetector(
                onTap: () => _onItemTapped(1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list,
                      size: 28,
                      color: _selectedIndex == 1 ? Colors.white : Colors.black,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            _selectedIndex == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== NAVBAR PAINTER DENGAN GRADIENT ===================
class NavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.deepOrange, Colors.orangeAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.5, 45);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 6, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
