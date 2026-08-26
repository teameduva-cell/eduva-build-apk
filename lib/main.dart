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
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF4F46E5),
        ),
      ),
      home: const MainDashboardShell(),
    );
  }
}

// Brand Look & Gradients
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
      ProfileScreen(onRefresh: () => setState(() {})),
    ];

    final pageForNav = {0: 0, 1: 1, 3: 2, 4: 3};

    return Scaffold(
      body: pages[pageForNav[_currentIndex] ?? 0],
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
                _navButton(Icons.school_outlined, Icons.school, "AI Classroom", 3),
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
                  ClipRRect(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    child: Image.asset(
                      'assets/images/edu_sir_board.png',
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.school, size: 60, color: kEduvaPrimary)),
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
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "⚠️ Note: Firebase OTP verification will be integrated in production.",
                style: TextStyle(fontSize: 11, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 12),
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

// 5. AI CHAT SCREEN (GROQ HYBRID ENGINE)
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

  static const String _textModel = "openai/gpt-oss-20b";
  static const String _visionModel = "qwen/qwen3.6-27b";

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
      final String modelToUse = hasImage ? _visionModel : _textModel;

      dynamic userMessageContent;
      if (hasImage) {
        final bytes = await imageToSend.readAsBytes();
        final base64Image = base64Encode(bytes);
        final lowerPath = imageToSend.path.toLowerCase();
        final mimeType = lowerPath.endsWith('.png') ? 'image/png' : 'image/jpeg';

        userMessageContent = [
          {"type": "text", "text": query.isNotEmpty ? query : "कृपया इस चित्र में दिए गए प्रश्न को विस्तार से हल करें।"},
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
              "content": "You are Edu Sir, an expert, encouraging AI Teacher for Indian students. Subject: $_activeSubject. Provide a crystal-clear, step-by-step easy explanation with formulas and final answer in simple Hindi/Hinglish."
            },
            {"role": "user", "content": userMessageContent}
          ],
          "temperature": 0.5,
          "max_tokens": 1024
        }),
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        setState(() {
          _messages.add(ChatMessage(role: "assistant", text: content));
          UserState.doubtsSolved += 1;
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
      appBar: AppBar(title: const Text("AI Classroom"), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => is3DMode = false),
                    style: ElevatedButton.styleFrom(backgroundColor: is3DMode ? Colors.grey.shade200 : kEduvaPrimary, foregroundColor: is3DMode ? Colors.black87 : Colors.white),
                    child: const Text("Board Mode"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => is3DMode = true),
                    style: ElevatedButton.styleFrom(backgroundColor: is3DMode ? kEduvaPrimary : Colors.grey.shade200, foregroundColor: is3DMode ? Colors.white : Colors.black87),
                    child: const Text("3D Mode"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 220, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)), child: Center(child: Icon(is3DMode ? Icons.view_in_ar : Icons.dashboard_customize, size: 80, color: kEduvaPrimary))),
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

// 8. PROFILE SCREEN (WITH ACHIEVEMENTS & PROGRESS BARS)
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
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.white, elevation: 0),
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
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  const CircleAvatar(radius: 18, backgroundColor: Color(0xFFEFF6FF), child: Icon(Icons.school, color: kEduvaPrimary, size: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Message from Edu Sir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("Great job, ${UserState.name.split(' ')[0]}! Keep the streak going 🔥", style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                  _statBox(Icons.star, Colors.amber, "Lvl 1", "Level"),
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
