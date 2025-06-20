import 'package:apiuser/list_dosen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                size: 100,
                color: Colors.pink,
              ),
              const SizedBox(height: 20),
              const Text(
                'DATA DOSEN',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Aplikasi CRUD untuk manajemen data dosen',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.pinkAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ListDosenPage()),
                  );
                },
                child: const Text(
                  'MASUK APLIKASI',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
