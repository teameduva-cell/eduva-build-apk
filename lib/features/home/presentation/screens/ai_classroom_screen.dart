import 'package:flutter/material.dart';

class AIClassroomScreen extends StatelessWidget {
  const AIClassroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('AI Classroom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Clear Board'),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.power_settings_new, color: Colors.red),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                child: const Text('✏️ Board Mode'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('📦 3D Mode'),
                              ),
                            ],
                          ),
                          const Text('EDUVA', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        'Human Heart Anatomy',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                      ),
                      const SizedBox(height: 8),
                      const Text('• The heart is a muscular organ that pumps blood.\n• It consists of 4 main chambers:\n  1. Right Atrium\n  2. Right Ventricle\n  3. Left Atrium\n  4. Left Ventricle\n• Blue = Deoxygenated Blood | Red = Oxygenated Blood',
                          style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155))),
                      const Spacer(),
                      Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.favorite, size: 70, color: Color(0xFFDC2626)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Action Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ask anything about this topic...',
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.mic, color: Color(0xFF4F46E5))),
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
