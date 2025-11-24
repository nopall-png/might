import 'package:flutter/material.dart';
import 'presentation/pages/onboarding/splash_screen.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meet & Fight',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // halaman pertama yang tampil
      home: const SplashScreen(),

      // route global
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterScreen(),
      },
    );
  }
}
