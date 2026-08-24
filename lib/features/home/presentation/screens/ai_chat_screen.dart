import 'package:flutter/material.dart';

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Edu Sir (AI Teacher)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.history)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Sir, please solve Pythagoras theorem step by step.',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Edu Sir 👨‍🏫', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                          SizedBox(height: 6),
                          Text(
                            'Sure, Champion! Let’s solve it:\n\nIn Right-Angled Triangle ABC:\nAC² = AB² + BC²\n(25)² = h² + (7)²\n625 = h² + 49\nh² = 576\nh = √576\nh = 24 m\n\nTherefore, Height AB = 24 m.',
                            style: TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your doubt...',
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt, color: Color(0xFF4F46E5))),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.send, color: Color(0xFF4F46E5))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
