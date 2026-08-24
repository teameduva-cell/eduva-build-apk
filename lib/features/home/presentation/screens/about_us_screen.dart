import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('About Eduva', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: const [
                  Text('EDUVA', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5))),
                  SizedBox(height: 8),
                  Text(
                    'Eduva is an AI-powered learning platform built to make quality education simple, interactive, and accessible for every student.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard('Our Mission 🎯', 'To make high-quality education accessible to every student through AI without compromising on learning quality.'),
            const SizedBox(height: 12),
            _buildCard('Our Vision 👁️', 'To become the world’s most trusted AI learning companion where students learn with confidence.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String desc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
        ],
      ),
    );
  }
}
