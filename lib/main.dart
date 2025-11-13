import 'package:flutter/material.dart';
import '/data/candi_data.dart';
import '/screens/profile_screen.dart';
import '/screens/search_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SearchScreen(),
      // home: ProfileScreen(),
      // home: DetailScreen(candi: candi),
    );
  }
}
