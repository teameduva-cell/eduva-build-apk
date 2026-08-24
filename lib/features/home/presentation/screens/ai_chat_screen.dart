import 'package:flutter/material.dart';

class AIChatScreen extends StatefulWidget {
  final String? initialQuery;
  const AIChatScreen({super.key, this.initialQuery});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      _sendMessage(widget.initialQuery!);
    } else {
      _messages.add({
        'sender': 'ai',
        'text': 'Namaste Champion! 👋 Main hoon Edu Sir, aapka AI teacher. Aap mujhse koi bhi math, science ya kisi bhi subject ka question pooch sakte hain!',
      });
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text.trim()});
      _isTyping = true;
    });
    _msgController.clear();

    // AI Dynamic Simulation Response
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      String reply = "Great question! Let's solve this step by step 🚀:\n\n";
      final lower = text.toLowerCase();
      if (lower.contains('pythagoras') || lower.contains('triangle') || lower.contains('math')) {
        reply += "In a Right-Angled Triangle:\n• Hypotenuse² = Base² + Perpendicular² (AC² = AB² + BC²)\n• Example: If Base = 7m, Hypotenuse = 25m\n• Height² = 25² - 7² = 625 - 49 = 576\n• Height = √576 = 24m ✅";
      } else if (lower.contains('heart') || lower.contains('blood') || lower.contains('biology')) {
        reply += "Human Heart Anatomy:\n• 4 Chambers: Right/Left Atrium, Right/Left Ventricle.\n• Pumps oxygenated blood to the whole body.";
      } else if (lower.contains('photo') || lower.contains('camera') || lower.contains('image')) {
        reply += "📷 Question scanned successfully from Image!\n• Solution: The key concept here is conservation of energy and linear equations. Follow standard NCERT formulas for full marks.";
      } else if (lower.contains('pdf') || lower.contains('document')) {
        reply += "📄 Document parsed!\n• Summary: Extracted important practice questions from your notes. Ready for revision!";
      } else {
        reply += "To master this topic '$text':\n1. Understand the core formula/theory.\n2. Practice 3 textbook examples.\n3. Solve previous year questions (PYQs).";
      }

      setState(() {
        _isTyping = false;
        _messages.add({'sender': 'ai', 'text': reply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Edu Sir (AI Teacher)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _messages.clear());
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['sender'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFF4F46E5) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isUser ? null : Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser)
                            const Text('Edu Sir 👨‍🏫', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5), fontSize: 12)),
                          if (!isUser) const SizedBox(height: 4),
                          Text(
                            msg['text']!,
                            style: TextStyle(
                              color: isUser ? Colors.white : const Color(0xFF1E293B),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isTyping)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Edu Sir is typing...', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontStyle: FontStyle.italic)),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_rounded, color: Color(0xFF8B5CF6)),
                    onPressed: () => _sendMessage("📷 [Scanned Math Question from Camera]"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_rounded, color: Color(0xFFEC4899)),
                    onPressed: () => _sendMessage("🎙️ [Voice Question: Please explain the core concept]"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: Color(0xFF0EA5E9)),
                    onPressed: () => _sendMessage("📄 [Attached PDF Notes for doubt solving]"),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: Color(0xFF4F46E5)),
                    onPressed: () => _sendMessage(_msgController.text),
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
