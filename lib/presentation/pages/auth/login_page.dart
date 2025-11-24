import 'package:flutter/material.dart';
import 'package:wmp/presentation/pages/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B164A), Color(0xFF7A3FFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // LOGO MEET & FIGHT - BERSIH TANPA BORDER EMAS
                const SizedBox(height: 40),

                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF7A3FFF),
                        child: const Icon(
                          Icons.sports_martial_arts,
                          size: 100,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),

                // Login Card
                Container(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EFFF),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF7A3FFF),
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(8, 8)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // WELCOME BACK
                      const Text(
                        'WELCOME BACK',
                        style: TextStyle(
                          fontFamily: 'Press Start 2P',
                          fontSize: 20,
                          color: Color(0xFF2B164A),
                          letterSpacing: 1.2,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggle: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // LOGIN BUTTON
                      GestureDetector(
                        onTap: () {
                          // TODO: Login logic
                          print('Login tapped');
                        },
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white30, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF4C2C82),
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Color(0xFFF9F8FF),
                                fontSize: 16,
                                fontFamily: 'Press Start 2P',
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Text
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(
                            color: Color(0xFF7A3FFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Tagline
                const Text(
                  'Find your perfect sparring partner',
                  style: TextStyle(
                    color: Color(0xFFF4EFFF),
                    fontSize: 16,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF7A3FFF), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF7A3FFF), size: 24),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB6A9D7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF7A3FFF),
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    );
  }
}
