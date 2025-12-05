import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:wmp/presentation/pages/profile/create_profile_page.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:wmp/data/services/matches_notification_service.dart';
import 'package:wmp/data/services/chat_notification_service.dart';
import 'package:wmp/presentation/widgets/responsive_app_bar.dart';
// Migrated: remove Firebase imports

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveGradientAppBar(
        title: 'REGISTER',
        onBack: () => Navigator.pop(context),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // LOGO MEET & FIGHT (sama kayak di Login)
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF7A3FFF),
                      child: const Icon(
                        Icons.sports_martial_arts,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // CREATE ACCOUNT CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA96CFF), Color(0xFF7A3FFF)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFF4EFFF),
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(8, 8)),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'CREATE ACCOUNT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Press Start 2P',
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Join the fighter community',
                        style: TextStyle(
                          color: Color(0xFFF4EFFF),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // FORM FIELDS
                      _buildField(
                        'Fighter Name',
                        Icons.person_outline,
                        _nameController,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        'Email Address',
                        Icons.email_outlined,
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        'Password',
                        Icons.lock_outline,
                        _passwordController,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggle: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        'Confirm Password',
                        Icons.lock_outline,
                        _confirmPasswordController,
                        isPassword: true,
                        obscureText: _obscureConfirm,
                        onToggle: () {
                          setState(() => _obscureConfirm = !_obscureConfirm);
                        },
                      ),

                      const SizedBox(height: 20),

                      // TERMS CHECKBOX
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _acceptTerms,
                              onChanged: (v) =>
                                  setState(() => _acceptTerms = v!),
                              activeColor: const Color(0xFFAFFF8B),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Color(0xFFF4EFFF),
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(text: 'I accept the '),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Color(0xFFAFFF8B),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: Color(0xFFAFFF8B),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // CREATE ACCOUNT BUTTON
                      GestureDetector(
                        onTap: _loading
                            ? null
                            : () async {
                                final name = _nameController.text.trim();
                                final email = _emailController.text.trim();
                                final password = _passwordController.text
                                    .trim();
                                final confirm = _confirmPasswordController.text
                                    .trim();

                                if (name.isEmpty ||
                                    email.isEmpty ||
                                    password.isEmpty ||
                                    confirm.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Semua field wajib diisi'),
                                    ),
                                  );
                                  return;
                                }
                                if (password != confirm) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Konfirmasi password tidak cocok',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (!_acceptTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Harap setujui Terms terlebih dahulu',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() => _loading = true);
                                try {
                                  // Step 1: Buat akun & sesi (fallback sign-in jika 409)
                                  final cred = await AuthService.instance
                                      .signUpOrSignIn(
                                        email: email,
                                        password: password,
                                      );
                                  final uid = cred.user!.uid;

                                  // Mulai listener notifikasi segera setelah berhasil login/signup
                                  try {
                                    await MatchesNotificationService.instance
                                        .startListening(uid);
                                    await ChatNotificationService.instance
                                        .startListening(uid);
                                  } catch (_) {
                                    // Abaikan jika gagal; tidak menghambat alur registrasi
                                  }

                                  // Step 2: Buat/Update profil user di database
                                  try {
                                    await FirestoreService.instance
                                        .ensureUserProfile(uid, {
                                          'displayName': name,
                                          'martialArt': 'unknown',
                                          'weightKg': 0,
                                          'heightCm': 0,
                                          'age': 0,
                                          'gender': 'unknown',
                                          'location': 'unknown',
                                          'experience': 'beginner',
                                          'about': '',
                                          'updatedAt': DateTime.now()
                                              .toIso8601String(),
                                        });
                                  } on AppwriteException catch (e) {
                                    // Detilkan error untuk diagnosa (code/message/response)
                                    // ignore: avoid_print
                                    print(
                                      '[Register] ensureUserProfile error: code=${e.code}, message=${e.message}, response=${e.response}',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Akun berhasil/sudah ada, tapi gagal membuat/memperbarui profil. Silakan coba lagi.',
                                        ),
                                      ),
                                    );
                                    return;
                                  } catch (e) {
                                    // ignore: avoid_print
                                    print(
                                      '[Register] ensureUserProfile unexpected error: $e',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Akun berhasil/sudah ada, tapi gagal membuat/memperbarui profil. Silakan coba lagi.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CreateProfileScreen(),
                                      ),
                                    );
                                  }
                                } on Exception catch (e) {
                                  // ignore: avoid_print
                                  print('[Register] signUp error: $e');
                                  final msg = e.toString();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Registrasi gagal: $msg'),
                                    ),
                                  );
                                } finally {
                                  if (mounted) setState(() => _loading = false);
                                }
                              },
                        child: Container(
                          height: 62,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
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
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                      fontFamily: 'Press Start 2P',
                                      fontSize: 14,
                                      color: Colors.white,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // FEATURE CARDS (persis mockup)
                _featureCard(
                  '🥊',
                  'FIND PARTNERS',
                  'Connect with fighters nearby who match your style and level',
                  [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                ),
                SizedBox(height: 16),
                _featureCard(
                  '🏆',
                  'TRACK PROGRESS',
                  'Earn achievements, level up, and become a champion',
                  [Color(0xFFA96CFF), Color(0xFFFF7CFD)],
                ),
                SizedBox(height: 16),
                _featureCard(
                  '💪',
                  'BUILD COMMUNITY',
                  'Join a supportive community of martial artists',
                  [Color(0xFFFF7CFD), Color(0xFF7A3FFF)],
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 71,
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFF4EFFF),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF4C2C82), offset: Offset(3, 3)),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF2B164A)),
            ),
          ),
          const Text(
            'REGISTER',
            style: TextStyle(
              color: Color(0xFFF9F8FF),
              fontSize: 14,
              fontFamily: 'Press Start 2P',
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF4EFFF), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
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

  Widget _featureCard(
    String emoji,
    String title,
    String description,
    List<Color> gradient,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF4EFFF), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Press Start 2P',
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFFF4EFFF),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
