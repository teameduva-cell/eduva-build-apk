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
  static int quizScore = 0;
  static List<String> savedDoubts = [];
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
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF4F46E5),
        ),
      ),
      home: const MainDashboardShell(),
    );
  }
}

// Brand Colors & Gradients
const kEduvaGradient = LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]);
const kEduvaPrimary = Color(0xFF4F46E5);

class MainDashboardShell extends StatefulWidget {
  const MainDashboardShell({super.key});

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  int _currentIndex = 0;
  bool _autoOpenCamera = false;

  void _goToChat({bool openCamera = false}) {
    setState(() {
      _autoOpenCamera = openCamera;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onAskDoubtTab: () => _goToChat()),
      AskDoubtScreen(autoOpenCamera: _autoOpenCamera, onCameraConsumed: () => setState(() => _autoOpenCamera = false)),
      const AIClassroomScreen(),
      const DailyQuizScreen(),
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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navButton(Icons.home_outlined, Icons.home, "Home", 0),
                _navButton(Icons.chat_bubble_outline, Icons.chat_bubble, "AI Chat", 1),
                GestureDetector(
                  onTap: () => _goToChat(openCamera: true),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          gradient: kEduvaGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 2),
                      const Text("Scan", style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                _navButton(Icons.quiz_outlined, Icons.quiz, "Daily Quiz", 3),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: isSelected ? kEduvaPrimary : Colors.grey.shade600, size: 24),
            Text(label, style: TextStyle(color: isSelected ? kEduvaPrimary : Colors.grey.shade600, fontSize: 10)),
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
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: kEduvaPrimary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.token, color: Colors.white, size: 18)),
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
              style: ElevatedButton.styleFrom(backgroundColor: kEduvaPrimary, foregroundColor: Colors.white),
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
                        const Text("That's why we created Edu Sir — your personal AI teacher.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kEduvaPrimary)),
                      ],
                    ),
                  ),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 55, color: kEduvaPrimary),
                          SizedBox(height: 4),
                          Text("Edu Sir • AI Teacher", style: TextStyle(fontWeight: FontWeight.bold, color: kEduvaPrimary)),
                        ],
                      ),
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
                decoration: BoxDecoration(gradient: kEduvaGradient, borderRadius: BorderRadius.circular(16)),
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    context,
                    "AI Classroom & 3D Lab",
                    "Interactive models & board",
                    Icons.view_in_ar,
                    Colors.orange,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIClassroomScreen())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionCard(
                    context,
                    "Career Guidance",
                    "Roadmaps & Salaries",
                    Icons.explore,
                    Colors.purple,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerGuidanceScreen())),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color, size: 20)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

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
                    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.school, size: 50, color: kEduvaPrimary)),
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
                  style: ElevatedButton.styleFrom(backgroundColor: kEduvaPrimary),
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
                    child: const Text("Sign Up", style: TextStyle(color: kEduvaPrimary, fontWeight: FontWeight.bold)),
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
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _aimCtrl.dispose();
    super.dispose();
  }

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
                style: ElevatedButton.styleFrom(backgroundColor: kEduvaPrimary),
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
              style: ElevatedButton.styleFrom(backgroundColor: kEduvaPrimary),
              child: const Text("Send Reset Link", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

// Simple Chat Message Model
class ChatMessage {
  final String role;
  final String text;
  final File? image;
  ChatMessage({required this.role, required this.text, this.image});
}

// 5. AI CHAT SCREEN (PLAIN MATH STUDENT READABLE FORMAT)
class AskDoubtScreen extends StatefulWidget {
  final bool autoOpenCamera;
  final VoidCallback? onCameraConsumed;
  const AskDoubtScreen({super.key, this.autoOpenCamera = false, this.onCameraConsumed});

  @override
  State<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends State<AskDoubtScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ScrollController _scrollController = ScrollController();

  File? _pendingImage;
  bool _isListening = false;
  bool _isLoading = false;
  String _activeSubject = "Mathematics";
  final List<ChatMessage> _messages = [];

  final String _groqApiKey = "gsk_" + "rqSD0CJstk1b1sPiB1Xn" + "WGdyb3FY3A5mbYtcwy" + "Le1ch2gMoV1GE3";

  // Helper: LaTeX/Raw code को Clean Student-Readable Text में बदलना
  String _sanitizeMathText(String text) {
    String cleaned = text;
    if (cleaned.contains("</think>")) {
      cleaned = cleaned.split("</think>").last.trim();
    }
    cleaned = cleaned.replaceAll(r'$$', '').replaceAll(r'$', '');
    cleaned = cleaned.replaceAll(r'\[', '').replaceAll(r'\]', '');
    cleaned = cleaned.replaceAll(r'\(', '').replaceAll(r'\)', '');
    
    cleaned = cleaned.replaceAll(r'\Delta', 'Triangle ');
    cleaned = cleaned.replaceAll(r'\angle', 'Angle ');
    cleaned = cleaned.replaceAll(r'\times', ' × ');
    cleaned = cleaned.replaceAll(r'\cdot', ' · ');
    cleaned = cleaned.replaceAll(r'\implies', ' ⟹ ');
    cleaned = cleaned.replaceAll(r'\ge', ' ≥ ');
    cleaned = cleaned.replaceAll(r'\le', ' ≤ ');
    cleaned = cleaned.replaceAll(r'\neq', ' ≠ ');
    cleaned = cleaned.replaceAll(r'\pm', ' ± ');
    cleaned = cleaned.replaceAll(r'\sqrt', '√');
    cleaned = cleaned.replaceAll(r'\degree', '°');
    cleaned = cleaned.replaceAll(r'\circ', '°');

    cleaned = cleaned.replaceAllMapped(
      RegExp(r'\\frac\{([^{}]+)\}\{([^{}]+)\}'),
      (match) => '(${match.group(1)} / ${match.group(2)})',
    );

    return cleaned.trim();
  }

  @override
  void initState() {
    super.initState();
    if (widget.autoOpenCamera) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openCamera();
        widget.onCameraConsumed?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (photo != null) {
        setState(() => _pendingImage = File(photo.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Camera error: $e")));
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        setState(() => _pendingImage = File(image.path));
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
          setState(() => _controller.text = val.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _sendQuickPrompt(String prompt) {
    _controller.text = prompt;
    _solveWithAI();
  }

  Future<void> _solveWithAI() async {
    final query = _controller.text.trim();
    final imageToSend = _pendingImage;

    if (query.isEmpty && imageToSend == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया सवाल लिखें, फ़ोटो लें या बोलकर पूछें!")),
      );
      return;
    }

    setState(() {
      _messages.add(ChatMessage(role: "user", text: query.isNotEmpty ? query : "(Photo Attached)", image: imageToSend));
      _controller.clear();
      _pendingImage = null;
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final bool hasImage = imageToSend != null;
      final String modelToUse = hasImage ? "llama-3.2-11b-vision-preview" : "llama-3.3-70b-versatile";

      dynamic userMessageContent;
      if (hasImage) {
        final bytes = await imageToSend.readAsBytes();
        final base64Image = base64Encode(bytes);
        final lowerPath = imageToSend.path.toLowerCase();
        final mimeType = lowerPath.endsWith('.png') ? 'image/png' : 'image/jpeg';

        userMessageContent = [
          {
            "type": "text",
            "text": query.isNotEmpty
                ? query
                : "Please solve the question in this image step-by-step in clean, plain readable text without any LaTeX code."
          },
          {"type": "image_url", "image_url": {"url": "data:$mimeType;base64,$base64Image"}}
        ];
      } else {
        userMessageContent = query;
      }

      final res = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_groqApiKey',
        },
        body: jsonEncode({
          "model": modelToUse,
          "messages": [
            {
              "role": "system",
              "content": "You are 'Edu Sir', a friendly and expert AI Teacher for Indian students. Subject: $_activeSubject.\n\n"
                  "CRITICAL FORMATTING RULES:\n"
                  "1. NEVER output LaTeX syntax (do NOT use \$, \\frac, \\angle, \\sin, \\cos, \\Delta, \\cdot, \\times, or any backslashes).\n"
                  "2. Write math in 100% plain, readable textbook text. For example:\n"
                  "   - Write 'BD / DC' instead of '\\frac{BD}{DC}'\n"
                  "   - Write 'Triangle ABC' instead of '\\Delta ABC'\n"
                  "   - Write 'Angle BAE' instead of '\\angle BAE'\n"
                  "   - Write 'D1 + D2 = (p - r)^2 ≥ 0' instead of LaTeX\n"
                  "   - Use normal symbols: +, -, *, /, =, ^, ≥, ≤, √, °\n"
                  "3. Structure your answer with:\n"
                  "   • Given Data\n"
                  "   • Key Formula Used\n"
                  "   • Step-by-Step Explanation / Calculation\n"
                  "   • Final Answer\n"
                  "4. Write in easy-to-understand Hindi / Hinglish."
            },
            {"role": "user", "content": userMessageContent}
          ],
          "temperature": 0.4,
          "max_tokens": 1500
        }),
      ).timeout(const Duration(seconds: 35));

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        String rawContent = data['choices'][0]['message']['content'];
        String cleanContent = _sanitizeMathText(rawContent);

        setState(() {
          _messages.add(ChatMessage(role: "assistant", text: cleanContent));
          UserState.doubtsSolved += 1;
          if (query.isNotEmpty) {
            UserState.savedDoubts.insert(0, query);
          }
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(role: "assistant", text: "⚠️ Groq Server Error (${res.statusCode}):\n${res.body}"));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(role: "assistant", text: "⚠️ Connection Error: $e\nकृपया इंटरनेट कनेक्शन जांचें।"));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  static const List<Map<String, dynamic>> _quickActions = [
    {"icon": Icons.school_outlined, "label": "Explain a topic"},
    {"icon": Icons.functions, "label": "Solve this question"},
    {"icon": Icons.description_outlined, "label": "Write notes"},
    {"icon": Icons.emoji_emotions_outlined, "label": "Make it simple"},
    {"icon": Icons.menu_book_outlined, "label": "Practice questions"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("AI Chat", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (v) {
              if (v == "clear") setState(() => _messages.clear());
            },
            itemBuilder: (_) => [const PopupMenuItem(value: "clear", child: Text("Clear Chat"))],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Mathematics", "Physics", "Chemistry", "Biology"].map((sub) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sub, style: const TextStyle(fontSize: 12)),
                      selected: _activeSubject == sub,
                      selectedColor: kEduvaPrimary,
                      labelStyle: TextStyle(color: _activeSubject == sub ? Colors.white : Colors.black87),
                      onSelected: (val) => setState(() => _activeSubject = sub),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(14),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _buildTypingBubble();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          if (_pendingImage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_pendingImage!, height: 40, width: 40, fit: BoxFit.cover)),
                  const SizedBox(width: 10),
                  const Expanded(child: Text("Image attached", style: TextStyle(fontWeight: FontWeight.w600, color: kEduvaPrimary))),
                  IconButton(icon: const Icon(Icons.close, size: 18, color: Colors.red), onPressed: () => setState(() => _pendingImage = null)),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(hintText: "Ask anything...", border: InputBorder.none),
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : Colors.grey.shade600, size: 20),
                          onPressed: _listenVoice,
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt_outlined, color: Colors.grey.shade600, size: 20),
                          onPressed: _openCamera,
                        ),
                        IconButton(
                          icon: Icon(Icons.photo_library_outlined, color: Colors.grey.shade600, size: 20),
                          onPressed: _openGallery,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isLoading ? null : _solveWithAI,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: _isLoading ? null : kEduvaGradient,
                      color: _isLoading ? Colors.grey.shade300 : null,
                      shape: BoxShape.circle,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Try asking Edu Sir", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickActions.map((qa) {
                    return ActionChip(
                      avatar: Icon(qa["icon"] as IconData, size: 16, color: kEduvaPrimary),
                      label: Text(qa["label"] as String, style: const TextStyle(fontSize: 12)),
                      backgroundColor: const Color(0xFFEFF6FF),
                      onPressed: () => _sendQuickPrompt(qa["label"] as String),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                CircleAvatar(radius: 36, backgroundColor: const Color(0xFFEFF6FF), child: Icon(Icons.school, color: kEduvaPrimary, size: 36)),
                const SizedBox(height: 10),
                const Text("Edu Sir आपका इंतज़ार कर रहा है!", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const Text("अपना सवाल टाइप करें, बोलें या फ़ोटो खींचें।", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.role == "user";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(radius: 16, backgroundColor: const Color(0xFFEFF6FF), child: Icon(Icons.school, size: 16, color: kEduvaPrimary)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 2, left: 2),
                    child: Text("Edu Sir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: kEduvaPrimary)),
                  ),
                Container(
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
                  decoration: BoxDecoration(
                    gradient: isUser ? kEduvaGradient : null,
                    color: isUser ? null : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isUser ? null : Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (msg.image != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(msg.image!, height: 140, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 6),
                      ],
                      SelectableText(
                        msg.text,
                        style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 14, height: 1.4),
                      ),
                      if (!isUser) ...[
                        const Divider(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: msg.text));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("समाधान कॉपी हो गया!")));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.copy, size: 14, color: kEduvaPrimary),
                                  SizedBox(width: 4),
                                  Text("Copy", style: TextStyle(fontSize: 11, color: kEduvaPrimary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: const Color(0xFFEFF6FF), child: Icon(Icons.school, size: 16, color: kEduvaPrimary)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: const Text("Edu Sir is typing...", style: TextStyle(color: Colors.grey, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// 6. ADVANCED AI CLASSROOM & 3D LAB (INTERACTIVE)
class AIClassroomScreen extends StatefulWidget {
  const AIClassroomScreen({super.key});

  @override
  State<AIClassroomScreen> createState() => _AIClassroomScreenState();
}

class _AIClassroomScreenState extends State<AIClassroomScreen> {
  bool is3DMode = false;
  int selectedModel = 0;
  final List<Offset?> _whiteboardPoints = [];

  final List<Map<String, dynamic>> _models3D = [
    {"name": "Human Heart", "desc": "4 Chambers • Circulatory System", "icon": Icons.favorite, "color": Colors.red},
    {"name": "Electric Motor", "desc": "Fleming's Left Hand Rule • Physics", "icon": Icons.electric_bolt, "color": Colors.blue},
    {"name": "Solar System", "desc": "Gravitation & Kepler's Laws", "icon": Icons.public, "color": Colors.amber},
    {"name": "Bohr Atom", "desc": "Electrons & Quantum Energy Levels", "icon": Icons.bubble_chart, "color": Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Classroom & 3D Lab"), backgroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => is3DMode = false),
                    icon: const Icon(Icons.edit_note),
                    label: const Text("Live Board"),
                    style: ElevatedButton.styleFrom(backgroundColor: !is3DMode ? kEduvaPrimary : Colors.grey.shade200, foregroundColor: !is3DMode ? Colors.white : Colors.black87),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => is3DMode = true),
                    icon: const Icon(Icons.view_in_ar),
                    label: const Text("3D Models"),
                    style: ElevatedButton.styleFrom(backgroundColor: is3DMode ? kEduvaPrimary : Colors.grey.shade200, foregroundColor: is3DMode ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: is3DMode ? _build3DLabView() : _buildLiveWhiteboard(),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveWhiteboard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.horizontal(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Draw or write rough formulas below:", style: TextStyle(fontSize: 12, color: Colors.grey)),
              TextButton.icon(
                onPressed: () => setState(() => _whiteboardPoints.clear()),
                icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                label: const Text("Clear Board", style: TextStyle(color: Colors.red, fontSize: 12)),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    _whiteboardPoints.add(renderBox.globalToLocal(details.globalPosition));
                  });
                },
                onPanEnd: (details) => _whiteboardPoints.add(null),
                child: CustomPaint(
                  painter: WhiteboardPainter(_whiteboardPoints),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _build3DLabView() {
    final active = _models3D[selectedModel];
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: (active["color"] as Color).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: (active["color"] as Color).withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(active["icon"] as IconData, size: 80, color: active["color"] as Color),
                const SizedBox(height: 12),
                Text(active["name"] as String, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: active["color"] as Color)),
                Text(active["desc"] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Select Interactive Topic:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _models3D.length,
              itemBuilder: (context, i) {
                final item = _models3D[i];
                final isSel = selectedModel == i;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFEFF6FF) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSel ? kEduvaPrimary : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: (item["color"] as Color).withOpacity(0.1), child: Icon(item["icon"] as IconData, color: item["color"] as Color)),
                    title: Text(item["name"] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item["desc"] as String, style: const TextStyle(fontSize: 11)),
                    trailing: isSel ? const Icon(Icons.check_circle, color: kEduvaPrimary) : null,
                    onTap: () => setState(() => selectedModel = i),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<Offset?> points;
  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 7. EXPANDED CAREER GUIDANCE & ROADMAPS
class CareerGuidanceScreen extends StatelessWidget {
  const CareerGuidanceScreen({super.key});

  final List<Map<String, dynamic>> roadmaps = const [
    {
      "title": "Software / AI Engineer",
      "exam": "JEE Main & Advanced / CUET",
      "duration": "4 Years (B.Tech)",
      "salary": "₹8 - 25 LPA Average",
      "steps": ["Class 11-12: PCM + Coding Basics", "Crack JEE / State CET Exams", "4 Yrs B.Tech in CS/AI", "Internships & AI Projects"]
    },
    {
      "title": "Doctor (MBBS / Specialist)",
      "exam": "NEET UG",
      "duration": "5.5 Years + MD/MS",
      "salary": "₹10 - 30 LPA Average",
      "steps": ["Class 11-12: PCB + Biology Focus", "Crack NEET UG Exam", "5.5 Yrs MBBS with Internship", "Crack NEET PG for Specialization"]
    },
    {
      "title": "Defense Officer (Army/Navy/Air Force)",
      "exam": "NDA & NA Exam / SSB",
      "duration": "3 Years Academy + 1 Yr Training",
      "salary": "₹12 - 18 LPA + Perks",
      "steps": ["Class 12th PCM", "Crack UPSC NDA Exam", "Clear 5-day SSB Interview", "Join NDA Khadakwasla"]
    },
    {
      "title": "Civil Services (IAS / IPS)",
      "exam": "UPSC CSE",
      "duration": "Graduation + 1-2 Yrs Prep",
      "salary": "Top Govt Scale + Authority",
      "steps": ["Complete Any Bachelor Degree", "General Studies + Optional Prep", "Crack Prelims, Mains & Interview", "Join LBSNAA Training"]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career Roadmaps & Guidance"), backgroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: roadmaps.length,
        itemBuilder: (context, index) {
          final item = roadmaps[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["title"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kEduvaPrimary)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                  child: Text(item["salary"] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kEduvaPrimary)),
                ),
                const SizedBox(height: 8),
                Text("Target Exam: ${item["exam"]}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                Text("Course Duration: ${item["duration"]}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Divider(height: 18),
                const Text("Step-by-Step Roadmap:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                Column(
                  children: (item["steps"] as List<String>).map((step) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_right, color: kEduvaPrimary),
                          Expanded(child: Text(step, style: const TextStyle(fontSize: 12))),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// 8. DAILY AI PRACTICE QUIZ & TEST SCREEN
class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key});

  @override
  State<DailyQuizScreen> createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen> {
  int currentQuestion = 0;
  int? selectedAnswer;
  int score = 0;
  bool isFinished = false;

  final List<Map<String, dynamic>> questions = [
    {
      "q": "What is the SI unit of Electric Current?",
      "options": ["Volt", "Ampere", "Ohm", "Watt"],
      "correct": 1
    },
    {
      "q": "Which gas is released during photosynthesis?",
      "options": ["Carbon Dioxide", "Nitrogen", "Oxygen", "Hydrogen"],
      "correct": 2
    },
    {
      "q": "Derivative of sin(x) with respect to x is:",
      "options": ["cos(x)", "-cos(x)", "tan(x)", "-sin(x)"],
      "correct": 0
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily 5-Min Quiz"), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isFinished
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                    const SizedBox(height: 16),
                    Text("Quiz Completed! 🎉", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("You scored $score out of ${questions.length}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestion = 0;
                          selectedAnswer = null;
                          score = 0;
                          isFinished = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: kEduvaPrimary),
                      child: const Text("Retake Quiz", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Question ${currentQuestion + 1} of ${questions.length}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text(questions[currentQuestion]["q"] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ...List.generate(4, (i) {
                    final opt = (questions[currentQuestion]["options"] as List)[i];
                    final isSel = selectedAnswer == i;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFEFF6FF) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSel ? kEduvaPrimary : Colors.grey.shade300),
                      ),
                      child: ListTile(
                        title: Text(opt as String, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                        leading: CircleAvatar(radius: 12, backgroundColor: isSel ? kEduvaPrimary : Colors.grey.shade300, child: Text("${i + 1}", style: const TextStyle(fontSize: 11, color: Colors.white))),
                        onTap: () => setState(() => selectedAnswer = i),
                      ),
                    );
                  }),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: selectedAnswer == null
                          ? null
                          : () {
                              if (selectedAnswer == questions[currentQuestion]["correct"]) {
                                score += 1;
                                UserState.quizScore += 10;
                              }
                              if (currentQuestion < questions.length - 1) {
                                setState(() {
                                  currentQuestion += 1;
                                  selectedAnswer = null;
                                });
                              } else {
                                setState(() => isFinished = true);
                              }
                            },
                      style: ElevatedButton.styleFrom(backgroundColor: kEduvaPrimary),
                      child: Text(currentQuestion < questions.length - 1 ? "Next Question" : "Submit Quiz", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

// 9. PROFILE SCREEN WITH DOUBT HISTORY & STATS
class ProfileScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  const ProfileScreen({super.key, required this.onRefresh});

  Widget _statBox(IconData icon, Color color, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _subjectBar(String subject, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text("${(percent * 100).toInt()}%", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 7,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("Profile & History"), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 34, backgroundColor: kEduvaPrimary, child: Icon(Icons.person, size: 38, color: Colors.white)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(UserState.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          children: [
                            Chip(label: Text(UserState.studentClass, style: const TextStyle(fontSize: 11)), backgroundColor: Colors.white, visualDensity: VisualDensity.compact),
                            Chip(label: Text(UserState.targetGoal, style: const TextStyle(fontSize: 11)), backgroundColor: Colors.white, visualDensity: VisualDensity.compact),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  _statBox(Icons.local_fire_department, Colors.orange, "${UserState.streakDays}", "Day Streak"),
                  _statBox(Icons.check_circle, Colors.green, "${UserState.doubtsSolved}", "Doubts Solved"),
                  _statBox(Icons.star, Colors.amber, "${UserState.quizScore} pts", "Quiz Points"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Subject Wise Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  _subjectBar("Mathematics", 0.72, Colors.indigo),
                  _subjectBar("Physics", 0.60, Colors.blue),
                  _subjectBar("Chemistry", 0.55, Colors.teal),
                  _subjectBar("Biology", 0.68, Colors.pink),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (UserState.savedDoubts.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Recently Asked Doubts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    ...UserState.savedDoubts.take(4).map((d) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.history, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(child: Text(d, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerGuidanceScreen())),
                icon: const Icon(Icons.explore_outlined, color: kEduvaPrimary),
                label: const Text("Explore Career Guidance", style: TextStyle(color: kEduvaPrimary)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
