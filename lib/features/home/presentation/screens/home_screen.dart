import 'package:flutter/material.dart';
import 'ai_classroom_screen.dart';
import 'ai_chat_screen.dart';
import 'profile_screen.dart';
import 'career_guidance_screen.dart';
import 'help_support_screen.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const AIClassroomScreen(),
    const AIChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AIChatScreen()));
        },
        backgroundColor: const Color(0xFF4F46E5),
        elevation: 4,
        shape: const CircleBorder),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 26),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home_filled, 'Home', 0),
              _buildBottomNavItem(Icons.smart_toy_outlined, 'AI Class', 1),
              const SizedBox(width: 40),
              _buildBottomNavItem(Icons.chat_bubble_outline, 'AI Chat', 2),
              _buildBottomNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8), size: 22),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final TextEditingController _searchController = TextEditingController();

  void _askAI(String query) {
    if (query.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIChatScreen(initialQuery: query.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bolt, color: Color(0xFF4F46E5), size: 30),
                      SizedBox(width: 4),
                      Text(
                        'EDUVA',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen())),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(20)),
                          child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
                        icon: const Icon(Icons.help_outline, color: Color(0xFF4F46E5)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Namaste 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Champion!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5))),
                          SizedBox(height: 6),
                          Text('Aaj kya padhna hai?', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.school, size: 50, color: Color(0xFF4F46E5)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Comprehensive AI Search Bar (Type, Camera, Mic, Upload & Ask)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _askAI,
                        decoration: const InputDecoration(
                          hintText: 'Question type karein...',
                          hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF8B5CF6), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _askAI("📷 [Photo Doubt: Scan and Solve this problem]"),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.mic_none, color: Color(0xFFEC4899), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _askAI("🎙️ [Voice Question: Explain this concept simply]"),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.upload_file_outlined, color: Color(0xFF0EA5E9), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _askAI("📄 [PDF Upload Doubt: Explain chapter topics]"),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF4F46E5), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _askAI(_searchController.text),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text('✨ Ask Your Way ✨', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5))),
              ),
              const SizedBox(height: 12),

              // 4 Direct Action Cards
              Row(
                children: [
                  _buildAskItem(Icons.camera_alt_rounded, 'Camera', 'Photo kheecho', const Color(0xFF8B5CF6), () {
                    _askAI("📷 [Photo Doubt: Scan and solve the problem from image]");
                  }),
                  const SizedBox(width: 8),
                  _buildAskItem(Icons.keyboard_rounded, 'Type', 'Likhe karke', const Color(0xFF10B981), () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AIChatScreen()));
                  }),
                  const SizedBox(width: 8),
                  _buildAskItem(Icons.mic_rounded, 'Voice', 'Bol kar', const Color(0xFFEC4899), () {
                    _askAI("🎙️ [Voice Question: Explain Pythagoras theorem and formulas]");
                  }),
                  const SizedBox(width: 8),
                  _buildAskItem(Icons.upload_file_rounded, 'Upload PDF', 'PDF se', const Color(0xFF0EA5E9), () {
                    _askAI("📄 [PDF Document: Explain key definitions and summary]");
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Feature Icons Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFeature(Icons.track_changes, 'Mock Test', const Color(0xFF8B5CF6), () {
                    _askAI("Generate a 5-question Mock Test with answers");
                  }),
                  _buildFeature(Icons.menu_book, 'Material', const Color(0xFFF59E0B), () {
                    _askAI("Show Class 10/12 Science & Maths Study Material");
                  }),
                  _buildFeature(Icons.explore, 'Career', const Color(0xFF3B82F6), () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerGuidanceScreen()));
                  }),
                  _buildFeature(Icons.help, 'Support', const Color(0xFF10B981), () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                  }),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAskItem(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              Text(subtitle, style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
