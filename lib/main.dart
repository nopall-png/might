import 'package:flutter/material.dart';
import 'data/services/appwrite_service.dart';
import 'data/services/appwrite_config.dart';
import 'presentation/pages/onboarding/splash_screen.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Appwrite client
  AppwriteService.instance.initialize(
    endpoint: AppwriteConfig.endpoint,
    projectId: AppwriteConfig.projectId,
  );
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
