import 'package:flutter/material.dart';
import 'package:wmp/presentation/pages/auth/login_page.dart';
import 'package:wmp/presentation/pages/auth/register_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterScreen(),
  };
}
