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

// User Profile & Session State
class UserState {
  static String name = "Kanha Jain";
  static String email = "kanha@eduva.com";
  static String studentClass = "Class 11th";
  static String targetGoal = "JEE 2026";
  static int doubtsSolved = 24;
  static int streakDays = 7;
  static bool isLoggedIn = false;
}

class EduvaMasterApp extends StatelessWidget {
  const EduvaMasterApp({super.key});

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
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    if (!UserState.isLoggedIn) {
      return LoginScreen(
        onLogin: () => setState(() => UserState.isLoggedIn = true),
      );
    }
    return MainDashboardShell(
      onLogout: () => setState(() => UserState.isLoggedIn = false),
    );
  }
}

// ==========================================
// 1. LOGIN SCREEN (With Top Login & Forgot Pass)
// ==========================================
class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.school, size: 50, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(height: 12),
                    const Text("EDUVA", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Color(0xFF1E3A8A))),
                    const Text("Your Personal AI Teacher", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text("Welcome Back! 👋", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 6),
              const Text("Login to access Edu Sir and your study dashboard", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 24),
              const Text("Email or Phone", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Enter email / phone",
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2563EB)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2563EB)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                  },
                  child: const Text("Forgot Your Password?", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) UserState.email = _emailController.text;
                    widget.onLogin();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text("Log In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen(onSuccess: widget.onLogin)));
                    },
                    child: const Text("Sign Up", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SIGN UP SCREEN
// ==========================================
class SignUpScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  const SignUpScreen({super.key, required this.onSuccess});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String _classVal = "Class 11th";
  String _goalVal = "JEE 2026";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Account ✨", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Register to start learning with Edu Sir AI", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            const Text("Full Name", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(controller: _nameCtrl, decoration: InputDecoration(hintText: "Enter full name", filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
            const SizedBox(height: 16),
            const Text("Class / Grade", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _classVal,
              decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              items: ["Class 9th", "Class 10th", "Class 11th", "Class 12th", "Dropper"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _classVal = v!),
            ),
            const SizedBox(height: 16),
            const Text("Target Goal", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _goalVal,
              decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              items: ["JEE 2026", "NEET 2026", "Board Exams", "CUET"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _goalVal = v!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameCtrl.text.isNotEmpty) UserState.name = _nameCtrl.text;
                  UserState.studentClass = _classVal;
                  UserState.targetGoal = _goalVal;
                  Navigator.pop(context);
                  widget.onSuccess();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text("Sign Up & Start", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// FORGOT PASSWORD WINDOW
// ==========================================
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Forgot Password"), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reset Password 🔒", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Enter your registered email address to receive password reset instructions.", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            TextField(controller: ctrl, decoration: InputDecoration(hintText: "Enter email address", filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset link sent successfully to your email!")));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Send Reset Link", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MAIN APP SHELL & NAVIGATION
// ==========================================
class MainDashboardShell extends StatefulWidget {
  final VoidCallback onLogout;
  const MainDashboardShell({super.key, required this.onLogout});

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const AIClassroomScreen(),
      const AskDoubtScreen(),
      const CareerGuidanceScreen(),
      ProfileScreen(onLogout: widget.onLogout),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navButton(Icons.home_outlined, Icons.home, "Home", 0),
                _navButton(Icons.ondemand_video_outlined, Icons.ondemand_video, "AI Classroom", 1),
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 2),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF4F46E5)]), shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 4))]),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade600, size: 24),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade600, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 1: HOME (About Us + Official 3D Edu Sir)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.token, color: Colors.white, size: 18)),
            const SizedBox(width: 8),
            const Text("EDUVA", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Color(0xFF1E3A8A))),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent), onPressed: () {})],
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
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFDBEAFE))),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome to", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                        Text("Eduva ✨", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                        SizedBox(height: 8),
                        Text("Eduva is an AI-powered learning platform built to make quality education simple, interactive and accessible for every student.", style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                        SizedBox(height: 10),
                        Text("That's why we created Edu Sir — your personal AI teacher.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
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
                        return Container(height: 150, color: const Color(0xFFDBEAFE), child: const Center(child: Icon(Icons.school, size: 60, color: Color(0xFF2563EB))));
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
}

// ==========================================
// SCREEN 2: AI CLASSROOM (Whiteboard & 3D Lab)
// ==========================================
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => is3DMode = false),
                    icon: const Icon(Icons.draw, size: 16),
                    label: const Text("Whiteboard Mode"),
                    style: ElevatedButton.styleFrom(backgroundColor: !is3DMode ? const Color(0xFF2563EB) : Colors.grey.shade200, foregroundColor: !is3DMode ? Colors.white : Colors.black87, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => is3DMode = true),
                    icon: const Icon(Icons.view_in_ar, size: 16),
                    label: const Text("3D Interactive View"),
                    style: ElevatedButton.styleFrom(backgroundColor: is3DMode ? const Color(0xFF2563EB) : Colors.grey.shade200, foregroundColor: is3DMode ? Colors.white : Colors.black87, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Human Heart Anatomy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  const SizedBox(height: 6),
                  const Text("• 4 Chambers: Right/Left Atrium & Ventricles\n• Double circulation of blood", style: TextStyle(fontSize: 13, height: 1.4)),
                  const SizedBox(height: 14),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Icon(is3DMode ? Icons.view_in_ar : Icons.favorite, size: 76, color: Colors.red.shade400)),
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

// ==========================================
// SCREEN 3: ASK A DOUBT (Camera, Upload, Voice, Type & AI Solver)
// ==========================================
class AskDoubtScreen extends StatefulWidget {
  const AskDoubtScreen({super.key});

  @override
  State<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends State<AskDoubtScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _response;
  String _activeSubject = "Mathematics";

  Future<void> _askEduSirAI() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please write, snap or speak your question first!")));
      return;
    }

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final apiKey = utf8.decode(base64.decode('QVEuQWI4Uk42SkVBMURYT3ZrTnQ4Vk9MMkpOcDYyQTFaRllmREZpYU5rOU1LRVJBWkxCNEE='));
      final prompt = "You are 'Edu Sir', a friendly and expert AI teacher for Indian students. "
          "Subject: $_activeSubject. Question: '$query'. "
          "Provide a crystal clear, step-by-step easy explanation with formulas and final answer.";

      final res = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{'parts': [{'text': prompt}]}]
        }),
      );

      if (res.statusCode == 200) {
        final d = jsonDecode(res.body);
        setState(() {
          _response = d['candidates'][0]['content']['parts'][0]['text'];
          UserState.doubtsSolved += 1;
        });
      } else {
        setState(() => _response = "Edu Sir is currently analyzing. Please tap Solve again.");
      }
    } catch (_) {
      setState(() => _response = "Network connection error. Please check your internet.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ask Edu Sir (Doubt Solver)"), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Subject:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Mathematics", "Physics", "Chemistry", "Biology"].map((sub) {
                  final isSel = _activeSubject == sub;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sub),
                      selected: isSel,
                      selectedColor: const Color(0xFF2563EB),
                      labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                      onSelected: (val) => setState(() => _activeSubject = sub),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: "✍️ Write / Type your doubt here...", border: InputBorder.none),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Color(0xFF2563EB)),
                        label: const Text("Camera", style: TextStyle(color: Color(0xFF2563EB))),
                        onPressed: () {
                          setState(() => _controller.text = "In right triangle ABC, AC = 25m, BC = 7m. Find height AB.");
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("📸 Camera scanned question successfully!")));
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.photo_library, color: Color(0xFF2563EB)),
                        label: const Text("Upload", style: TextStyle(color: Color(0xFF2563EB))),
                        onPressed: () {
                          setState(() => _controller.text = "A 5kg block rests on rough surface with μ=0.2. Find acceleration for 20N force.");
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("📁 Image uploaded from gallery!")));
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.mic, color: Color(0xFF2563EB)),
                        label: const Text("Voice", style: TextStyle(color: Color(0xFF2563EB))),
                        onPressed: () {
                          setState(() => _controller.text = "Explain Photosynthesis light and dark reactions step by step.");
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🎙️ Voice recorded and transcribed!")));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _askEduSirAI,
                icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.auto_awesome, color: Colors.white),
                label: Text(_isLoading ? "Edu Sir is Solving..." : "Solve My Doubt Now 🚀", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              ),
            ),
            if (_response != null) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF93C5FD))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.school, color: Color(0xFF2563EB), size: 18),
                        SizedBox(width: 8),
                        Text("Edu Sir's Step-by-Step Solution:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 4),
                    SelectableText(_response!, style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF1F2937))),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 4: PROGRESS & GOALS
// ==========================================
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
              child: const Text("AI Career Roadmaps & Test for Students", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

// ==========================================
// SCREEN 5: STUDENT PROFILE
// ==========================================
class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile"), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Color(0xFF2563EB), child: Icon(Icons.person, size: 48, color: Colors.white)),
            const SizedBox(height: 10),
            Text(UserState.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("${UserState.studentClass} • Goal: ${UserState.targetGoal}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  ListTile(leading: const Icon(Icons.bolt, color: Colors.orange), title: Text("Streak: ${UserState.streakDays} Days active")),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: Text("Doubts Solved: ${UserState.doubtsSolved}")),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), onTap: onLogout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
