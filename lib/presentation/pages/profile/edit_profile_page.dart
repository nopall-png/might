import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutController = TextEditingController();

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "EDIT PROFILE",
          style: TextStyle(
            fontFamily: 'Press Start 2P',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
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
              children: [
                const SizedBox(height: 24),

                // ✅ PROFILE PHOTO
                const Text(
                  'PROFILE PHOTO',
                  style: TextStyle(
                    fontFamily: 'Press Start 2P',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF4C2C82),
                            offset: Offset(8, 8),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7CFD),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ✅ NAME
                _buildSectionTitle("FIGHTER NAME"),
                _buildTextField(_nameController, "Enter your name"),

                const SizedBox(height: 28),

                // ✅ MARTIAL ART STYLE
                _buildSectionTitle("MARTIAL ART STYLE"),
                _buildDropdown(
                  "Pick your style",
                  martialArts,
                  selectedStyle,
                  (val) => setState(() => selectedStyle = val),
                ),

                const SizedBox(height: 28),

                // ✅ GENDER
                _buildSectionTitle("GENDER"),
                _buildDropdown(
                  "Pick gender",
                  genders,
                  selectedGender,
                  (val) => setState(() => selectedGender = val),
                ),

                const SizedBox(height: 28),

                // ✅ LEVEL
                _buildSectionTitle("EXPERIENCE LEVEL"),
                Row(
                  children: levels
                      .map(
                        (level) => Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedLevel = level),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: selectedLevel == level
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFFA96CFF),
                                          Color(0xFFFF7CFD),
                                        ],
                                      )
                                    : null,
                                color: selectedLevel == level
                                    ? null
                                    : Colors.white,
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
                              ),
                              child: Center(
                                child: Text(
                                  level,
                                  style: TextStyle(
                                    color: selectedLevel == level
                                        ? Colors.white
                                        : const Color(0xFF2B164A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 28),

                // ✅ LOCATION
                _buildSectionTitle("LOCATION"),
                _buildTextField(_locationController, "City / Country"),

                const SizedBox(height: 28),

                // ✅ ABOUT
                _buildSectionTitle("ABOUT YOU"),
                _buildTextArea(),

                const SizedBox(height: 40),

                // ✅ SAVE BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                        'SAVE CHANGES',
                        style: TextStyle(
                          fontFamily: 'Press Start 2P',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ UI HELPERS
  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Press Start 2P',
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF4EFFF), width: 3),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: const TextStyle(color: Colors.black54)),
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF4EFFF), width: 3),
      ),
      child: TextField(
        controller: _aboutController,
        maxLines: 4,
        maxLength: 100,
        style: const TextStyle(color: Colors.black87),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Say something short...",
          contentPadding: EdgeInsets.all(16),
          counterText: '',
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
