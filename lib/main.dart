import 'package:flutter/material.dart';
import '/data/candi_data.dart';
import '/screens/profile_screen.dart';
import '/screens/search_screen.dart';
import '/screens/detail_screen.dart';
import '/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      final candi = candiList.first;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wisata Candi',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const HomeScreen(), // ← ubah di sini sesuai tampilan awal
      // home: SearchScreen(),
      // home: ProfileScreen(),
      // home: DetailScreen(candi: candi),
    );
  }
}
