import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'presentation/pages/onboarding/splash_screen.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Activate Firebase App Check (Android debug provider for development)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.deviceCheck,
  );
  // Print App Check token to help allowlisting in Firebase Console
  try {
    final token = await FirebaseAppCheck.instance.getToken(true);
    // Copy this token into Firebase Console → App Check → Debug tokens
    // so that Storage will accept requests from this device in debug mode.
    // Note: Only for development; remove in production.
    // ignore: avoid_print
    print('AppCheck debug token: ' + (token ?? 'null'));
  } catch (_) {
    // ignore: avoid_print
    print('AppCheck: failed to get debug token');
  }
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
      routes: AppRoutes.routes,
    );
  }
}
