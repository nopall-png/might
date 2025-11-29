import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:wmp/utils/storage_uploader_stub.dart'
    if (dart.library.io) 'package:wmp/utils/storage_uploader_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wmp/presentation/widgets/avatar_cropper.dart';
import 'package:wmp/presentation/widgets/responsive_app_bar.dart';
// Firebase imports dihapus, migrasi ke Appwrite

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  String gender = 'Male';
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController aboutCtrl = TextEditingController();
  String experience = 'Beginner';
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();
  bool _prefillLoading = false;
  String? _photoUrl;
  bool _uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    // Prefill from Firestore profile if available
    final uid = AuthService.instance.currentUser?.uid;
    _prefillLoading = true;
    if (uid != null) {
      FirestoreService.instance
          .getUserProfile(uid)
          .then((data) {
            if (data == null) return;
            nameCtrl.text = (data['displayName'] as String?) ?? '';
            _photoUrl = (data['photoUrl'] as String?);
            final ageVal = data['age'];
            if (ageVal is int) {
              ageCtrl.text = ageVal.toString();
            } else if (ageVal is String) {
              ageCtrl.text = ageVal;
            }
            gender = (data['gender'] as String?) ?? gender;
            locationCtrl.text = (data['location'] as String?) ?? '';
            aboutCtrl.text = (data['about'] as String?) ?? '';
            experience = (data['experience'] as String?) ?? experience;
            final weightVal = data['weightKg'];
            if (weightVal is int) {
              weightCtrl.text = weightVal.toString();
            } else if (weightVal is String) {
              weightCtrl.text = weightVal;
            }
            final heightVal = data['heightCm'];
            if (heightVal is int) {
              heightCtrl.text = heightVal.toString();
            } else if (heightVal is String) {
              heightCtrl.text = heightVal;
            }
            if (mounted)
              setState(() {
                _prefillLoading = false;
              });
          })
          .catchError((_) {
            if (mounted)
              setState(() {
                _prefillLoading = false;
              });
          });
    } else {
      _prefillLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width - 48;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: ResponsiveGradientAppBar(
        title: 'Edit Profile',
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  _buildProfileCard(cardWidth),
                  const SizedBox(height: 24),
                  _buildExperienceLevel(),
                  const SizedBox(height: 24),
                  _buildAboutMe(),
                  const SizedBox(height: 24),
                  _buildStatsInputs(),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                ],
              ),
            ),
            if (_prefillLoading)
              Container(
                color: Colors.black.withOpacity(0.08),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                ),
              ),
            if (_uploadingPhoto)
              Container(
                color: Colors.black.withOpacity(0.12),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildProfileCard(double cardWidth) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF7A3FFF), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF7A3FFF), width: 4),
                  borderRadius: BorderRadius.circular(64),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: (_photoUrl != null && _photoUrl!.isNotEmpty)
                      ? Image.network(
                          _photoUrl!,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stack) => Image.asset(
                            'assets/images/dummyimage.jpg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/dummyimage.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: -6,
                right: -6,
                child: GestureDetector(
                  onTap: _pickAndUploadPhoto,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A3FFF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C2C82),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _label('Full Name'),
          _input(nameCtrl),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Age'),
                    _input(ageCtrl, keyboardType: TextInputType.number),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Gender'),
                    _dropdown(
                      value: gender,
                      items: const ['Male', 'Female', 'Other'],
                      onChanged: (v) => setState(() => gender = v ?? gender),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          _label('Location'),
          _input(locationCtrl),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadPhoto() async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap login untuk mengubah foto')),
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;

      setState(() => _uploadingPhoto = true);

      // Baca bytes, tampilkan cropper UI, kemudian upload hasil crop
      final originalBytes = await file.readAsBytes();
      final croppedBytes = await showAvatarCropper(context, originalBytes);
      final toUpload = croppedBytes ?? originalBytes;
      final url = await uploadUserPhotoBytes(bytes: toUpload, uid: uid);
      await FirestoreService.instance.updateUserProfile(uid, {
        'photoUrl': url,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        setState(() => _photoUrl = url);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Foto profil diperbarui')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload foto: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Widget _buildExperienceLevel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 27, left: 27, right: 27, bottom: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Color(0xFF7A3FFF)),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(color: Color(0xFFE5D5FF), offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EXPERIENCE LEVEL',
            style: TextStyle(
              color: Color(0xFF1F1A2E),
              fontSize: 14,
              fontFamily: 'Press Start 2P',
              letterSpacing: 0.7,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _dropdown(
            value: experience,
            items: const ['Beginner', 'Intermediate', 'Advanced'],
            onChanged: (v) => setState(() => experience = v ?? experience),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMe() {
    return _section(
      title: 'ABOUT ME',
      child: TextField(
        controller: aboutCtrl,
        maxLines: 5,
        style: const TextStyle(fontSize: 16, color: Color(0xFF1F1A2E)),
        decoration: _inputDecoration(),
      ),
    );
  }

  Widget _buildStatsInputs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Color(0xFF7A3FFF)),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(color: Color(0xFFE5D5FF), offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STATISTICS',
            style: TextStyle(
              color: Color(0xFF1F1A2E),
              fontSize: 14,
              fontFamily: 'Press Start 2P',
              letterSpacing: 0.7,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Two inputs similar to weight/height cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadows: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weight',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: weightCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadows: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Height',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: heightCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () async {
        // Validasi form
        final name = nameCtrl.text.trim();
        final loc = locationCtrl.text.trim();
        final age = int.tryParse(ageCtrl.text.trim());
        final weight = int.tryParse(weightCtrl.text.trim());
        final height = int.tryParse(heightCtrl.text.trim());
        if (name.isEmpty || loc.isEmpty || age == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nama, usia, dan lokasi wajib diisi dengan benar'),
            ),
          );
          return;
        }
        if (weight == null || height == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berat dan tinggi harus berupa angka'),
            ),
          );
          return;
        }

        final uid = AuthService.instance.currentUser?.uid;
        if (uid == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada user yang login')),
          );
          return;
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 4,
            ),
          ),
        );
        try {
          await FirestoreService.instance.updateUserProfile(uid, {
            'displayName': name,
            'age': age,
            'gender': gender,
            'location': loc,
            'about': aboutCtrl.text.trim(),
            'experience': experience,
            'weightKg': weight,
            'heightCm': height,
            'updatedAt': DateTime.now().toIso8601String(),
          });

          if (mounted) Navigator.pop(context); // close loader
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Profile updated')));
          Navigator.pop(context);
        } catch (e) {
          if (mounted) Navigator.pop(context); // close loader
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal update profil: ${e.toString()}')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Center(
          child: Text(
            'EDIT PROFILE',
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 16,
              color: Color(0xFFF5EFFF),
            ),
          ),
        ),
      ),
    );
  }

  // Helpers
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF7A3FFF), fontSize: 12),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5EFFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF7A3FFF), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF7A3FFF), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFA96CFF), width: 2),
      ),
    );
  }

  Widget _input(
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: Color(0xFF1F1A2E)),
      decoration: _inputDecoration(),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF7A3FFF), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF7A3FFF), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
