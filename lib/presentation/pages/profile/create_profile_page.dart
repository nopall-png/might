import 'package:flutter/material.dart';
import 'package:wmp/presentation/pages/onboarding/welcome_arena_screen.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
// Migrated: remove Firebase imports
import 'package:wmp/utils/storage_uploader_stub.dart'
    if (dart.library.io) 'package:wmp/utils/storage_uploader_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wmp/presentation/widgets/avatar_cropper.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutController = TextEditingController();

  String? _photoUrl;
  bool _uploadingPhoto = false;

  String? selectedStyle;
  String? selectedGender;
  String? selectedLevel;

  final List<String> martialArts = [
    'Boxing 🥊',
    'Muay Thai 🦵',
    'Brazilian Jiu-Jitsu (BJJ) 🟪',
    'Wrestling 🤼',
    'Karate 🥋',
    'Taekwondo 🥋',
    'Judo 🥋',
    'MMA 🥊',
    'Kickboxing 🥊',
  ];

  final List<String> genders = ['Male', 'Female', 'Prefer not to say'];
  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF2B164A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7A3FFF), Color(0xFF2B164A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // TITLE
                const Text(
                  'CREATE PROFILE',
                  style: TextStyle(
                    fontFamily: 'Press Start 2P',
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Set up your fighter profile',
                  style: TextStyle(color: Color(0xFFF4EFFF), fontSize: 16),
                ),

                const SizedBox(height: 40),

                // PROFILE PHOTO
                const Text(
                  'PROFILE PHOTO',
                  style: TextStyle(
                    fontFamily: 'Press Start 2P',
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadPhoto,
                      child: Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFF4EFFF),
                            width: 4,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF4C2C82),
                              offset: Offset(8, 8),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _uploadingPhoto
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 4,
                                ),
                              )
                            : (_photoUrl != null && _photoUrl!.isNotEmpty)
                            ? Image.network(
                                _photoUrl!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stack) =>
                                    const Icon(
                                      Icons.camera_alt,
                                      size: 48,
                                      color: Colors.white70,
                                    ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 48,
                                color: Colors.white70,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickAndUploadPhoto,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7CFD),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF4C2C82),
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Add a clear photo — helmets and masks optional',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFF4EFFF), fontSize: 14),
                ),

                const SizedBox(height: 40),

                // FIGHTER NAME
                _buildSectionTitle('FIGHTER NAME *'),
                _buildTextField(_nameController, 'Enter your display name'),
                _buildHint('This name will be visible to others.'),

                const SizedBox(height: 32),

                // MARTIAL ART STYLE
                _buildSectionTitle('MARTIAL ART STYLE *'),
                _buildDropdown(
                  'Choose your main fighting discipline.',
                  martialArts,
                  selectedStyle,
                  (val) => setState(() => selectedStyle = val),
                ),

                const SizedBox(height: 32),

                // WEIGHT & HEIGHT ROW
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('WEIGHT (KG) *'),
                          _buildTextField(
                            _weightController,
                            'e.g., 70',
                            keyboardType: TextInputType.number,
                          ),
                          _buildHint('For weight class', fontSize: 12),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('HEIGHT (CM) *'),
                          _buildTextField(
                            _heightController,
                            'e.g., 175',
                            keyboardType: TextInputType.number,
                          ),
                          _buildHint('Balance matchups', fontSize: 12),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // AGE & GENDER ROW
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('AGE *'),
                          _buildTextField(
                            _ageController,
                            'e.g., 19',
                            keyboardType: TextInputType.number,
                          ),
                          _buildHint('Must be 16+', fontSize: 12),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('GENDER'),
                          _buildDropdown(
                            'Select gender',
                            genders,
                            selectedGender,
                            (val) => setState(() => selectedGender = val),
                            height: 62,
                          ),
                          _buildHint('For filters only', fontSize: 12),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // LOCATION
                _buildSectionTitle('LOCATION *'),
                _buildTextField(
                  _locationController,
                  'e.g., Jakarta, Bandung, Bali',
                ),
                _buildHint('So we can connect you with fighters near you.'),

                const SizedBox(height: 32),

                // EXPERIENCE LEVEL
                _buildSectionTitle('EXPERIENCE LEVEL'),
                Row(
                  children: levels
                      .map(
                        (level) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => selectedLevel = level),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFF4EFFF),
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFF4C2C82),
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                  gradient: selectedLevel == level
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFA96CFF),
                                            Color(0xFFFF7CFD),
                                          ],
                                        )
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    level,
                                    style: TextStyle(
                                      color: selectedLevel == level
                                          ? Colors.white
                                          : const Color(0xFF2B164A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                _buildHint(
                  'Tell others your experience so you\'re matched fairly.',
                ),

                const SizedBox(height: 32),

                // ABOUT YOU
                _buildSectionTitle('ABOUT YOU'),
                const SizedBox(height: 8),

                // TextField dengan tinggi tetap biar nggak overflow
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFF4EFFF),
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
                    ],
                  ),
                  child: TextField(
                    controller: _aboutController,
                    maxLines: 4,
                    maxLength: 100,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText:
                          'Write a short line about your fighting style or goals.',
                      hintStyle: TextStyle(color: Color(0xFFB6A9D7)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      counterText: '', // sembunyiin counter bawaan
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                const SizedBox(height: 8),

                // Counter + keterangan — DI BUNGKUS COLUMN BIAR NGGAK OVERFLOW
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Keep it short and punchy — max 100 characters.',
                            style: TextStyle(
                              color: Color(0xFFF4EFFF),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_aboutController.text.length}/100',
                            style: const TextStyle(
                              color: Color(0xFFF4EFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // INFO BOX
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF4EFFF),
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Your info helps us suggest fair and safe matchups. Use real data for accurate pairing.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // SAVE & CONTINUE BUTTON → SIMPAN KE FIRESTORE LALU KE WELCOME ARENA
                GestureDetector(
                  onTap: () async {
                    // VALIDASI SEDERHANA (biar nggak kosong)
                    if (_nameController.text.isEmpty ||
                        selectedStyle == null ||
                        _weightController.text.isEmpty ||
                        _heightController.text.isEmpty ||
                        _ageController.text.isEmpty ||
                        _locationController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Lengkapi semua field wajib dulu bro!'),
                        ),
                      );
                      return;
                    }

                    // Loading biar keren
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 5,
                        ),
                      ),
                    );

                    try {
                      final uid = AuthService.instance.currentUser?.uid;
                      if (uid == null) {
                        throw Exception('User belum login');
                      }

                      await FirestoreService.instance.updateUserProfile(uid, {
                        'displayName': _nameController.text.trim(),
                        'martialArt': selectedStyle,
                        'weightKg': int.tryParse(_weightController.text.trim()),
                        'heightCm': int.tryParse(_heightController.text.trim()),
                        'age': int.tryParse(_ageController.text.trim()),
                        'gender': selectedGender,
                        'location': _locationController.text.trim(),
                        'experience': selectedLevel,
                        'about': _aboutController.text.trim(),
                        if (_photoUrl != null && _photoUrl!.isNotEmpty)
                          'photoUrl': _photoUrl,
                        'updatedAt': DateTime.now().toIso8601String(),
                      });
                    } catch (e) {
                      if (mounted) Navigator.pop(context); // tutup loader
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(
                            'Gagal menyimpan profil: ${e.toString()}',
                          ),
                        ),
                      );
                      return;
                    }

                    // Tutup loading
                    if (mounted) Navigator.pop(context);

                    // KE WELCOME ARENA SCREEN
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeArenaScreen(
                            displayName: _nameController.text.trim(),
                            martialArt: selectedStyle!,
                            // profilePhotoUrl: nanti kalau udah ada foto
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 62,
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
                    child: const Center(
                      child: Text(
                        'SAVE & CONTINUE',
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

                const SizedBox(height: 16),
                const Text(
                  'You can update your profile anytime in Settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFF4EFFF), fontSize: 14),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Press Start 2P',
        fontSize: 14,
        color: Colors.white,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB6A9D7)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFF4EFFF), width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFF4EFFF), width: 3),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    Function(String?) onChanged, {
    double height = 62,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF4EFFF), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFFB6A9D7), fontSize: 16),
          ),
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildHint(String text, {double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(color: const Color(0xFFF4EFFF), fontSize: fontSize),
      ),
    );
  }

  Future<void> _pickAndUploadPhoto() async {
    if (_uploadingPhoto) return;
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Belum login — tidak bisa unggah foto.'),
        ),
      );
      return;
    }
    final picker = ImagePicker();
    try {
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;
      setState(() => _uploadingPhoto = true);
      final originalBytes = await file.readAsBytes();
      final croppedBytes = await showAvatarCropper(context, originalBytes);
      final toUpload = croppedBytes ?? originalBytes;
      final url = await uploadUserPhotoBytes(bytes: toUpload, uid: uid);
      // Simpan ke state dan (opsional) langsung update profil agar tersimpan
      setState(() => _photoUrl = url);
      await FirestoreService.instance.updateUserProfile(uid, {
        'photoUrl': url,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Gagal upload foto: ${e.toString()}'),
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }
}
