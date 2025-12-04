import 'package:flutter/material.dart';
import '/screens/signin_screen.dart';

const _brandPurple = Color(0xFF5A2D82);
const _brandOrange = Color(0xFFFF8A5C);
const _surface = Color(0xFFF6F4FB);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wisata Candi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandPurple,
          primary: _brandPurple,
          secondary: _brandOrange,
        ),
        scaffoldBackgroundColor: _surface,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: _brandPurple,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF3B344D),
            height: 1.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2DDF3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _brandPurple, width: 1.4),
          ),
        ),
      ).copyWith(
        dividerColor: const Color(0xFFE8E4F2),
      ),
      home: const SignInScreen(),
    );
  }
}
