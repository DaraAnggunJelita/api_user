import 'package:apiuser/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:apiuser/tambah_dosen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Dosen',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink.shade50,
        appBarTheme: AppBarTheme(
          color: Colors.pink.shade400,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.pink.shade400,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.pink),
          filled: true,
          fillColor: Colors.pink.shade100,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink.shade700),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
