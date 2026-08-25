import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const EduvaMasterApp());
}

class EduvaMasterApp extends StatelessWidget {
  const EduvaMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDUVA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    AboutUsScreen(),
    AIClassroomScreen(),
    AIChatScreen(),
    CareerGuidanceScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_outlined, Icons.home, "Home", 0),
                _navItem(Icons.ondemand_video_outlined, Icons.ondemand_video, "AI Classroom", 1),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Instant Camera Doubt Solver Ready! Point at any book question.")),
                    );
                    setState(() => _currentIndex = 2);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 26),
                  ),
                ),
                _navItem(Icons.trending_up, Icons.trending_up, "Progress", 3),
                _navItem(Icons.person_outline, Icons.person, "Profile", 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Column(
          mainAxisSize: dynamic_size(isSelected),
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade600,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  MainAxisSize dynamic_size(bool _) => MainAxisSize.min;
}

// 1. ABOUT US SCREEN
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.token, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text("EDUVA", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Color(0xFF1E3A8A))),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent), onPressed: () {})
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Welcome to", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                        const Text("Eduva ✨", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                        const SizedBox(height: 8),
                        Text(
                          "Eduva is an AI-powered learning platform built to make quality education simple, interactive and accessible for every student.",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "That's why we created Edu Sir — your personal AI teacher.",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFDBEAFE),
                      ),
                      child: const Icon(Icons.face_retouching_natural, size: 70, color: Color(0xFF1D4ED8)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _cardInfo(Icons.track_changes, "Our Mission", "To make high-quality education accessible through AI.", const Color(0xFF10B981), const Color(0xFFECFDF5))),
                const SizedBox(width: 12),
                Expanded(child: _cardInfo(Icons.visibility, "Our Vision", "To become the world's most trusted AI learning platform.", const Color(0xFF8B5CF6), const Color(0xFFF5F3FF))),
              ],
            ),
            const SizedBox(height: 20),
            const Center(child: Text("— What Makes Eduva Different? —", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _featureBadge(Icons.person, "Edu Sir", "Your AI Teacher", const Color(0xFF3B82F6)),
                  _featureBadge(Icons.camera_alt, "Instant Camera", "Doubt Solving", const Color(0xFF10B981)),
                  _featureBadge(Icons.edit_note, "Step-by-step", "Explanations", const Color(0xFFF59E0B)),
                  _featureBadge(Icons.view_in_ar, "3D Learning", "Whiteboard", const Color(0xFF8B5CF6)),
                  _featureBadge(Icons.picture_as_pdf, "PDF Learning", "Support", const Color(0xFFEF4444)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, color: Color(0xFF2563EB), size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Our Promise", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("We don't just give answers. We help students understand, learn, practice and grow.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(child: Text("Learn Better. Grow Faster.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade800)))
          ],
        ),
      ),
    );
  }

  Widget _cardInfo(IconData icon, String title, String desc, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.3)),
        ],
      ),
    );
  }

  Widget _featureBadge(IconData icon, String title, String sub, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

// 2. AI CLASSROOM
class AIClassroomScreen extends StatefulWidget {
  const AIClassroomScreen({super.key});

  @override
  State<AIClassroomScreen> createState() => _AIClassroomScreenState();
}

class _AIClassroomScreenState extends State<AIClassroomScreen> {
  bool is3DMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Classroom", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => is3DMode = false),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text("Board Mode"),
                  style: ElevatedButton.styleFrom(backgroundColor: !is3DMode ? const Color(0xFF2563EB) : Colors.grey.shade200, foregroundColor: !is3DMode ? Colors.white : Colors.black87),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => setState(() => is3DMode = true),
                  icon: const Icon(Icons.view_in_ar, size: 16),
                  label: const Text("3D Mode"),
                  style: ElevatedButton.styleFrom(backgroundColor: is3DMode ? const Color(0xFF2563EB) : Colors.grey.shade200, foregroundColor: is3DMode ? Colors.white : Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0), width: 2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Human Heart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  const SizedBox(height: 8),
                  const Text("• The heart is a muscular organ.\n• Pumps blood to all parts of the body.\n• Has 4 chambers (Right/Left Atrium & Ventricles).", style: TextStyle(fontSize: 13, height: 1.5)),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(is3DMode ? Icons.view_in_ar : Icons.favorite, size: 72, color: Colors.red.shade400),
                          const SizedBox(height: 8),
                          Text(is3DMode ? "Interactive 3D Heart Simulation" : "Anatomical Diagram of Heart", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. AI CHAT
class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<Map<String, String>> _messages = [
    {'role': 'user', 'text': 'Sir, please solve this right triangle question step by step:\nAC = 25m, BC = 7m, find h (AB).'},
    {'role': 'ai', 'text': 'Sure, Champion! 😊\nBy Pythagoras Theorem:\nAC² = AB² + BC²\n(25)² = h² + (7)²\n625 = h² + 49\nh² = 576\nh = 24 m\nHeight (AB) is 24 m. ✅'}
  ];
  final _controller = TextEditingController();
  static final String _apiKey = utf8.decode(base64.decode('QVEuQWI4Uk42SkVBMURYT3ZrTnQ4Vk9MMkpOcDYyQTFaRllmREZpYU5rOU1LRVJBWkxCNEE='));

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _messages.add({'role': 'user', 'text': text}));
    _controller.clear();

    try {
      final res = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contents': [{'parts': [{'text': text}]}]}),
      );

      if (res.statusCode == 200) {
        final d = jsonDecode(res.body);
        final ans = d['candidates'][0]['content']['parts'][0]['text'];
        setState(() => _messages.add({'role': 'ai', 'text': ans}));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chat (Edu Sir)"), backgroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final isUser = _messages[i]['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(color: isUser ? const Color(0xFF2563EB) : Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Text(_messages[i]['text']!, style: TextStyle(color: isUser ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Ask anything...", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send, color: Color(0xFF2563EB)), onPressed: _send),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 4. CAREER GUIDANCE
class CareerGuidanceScreen extends StatelessWidget {
  const CareerGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career Guidance"), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]), borderRadius: BorderRadius.circular(16)),
              child: const Text("AI Career Test & Roadmaps for Students", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 16),
            const ListTile(leading: Icon(Icons.engineering, color: Colors.blue), title: Text("AI Engineer Roadmap"), subtitle: Text("12 Skills • ₹12 LPA")),
            const ListTile(leading: Icon(Icons.medical_services, color: Colors.green), title: Text("Doctor (MBBS) Roadmap"), subtitle: Text("15 Skills • ₹10 LPA")),
          ],
        ),
      ),
    );
  }
}

// 5. PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 36, backgroundColor: Color(0xFF2563EB), child: Icon(Icons.person, size: 42, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("Ankit (Kanha Jain)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Class 11th • JEE 2026", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: Color(0xFF2563EB)),
                title: const Text("Help & Support"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
