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
  runApp(const EduvaApp());
}

class UserState {
  static String name = "Kanha Jain";
  static String email = "student@eduva.com";
  static String studentClass = "Class 11th";
  static String targetGoal = "JEE 2026";
  static int doubtsSolved = 18;
  static int streakDays = 7;
  static bool isLoggedIn = true;
}

class EduvaApp extends StatelessWidget {
  const EduvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDUVA - AI Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          surface: Colors.white,
        ),
      ),
      home: const MainDashboardShell(),
    );
  }
}

class MainDashboardShell extends StatefulWidget {
  const MainDashboardShell({super.key});

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const AIClassroomScreen(),
    const AskDoubtScreen(),
    const CareerGuidanceScreen(),
    const ProfileScreen(),
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
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navButton(Icons.home_outlined, Icons.home, "Home", 0),
                _navButton(Icons.ondemand_video_outlined, Icons.ondemand_video, "AI Classroom", 1),
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 2),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 26),
                  ),
                ),
                _navButton(Icons.auto_graph_outlined, Icons.auto_graph, "Progress", 3),
                _navButton(Icons.person_outline, Icons.person, "Profile", 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, IconData activeIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
}

// 1. HOME SCREEN (About Us & Edu Sir 3D Banner)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    child: Image.asset(
                      'assets/images/edu_sir_board.png',
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          color: const Color(0xFFDBEAFE),
                          child: const Center(child: Icon(Icons.school, size: 64, color: Color(0xFF2563EB))),
                        );
                      },
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
      appBar: AppBar(title: const Text("AI Classroom & 3D Lab"), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => is3DMode = false),
                    icon: const Icon(Icons.draw, size: 16),
                    label: const Text("Board Mode"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !is3DMode ? const Color(0xFF2563EB) : Colors.grey.shade200,
                      foregroundColor: !is3DMode ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => is3DMode = true),
                    icon: const Icon(Icons.view_in_ar, size: 16),
                    label: const Text("3D Mode"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: is3DMode ? const Color(0xFF2563EB) : Colors.grey.shade200,
                      foregroundColor: is3DMode ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Human Heart Anatomy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  const SizedBox(height: 6),
                  const Text("• Muscular organ with 4 distinct chambers\n• Interventricular septum separates oxygenated & deoxygenated blood", style: TextStyle(fontSize: 13, height: 1.4)),
                  const SizedBox(height: 14),
                  Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Icon(is3DMode ? Icons.view_in_ar : Icons.favorite, size: 70, color: Colors.red.shade400),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 3. ASK DOUBT / AI CHAT
class AskDoubtScreen extends StatefulWidget {
  const AskDoubtScreen({super.key});

  @override
  State<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends State<AskDoubtScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _response;

  Future<void> _askAI() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final apiKey = utf8.decode(base64.decode('QVEuQWI4Uk42SkVBMURYT3ZrTnQ4Vk9MMkpOcDYyQTFaRllmREZpYU5rOU1LRVJBWkxCNEE='));
      final res = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [{'text': "You are Edu Sir, an expert AI teacher. Provide crystal clear step by step solution: " + text}]
            }
          ]
        }),
      );

      if (res.statusCode == 200) {
        final d = jsonDecode(res.body);
        setState(() => _response = d['candidates'][0]['content']['parts'][0]['text']);
      } else {
        setState(() => _response = "Edu Sir is busy. Please ask again.");
      }
    } catch (_) {
      setState(() => _response = "Network error. Please check your internet connection.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ask Edu Sir (Live AI)"), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: "✍️ Write / Type your question here...", border: InputBorder.none),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(icon: const Icon(Icons.camera_alt, color: Color(0xFF2563EB)), onPressed: () => _controller.text = "In a right triangle ABC, AC = 25m, BC = 7m. Find AB."),
                      IconButton(icon: const Icon(Icons.photo, color: Color(0xFF2563EB)), onPressed: () => _controller.text = "State Ohm's law and write its mathematical formula."),
                      IconButton(icon: const Icon(Icons.mic, color: Color(0xFF2563EB)), onPressed: () => _controller.text = "Explain Photosynthesis light and dark reactions."),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _askAI,
                icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send, color: Colors.white),
                label: Text(_isLoading ? "Edu Sir is Solving..." : "Solve My Doubt 🚀", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (_response != null) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF93C5FD))),
                child: SelectableText(_response!, style: const TextStyle(fontSize: 14, height: 1.5)),
              )
            ]
          ],
        ),
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
      appBar: AppBar(title: const Text("Career Guidance"), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]), borderRadius: BorderRadius.circular(16)),
              child: const Text("AI Career Test & Roadmaps for Classes 9-12", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 38, backgroundColor: Color(0xFF2563EB), child: Icon(Icons.person, size: 44, color: Colors.white)),
            const SizedBox(height: 10),
            Text(UserState.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("${UserState.studentClass} • Goal: ${UserState.targetGoal}", style: const TextStyle(color: Colors.grey)),
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
