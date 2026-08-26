import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const EduvaMasterApp());
}

class UserState {
  static String name = "Guest Student";
  static String email = "student@eduva.com";
  static String phone = "";
  static String studentClass = "Class 11th";
  static String targetGoal = "JEE 2026";
  static int doubtsSolved = 0;
  static int streakDays = 1;
  static bool isLoggedIn = false;
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onAskDoubtTab: () => setState(() => _currentIndex = 2)),
      const AIClassroomScreen(),
      const AskDoubtScreen(),
      const CareerGuidanceScreen(),
      ProfileScreen(onRefresh: () => setState(() {})),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))
          ],
        ),
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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF4F46E5)]),
                      shape: BoxShape.circle,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade600, size: 24),
            Text(label, style: TextStyle(color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade600, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// 1. HOME SCREEN
class HomeScreen extends StatelessWidget {
  final VoidCallback onAskDoubtTab;
  const HomeScreen({super.key, required this.onAskDoubtTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.token, color: Colors.white, size: 18)),
            const SizedBox(width: 8),
            const Text("EDUVA", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A))),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: Icon(UserState.isLoggedIn ? Icons.person : Icons.login, size: 16),
              label: Text(UserState.isLoggedIn ? UserState.name.split(' ')[0] : "Log In"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
            ),
          )
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
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFDBEAFE))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Welcome to", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                        const Text("Eduva ✨", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                        const SizedBox(height: 8),
                        const Text("Eduva is an AI-powered learning platform built to make quality education simple, interactive and accessible for every student.", style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                        const SizedBox(height: 10),
                        const Text("That's why we created Edu Sir — your personal AI teacher.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
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
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.school, size: 60, color: Color(0xFF2563EB))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onAskDoubtTab,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF4F46E5)]), borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 30),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Instant Camera & Voice Doubt Solver", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("Snap, write or speak your question for instant solution", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.school, size: 50, color: Color(0xFF2563EB))),
                    const SizedBox(height: 10),
                    const Text("EDUVA", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Welcome Back! 👋", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: _emailController, decoration: InputDecoration(hintText: "Email or Phone", prefixIcon: const Icon(Icons.email_outlined), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
              const SizedBox(height: 14),
              TextField(controller: _passController, obscureText: true, decoration: InputDecoration(hintText: "Password", prefixIcon: const Icon(Icons.lock_outline), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                  child: const Text("Forgot Your Password?", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    UserState.isLoggedIn = true;
                    if (_emailController.text.isNotEmpty) UserState.email = _emailController.text;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  child: const Text("Log In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: const Text("Sign Up", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 3. SIGN UP SCREEN
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _aimCtrl = TextEditingController();
  String _classVal = "Class 11th";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Create Student Account"), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: InputDecoration(hintText: "Full Name", prefixIcon: const Icon(Icons.person_outline), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _classVal,
              decoration: InputDecoration(prefixIcon: const Icon(Icons.school_outlined), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              items: ["Class 9th", "Class 10th", "Class 11th", "Class 12th", "Dropper"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _classVal = v!),
            ),
            const SizedBox(height: 12),
            TextField(controller: _emailCtrl, decoration: InputDecoration(hintText: "Email ID", prefixIcon: const Icon(Icons.email_outlined), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: "Phone Number", prefixIcon: const Icon(Icons.phone_outlined), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
            const SizedBox(height: 12),
            TextField(controller: _aimCtrl, decoration: InputDecoration(hintText: "Target Goal / Aim (e.g. JEE, NEET, Board 95%)", prefixIcon: const Icon(Icons.flag_outlined), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameCtrl.text.isNotEmpty) UserState.name = _nameCtrl.text;
                  if (_emailCtrl.text.isNotEmpty) UserState.email = _emailCtrl.text;
                  if (_phoneCtrl.text.isNotEmpty) UserState.phone = _phoneCtrl.text;
                  if (_aimCtrl.text.isNotEmpty) UserState.targetGoal = _aimCtrl.text;
                  UserState.studentClass = _classVal;
                  UserState.isLoggedIn = true;

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account created successfully!")));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                child: const Text("Create Account & Start", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 4. FORGOT PASSWORD SCREEN
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Forgot Password"), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Enter your registered email ID to receive a password reset link:"),
            const SizedBox(height: 16),
            TextField(decoration: InputDecoration(hintText: "Email ID", filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset link sent to your email!")));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
              child: const Text("Send Reset Link", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

// 5. ASK DOUBT SCREEN (GROQ ENGINE - LLAMA 3.1 8B INSTANT)
class AskDoubtScreen extends StatefulWidget {
  const AskDoubtScreen({super.key});

  @override
  State<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends State<AskDoubtScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();

  File? _imageFile;
  bool _isListening = false;
  bool _isLoading = false;
  String? _response;
  String _activeSubject = "Mathematics";

  // आपकी Groq API Key
  final String _groqApiKey = "gsk_" + "rqSD0CJstk1b1sPiB1Xn" + "WGdyb3FY3A5mbYtcwy" + "Le1ch2gMoV1GE3";

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path);
          _controller.text = "Please solve the question in this image step by step.";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Camera error: $e")));
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _controller.text = "Please explain the concept and solution for this problem.";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gallery error: $e")));
    }
  }

  Future<void> _listenVoice() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _controller.text = val.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _solveWithAI() async {
    final query = _controller.text.trim();
    if (query.isEmpty && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया सवाल लिखें, फ़ोटो लें या बोलकर पूछें!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final res = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_groqApiKey',
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {
              "role": "system",
              "content": "You are Edu Sir, an expert, encouraging AI Teacher for Indian students. Subject: $_activeSubject. Provide a crystal-clear, step-by-step easy explanation with formulas and final answer in simple Hindi/Hinglish."
            },
            {
              "role": "user",
              "content": query.isNotEmpty ? query : "कृपया इस विषय को विस्तार से समझाएं।"
            }
          ],
          "temperature": 0.5,
          "max_tokens": 1024
        }),
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        setState(() {
          _response = content;
          UserState.doubtsSolved += 1;
        });
      } else {
        setState(() {
          _response = "Groq Server Error (${res.statusCode}):\n${res.body}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Connection Error: $e\nकृपया इंटरनेट कनेक्शन जांचें।";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask Edu Sir (Doubt Solver)", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Mathematics", "Physics", "Chemistry", "Biology"].map((sub) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sub),
                      selected: _activeSubject == sub,
                      selectedColor: const Color(0xFF2563EB),
                      labelStyle: TextStyle(color: _activeSubject == sub ? Colors.white : Colors.black),
                      onSelected: (val) => setState(() => _activeSubject = sub),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "✍️ अपना सवाल यहाँ लिखें, फ़ोटो खींचें या बोलें...",
                      border: InputBorder.none,
                    ),
                  ),
                  if (_imageFile != null) ...[
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.image, color: Color(0xFF2563EB)),
                        const SizedBox(width: 8),
                        const Text("Image Attached", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => setState(() => _imageFile = null),
                        )
                      ],
                    ),
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(icon: const Icon(Icons.camera_alt), label: const Text("Camera"), onPressed: _openCamera),
                      TextButton.icon(icon: const Icon(Icons.photo_library), label: const Text("Gallery"), onPressed: _openGallery),
                      TextButton.icon(
                        icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: _isListening ? Colors.red : const Color(0xFF2563EB)),
                        label: Text(_isListening ? "Listening..." : "Voice"),
                        onPressed: _listenVoice,
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
                onPressed: _isLoading ? null : _solveWithAI,
                icon: _isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.auto_awesome, color: Colors.white),
                label: Text(
                  _isLoading ? "Edu Sir हल कर रहे हैं..." : "Solve My Doubt Now 🚀",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
              ),
            ),
            if (_response != null) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF93C5FD)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school, color: Color(0xFF2563EB)),
                        const SizedBox(width: 8),
                        const Text("Edu Sir का समाधान:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _response!));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("समाधान कॉपी हो गया!")));
                          },
                        )
                      ],
                    ),
                    const Divider(),
                    SelectableText(_response!, style: const TextStyle(fontSize: 14, height: 1.5)),
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

// 6. AI CLASSROOM
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
      appBar: AppBar(title: const Text("AI Classroom & 3D Lab"), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () => setState(() => is3DMode = false), child: const Text("Whiteboard"))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => setState(() => is3DMode = true), child: const Text("3D View"))),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 220, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)), child: Center(child: Icon(is3DMode ? Icons.view_in_ar : Icons.favorite, size: 80, color: Colors.redAccent))),
          ],
        ),
      ),
    );
  }
}

// 7. CAREER GUIDANCE
class CareerGuidanceScreen extends StatelessWidget {
  const CareerGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career Guidance"), backgroundColor: Colors.white),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(leading: Icon(Icons.engineering, color: Colors.blue), title: Text("AI Engineer Roadmap"), subtitle: Text("12 Skills • ₹12 LPA")),
            ListTile(leading: Icon(Icons.medical_services, color: Colors.green), title: Text("Doctor (MBBS) Roadmap"), subtitle: Text("15 Skills • ₹10 LPA")),
          ],
        ),
      ),
    );
  }
}

// 8. PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  const ProfileScreen({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.white),
      body: Padding(
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
                  ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: Text("Doubts Solved: ${UserState.doubtsSolved}")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
