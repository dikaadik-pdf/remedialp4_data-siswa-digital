import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/AddFormSiswa.dart';
import 'widgets/CardForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qrpwmbohdxzqkcbybvue.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFycHdtYm9oZHh6cWtjYnlidnVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTAxMzEsImV4cCI6MjA3MzU2NjEzMX0.Yc46cV6EKSigAvjSyoWscTrC6LkHA-A84mjWdZOnuyA',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DaftarSiswaDigitalPage(),
    const ListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: _pages[_selectedIndex]),
        bottomNavigationBar: SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Segitiga custom
              CustomPaint(
                size: const Size(double.infinity, 70),
                painter: NavBarPainter(),
              ),

              // Icon kiri
              Positioned(
                left: 50,
                bottom: 8, // 🔽 diturunin sedikit
                child: GestureDetector(
                  onTap: () => _onItemTapped(0),
                  child: Icon(
                    Icons.person_add_alt_1,
                    size: 28,
                    color: _selectedIndex == 0 ? Colors.white : Colors.black,
                  ),
                ),
              ),

              // Icon kanan
              Positioned(
                right: 50,
                bottom: 8, // 🔽 diturunin sedikit
                child: GestureDetector(
                  onTap: () => _onItemTapped(1),
                  child: Icon(
                    Icons.list,
                    size: 28,
                    color: _selectedIndex == 1 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.15);
    path.lineTo(size.width * 0.5, size.height * 0.65);
    path.lineTo(size.width, size.height * 0.15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // bayangan
    canvas.drawShadow(path, Colors.black.withOpacity(0.25), 6, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
