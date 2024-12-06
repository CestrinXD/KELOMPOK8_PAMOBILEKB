import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sofa Score'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Image.network(
                  'https://databar.ai/media/external_source_logo/Sofascore.png',
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 320,
                  child: Text(
                    'Welcome to Sofa Score',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF18191A),
                      fontSize: 24,
                      fontFamily: 'Work Sans',
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  width: 320,
                  child: Text(
                    'Discover live scores, stats, and news for your favorite sports teams and players!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF18191A),
                      fontSize: 16,
                      fontFamily: 'Work Sans',
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF18191A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
