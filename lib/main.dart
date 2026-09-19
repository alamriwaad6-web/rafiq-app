import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8),

      appBar: AppBar(backgroundColor: const Color(0xFFFFF7E8), elevation: 0),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width < 600 ? 24 : 80),

          child: Center(
            child: SizedBox(
              width: width < 600 ? double.infinity : 600,

              child: Column(
                children: [
                  const SizedBox(height: 60),

                  Center(
                    child: Image.asset(
                      'assets/rafiq.png',
                      width: width < 600 ? 140 : 200,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2DF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'مرحباً بك',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4D8B4A)),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'رفيقك الذكي للدراسة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'حوّل مهامك الدراسية إلى تحديات تفتخر بإنجازها',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

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
        ),
      ),
    );
  }
}
