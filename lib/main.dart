import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),

              // صورة رفيق
              Center(
                child: Image.asset(
                  'assets/rafiq.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // مرحباً بك
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F1DF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'مرحباً بك',
                  style: TextStyle(fontSize: 15, color: Color(0xFF4D8B4A)),
                ),
              ),

              const SizedBox(height: 20),

              // العنوان
              const Text(
                'رفيقك الذكي للدراسة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 35),

              // النبذة
              const Text(
                'حوّل مهامك الدراسية إلى تحديات تفتخر بإنجازها',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              // الزر
              Center(
                child: SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4D8B4A),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'ابدأ الآن',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
